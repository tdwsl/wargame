
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

3 cells 10 + constant tile-sz
create tiles
s" Deep Water" c, , 1 c,
0 c, 0 c, 0 c, 4 c, 3 c, 5 c,
s" You didn't come into this world. You came out of it, like a wave from the ocean. You are not a stranger here." c, ,
s" Deep water is traversed more slowly, and cannot be accessed by smaller vessels. Helicopters and large boats move slower." c, ,

s" Water" c, , 1 c,
0 c, 0 c, 5 c, 5 c, 4 c, 5 c,
s" You never really know what's coming. A small wave, or maybe a big one. All you can really do is hope that whe it comes, you can surf over it, instead of dron in its monstrosity." c, ,
s" This tile can only be accessed by boats and flying vehicles. It is ideal for large boats." c, ,

s" Shallow Water" c, , 1 c,
1 c, 0 c, 3 c, 2 c, 5 c, 5 c,
s" They both listened silently to the water, which to them was not just water, but the voice of life, the voice of Being, the voice of perpetual Becoming." c, ,
s" Can be waded through by infantry units. Ideal terrain for loading and unloading troops into ships." c, ,

s" Grass" c, , 1 c,
5 c, 3 c, 0 c, 0 c, 5 c, 5 c,
s" To me a lush carpet of pine needles or spongy grass is more welcome than the most luxurious persian rug." c, ,
s" Open and undefended, this terrain is easily traversable by infantry." c, ,

s" Sand" c, , 1 c,
3 c, 1 c, 0 c, 0 c, 5 c, 5 c,
s" I don't like sand. It's coarse, and rough, and irritating, and it gets everywhere." c, ,
s" This terrain is difficult to traverse by land, and undefended." c, ,

s" Road" c, , 1 c,
5 c, 5 c, 0 c, 0 c, 5 c, 5 c,
s" If you don't know where you are going, any road will get you there." c, ,
s" Roads make for fast travel in land vehicles, but are undefended." c, ,

s" Bridge" c, , 1 c,
5 c, 5 c, 3 c, 3 c, 5 c, 5 c,
s" What is great in man is that he is a bridge and not a goal." c, ,
s" Bridges are fast to traverse in land vehicles, and undefended. They can also be slowly traversed by boats." c, ,

s" Forest" c, , 4 c,
2 c, 0 c, 0 c, 0 c, 5 c, 5 c,
s" What we are doing to the forests of the world is but a mirror reflection of what we are doing to ourselves and to one another." c, ,
s" Difficult to traverse, but provide good coverage for infantry. Cannot be traversed by land vehicles." c, ,

s" Hill" c, , 3 c,
2 c, 0 c, 0 c, 0 c, 4 c, 5 c,
s" Just remember, once you're over the hill you begin to pick up speed." c, ,
s" Rugged terrain providing some defense for infantry. Cannot be traversed by land vehicles, helicopters have limited mobility." c, ,

s" Mountain" c, , 5 c,
1 c, 0 c, 0 c, 0 c, 1 c, 3 c,
s" Climb the mountain so you can see the world, not so the world can see you." c, ,
s" Slow to traverse, but well defended terrain. Cannot be travelled by land vehicles. Air vehicles have limited mobility." c, ,

: tile ( u -- addr )
  tile-sz * tiles + ;

: str@ ( addr -- str len ) dup 1+ @ swap c@ ;
: str! ( str len addr -- )
  swap over c! 1+ ! ;

: tile-name ( addr -- str len ) str@ ;
: tile-defense cell+ 1+ c@ ;
: tile-units cell+ 2 + ;
: tile-infantry tile-units c@ ;
: tile-land tile-units 1 + c@ ;
: tile-smallboat tile-units 2 + c@ ;
: tile-sea tile-units 3 + c@ ;
: tile-heli tile-units 4 + c@ ;
: tile-air tile-units 5 + c@ ;

: tile-quote tile-units 6 + str@ ;
: tile-desc tile-units 6 + 1+ cell+ str@ ;

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

