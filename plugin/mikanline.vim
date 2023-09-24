" =============================================================================
" File: plugin/mikanline.vim
" Description: Mikan-Line Plugin
" Author: KusaReMKN <https://github.com/KusaReMKN>
" License: The 2-Clause BSD License (BSD-2-Clause)
" =============================================================================

scriptencoding utf-8

" TODO: version check
if exists('g:loaded_mikanline')
    finish
endif
let g:loaded_mikanline = 1

augroup mikanline
    autocmd!
    autocmd BufRead * call mikanline#onBufRead()
    autocmd BufEnter * call mikanline#onBufEnter()
augroup END

if !exists('g:mikanline')
    let g:mikanline = {
        \ 'Zzz': {
            \ 'SigUSR1': [
                \ 'call mikanline#WakeUpMikanchan()'
            \ ]
        \ }
    \ }
endif

" mkn: Zzz :
" vim: se et ts=4 :
