fs = require("fs")
wav = require("wav")
Speaker = require("Speaker")

speaker = new Speaker {
  channels: 1
  bitDepth: 8     
  sampleRate: 11025
}


broadcastNew = ->
  message = new Buffer(news[Math.floor(Math.random() * news.length)])
  server.send message, 0, message.length, 5007, "224.1.1.1"
  console.log "Sent " + message + " to the wire..."
  return
  
broadcastWave = ->
  
  file = fs.createReadStream("/Users/rpechayr/Downloads/1up.wav")
  reader = new wav.Reader()
  


  # the "format" event gets emitted at the end of the WAVE header
  reader.on "format", (format) ->
    # server.send format, 0, format.length, 5007, "224.1.1.1"
    # # the WAVE header is stripped from the output of the reader
    reader.on "data", (data) ->
      console.log(data)
      speaker.write data
      server.send data, 0, data.length, 5007, "224.1.1.1"
    return

  file.pipe reader
  
news = [
  "Borussia Dortmund wins German championship"
  "Tornado warning for the Bay Area"
  "More rain for the weekend"
  "Android tablets take over the world"
  "iPad2 sold out"
  "Nation's rappers down to last two samples"
]

dgram = require("dgram")
server = dgram.createSocket("udp4")
server.bind ->
  server.setBroadcast true
  server.setMulticastTTL 128
  setInterval broadcastWave, 1000
  return

