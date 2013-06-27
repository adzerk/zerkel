parser = require './zerkel-parser'

module.exports.compile = (query) ->
  body = "return " + parser.parse query
  new Function('_env', body)
