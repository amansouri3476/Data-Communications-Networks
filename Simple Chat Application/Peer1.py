import socket
import threading
import re
import string
global i
i = 0
global seq_no
fseq_no = 0
global acktime
global caller_seq_no
global caller_ack_no
global callee_seq_no
global callee_ack_no
global seq_no_shift
global ack_no_shift
global ack
caller_seq_no = 0
caller_ack_no = 0
callee_seq_no = 0
callee_ack_no = 0
seq_no_shift = 0
ack = True
token_1 = "ed3be6490bb78dcdcd1ac568100ff677"
token_2 = "436d7f430491a97acf9709ecfeb3027f"
token_no = 0
tokens = [token_1, token_2]
def heartbeat():
    hb_message = "HEARTBEAT:" + tokens[token_no]
    hb_message = bytes(hb_message, 'utf-8')
    server.sendto(hb_message, (ip, port))
    hb_timer = threading.Timer(58, heartbeat)
    hb_timer.start()

def ack_timer():
    # print(1)
    global i
    i = 0
    global acktime
    acktime.cancel()
    acktime = threading.Timer(1.5, ack_timer)
    counter = 0
    acktime.start()
    while True:
        i = i + 1
        print(i)
        try:
            [data, addr] = server.recvfrom(1024)
            temp = data.decode('utf-8')
            print(temp)
            if counter == 0:
                if temp == "RELAYED":
                    counter = 1  # Server Ack received
                    print("server ack")
                    continue
                else:
                    acktime.cancel()
                    print("server NACK")
                    return False
            else:
                print(temp[47:49])
                if temp[47:49] == '01':
                    fseq_no = temp[65:]
                    print(fseq_no)
                    print(caller_seq_no)
                    if fseq_no == caller_seq_no:
                        acktime.cancel()
                        print("receiver ack")
                        return True
                    else:
                        acktime.cancel()
                        print("receiver NACK")
                        return False
        except:
            return




def message_builder(ftyped_message, fpacket_type, fack_flag, fpacket_length, fseq_no, fack_no):
    if ftyped_message == None:
        output_message = '73DF'
        output_message = output_message + fpacket_type + fack_flag + fpacket_length + fseq_no + fack_no
        return bytes(output_message, 'utf-8')
    else:
        output_message = '73DF'
        output_message = output_message + fpacket_type + fack_flag + fpacket_length + fseq_no + fack_no + ftyped_message
        output_message = bytes(output_message, 'utf-8')
        return output_message


server = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
server.settimeout(5)
ip = socket.gethostbyname("dnrl.ir")
# print(ip)
port = 13570
hb_timer = threading.Timer(58, heartbeat)
# noinspection PyTypeChecker

print("Welcome")
user_command = input("Please enter your username?\n")
message = "REGISTER:" + tokens[token_no] + ":" + user_command
message = bytes(message, 'utf-8')
server.sendto(message, (ip, port))
[data, addr] = server.recvfrom(1024)
print(data.decode('utf-8'))
hb_timer.start()
acktime = threading.Timer(1.5, ack_timer)
user_found = 1

while True:
        user_command = input("Please select what you are going to do?\n1.Invite\n2.Read\n")
        if user_command == "1":
            user_command = input("Please enter username of the person you would like to chat with:\n")
            # Invite Message

            message = "INVITE:" + tokens[token_no] + ":" + user_command
            message = bytes(message, 'utf-8')
            server.sendto(message, (ip, port))
            [data, addr] = server.recvfrom(1024)
            temp = data.decode('utf-8')
            print(temp)
            if temp.startswith("START"):
                IP_part = re.search(r"{([0-9,]+)", data.decode('utf-8'))
                ans = IP_part.group(1)
                ans = ans.replace(',', '.')
                callee_ip = ans
                print(callee_ip)
                callee_port = re.search(r"}, ([0-9]+)}", data.decode('utf-8'))
                callee_port = callee_port.group(1)
                print(callee_port)
                callee_port = int(callee_port)
                # callee socket obtained. Using Relay to avoid problems arising when symmetric NATs are used.
                message = "MAKE_RELAY:" + tokens[token_no] + ":" + user_command
                message = bytes(message, 'utf-8')
                server.sendto(message, (ip, port))
                # Relay Constructed
                # Listening to server's response to see whether user is found or not.
                [data, addr] = server.recvfrom(1024)
                print(data.decode('utf-8'))
                temp = data.decode('utf-8')
                session_counter = 0
                while True:
                    print(126)

                    if session_counter == 0:  # Before connection is set we will recieve "RELTO" message and obtain the
                            #  session key. Afterwards message start with keyword "RELAY"
                        try:
                            [data, addr] = server.recvfrom(1024)
                            print(data.decode('utf-8'))
                            temp = data.decode('utf-8')
                            print(135)
                            if temp.startswith("RELTO:"):
                                typed_message = input("Please Write your message:\n")
                                length = len(temp)
                                session_key = temp[length - 32:]
                                print('sessionkey')
                                print(session_key)
                                packet_type = '01'
                                ack_flag = '00'
                                packet_length = len(bytes(user_command, 'utf-8')) + 16 - 1
                                packet_length = '{:08x}'.format(packet_length)
                                print(packet_length)
                                caller_seq_no = 0
                                caller_seq_no = '{:08x}'.format(caller_seq_no)
                                ack = '{:08x}'.format(0)
                                message = bytes("RELAY:" + session_key + ":", 'utf-8') + message_builder(typed_message,
                                                                                                         packet_type,
                                                                                                         ack_flag,
                                                                                                         packet_length,
                                                                                                         caller_seq_no,
                                                                                                         ack)
                                caller_seq_no = int(caller_seq_no, 16) + int(packet_length, 16)
                                caller_seq_no = '{:08x}'.format(caller_seq_no)
                                print(message)
                                session_counter = 1
                                # print(143)
                                while True:
                                    # print('hello')
                                    server.sendto(message, (ip, port))
                                    acknowledge_status = ack_timer()
                                    print(172)
                                    print(acknowledge_status)
                                    if not acknowledge_status:  # timeout occurred
                                            continue
                                    else:  # ack received in time
                                            break
                        except:
                            continue
                    else:
                            typed_message = input("Please Write your message:\n")
                            packet_type = '01'
                            ack_flag = '01'
                            packet_length = len(bytes(typed_message, 'utf-8')) + 16 - 1
                            packet_length = '{:08x}'.format(packet_length)
                            caller_seq_no = int(caller_seq_no, 16) + int(packet_length, 16)
                            caller_seq_no = '{:08x}'.format(caller_seq_no)
                            print(caller_seq_no)
                            ack = '{:08x}'.format(0)
                            print(ack)
                            message = bytes("RELAY:" + session_key + ":", 'utf-8') + message_builder(typed_message, packet_type,
                                                                                         ack_flag, packet_length,
                                                                                         caller_seq_no,
                                                                                         ack)
                            caller_seq_no = int(caller_seq_no, 16) + int(packet_length, 16)
                            caller_seq_no = '{:08x}'.format(caller_seq_no)
                            print(message)
                            while True:
                                server.sendto(message, (ip, port))
                                acknowledge_status = ack_timer()
                                print(206)
                                print(acknowledge_status)
                                if not acknowledge_status:  # timeout occurred
                                    continue
                                else:  # ack received in time
                                    break
            else:
                print("User not found.")
                continue
        else:
            if user_command == "2":
                print("listen")
                while True:
                    hb_timer.cancel()
                    heartbeat()
                    try:
                        [data, addr] = server.recvfrom(1024)
                        # print(data.decode('utf-8'))
                        temp = data.decode('utf-8')
                        print(temp[73:])
                        if temp.startswith("START:"):
                            IP_part = re.search(r"{([0-9,]+)", temp)
                            ans = IP_part.group(1)
                            ans = ans.replace(',', '.')
                            caller_ip = ans
                            print(caller_ip)
                            caller_port = re.search(r"}, ([0-9]+)}", temp)
                            caller_port = caller_port.group(1)
                            print(caller_port)
                            caller_port = int(caller_port)
                        else:
                            if temp.startswith("RELREQ_FROM:"):
                                message = "ACK_RELAY:" + tokens[token_no] + ":" + temp[12:]
                                message = bytes(message, 'utf-8')
                                server.sendto(message, (ip, port))
                            else:
                                if temp.startswith("RELTO:"):
                                    length = len(temp)
                                    session_key = temp[length - 32:]
                                    print('sessionkey')
                                    print(session_key)
                                    continue
                                else:
                                    print(temp)
                                    print('packet_type')
                                    if temp[45:47] == "01":
                                        print("text")
                                    else:
                                        print("control")
                                    print("ackflag")
                                    if temp[47:49] == "01":
                                        print("ack valid")
                                    else:
                                        print("ack not valid")
                                    print("packet length")

                                    # Sending ack immediately
                                    packet_type = '00'
                                    ack_flag = '01'
                                    packet_length = '{:08x}'.format(16)
                                    callee_seq_no = '{:08x}'.format(callee_seq_no)
                                    ack = int(temp[49:57], 16) + int(temp[57:65], 16)
                                    ack = '{:08x}'.format(ack)
                                    message = bytes("RELAY:" + session_key + ":", 'utf-8') + message_builder(None,
                                                                                                             packet_type,
                                                                                                             ack_flag,
                                                                                                             packet_length,
                                                                                                             callee_seq_no,
                                                                                                             ack)
                                    print(message.decode('utf-8'))
                                    callee_seq_no = int(callee_seq_no, 16) + int(packet_length, 16)
                                    print("callee_seq_no")
                                    print(callee_seq_no)
                                    server.sendto(message, (ip, port))
                                    continue
                                    # user_command = input("Would you like to answer?\n1.Yes\n2.No\n")
                                    # if user_command == '2':
                                    #     continue
                                    # else:
                                    #     typed_message = input("Please Write your message:\n")
                                    #     packet_type = '01'
                                    #     ack_flag = '00'
                                    #     packet_length = len(bytes(user_command, 'utf-8')) + 16
                                    #     message = bytes("RELAY:" + session_key + ":", 'utf-8') + message_builder(
                                    #         typed_message, packet_type, ack_flag, packet_length, callee_seq_no,
                                    #         caller_seq_no + seq_no_shift)
                                    #     while True:
                                    #         server.sendto(message, (ip, port))
                                    #         fseq_no = callee_seq_no
                                    #         acknowledge_status = ack_timer()
                                    #         acktime.cancel()
                                    #         if not acknowledge_status:  # timeout occurred
                                    #             continue
                                    #         else:  # ack received in time
                                    #             break
                    except:
                        continue
                continue


            else:
                print("Unknown Command. Please try again")