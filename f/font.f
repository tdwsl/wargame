
create kern

  0 c, 0 c, 0 c, 0 c, 0 c, 0 c, 0 c, 0 c, 0 c, 0 c, 0 c, 0 c, 0 c, 0 c, 0 c, 0 c,

  0 c, 0 c, 0 c, 0 c, 0 c, 0 c, 0 c, 0 c, 0 c, 0 c, 0 c, 0 c, 0 c, 0 c, 0 c, 0 c,
\      !    "    #    $    %    &    '    (    )    *    +    ,    -    .    /
  4 c, 2 c, 4 c, 9 c, 6 c, 7 c, 7 c, 2 c, 4 c, 4 c, 6 c, 6 c, 3 c, 6 c, 2 c, 4 c,
\ 0    1    2    3    4    5    6    7    8    9    :    ;    <    =    >    ?
  6 c, 6 c, 6 c, 6 c, 6 c, 6 c, 6 c, 6 c, 6 c, 6 c, 2 c, 3 c, 5 c, 6 c, 5 c, 6 c,
\ @    A    B    C    D    E    F    G    H    I    J    K    L    M    N    O
  8 c, 6 c, 6 c, 6 c, 6 c, 5 c, 5 c, 7 c, 6 c, 4 c, 6 c, 5 c, 5 c, 8 c, 7 c, 7 c,
\ P    Q    R    S    T    U    V    W    X    Y    Z    [    \    ]    ^    _
  6 c, 8 c, 6 c, 6 c, 6 c, 6 c, 6 c, 8 c, 6 c, 6 c, 6 c, 3 c, 4 c, 3 c, 4 c, 6 c,
\ `    a    b    c    d    e    f    g    h    i    j    k    l    m    n    o
  3 c, 5 c, 5 c, 5 c, 5 c, 5 c, 5 c, 5 c, 5 c, 2 c, 3 c, 5 c, 3 c, 6 c, 5 c, 5 c,
\ p    q    r    s    t    u    v    w    x    y    z    {    |    }    ~
  5 c, 5 c, 5 c, 4 c, 4 c, 5 c, 4 c, 6 c, 4 c, 5 c, 5 c, 4 c, 2 c, 4 c, 6 c, 0 c,
\ icons/graphics
  7 c, 7 c, 7 c, 7 c, 7 c, 7 c, 8 c, 8 c, 8 c, 8 c, 8 c, 8 c, 0 c, 0 c, 0 c, 0 c,

8 constant txw
16 constant txh
14 constant txl

0 value txx
0 value txy
0 value txm
0 value txe

: text-cursor to txy to txx ;

: dremit ( c -- )
  t-font over 32 /mod txh * swap txw * swap txw txh txx txy gds-blit
  kern + c@ txx + to txx ;

: dr. ( n -- )
  dup 0< if negate [char] - dremit then
  0 swap begin
    swap 1+ swap
    10 /mod swap [char] 0 + >r
  dup 0= until
  drop begin dup while r> dremit 1- repeat drop ;

: draw-text ( str len -- )
  0 do dup c@ dremit 1+ loop drop ;

: text-width ( str len -- u )
  0 swap 0 do over i + c@ kern + c@ + loop nip ;

: str>> ( str len u -- str len )
  over min dup >r - swap r> + swap ;

: font-newline ( -- ) txm to txx txy txl + to txy ;

: draw-text-wrapped ( str len w -- )
  to txe txx to txm
  \ txe 0= if draw-text exit then
  0 >r begin dup r@ > while ( -- str len )
    \ over r@ type cr
    over r@ + c@ 32 <= over 1- r@ = or if
      over r@ 1+ 2dup
      text-width txx + txm - txe >= if font-newline then
      draw-text
      over r@ + c@ 10 = if font-newline then
      r> 1+ str>> 0 >r
    then
    r> 1+ >r
  repeat r> drop
  2drop ;

: dr" ( -- ) postpone s" postpone draw-text ; immediate


