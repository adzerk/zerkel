parser  = require('./zerkel-parser') || window?.zerkelParser
runtime = require('./zerkel-runtime') || window?.zerkelRuntime
zlib    = require 'zlib'

makePredicate = (body) ->
  if body.substr(0, 3) is "GZ:"
    body = zlib.unzipSync(new Buffer(body.substr(3), 'base64')).toString()
  runtime.makePredicate(body)

compile = (query) ->
  return makePredicate(parser.parse(query))

if window?
  window.zerkel = {makePredicate, compile}
else
  module.exports = {makePredicate, compile}
