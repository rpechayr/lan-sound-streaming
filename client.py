import socket
import pyaudio
import json

p = pyaudio.PyAudio()


TCP_IP = '127.0.0.1'
TCP_PORT = 5123
BUFFER_SIZE = 128
CHUNK = BUFFER_SIZE 

 
s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
s.connect((TCP_IP, TCP_PORT))

dicJSON = json.loads(s.recv(1024))

FORMAT = dicJSON['format']
CHANNELS = dicJSON['channel']
RATE = dicJSON['sampleRate']

print "Reading "+str(CHANNELS)+" channels at sample rate "+str(RATE)+"Hz" 

# list all audio devices
print "List of audio devices: "
for k in range(p.get_device_count()):
  print k,':',p.get_device_info_by_index(k)['name']

# input device id to play sound
var = "";
while not( var.isdigit() and int(var)>=0 and int(var)<p.get_device_count()):
  var = raw_input("Choose audio device to play sound (number between 0 and "+str(p.get_device_count()-1)+"): ")
device_id = int(var)
print "You chose device: "+p.get_device_info_by_index(device_id)['name']


stream = p.open(format=FORMAT,
                channels=CHANNELS,
                rate=RATE,
                output=True,
                output_device_index=device_id)

s.send('Ready !');

while 1:
  data = s.recv(BUFFER_SIZE)
  stream.write(data)

stream.stop_stream()
stream.close()

p.terminate()
s.close()
