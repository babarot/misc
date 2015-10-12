function h {
    cd ~/work/hatena/$1
}
 
function _h {
    local allfiles
    #local -a _projects _others
 
    #allfiles=`find ~/work/hatena/* -type d -maxdepth 0 -exec basename '{}' ';'`
    allfiles=(`awk '{print $1}' ~/.favdir/favdirlist`)
 
    #_projects=( $(echo $allfiles | grep '^Hatena-' | sed -e 's/^Hatena-//') )
    #_describe -t projects "Projects" _projects -P Hatena-
 
    #_others=( $(echo $allfiles | grep -v '^Hatena-') )
    _describe -t others "Others" allfiles
 
    return 1;
}
 
compdef _h h
