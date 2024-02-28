Existing architecture!
API: 

Three commands:
  - showmoves
  - move
  - promote

@showmoves:
  description: based on location, identifies piece and potential moves for that piece
    input: location
    output: location(s)
  
@move:
  description: based on two locations, moves piece from one location to another. Performs relevant checks to determine piece is able to make the move and there are no issues with players moving out of turn(could potentially be moved out). 
    input: (location, location)
    output: board

@promote:
  description: moves piece from location a to location b and promotes it to piece c. 
    input: (location, location, piece)
    output: board
