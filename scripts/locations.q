\d .chess

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
