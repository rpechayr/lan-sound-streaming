portAudio = require('portaudio')

#create a sine wave lookup table
sampleRate = 44100
tableSize = 200
buffer = new Buffer(tableSize)
for i in [0..tableSize]
  buffer[i] = (Math.sin((i / tableSize) * 3.1415 * 2.0) * 127) + 127


portAudio.getDevices (err, devices)->
  console.log(devices)

portAudioOpenCbs = (err, pa) ->
  #send samples to be played
  for i in [0..(5 * sampleRate / tableSize)]
    pa.write(buffer)

  #start playing
  pa.start()

  #stop playing 1 second later
  cbs = () ->
    pa.stop()
  setTimeout(cbs, 1 * 1000)
  
portAudio.open {
  channelCount: 1
  sampleFormat: portAudio.SampleFormat8Bit
  sampleRate: sampleRate
}, portAudioOpenCbs
  