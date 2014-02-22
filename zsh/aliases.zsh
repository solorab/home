#!/usr/bin/zsh

 zman() {
    # http://qiita.com/mollifier/items/14bbea7503910300b3ba
    PAGER="less -g -s '+/^       "$1"'" man zshall
}

alias notify='notify-send -i terminal'

alias gitignored='git ls-files -o -i --exclude-standard'

# vim
vimrc() { $VISUAL ~/.vimrc ; }
vf() {
    vim -c 'au FileType vimfiler nnoremap <buffer> q :<C-u>quit<CR>' \
        -c 'au FileType vimfiler nnoremap <buffer> Q :<C-u>quit<CR>' \
        -c ':VimFiler -status '"$*"
}

# locate(1)
MLOCATE_HOME_DB=$HOME/var/home.mlocate.db
updatedb-home() {
	updatedb --database-root $HOME --output $MLOCATE_HOME_DB --require-visibility 0 $@
}
locate-home() {
	locate --database $MLOCATE_HOME_DB $@
}
locu() { locate "$@" | grep --color=never ^/usr/ ; }

# url
url_quote() {
    if [ $# = 0 ]
    then echo -n "`cat`"
    else echo -n "$@"
    fi | python3 -c 'import sys, urllib.parse as url ; print(url.quote(sys.stdin.read()))'
}
duckduckgo() { echo http://duckduckgo.com/\?q=`echo $@ | url_quote` }
alias ddg=duckduckgo
wikipedia() {
    local lang
    lang=en
    case "$1" in
        ja | japan | jp ) lang=ja ; shift ;;
        -- | en | english ) shift ;;
    esac
    echo http://${lang}.wikipedia.org/wiki/`echo $@ | url_quote`
}
alias wikip=wikipedia
alias wkp=wikipedia
google() {
    local lang
    lang=com
    case "$1" in
        jp | co.jp | japan | ja ) lang=co.jp ; shift ;;
        -- | en | com | english ) shift ;;
    esac
    echo http://www.google.$lang/search\?q=`echo $@ | url_quote`
}
alias ggl=google
bing() { echo http://www.bing.com/search\?q=`echo $@ | url_quote` }
weblio() {
    local type
    type=ejje
    case "$1" in
        ejje ) type=$1 ; shift ;;
    esac
    echo http://${type}.weblio.jp/content/`echo $@ | url_quote`\#main
}
hoogle() { echo http://www.haskell.org/hoogle/\?hoogle=`echo $@ | url_quote` }
github() { echo git@github.com:"$1".git }
axfc() {
    local elem num
    case "$#" in
        1 )
            elem=`echo $1 | sed -e 's/_.*//'`
            num=`echo $1 | sed -e 's/.*_//'`
            ;;
        2 )
            elem=$1
            num=$2
            ;;
    esac
    [ -n "$elem" -a -n "`echo "$num" | grep '^[[:digit:]]\+$'`" ] || error "$type"': wrong format argument: '"$*"
    echo http://www1.axfc.net/uploader/"$elem"/so/"$num"
}
nicovideo() {
    local num
    num=`echo "$1" | grep '^\(sm\)\?[[:digit:]]\+$'`
    [ "$num" ] || error "$type"': wrong format argument: '"$1"
    echo http://www.nicovideo.jp/watch/sm"$num"
}
bddg() { $BROWSER `duckduckgo "$@"` }
bwkp() { $BROWSER `wikipedia  "$@"` }
bggl() { $BROWSER `google     "$@"` }

# blog
BLOG_DIR=$HOME/work/public/blog
blog-do() { (cd $BLOG_DIR ; "$@" ) }
new-post()  { blog-do rake new_post }
edit-post() { (
    cd $BLOG_DIR
    local prefix file
    prefix=source/_posts
    file="`ls $prefix | canything`"
    [ -f "$prefix/$file" ] && $VISUAL $prefix/$file
) }
blog-preview() { blog-do rake preview }

# diar(1)
export DIAR_DIR=$HOME/var/diary
export DIAR_DEFAULT_FILE=a.md
diar-grep() { grep "$@" $DIAR_DIR/**/*.md ; }
diar-show() { (
    file="$(diar -pF "$@")"
    cat "$file" \
    | pandoc --mathjax --include-in-header=<(echo '<base href="'$(dirname "$file")'/">') \
    | tof --html -l opera
) ; }

# haskell
cabal-configure() { cabal configure --enable-test --disable-library-prof --disable-executable-prof "$@" }
cabal-rebuild() { cabal clean ; cabal-configure "$@" ; cabal build }
alias hs=ghci
