" Vim ftplugin file
" Language: Scheme
" Authors:  Sergi Mansilla <sergi@nimbleteq.com>
"
if exists('*s:ShowChickenDoc') && g:cdoc_perform_mappings
    call s:PerformMappings()
    finish
endif

if !exists('g:cdoc_perform_mappings')
    let g:cdoc_perform_mappings = 1
endif

if !exists('g:cdoc_cmd')
    let g:cdoc_cmd = 'chicken-doc'
endif

if !exists('g:cdoc_open_cmd')
    let g:cdoc_open_cmd = 'split'
endif

setlocal switchbuf=useopen

function! s:GetWindowLine(value)
    if a:value < 1
        return float2nr(winheight(0)*a:value)
    else
        return a:value
    endif
endfunction

" Args: name: lookup;
function! s:ShowChickenDoc(name)
    if a:name == ''
        return
    endif

    if g:cdoc_open_cmd == 'split'
        if exists('g:cdoc_window_lines')
            let l:cdoc_wh = s:GetWindowLine(g:cdoc_window_lines)
        else
            let l:cdoc_wh = 10
        endif
    endif

    if bufloaded("__cdoc__")
        let l:buf_is_new = 0
        if bufname("%") == "__cdoc__"
            " The current buffer is __cdoc__, thus do not
            " recreate nor resize it
            let l:cdoc_wh = -1
        else
            " If the __cdoc__ buffer is open, jump to it
            if exists("g:cdoc_use_drop")
                execute "drop" "__cdoc__"
            else
                execute "sbuffer" bufnr("__cdoc__")
            endif
            let l:cdoc_wh = -1
        endif
    else
        let l:buf_is_new = 1
        execute g:cdoc_open_cmd '__cdoc__'
        if g:cdoc_perform_mappings
            call s:PerformMappings()
        endif
    endif

    setlocal modifiable
    setlocal noswapfile
    setlocal buftype=nofile
    setlocal bufhidden=delete
    setlocal syntax=man
    setlocal nolist

    normal ggdG
    " Remove function/method arguments
    let s:name2 = substitute(a:name, '(.*', '', 'g' )
    " Remove all colons
    let s:cmd = g:cdoc_cmd . ' ' . shellescape(s:name2)

    if &verbose
        echomsg "chicken-doc: calling " s:cmd
    endif
    execute  "silent read !" s:cmd
    normal 1G

    if exists('l:cdoc_wh') && l:cdoc_wh != -1
        execute "resize" l:cdoc_wh
    end

    let l:line = getline(2)
    if l:line =~ "^no documentation found for.*$"
        if l:buf_is_new
            execute "bdelete!"
        else
            normal u
            setlocal nomodified
            setlocal nomodifiable
        endif
        redraw
        echohl WarningMsg | echo l:line | echohl None
    else
        setlocal nomodified
        setlocal nomodifiable
    endif
endfunction

function! s:ExpandModulePath()
    " Extract the 'word' at the cursor, expanding leftwards across identifiers
    " and the # operator, and rightwards across the identifier only.
    let l:line = getline("#")
    let l:pre = l:line[:col("#") - 1]
    let l:suf = l:line[col("#"):]
    return matchstr(pre, "[A-Za-z0-9_.]*$") . matchstr(suf, "^[A-Za-z0-9_]*")
endfunction

" Mappings
function! s:PerformMappings()
    nnoremap <silent> <buffer> <Leader>cw :call <SID>ShowChickenDoc('<C-R><C-W>')<CR>
endfunction

if g:cdoc_perform_mappings
    call s:PerformMappings()
endif

" Commands
command! -nargs=1 Cdoc       :call s:ShowChickenDoc('<args>', 1)
command! -nargs=* CdocSearch :call s:ShowChickenDoc('<args>', 0)
