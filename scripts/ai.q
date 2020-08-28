// WELCOME TO CHESS!! written by James Betz

\d .ai

// AI Program
cfg.isUpper:{[piece]
  not (lower piece)= piece
 }

cfg.isLower:{[piece]
  not (upper piece)= piece
 }

cfg.findPiece:{[tab;space]
/  if[(type space) in (11;-11); .ai.cfg.symToCords each space];
  {[tab;x;y] tab[y; x]}[tab] ./: space
 }

cfg.symToCords:{[s]
  // where x is atomic
  x:string s;
  (`$x[0]; "J"$x[1])
 }

cfg.cordsToSym:{[cords]
  // where x is enlisted (`A;1)
  x:raze cords;
  `$(,) . string x
 }

cfg.findBlack:{[tab;print]
  // create spaces
  // find the value at the space
  // boolean list of black space
  // spaces where boolean
  spaces: cross[`$/:"ABCDEFGH"; 1+til 8];
  symSpaces: cfg.cordsToSym each spaces;
  p:cfg.findPiece[tab;] spaces;
  b:cfg.isUpper p;
  .ai.black.spaces:symSpaces where b;
  if[ print; :.ai.black.spaces];
 }

cfg.findWhite:{[tab;print]
  // create atkSpaces
  // find the value at teh space
  // boolean list of white space
  // spaces where boolean
  spaces: cross[`$/:"ABCDEFGH"; 1+til 8];
  symSpaces: cfg.cordsToSym each spaces;
  p:cfg.findPiece[tab;] spaces;
  w:cfg.isLower p;
  .ai.white.spaces:symSpaces where w;
  if[ print; :.ai.white.spaces];
 }

genMoves:{[]
  .ai.black.moveList::raze {x,/:`$.chess.showOptions x}each .ai.black.spaces
  .ai.white.moveList::raze {x,/:`$.chess.showOptions x}each .ai.white.spaces
 }


move:{[org;dest;table]
   ocords:string org;
   dcords:string dest;
   piece:table["I"$ocords 1;`$ocords 0];
   table["I"$ocords 1;`$ocords 0]:`;
   table["I"$dcords 1;`$dcords 0]:piece;
   :table
  }

makeMove:{[]
  cfg.findBlack[.chess.board;0b]
  move:first 1?.ai.black.moveList;
 .chess.move . move;
 :.chess.board
 }

.z.ts:{[]
  genMoves[];
  if[play;[makeMove[];play:0b]];
 }

cfg.findBlack[.chess.board;0b];
cfg.findWhite[.chess.board;0b];

\d .
// Create dictionary of moveOptions for each place
// Generate hypothetical boards for each move
  // How do we store?
  //
  // How do we generate?
  // How do we look ahead?
// Decide the best board
