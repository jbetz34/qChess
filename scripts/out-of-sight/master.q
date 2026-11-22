// WELCOME TO CHESS!! written by James Betz

\d .chess

showOptions:{[cords]
  piece:.chess.board . cfg.convertCords cords;
  cfg.availableOptions[piece;string cords]
 }

move:{[orig;dest]
  ocords:string orig;
  dcords:string dest;
  piece:.chess.board . cfg.convertCords orig;
  team:$[piece=lower piece;`w;`b];
  if[not .chess.cfg.turns[team];:"IT IS NOT YOUR TURN!"];
  .debug.q:1;
  if[all not dcords in .chess.cfg.availableOptions[piece;ocords];:"NOT A VALID MOVE. PLEASE TRY AGAIN."];
  .debug.w:2;
  res:$[all (`k=lower piece;dest in `$cfg.cs);
		.chess.moves.castle[orig;dest;team];
	all (`p=lower piece;dest in `$moves.enpassant[(`w`b!1 -1)team;ocords]);
		.chess.moves.enp[orig;dest;team];
	.chess.cfg.testCheck[orig;dest;team]
	];
  .debug.e:3;
  $[cfg.checkmate first `w`b except team;:("Congrats you have won";show .chess.board);res]
 }

b.take:{[piece]
  .chess.w.captured,:enlist piece;
  //should this be {x set x where not null x}??
  {x set x where not null x}.chess.w.captured;
  locat:.chess.w.remaining? piece;
  n:count .chess.w.remaining;
  .chess.w.remaining:.chess.w.remaining[(til n)except locat]
 }

w.take:{[piece]
  .chess.b.captured,:enlist piece;
  {x set value x set x where not null value x}`.chess.b.captured;
  locat:.chess.b.remaining? piece;
  n:count .chess.b.remaining;
  .chess.b.remaining:.chess.b.remaining[(til n)except locat]
 }

log.write:{[team; ocords; dcords]
  .debug.t,:.z.P;
  if[()~num:1+max .chess.log.file[; 0]; num:1];
  .chess.log.file,:enlist(num; team; ocords; dcords)
 }

.z.ts:{w.options:`$distinct raze showOptions each location[`w;`all];b.options:`$distinct raze showOptions each location[`b;`all];}
system"t 500";

/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/

// .chess.cfg

.debug.t:enlist 0np;
cfg.cs:"";

cfg.convertCords:{[cords]
  ("I"$string[cords] 1;`$string[cords] 0)
 }

cfg.team:{`w`b@x=upper x}

cfg.moveOptions:{[piece;ocords]
  $[`p=lower piece;();null piece;:"XX";piece:lower piece];
  :(.chess.moves[piece] [ocords]);
 }

cfg.castle:{[team;sq] string sq[0] where min each ((not[cfg.check team],location[team;`kingmove]),/:location[team;`arook`hrook]),'{cfg.openSpace'[y],cfg.test[first .chess[x;`king;`];;x]'[y except `B1`B8]}[team] each sq 1 2}

// at some point I will might switch to this method, otherwise use separate piece funcs
//cfg.moveOptions:{[piece;ocords]
//  $[`p=lower piece;();null piece;:"XX";piece:lower piece];
//  :(.chess.moves[ocords;moves.direction[piece];moves.maxmoves[piece]])
// }

cfg.turns:{[team]
  team~$[(count .chess.log.file) mod 2;`b;`w]
 }

cfg.opponent:{[team;cords]
  / team: (white;-1) (black;1)
  $[0>team;chkSame:{x~lower x};chkSame:{x~upper x}];
  opp:board . cfg.convertCords cords;
  :$[null opp;:0b;chkSame opp;:0b;:1b]
 }

//cfg.availableOptions: {[piece;ocords]
//  list:.chess.cfg.moveOptions[piece;ocords];
//  if[list~"XX";:()];
//  if[`p=lower piece;:list];
//  if[1<count blockers:list where not .chess.cfg.openSpace each list;enlist blockers];
//  if[1<count options:list where .chess.cfg.openSpace each list;enlist options];
//  .chess.cfg.blk[ocords;blockers;options]
// }

// utilizes directions for a more straighforward approach to blockers
cfg.availableOptions:{[piece;ocords]
  .debug.x:(piece;ocords);
  list:.chess.cfg.moveOptions[piece;ocords];
  .debug.x2:(piece;ocords);
  if[list~"XX";:()];
  if[`p=lower piece;:list];
  if[`k=lower piece;list,:enlist each cfg.cs:cfg.castle[cfg.team piece;location[cfg.team piece;`csquares]]];
  .debug.list:list;
  blk:first each {where not cfg.openSpace each x}'[list];
  m:@[blk;where not null blk;+;] .chess.cfg.opponent[$[piece~lower piece;-1;1]] each moves.spotCheck list@'blk;
  raze list@'til each count'[list]^m
 }

// determines if given cords are empty or not
cfg.openSpace:{[cords]
  $[null board . cfg.convertCords cords;1b;0b]
 }

cfg.test:{[orig;dest;team]
  tmp:.chess.board;
  tmpLoc:.chess.location[`w`b];
  .[`.chess.board;cfg.convertCords dest;:;] tmp . cfg.convertCords orig;
  .[`.chess.board;cfg.convertCords orig;:;`];
  .chess.location.upd[tmp;team;orig;dest];
  res:not cfg.check[team];
  .chess.board:tmp; 
  @[`.chess.location;`w`b;:;tmpLoc];
  res
 }


// test if the move will put/keep team in check. If not, follow move protocol
cfg.testCheck:{[orig;dest;team]
  tmp:.chess.board;
  tmpLoc:.chess.location[`w`b];
  .[`.chess.board;cfg.convertCords dest;:;] tmp . cfg.convertCords orig;
  .[`.chess.board;cfg.convertCords orig;:;`];
  .chess.location.upd[tmp;team;orig;dest];
  .z.ts[];
  $[not cfg.check[team];
    [ cfg.recordMove[tmp;orig;dest;team]; .chess.board ];
    [ .chess.board:tmp; @[`.chess.location;`w`b;:;tmpLoc]; "YOU ARE IN CHECK!" ]
  ]
 }

cfg.recordMove:{[board;orig;dest;team]
  .chess.log.write[team;orig;dest];
  location.upd[board;team;orig;dest];
  .chess[team][`take]board . cfg.convertCords dest;
 }

cfg.initialize:{[]
  .chess.board:.chess.cfg.board[];
  .chess.log.file:();
  .chess.b.caputred:();
  .chess.w.captured:();
  .chess.b.remaining:(`K`Q`B`B`N`N`R`R,8#`P);
  .chess.w.remaining:lower .chess.b.remaining;
  .chess.board[1;]:`r`n`b`q`k`b`n`r;
  .chess.board[2;]:`p;
  .chess.board[7;]:`P;
  .chess.board[8;]:`R`N`B`Q`K`B`N`R;
  :.chess.board
 }

cfg.board:{[]
  ([KEY:reverse 1+til 8]A:8#`;B:8#`;C:8#`;D:8#`;E:8#`;F:8#`;G:8#`;H:8#`)
 }

//cfg.blk:{[cords;blocker;options]
//  direction:flip(("i"$blocker[;0])-"i"$cords[0];("i"$blocker[;1])-"i"$cords[1]);
//  blocks:.chess.moves.spotCheck distinct raze{("c"$(y[0]+signum[y[0]]*til 8)+"i"$x[0]),'string (y[1]+signum[y[1]]*til 8)+"I"$x[1]}[cords]@'direction;
//  options except blocks
// }

/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/

location.w.dic:(
  ``k`q`r`b`n`p!(enlist `;enlist `E1;enlist `D1;`A1`H1;`C1`F1;`B1`G1;`A2`B2`C2`D2`E2`F2`G2`H2)
 );

location.w.all:{raze x `k`q`r`b`n`p}[.chess.location.w.dic];

// these corresopnd to whether rooks have moved; arook = rook on A file, hrook = rook on H file
location.w.kingmove:1b;
location.w.arook:1b;
location.w.hrook:1b; 
location.b.kingmove:1b;
location.b.arook:1b;
location.b.hrook:1b;
location.w.csquares:(`C1`G1;`B1`C1`D1;`F1`G1);
location.b.csquares:(`C8`G8;`B8`C8`D8;`F8`G8);

location.b.dic:(
   ``K`Q`R`B`N`P!(enlist `;enlist `E8;enlist `D8;`A8`H8;`C8`F8;`B8`G8;`A7`B7`C7`D7`E7`F7`G7`H7)
 );

location.b.all:{raze x `K`Q`R`B`N`P}[.chess.location.b.dic];

location.upd:{[board;team;ocords;dcords]
   opp:first `w`b except team;
   piece:board . cfg.convertCords ocords;
   if[`k=lower piece;.[`.chess.location;(team;`kingmove);:;0b]];
   if[min(any location[team;`arook`hrook];`r=lower piece;in[;"ah"] lower first string ocords);.[`.chess.location;(team;`$lower[first string ocords],"rook");:;0b]];
   .debug.piece:piece;
   dpiece:board . cfg.convertCords dcords;
   .debug.dpiece:dpiece;
   locs:{x where not x=y}[location[team;`dic;piece]; ocords];
   .debug.locs:locs;
   dlocs:{x where not x=y}[location[opp;`dic;dpiece]; dcords];
   .debug.dlocs:dlocs;
   location[team;`dic;piece]:locs,dcords;
   location[opp;`dic;dpiece]:dlocs;
   location.b.all:{raze x `K`Q`R`B`N`P}[.chess.location.b.dic];
   location.w.all:{raze x `k`q`r`b`n`p}[.chess.location.w.dic];
 }

/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/

//.chess.moves

// Black Pawn
moves.P:{[cords]
  res:$[cords[1]="7";
    :moves.enpassant[-1;cords],moves.pawnAttack[-1;cords],{x where cfg.openSpace each x} cords[0],/:string ("I"$cords[1])+neg(1 2);
    :moves.enpassant[-1;cords],moves.pawnAttack[-1;cords],{x where cfg.openSpace each x }(enlist cords[0],string -1+"I"$cords[1])
   ];
  moves.spotCheck res
 }

// White Pawn
moves.p:{[cords]
  res:$[cords[1]="2";
    :moves.enpassant[1;cords],moves.pawnAttack[1;cords],{x where cfg.openSpace each x} cords[0],/:string ("I"$cords[1])+(1 2);
    :moves.enpassant[1;cords],moves.pawnAttack[1;cords],{x where cfg.openSpace each x} (enlist cords[0],string 1+"I"$cords[1])
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
  moves.generic[cords;moves.direction.k;1]
 }

moves.pawnAttack:{[team;cords]
  atkSpaces:moves.spotCheck ("c"$(-1 1)+"i"$cords[0]),\:string team+"I"$cords[1];
  :atkSpaces where cfg.opponent[neg team;]each atkSpaces
 }

moves.enpassant:{[team;cords]
  atkSpaces:moves.spotCheck ("c"$(-1 1)+"i"$cords[0]),\:string team+"I"$cords[1];
  enpas:moves.spotCheck ("c"$(-1 1)+"i"$cords[0]),\:string "I"$cords[1];
  enpas: enpas where cfg.opponent[neg team;]each enpas;
  startSq:enpas[;0],'string("I"$enpas[;1])+team*2;
  atkSpaces where (last .chess.log.file)[2 3] in/: enlist each ,'[`$startSq;`$enpas]
 }

moves.enp:{[orig;dest;team]
  res:.chess.cfg.testCheck[orig;dest;team];
  o:`A9;
  d:`$@[string dest;1;{first string (`w`b!-1 1)[x]+"I"$y}[team]];
  if[not type[res]=98;
	.debug.x:.z.P;
	.debug.catch:(o;d);
	location.upd[board;team;o;d];
  	.chess[team][`take]board . cfg.convertCords d;
	.[`.chess.board;cfg.convertCords d;:;`];
	:.chess.board
  ]
  res
 }
  

moves.castle:{[orig;dest;team]
  .chess.location.upd[board;team;orig;dest];
  .chess.location.upd[board;team;(`G1`C1`G8`C8!`H1`A1`H8`A8)dest;(`G1`C1`G8`C8!`F1`D1`F8`D8)dest];
  .[`.chess.board;cfg.convertCords dest;:;(`w`b!`k`K)team];
  .[`.chess.board;cfg.convertCords orig;:;`];
  .[`.chess.board;cfg.convertCords (`G1`C1`G8`C8!`F1`D1`F8`D8)dest;:;(`w`b!`r`R)team];
  .[`.chess.board;cfg.convertCords (`G1`C1`G8`C8!`H1`A1`H8`A8)dest;:;`];
  .chess.log.write[team;orig;dest];
  .chess.board
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

/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/

//checkmate.q

// attempt to limit moves based on whether a player is in check
// need to find the king an whether it is in check

//cfg.updKing:{
//  location:select column:{first (1 _ cols board) where `k=x}(A,B,C,D,E,F,G,H) by KEY from board;
// cfg.location.k:cfg.board2space location;
//  location:select column:{first (1 _ cols board) where `K=x}(A,B,C,D,E,F,G,H) by KEY from board;
//  cfg.location.K:cfg.board2space location;
//}

cfg.board2space:{
   ?[x;enlist (not;null `column);();enlist ($;`;(raze(string;H,KEY)))]
 }

// checks if the team provided is in check
cfg.check:{[team]
  opp:first `w`b except team;
  first .chess[team;`king;`] in .chess[opp;`options] 
 }

// checks if the team provided is in checkmate
cfg.checkmate:{[team]
  not any cfg.test[;;team] ./: raze distinct location[team;`all],/:'`$showOptions each location[team;`all]
 }

b.king:{.chess.location.b.dic`K}
w.king:{.chess.location.w.dic`k}

.chess.start:.chess.cfg.initialize[]
