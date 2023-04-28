
0 value map
0 0 value mapw value maph
0 value map-xo
0 value map-yo

30 constant tw
19 constant th
15 constant tfs

: dw 0 c, ;
: ww 1 c, ;
: sw 2 c, ;
: gs 3 c, ;
: sd 4 c, ;
: rd 5 c, ;
: bg 6 c, ;
: fs 7 c, ;
: hl 8 c, ;
: mt 9 c, ;

1 cells 8 + constant tile-sz
create tiles
s" Deep Water" c, , 1 c,
0 c, 0 c, 0 c, 4 c, 3 c, 5 c,
s" Water" c, , 1 c,
0 c, 0 c, 5 c, 5 c, 4 c, 5 c,
s" Shallow Water" c, , 1 c,
1 c, 0 c, 3 c, 2 c, 5 c, 5 c,
s" Grass" c, , 1 c,
5 c, 3 c, 0 c, 0 c, 5 c, 5 c,
s" Sand" c, , 1 c,
3 c, 1 c, 0 c, 0 c, 5 c, 5 c,
s" Road" c, , 1 c,
5 c, 5 c, 0 c, 0 c, 5 c, 5 c,
s" Bridge" c, , 1 c,
5 c, 5 c, 3 c, 3 c, 5 c, 5 c,
s" Forest" c, , 4 c,
2 c, 0 c, 0 c, 0 c, 5 c, 5 c,
s" Hill" c, , 3 c,
2 c, 0 c, 0 c, 0 c, 4 c, 5 c,
s" Mountain" c, , 5 c,
1 c, 0 c, 0 c, 0 c, 1 c, 3 c,

: tile ( u -- addr )
  tile-sz * tiles + ;

: tile-name ( addr -- str len )
  dup 1+ @ swap c@ ;
: tile-defense cell+ 1+ c@ ;
: tile-units cell+ 2 + ;
: tile-infantry tile-units c@ ;
: tile-land tile-units 1 + c@ ;
: tile-smallboat tile-units 2 + c@ ;
: tile-sea tile-units 3 + c@ ;
: tile-heli tile-units 4 + c@ ;
: tile-air tile-units 5 + c@ ;

: load-map ( addr -- )
  dup @ to mapw cell+ dup @ to maph cell+ to map ;

: map-addr ( x y -- addr )
  mapw * map + + ;

: in-bounds? ( x y -- tf )
  over 0 >= over 0 >= and -rot maph < swap mapw < and and ;

: map-tile ( x y -- t )
  2dup in-bounds? if map-addr c@ else 2drop 255 then ;

: map-tile! ( t x y -- )
  2dup in-bounds? if map-addr c! else 2drop drop then ;

: map-blit ( tx cx cy cw ch x y -- )
  swap tw * over 2 mod tfs * + map-xo +
  swap th * map-yo + gds-blit ;

: draw-map ( -- )
  maph 0 do
    mapw 0 do
        t-terrain
        0 i j map-addr c@ 32 * 32 32
        i j map-blit
    loop
  loop ;

