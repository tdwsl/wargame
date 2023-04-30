
0 value nunits
4 cells 5 + constant unit-sz
create units 80 unit-sz * allot

0 constant red-team
1 constant blue-team

1 cells 2 + constant unitd-sz

create unitds
s" Infantry" c, , 0 c,
s" Tank" c, , 1 c,

: unit ( u -- addr ) unit-sz * units + ;

: unit-team 4 cells + ;
: unit-type 4 cells + 1+ ;
: unit-status 4 cells + 2 + ;
: unit-hp 4 cells + 3 + ;
: unit-ap 4 cells + 4 + ;
: unit-xy@ ( addr -- x y ) dup @ swap cell+ @ ;
: unit-xy! ( x y addr -- ) swap over cell+ ! ! ;

: unitd ( u -- addr ) unitd-sz * unitds + ;
: unitd-name str@ ;
: unitd-class cell+ 2 + c@ ;

: unit-at ( x y -- addr|0 )
  nunits 0 do
    2dup i unit unit-xy@ rot = >r = r> and if
      2drop i unit unloop exit
    then
  loop
  2drop 0 ;

: add-unit ( x y type team -- )
  nunits unit >r
  0 r@ unit-status c!
  0 r@ unit-ap c!
  r@ unit-team c!
  r@ unit-type c!
  r> unit-xy!
  nunits 1+ to nunits ;

: draw-unit ( addr -- )
  >r
  t-units
  0 r@ unit-ap c@ if 32 + r@ unit-team c@ 32 * + then
  r@ unit-type c@ 64 *
  32 32
  r> unit-xy@
  map-blit ;

: draw-units ( -- )
  nunits 0 do i unit draw-unit loop ;
