function! s:cptool(mv, bang, ...) "{{{
  let src = []
  let mv = a:mv ? 'mv' : 'cp'
  let bang = empty(a:bang) ? 1 : 0

  " Split the arguments into src and dest {{{
  if a:0 == 1
    call add(src, expand('%'))
    let dst = expand(simplify(a:1))

  elseif a:0 == 2
    " If the src file is a directory.
    if !filereadable(a:1)
      echo printf("%s: %s: Is a directory", mv, a:1)
      return 0
    endif

    call add(src, expand(simplify(a:1)))
    let dst = expand(simplify(a:2))

  " a:0 >= 3
  else
    " The last argument must be a directory.
    if !isdirectory(a:000[-1])
      echo printf("%s: target `%s' is not a directory", mv, a:000[-1])
      return 0
    endif

    for file in a:000[0:-2]
      if filereadable(file)
        call add(src, expand(simplify(file)))
      endif
    endfor
    let dst = expand(simplify(a:000[-1]))
  endif
  "}}}

  " Coping or moving {{{
  let dst_success  = []
  let reopen_stack  = []
  for file in src
    " Get the pull path of a src file
    let src_file = fnamemodify(file, ':p')
    " If the dest is a directory or file.
    let dst_file = isdirectory(dst)
          \ ? substitute(fnamemodify(dst, ':p'), '/$', '', '') . '/' . file
          \ : fnamemodify(dst, ':p')

    " Overwrite?
    if filereadable(dst_file) && bang
      echo '"' . dst_file . '" is exists. Overwrite? [y/N]'
      if nr2char(getchar()) !=? 'y'
        echo 'Cancelled.'
        continue
      endif
    endif

    " Part to actually run
    if writefile(readfile(src_file, "b"), dst_file, "b") != 0
      echo 'cp miss!'
      continue
    else
      call add(dst_success, fnamemodify(dst_file, ':.:~'))
      " Delete the file and wipeout from a buffer-list, if has a:mv
      if a:mv
        call delete(src_file)
        if bufexists(file) && buflisted(file)
          execute 'bwipeout' bufnr(file)
          " Add reopen_stack
          call add(reopen_stack, dst_file)
        endif
      endif
    endif
  endfor

  " Reopen
  if a:mv
    for file in reopen_stack
      execute 'edit' file
    endfor
  endif

  " Display the results when copying or moving one or more files.
  if len(dst_success) >= 1
    echo "Copy " . string(src) . " to " . string(dst_success) . " successfully!"
  endif
  "}}}
endfunction "}}}

command! -nargs=+ -bang -complete=file Cp call s:cptool(0, <q-bang>, <f-args>)
command! -nargs=+ -bang -complete=file Mv call s:cptool(1, <q-bang>, <f-args>)

" vim:fdm=marker expandtab fdc=3 ft=vim ts=2 sw=2 sts=2:
