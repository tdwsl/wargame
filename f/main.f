
s" img/terrain.png" gds-loadimg constant t-terrain
s" img/units.png" gds-loadimg constant t-units
s" img/ui.png" gds-loadimg constant t-ui

20 gds-updatems!
2 gds-scale!

32 constant scrollsns
8 constant scrollspd
160 constant sidebar-w

0 value cursx
0 value cursy

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
  t-ui 0 32 160 64 gds-window 64 - swap 160 - swap gds-blit
  t-terrain 0 cursx cursy map-tile 32 * 32 32
  gds-window 56 - swap 152 - swap gds-blit ;

\ *** gds words ***

:noname
  t-terrain 0 0 32 512 32 32 gds-blit
  draw-map
  draw-units
  draw-cursor
  draw-current-tile
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

