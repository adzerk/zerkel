parser  = require('./zerkel-parser') || window?.zerkelParser
runtime = require('./zerkel-runtime') || window?.zerkelRuntime
zlib    = require 'zlib'

makePredicate = (body) ->
  if body.substr(0, 3) is "GZ:"
    body = zlib.unzipSync(Buffer.from(body.substr(3), 'base64')).toString()
  runtime.makePredicate(body)

makeDetailedPredicate = (body) ->
  if body.substr(0, 3) is "GZ:"
    body = zlib.unzipSync(Buffer.from(body.substr(3), 'base64')).toString()
  return runtime.makeDetailedPredicate(body)

compile = (query) ->
  return makePredicate(parser.parse(query))

compileDetailed = (query) ->
  return makeDetailedPredicate(parser.parse(query))

if window?
  window.zerkel = {makePredicate, compile, makeDetailedPredicate, compileDetailed}
else
  module.exports = {makePredicate, compile, makeDetailedPredicate, compileDetailed}
