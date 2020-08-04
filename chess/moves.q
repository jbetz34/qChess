\d .chess

//.chess.moves

// Black Pawn
moves.P:{[cords]
  res:$[cords[1]="7";
    :moves.pawnAttack[-1;cords],{x where cfg.openSpace[`P] each x} cords[0],/:string ("I"$cords[1])+neg(1 2);
    :moves.pawnAttack[-1;cords],{x where cfg.openSpace[`P]each x }(enlist cords[0],string -1+"I"$cords[1])
   ];
  moves.spotCheck res
 }

// White Pawn
moves.p:{[cords]
  res:$[cords[1]="2";
    :moves.pawnAttack[1;cords],{x where cfg.openSpace[`p] each x} cords[0],/:string ("I"$cords[1])+(1 2);
    :moves.pawnAttack[1;cords],{x where cfg.openSpace[`p] each x} (enlist cords[0],string 1+"I"$cords[1])
   ];
  moves.spotCheck res
 }

// Rook
moves.r:{[cords]
  moves.spotCheck distinct raze{{("c"$(y[0]*til 8)+"i"$x[0]),'string (y[1]*til 8)+"I"$x[1]}[x]@/: {x, reverse each x}cross[1 -1;0 0]}[cords]
 }

// Bishop
moves.b:{[cords]
  moves.spotCheck distinct raze {{("c"$(y[0]*til 8)+"i"$x[0]),'string (y[1]*til 8)+"I"$x[1]}[x]@/: cross[1 -1;1 -1]}[cords]
 }

// Knight
moves.n:{[cords]
  moves.spotCheck distinct {{("c"$y[0]+"i"$x[0]),string y[1]+"I"$x[1]}[x]@'{x,neg reverse each x}cross[1 -1;2 -2]}[cords]
 }

moves.q:{[cords]
  moves.b[cords],moves.r[cords]
 }

moves.k:{[cords]
  moves.kingmove:1b;
  moves.spotCheck distinct raze {{("c"$y[0]+"i"$x[0]),'string y[1]+"I"$x[1]}[x]@'{x,neg reverse each x}cross[0 1 -1;0 1 -1]}[cords]
 }

moves.pawnAttack:{[team;cords]
  atkSpaces:moves.spotCheck ("c"$(-1 1)+"i"$cords[0]),\:string team+"I"$cords[1];
  :atkSpaces where cfg.opponent[team;]each atkSpaces
 }

moves.spotCheck:{[options]
  options where options in cross["ABCDEFGH";string 1+til 8]
 }
