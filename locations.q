\d .chess

location.w.dic:(
  ``k`q`r`b`n`p!(enlist `;enlist `E1;enlist `D1;`A1`H1;`C1`F1;`B1`G1;`A2`B2`C2`D2`E2`F2`G2`H2)
 );

location.w.all:{raze x `k`q`r`b`n`p}[.chess.location.w.dic];

 location.b.dic:(
   ``K`Q`R`B`N`P!(enlist `;enlist `E8;enlist `D8;`A8`H8;`C8`F8;`B8`G8;`A7`B7`C7`D7`E7`F7`G7`H7)
 );

location.b.all:{raze x `K`Q`R`B`N`P}[.chess.location.b.dic];

 location.upd:{[team;ocords;dcords]
   opp:first `w`b except team;
   piece:board . cfg.convertCords ocords;
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
