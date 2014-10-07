Speaker = require("speaker")
PORT = 8124
net = require("net")

speaker = new Speaker {
  channels: 1
  bitDepth: 8     
  sampleRate: 11025
}
client = new net.Socket()
client.connect PORT, "127.0.0.1", () ->



client.on "data", (message) ->
  speaker.write message
  
