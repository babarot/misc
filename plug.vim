let s:true  = 1
let s:false = 0

let s:plug = {
            \ "plugs": get(g:, 'plugs', {}),
            \ "list":  keys(get(g:, 'plugs', {})),
            \ }

function! s:plug.is_installed(strict, ...)
    let list = []
    if type(a:strict) != type(0)
        call add(list, a:strict)
    endif
    let list += a:000

    for arg in list
        let name   = substitute(arg, '^vim-\|\.vim$', "", "g")
        let prefix = "vim-" . name
        let suffix = name . ".vim"

        if a:strict == 1
            let name   = arg
            let prefix = arg
            let suffix = arg
        endif

        if has_key(self.plugs, name)
                    \ ? isdirectory(self.plugs[name].dir)
                    \ : has_key(self.plugs, prefix)
                    \ ? isdirectory(self.plugs[prefix].dir)
                    \ : has_key(self.plugs, suffix)
                    \ ? isdirectory(self.plugs[suffix].dir)
                    \ : s:false
            continue
        else
            return s:false
        endif
    endfor

    return s:true
endfunction

function! s:plug.is_loaded(p)
    return s:plug.is_installed(1, a:p) && s:plug.is_rtp(a:p)
endfunction

function! s:plug.is_rtp(p)
    return index(split(&rtp, ","), get(self.plugs[a:p], "dir")) != -1
endfunction

function! PlugList(A,L,P)
    return join(s:plug.list, "\n")
endfunction
command! -nargs=1 -complete=custom,PlugList PlugHas if s:plug.is_installed('<args>') | echo "yes" | else | echo "no" | endif

" let s:true  = 1
" let s:false = 0
"
" let s:plug = {
"             \ "plugs": get(g:, 'plugs', {})
"             \ }
"
" function! s:plug.is_installed(strict, ...)
"     for arg in a:000
"         let name = substitute(arg, '^vim-\|\.vim$', "", "g")
"         let prefix = "vim-" . name
"         let suffix = name . ".vim"
"         if a:strict == 1
"             let prefix = name
"             let suffix = name
"         endif
"         if has_key(self.plugs, suffix)
"                     \ ? isdirectory(self.plugs[suffix].dir)
"                     \ : has_key(self.plugs, prefix)
"                     \ ? isdirectory(self.plugs[prefix].dir)
"                     \ : s:false
"             continue
"         else
"             return s:false
"         endif
"     endfor
"
"     return s:true
" endfunction
"
" if s:plug.is_installed("caw.vim", "vim-fzf")
"     echo "ok"
" else
"     echo "not ok"
" endif
