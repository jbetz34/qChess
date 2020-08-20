// attempt to limit moves based on whether a player is in check
// need to find the king an whether it is in check

\d .chess

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
  first .chess[team;`king;`] in `$distinct raze showOptions each location[opp;`all]
 }

b.king:{.chess.location.b.dic`K}
w.king:{.chess.location.w.dic`k}
