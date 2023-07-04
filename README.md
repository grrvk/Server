# Server
Lab for Uni - Client and Server parts for announcement board

Client and Server parts for announcement board
Programming language for client - Python, Server - Swift

Commands:
Who - server gives information about creator and Lab
Put # .. - server writes given announcement on # place on the board (if # is valid)
CLR - server clears the board
CLR # - server clears # place on the board
Stop - client is disconnected from the server

Server and client both maintain activity in .txt files, which contain socket info and response data in form ON/NOK (Not OK)
If command is not valid - error appears
