set macligatures
set guifont=FiraCodeNerdFontCompleteM-Regular:h15
set antialias
set lines=65 columns=200
set go-=T   "Start without the toolbar
set go+=c   "Do not use modal alert dialogs! (Prefer Vim style prompt.)

" Don't beep
set visualbell

" Fullscreen takes up entire screen
"set fuoptions=maxhorz,maxvert

if has("gui_macvim")
  " Let's unset CMD-t, CMD-T, CMD-S and CMD-W
  macm File.New\ Tab key=<nop>
  macm File.Open\ Tab\.\.\. key=<nop>
  "macm File.Save\ As\.\.\. key=<nop>
  "macm File.Close\ Window key=<nop>

  "Splits 
  nmap <D-t> :sp .<CR>
  nmap <D-T> :vs .<CR>

  "Move a line of text using Command+[jk]
  nmap <D-j> <M-j>
  nmap <D-k> <M-k>
  vmap <D-j> <M-j>
  vmap <D-k> <M-k>
end
