
http = require 'http'
sio = require 'socket.io'

class @RestServer

  constructor: (@serverUrl) ->
    @defaultPort = 8080
    #

  init: (next) ->
    @io.sockets.on 'connection', (socket) =>
      socket.on 'create', (data) =>
        console.log "Received some data from socket: %j", data
        # send to freeluna server
        dataString = JSON.stringify data
        headers =
          'Content-Type': 'application/json'
          'Content-Length': dataString.length
        options =
          host: @serverUrl,
          port: 80,
          path: '/create',
          method: 'POST',
          headers: headers
        req = http.request options, (res) ->
          res.setEncoding 'utf-8'
          responseString = ''

          res.on 'data', (data) ->
            responseString += data

          res.on 'end', () ->
            resultObject = JSON.parse responseString
            # return back value
            socket.emit 'createResponse', resultObject

        req.write dataString
        req.end()
    #
    next()

  listen: (port) ->
    p = port || @defaultPort
    @io = sio.listen p
    @init =>
      console.log "Socket.IO listening on port: #{p}"