// WELCOME TO CHESS!! written by James Betz

\d .chess

system"l chess/moves.q";
system"l chess/config.q";
system"l chess/locations.q";
system"l chess/checkmate.q";

showOptions:{[cords]
  piece:.chess.board . cfg.convertCords cords;
  cfg.availableOptions[piece;string cords]
 }

move:{[org;dest]
  ocords:string org;
  dcords:string dest;
  piece:.chess.board . cfg.convertCords org;
  team:$[piece=lower piece;`w;`b];
  if[not .chess.cfg.turns[team];:"IT IS NOT YOUR TURN!"];
  if[cfg.check[team]; "YOU ARE IN CHECK!"];
  if[all not string[dest] in .chess.cfg.availableOptions[piece;string org];:"NOT A VALID MOVE. PLEASE TRY AGAIN."];
  .chess.log.write[team;org;dest];
  location.upd[team;org;dest];
  .chess.board["I"$ocords 1;`$ocords 0]:`;
  .chess[team][`take].chess.board . cfg.convertCords dest;
  .chess.board["I"$dcords 1;`$dcords 0]:piece;
  :.chess.board
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
  if[()~num:1+max .chess.log.file[; 0]; num:1];
  .chess.log.file,:enlist(num; team; ocords; dcords)
 }

start:.chess.cfg.initialize[];
