\d .chess

//.chess.moves

// Black Pawn
moves.P:{[cords]
  res:$[cords[1]="7";
    :moves.pawnAttack[-1;cords],{x where cfg.openSpace each x} cords[0],/:string ("I"$cords[1])+neg(1 2);
    :moves.pawnAttack[-1;cords],{x where cfg.openSpace each x }(enlist cords[0],string -1+"I"$cords[1])
   ];
  moves.spotCheck res
 }

// White Pawn
moves.p:{[cords]
  res:$[cords[1]="2";
    :moves.pawnAttack[1;cords],{x where cfg.openSpace each x} cords[0],/:string ("I"$cords[1])+(1 2);
    :moves.pawnAttack[1;cords],{x where cfg.openSpace each x} (enlist cords[0],string 1+"I"$cords[1])
   ];
  moves.spotCheck res
 }

// Rook
moves.r:{[cords]
  moves.generic[cords;moves.direction.r;7]
 }

// Bishop
moves.b:{[cords]
  moves.generic[cords;moves.direction.b;7]
 }

// Knight
moves.n:{[cords]
  moves.generic[cords;moves.direction.n;1]
 }

moves.q:{[cords]
  moves.generic[cords;moves.direction.q;7]
 }

moves.k:{[cords]
  moves.kingmove:1b;
  moves.generic[cords;moves.direction.k;1]
 }

moves.pawnAttack:{[team;cords]
  atkSpaces:moves.spotCheck ("c"$(-1 1)+"i"$cords[0]),\:string team+"I"$cords[1];
  :atkSpaces where cfg.opponent[team;]each atkSpaces
 }

moves.spotCheck:{[options]
  options where options in cross["ABCDEFGH";string 1+til 8]
 }

// where cords are origin cords - string
// direction is a single move unit in the x,y plane. i.e 0,1 moves left 1
// iterations is how many times the piece can repeat the single move unit max is 7
moves.generic:{[cords;direction;iterations]
  moves.spotCheck each {("c"$(y[0]*z)+"i"$x[0]),'string (y[1]*z)+"I"$x[1]}[cords;;1+til iterations]@'direction
 }

moves.direction.q:(-1 -1;-1 0;-1 1;0 -1;0 1;1 -1;1 0;1 1);
moves.direction.k:(-1 -1;-1 0;-1 1;0 -1;0 1;1 -1;1 0;1 1);
moves.direction.b:(-1 -1;-1 1;1 -1;1 1);
moves.direction.r:(-1 0;0 -1;0 1;1 0);
moves.direction.n:(-1 -2;-1 2;1 -2;1 2;-2 -1;-2 1;2 -1;2 1);
