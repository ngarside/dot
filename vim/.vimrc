" """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Settings file used by Vim

" https://vim.rtorr.com
" https://vimhelp.org

" Remap movement keys """"""""""""""""""""""""""""""""""""""""""""""""""""""""""

" j : left
" k : up
" l : down
" ; : right

noremap ; l
noremap l j
noremap j h
noremap h <Nop>

" Remap jump keys """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Holding <shift> while pressing a movement key will jump to the start/end of
" the current document/line

" <shift>+j : start of line
" <shift>+k : start of document
" <shift>+l : end of document
" <shift>+; : end of line

noremap J 0
noremap : $
