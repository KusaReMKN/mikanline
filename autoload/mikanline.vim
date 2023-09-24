" =============================================================================
" File: autoload/mikanline.vim
" Description: Mikan-Line Plugin
" Author: KusaReMKN <https://github.com/KusaReMKN>
" License: The 2-Clause BSD License (BSD-2-Clause)
" =============================================================================

scriptencoding utf-8

" The function gets the mikanlines from the current buffer and provides a list
" of the commands they contain.  The returned list is sorted and any duplicated
" are eliminated.
function! s:GetMikanLineCommands()
    " If 'modeline' is off or 'modelines' is zero, no lines are checked and
    " this function returns [].
    if !&modeline || !&modelines
        return []
    endif

    let l:last = line('$')
    let l:lines = getline(0, &modelines) + getline(l:last - &modelines, l:last)
    unlet l:last

    let l:commands = []
    for l:line in l:lines
        let l:matched = matchlist(l:line, '\m\(\s\+\|^\)mkn:\(.*\):')
        call add(l:commands, get(l:matched, 2, ''))
    endfor
    return uniq(sort(split(join(l:commands), '\m[ :]')))
endfunction

" The function is invoked when reading the buffer and associates the mikanline
" commands with the current buffer.
function! mikanline#onBufRead()
    " s:mikanline_commands contains the mikanline commands of each buffer.
    " If it does not exist, it is initialised with {}.
    if !exists('s:mikanline_commands')
        let s:mikanline_commands = {}
    endif

    let s:mikanline_commands[bufnr()] = s:GetMikanLineCommands()
endfunction

" The function is invoked when entering the buffer and activates the mikanline
" commands associated with the current buffer.
function! mikanline#onBufEnter()
    " If s:mikanline_commands does not exist, do nothing.
    if !exists('s:mikanline_commands')
        return
    endif

    augroup mikanline_commands
        autocmd!
        let l:commands = get(s:mikanline_commands, bufnr(), [])
        for l:command in l:commands
            let l:lineCommands = get(g:mikanline, l:command, {})
            for [ l:ev, l:cmds ] in items(l:lineCommands)
                for l:cmd in l:cmds
                    let l:acmd = [
                        \ 'autocmd',
                        \ 'mikanline_commands',
                        \ l:ev,
                        \ '<buffer>',
                        \ l:cmd ]
                    call execute(join(l:acmd))
                endfor
            endfor
        endfor
    augroup END
endfunction

" Poke Mikan-chan!
function! mikanline#WakeUpMikanchan()
    if !exists('s:mknstat')
        let s:mknstat = 1
        call srand()
    endif

    if s:mknstat == 1
        echo $LANG =~ 'ja'
                    \ ? 'うーん... まだねむいよ...'
                    \ : 'Mmm... still sleepy...'
    elseif s:mknstat == 2
        echo $LANG =~ 'ja'
                    \ ? 'わかったよ... おきるよ...'
                    \ : "Okay... I'll get up..."
        let s:mknstat = 3
    else
        echo '......'
    endif

    if rand() % 16 == 0
        let s:mknstat = s:mknstat + 1
    endif
endfunction

" mkn: Zzz :
" vim: se et ts=4 :
