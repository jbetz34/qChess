\d .chess
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
