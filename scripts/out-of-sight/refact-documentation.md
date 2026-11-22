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
- Time for a user starts when we begin processing their turn (including queued moves), users with queued moves can still lose if queue does not process fast enough
- Time will stop for a user when the move is processed and the move confirmation is sent back to both users. ( how to you match local time tracking to server time tracking? )
- Server should understand specific castling commands
- Should keep a move log of every move cofirmed (maybe compressed version?)

CLIENT:
- Initialization is necessary with (time, opp name?, color) can initializae board appropriately. 
- Moves can be communicated back and forth between as 2x 2-byte structs { empty: 4, piece : 3, color : 1, locat: 6},
- Client should validate move is legal before sending structs to server
- When client sends to server, it should add move to queue. Board should not be updated until response is heard from server
- When response is heard back from server, that move should be compared against top of queue. If equal, drop that value. Else leave  it  
- When response receives clear response, it should clear local queue. User is responsible for sending another valid move before time expires
- Since queue is tracked locally and server wise, local machine should block sending more than 20 moves to queue (what happens if it does - hack? )
- Response can be used as validation for the message just sent. An invalid response should be sent back (either white/black empty space) to indicate invalid move. All other responses should be understood as valid responses. ( should there be checking if 1 color hasn't moved in 2 moves? )
- Client should understand specific castling commands
- May be responsible fo rreverse engineering chess logs (for AI/learining process)
- Completely responsible for understanding when the board received is in checkmate
- Should keep a move log of every move confirmed
- A virtual board may be built iteratively from queued moves or reduced iteratively using the move log 
- Queued moves should be based upon the virtual board that is built from iteratively adding all queued moves
- If queue is cleared locally (before server indicates) there needs to be a way to indicate that ( DOES STRUCT NEED TO CHANGE??!!)


