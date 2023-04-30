
s" img/terrain.png" gds-loadimg constant t-terrain
s" img/units.png" gds-loadimg constant t-units
s" img/ui.png" gds-loadimg constant t-ui
s" img/font.png" gds-loadimg constant t-font

20 gds-updatems!
2 gds-scale!

32 constant scrollsns
8 constant scrollspd
128 constant panelw

0 value cursx
0 value cursy

0 value pnlx
0 value pnly

0 value panelv

48 constant menuw
3 cells 1+ constant menu-sz
create menu menu-sz 15 * allot
0 value menux
0 value menuy
0 value menun
0 value menue?

include f/font.f
include f/map.f
include f/units.f

: load-level ( addr addr -- )
  0 to nunits
  execute
  load-map ;

include f/lvl1.f
load-level

: edge-scroll ( -- )
  gds-mouse 2dup
  scrollsns < if map-yo scrollspd + to map-yo then
  scrollsns < if map-xo scrollspd + to map-xo then
  gds-window scrollsns - rot < if map-yo scrollspd - to map-yo then
  scrollsns - >= if map-xo scrollspd - to map-xo then ;

: scroll-restrict ( -- )
  gds-window maph 1+ th * 8 + - map-yo max to map-yo
  mapw tw * 16 + - map-xo max to map-xo
  map-xo 0 min to map-xo
  map-yo 0 min to map-yo ;

: get-cursor ( -- )
  cursx cursy
  gds-mouse
  map-yo - th 2/ - th / to cursy
  map-xo - cursy 2 mod tfs * - tw / to cursx
  cursx cursy in-bounds? 0= if
    to cursy to cursx
  else 2drop then ;

: draw-cursor t-ui 0 0 32 32 cursx cursy map-blit ;

: draw-current-tile
  t-ui 0 32 panelw 64 gds-window 64 - panelv * nip 0 swap
  2dup to pnly to pnlx gds-blit
  t-terrain 0 cursx cursy map-tile 32 * 32 32
  pnlx 8 + pnly 8 + gds-blit
  pnlx 48 + pnly 8 + text-cursor
  cursx cursy map-tile tile tile-name draw-text
  pnlx 48 + pnly 24 + text-cursor
  dr" Def. " cursx cursy map-tile tile tile-defense 128 + dremit
  pnlx 8 + pnly 48 + text-cursor
  dr" (" cursx dr. dr" , " cursy dr. dr" )"
  pnlx 48 + pnly 40 + text-cursor
  cursx cursy map-tile tile tile-units
  4 0 do dup i 134 + dremit i + c@ 128 + dremit 32 dremit loop
  pnlx 48 + pnly 48 + text-cursor
  6 4 do dup i 134 + dremit i + c@ 128 + dremit 32 dremit loop drop ;

: draw-current-unit
  cursx cursy unit-at ?dup 0= if exit then
  t-ui 0 32 panelw 64 gds-window 64 - panelv * swap panelw - swap
  2dup to pnly to pnlx gds-blit
  dup unit-type c@ >r
  pnlx 48 + pnly 8 + text-cursor
  r@ unitd unitd-name draw-text
  pnlx 8 + pnly 48 + text-cursor
  r@ 134 + dremit
  t-units over unit-team c@ 32 * 64 + r@ 32 * 32 32 pnlx 8 + pnly 8 + gds-blit
  r> drop drop ;

: get-panelv
  cursy th * th 2/ + map-yo + gds-window 2/ nip < negate to panelv ;

: draw-menu
  menun 0 ?do
    t-ui 0 96 menuw 16 menux menuw menue? * + menuy i 16 * + gds-blit
    menux menuw menue? * + 2 + menuy i 16 * + 1+ text-cursor
    menu i menu-sz * + str@ draw-text
  loop ;

: menu-add ( addr addr str len -- )
  menun menu-sz * menu + dup >r str! r>
  cell+ 1+ dup >r ! r> cell+ !
  menun 1+ to menun ;

: build-menu-unit ( addr -- )
  drop ;

: build-menu
  gds-mouse drop menuw + gds-window drop >= to menue?
  0 to menun
  cursx cursy unit-at ?dup if build-menu-unit then
  0 0 s" Map info" menu-add
  0 0 s" End turn" menu-add ;

\ *** gds words ***

:noname
  get-panelv
  draw-map
  draw-units
  draw-cursor
  draw-current-tile
  draw-current-unit
  draw-menu
  0 0 text-cursor
; gds-draw!

:noname
  menux map-xo - menuy map-yo -
  map-xo map-yo
  edge-scroll scroll-restrict
  map-yo <> swap map-xo <> or if gds-redraw then
  map-yo + to menuy map-xo + to menux
; gds-update!

:noname
  cursx cursy get-cursor
  cursy = swap cursx = and if
    gds-mouse to menuy to menux
    menun if 0 to menun else build-menu then
    gds-redraw
  else 0 to menun then
; gds-click!

