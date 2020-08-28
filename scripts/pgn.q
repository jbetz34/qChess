\d .chess

readPGN:{[fp]
  file:read0 pf;
  details:{(`$x[;0])!x[;1]}"\"" vs/: except[;"[]"] each file where "[" = first'[file];
  m:first where pgn like "1.*";
  moves:(,/)pgn first[moves] + til first -[;moves] $[any b:moves<empty:where pgn like "";empty first where b;count[pgn]];
  // separate comments
  if[any moves="{";c1:where moves="{";c2:where moves="}"];
  moves:(,/){x where not x like "{*"}(0,raze (c1,'c2+1)) cut moves;
  mlist:cut[;moves] #[;p] first where null p:{first ss[moves;x]}each (string 1+til 200),\:".";
  mlist
 }

