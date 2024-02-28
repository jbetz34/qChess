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


SERVER:
- Server needs to hold multiple games in memory. Longer term games can also be saved to disk if necessary (future improvement)
- Game should have 64xstructs, where struct is 4 bits:
    struct {
      unsigned int piece: 3;
      unsigned int color: 1;
    }
- Game board will be about 64 bytes because of this
- Time should be specified/tracked for each player. Units for that time are yet to be decided
- Game should also include player ID/handle (how do I know player/ how is he talking to me? ) (How many bytes are needed?)
- For this reason games can be expressed in a struct { long long board (64 bits); int time white (32 bits); int time black (32bits); handle white (16 bits); handle black (16 bits)}
- Queue (16) exists for each player. Address to that queue should be stored in the struct. 
- Server should know how to clear queue when move is invalid
- When server receives a valid command it should append it to a user's queue
- When server receives clear command it should clear the user's Queue
- When a user's next move is invalid it should clear the user's Queue
- Server should respond to client every time it receives a move, whether that move is its own or the opponents 
- Server will do minimum validation (to be determined later) in exchange for maximum performance

