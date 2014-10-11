fs = require("fs")
wav = require("wav")
Speaker = require("Speaker")
mdns = require("mdns")

speaker = new Speaker {
  channels: 1
  bitDepth: 16     
  sampleRate: 44100
}


streamSound = (client) ->
  file = fs.createReadStream("#{process.cwd()}/sample.wav")
  reader = new wav.Reader()
  # the "format" event gets emitted at the end of the WAVE header
  reader.on "format", (format) ->
    # server.send format, 0, format.length, 5007, "224.1.1.1"
    # # the WAVE header is stripped from the output of the reader
    reader.on "data", (data) ->
      console.log(data)
      #speaker.write data
      client.write data
    return

  file.pipe reader


net = require("net")
server = net.createServer (client) ->
  console.log "New client"
  client.setNoDelay(true)
  cbs = () =>
    streamSound(client)
  setInterval cbs, 1000
  return

port = 8124
server.listen port , ->
  console.log "Server listeging on port #{port}"


# advertise a http server on port 4321
ad = mdns.createAdvertisement(mdns.tcp("lanremote"), port)
ad.start()

