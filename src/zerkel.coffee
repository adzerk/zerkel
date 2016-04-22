parser = require('./zerkel-parser') || window?.zerkelParser
zlib   = require('node-zlib-backport')

# https://developer.mozilla.org/en-US/docs/Web/JavaScript/Guide/Regular_Expressions
requote = (s) -> s.replace(/[.*+?^${}()|[\]\\]/g, "\\$&")

module.exports.match = match = (val, pattern) ->
  return true if pattern is '*'
  pat = requote(pattern.replace(/(^\*|\*$)/g, ''))
  pat = '.+' + pat if pattern[0] is '*'
  pat = pat + '.+' if pattern[pattern.length - 1] is '*'
  new RegExp(pat).test(val)

module.exports.regex = regex = (val, re) ->
  new RegExp(re).test(val)

module.exports.idxof = idxof = (val, x) ->
  if val and (idx = val.indexOf) and idx is String.prototype.indexOf or idx is Array.prototype.indexOf
    val.indexOf(x) >= 0

# deprecated
module.exports.getIn = getIn = (env, varName) ->
  levels = varName.split(".")
  out = env
  for level in levels
    unless out? and typeof out is 'object'
      out = undefined
      break

    out = out[level]
  return out

module.exports.helpers = helpers =
  match: match
  getIn: getIn
  regex: regex
  idxof: idxof

module.exports.makePredicate = makePredicate = (body) ->
  if body.substr(0, 3) is "GZ:"
    body = zlib.unzipSync(new Buffer(body.substr(3), 'base64')).toString()
  fn = new Function('_helpers', '_env', "return " + body)
  return (env) -> Boolean fn helpers, env

module.exports.compile = (query) ->
  return makePredicate(parser.parse(query))
