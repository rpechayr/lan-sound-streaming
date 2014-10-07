fs = require("fs")
wav = require("wav")

file = fs.createReadStream("/Users/rpechayr/Downloads/1up.wav")
reader = new wav.Reader()

# the "format" event gets emitted at the end of the WAVE header
reader.on "format", (format) ->
  console.log format
  # server.send format, 0, format.length, 5007, "224.1.1.1"
  # # the WAVE header is stripped from the output of the reader
  reader.on "data", (data) ->
    console.log(data)
  return

file.pipe reader