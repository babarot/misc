" dotlog.vim

if exists("g:loaded_dotlog")
  finish
endif
let g:loaded_dotlog = 1

let s:save_cpo = &cpo
set cpo&vim

function s:check_bof_dotlog()
  if getline(1) =~? '.LOG'
  "echo strftime("%H:%M %Y/%m/%d")
  call append(line('$'), '')
  call append(line('$'), strftime("%H:%M %Y/%m/%d"))
  endif
endfunction

augroup insert-time
  autocmd!
  "autocmd BufRead * if getline(1) =~? '.LOG' | call s:check_bof_dotlog()| endif
  autocmd BufRead * call s:check_bof_dotlog()
augroup END

let &cpo = s:save_cpo
unlet s:save_cpo

" vim:set et fdm=marker ft=vim ts=2 sw=2 sts=2:
