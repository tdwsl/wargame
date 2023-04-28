
s" img/terrain.png" gds-loadimg constant t-terrain
s" img/units.png" gds-loadimg constant t-units
s" img/ui.png" gds-loadimg constant t-ui
s" img/font.png" gds-loadimg constant t-font

20 gds-updatems!
2 gds-scale!

32 constant scrollsns
8 constant scrollspd
256 constant sidebar-w
128 constant sidebarh-w

0 value cursx
0 value cursy

0 value pnlx
0 value pnly

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
  sidebar-w - mapw tw * 16 + - map-xo max to map-xo
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
  t-ui 0 32 sidebarh-w 64 gds-window 64 - swap sidebar-w - swap
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
  t-ui 0 32 sidebarh-w 64 gds-window 64 - swap sidebarh-w - swap
  2dup to pnly to pnlx gds-blit
  cursx cursy unit-at ?dup 0= if exit then
  dup unit-type c@ >r
  pnlx 48 + pnly 8 + text-cursor
  r@ 134 + dremit 32 dremit
  r@ unitd unitd-name draw-text
  t-units over unit-team c@ 32 * 64 + r@ 32 * 32 32 pnlx 8 + pnly 8 + gds-blit
  r> drop drop ;

\ *** gds words ***

:noname
  draw-map
  draw-units
  draw-cursor
  draw-current-tile
  draw-current-unit
  0 0 text-cursor
  s" Hello world, this is a test, does my butt look big in this font? HOW ABOUT CAPITAL LETTERS? DAMN I'M GOOD!!" 100 draw-text-wrapped
  0 200 text-cursor
  s" wowee this is TOTALLY worth the trouble..." draw-text
; gds-draw!

:noname
  map-xo map-yo
  edge-scroll scroll-restrict
  map-yo <> swap map-xo <> or if gds-redraw then
; gds-update!

:noname
  ." click " gds-mouse swap . . cr
  get-cursor
; gds-click!

