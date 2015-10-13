" Compile tex file on macvim

command! -nargs=? -complete=file Tex call s:compile_texfile(<f-args>)
function! s:compile_texfile(...)
    let file = expand('%:p')
    let file = a:0 ? expand(a:1) : expand('%:p')

    let no_ext_file = fnamemodify(file, ':r')
    let log =  system("platex " .  shellescape(file))
    echo log
    call system("dvipdfmx " .  shellescape(no_ext_file.'.dvi'))
    call system("open " .  shellescape(no_ext_file.'.pdf'))
endfunction
