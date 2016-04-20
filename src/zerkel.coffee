parser = require './zerkel-parser'
zlib   = require 'node-zlib-backport'

# See https://developer.mozilla.org/en-US/docs/Web/JavaScript/Guide/Regular_Expressions?redirectlocale=en-US&redirectslug=JavaScript%2FGuide%2FRegular_Expressions
escapeRegExp = (string) ->
  return string.replace(/[.*+?^${}()|[\]\\]/g, "\\$&"); # $& means the whole matched string

module.exports.match = match = (val, pattern) ->
  if Array.isArray(val)
    for v in val
      return true if match(v, pattern)
    return false
  else if Array.isArray(pattern)
    for p in pattern
      return true if match(val, p)
    return false
  else
    if val.indexOf('*') >= 0
      [pattern, val] = [val, pattern] # swap pattern and val
    return true if pattern == '*'
    head = '^' + (if pattern[0] == "*" then '.+' else '')
    tail = (if pattern[pattern.length - 1] == "*" then '.+' else '') + '$'
    re = head + escapeRegExp(pattern.replace(/(^\*|\*$)/g, '')) + tail
    return new RegExp(re).test(val)

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

module.exports.makePredicate = makePredicate = (body) ->
  if body.substr(0, 3) is "GZ:"
    body = zlib.unzipSync(new Buffer(body.substr(3), 'base64')).toString()
  fn = new Function('_helpers', '_env', "return " + body)
  return (env) -> Boolean fn helpers, env

module.exports.compile = (query) ->
  return makePredicate(parser.parse(query))
