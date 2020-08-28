// WELCOME TO CHESS!! written by James Betz

\d .chess

system each "l ",/:ssr[string .z.f;"chess.q";] each ("moves.q";"config.q";"locations.q";"checkmate.q");
//system"l config.q";
//system"l locations.q";
//system"l checkmate.q";

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
  res:$[dest in `$cfg.cs;.chess.moves.castle[orig;dest;team];.chess.cfg.testCheck[orig;dest;team]];
  .debug.e:3;
  $[cfg.checkmate first `w`b except team;:"Congrats you have won";res]
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
start:.chess.cfg.initialize[];
