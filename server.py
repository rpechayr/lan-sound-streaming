import socket
import time
import pyaudio
import wave
import fileinput
import json

def separateChannelStream(data,channels,format):
  bytePerSample = pyaudio.get_sample_size(format)
  channelDataList = []
  for channel in range(channels):
    channelDataList.append(b''.join([data[i:i+bytePerSample] for i in range(bytePerSample*channel, len(data), bytePerSample*CHANNELS)]))
  return channelDataList


CHUNK = 128
FORMAT = pyaudio.paInt16


CHANNELS = 1
RATE = 44100

p = pyaudio.PyAudio()

# list all audio devices
print "List of audio devices: "
for k in range(p.get_device_count()):
  print k,':',p.get_device_info_by_index(k)['name']

# input device id to record from
var = "";
while not( var.isdigit() and int(var)>=0 and int(var)<p.get_device_count()):
  var = raw_input("Choose audio device to stream from (number between 0 and "+str(p.get_device_count()-1)+"): ")
device_id = int(var)
print "You chose device: "+p.get_device_info_by_index(device_id)['name']



TCP_IP = '127.0.0.1'
TCP_PORT = 5123
BUFFER_SIZE = CHUNK  # Normally 1024, but we want fast response

s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
s.bind((TCP_IP, TCP_PORT))

print "waiting connection"
s.listen(1)

conn, addr = s.accept()


# send audio stream information
conn.send(json.dumps({"format": FORMAT,"sampleRate": RATE,"channel": 1}));

data = conn.recv(16);

print '* stream audio to :', addr
# time.sleep(0.5)
stream = p.open(format=FORMAT,
                channels=CHANNELS,
                rate=RATE,
                input=True,
                frames_per_buffer=CHUNK,                
                input_device_index=device_id)
                #,output=True,
                #output_device_index=4)

while True:
  readSuccess = False;
  while not(readSuccess):
    try:
      audiodata = stream.read(CHUNK)
      readSuccess = True
    except IOError:
      print "Underflow error caught"

  #stream.write(audiodata)#,exception_on_underflow=False)
  separatedChannelData = separateChannelStream(data=audiodata,channels=CHANNELS,format=FORMAT)
  conn.send(separatedChannelData[0])
  #conn.send(audiodata)

conn.close()

stream.stop_stream()
stream.close()
p.terminate()


