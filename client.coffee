Speaker = require("speaker")
PORT = 5007
dgram = require("dgram")
client = dgram.createSocket("udp4")

speaker = new Speaker {
  channels: 1
  bitDepth: 8     
  sampleRate: 11025
}

client.on "listening", ->
  address = client.address()
  console.log "UDP Client listening on " + address.address + ":" + address.port
  client.setBroadcast true
  client.setMulticastTTL 128
  client.addMembership "224.1.1.1"
  return

client.on "message", (message, remote) ->
  console.log "A: Epic Command Received. Preparing Relay."
  console.log "B: From: " + remote.address + ":" + remote.port + " - " + message
  speaker.write message
  return

client.bind PORT