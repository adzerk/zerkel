parser = require './zerkel-parser'

module.exports.parse = (query) ->
  body = "return " + parser.parse query
  new Function('_env', body)
