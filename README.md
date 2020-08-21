# qChess

Project still in progress.
Missing functionality: en-passant, castle
Known Bugs: pawns cannot capture

To Play:
It is generally convenient to enter the .chess namespace before playing as all commands exist in that domain
The lowercase letters are white, the uppercase letters are black

* .chess.start - Initialize game. New board, new game log, etc. 
* .chess.showOptions[x] - Where x is coordinates, will show all the possible move options for the piece on the selected square. 
* .chess.move[x;y] - Where x is the origin coordinates, y is the destination coordinates. Will move the piece at x to y (if a legal move)

At the moment there is no AI, so the user will have to play against his/herself. 
