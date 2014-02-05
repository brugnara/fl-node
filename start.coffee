###
  Daniele Brugnara
###

{RestServer} = require './rest-server'

# Starting restify server
server = new RestServer('hello.freeluna.it')

server.listen 8080