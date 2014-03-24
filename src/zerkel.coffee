parser = require './zerkel-parser'

module.exports.match = match = (val, pattern) ->
  if val.indexOf('*') >= 0
    x = pattern
    pattern = val
    val = pattern
  if pattern == '*' then return true
  if pattern[0] == '*' and pattern[pattern.length - 1] == '*'
    pattern = pattern[1..-3]
    return (val.indexOf(pattern) >= 0) and val.length > pattern.length + 1
  if pattern[0] == '*'
    pattern = pattern[1..-1]
    return (val.indexOf(pattern) == val.length - pattern.length) and val.length > pattern.length
  if pattern[pattern.length - 1] == '*'
    return (val.indexOf(pattern[0..-2]) == 0) and val.length > pattern.length

module.exports.getIn = getIn = (env, varName) ->
  levels = varName.split(".")
  out = env
  for level in levels
    unless out? and typeof out is 'object'
      out = undefined
      break

    out = out[level]
  return out

module.exports.helpers = helpers = {match: match, getIn: getIn}

module.exports.compile = (query) ->
  body = "return " + parser.parse(query)
  fn = new Function('_helpers', '_env', body)
  return (env) -> Boolean fn helpers, env
