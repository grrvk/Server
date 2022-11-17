import socket
import datetime
def checkComm(command):
    length = len(command)
    if (length==3):
        if (command == "Who"):
            return "3Who"
        elif (command == "CLR"):
            return "3CLR"
        else:
            raise Exception("Invalid command")
    elif (length > 3):
        comm = command.split(' ')[0]
        if (comm == "Put"):
            index = command.split(' ')[1]
            try:
               lengt = len(comm)+len(index)+1
               text = command.split(' ')[2]
            except Exception as e:
               return f"{lengt}Put_{index}"
            return f"{lengt}Put_{index}{text}"
        elif (comm == "CLR"):
            index = command.split(' ')[1]
            try:
               lengt = len(comm)+len(index)+1
               text = command.split(' ')[2]
            except Exception as e:
               return f"{lengt}CLR_{index}"
            raise Exception("Invalid command")
        else:
            raise Exception("Invalid command")
    else:
        raise Exception("Invalid command")
try:
   f = open('/Users/vika/Desktop/LabTextClient.txt', 'w').close()
   client = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
   client.connect((socket.gethostname(), 1030))
   IPAddr=socket.gethostbyname(socket.gethostname())
   cycle = True
   print("Valid commands\nWho - info\nCLR - clear all\nCLR Num - clear Num textbox\n"
         "Put Num text - paste text to Num textbox\nstop - disconnect")
   while (cycle):
       print("Enter command")
       command = input()
       if (command == "stop"):
            cycle = False
            client.close()
       else:
            try:
                  encoded_string = checkComm(command).encode()
                  byte_array = bytearray(encoded_string)
                  client.send(byte_array)
                  msg = client.recv(1024)
                  encoding = 'utf-8'
                  f = open("/Users/vika/Desktop/LabTextClient.txt", "a")
                  f.write(IPAddr + " " + str(datetime.datetime.now())
                    + msg.decode(encoding) + "\n")
                  f.close()
            except Exception as e:
                  print(f'{e}')
                  pass
except ConnectionError as e:    
   print("Cannot connect to server\n", e)
        



"""
Put Num
CLR
CLR Num
Who
"""
