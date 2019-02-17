parser  = require('./zerkel-parser-impl') || `window`?.zerkelParserImpl
zlib    = require 'zlib' if not `window`?

MIN_GZIP_SIZE = Infinity

emit = (ast) ->
  switch Object.prototype.toString.call(ast).slice(8, -1)
    when 'Number'
      JSON.stringify(ast)
    when 'String'
      "\"#{ast}\""
    when 'Array'
      switch ast[0]
        when 'var'
          ret = "_env.#{ast[1]}"
          for x in ast.slice(2)
            ret = "(#{ret}||{}).#{x}"
          ret
        when 'array'
          "[#{ast.slice(1).map(emit).join(',')}]"
        when 'not'
          "(!#{emit(ast[1])})"
        when 'and'
          "(#{emit(ast[1])} && #{emit(ast[2])})"
        when 'or'
          "(#{emit(ast[1])} || #{emit(ast[2])})"
        when 'eq'
          "(#{emit(ast[1])} == #{emit(ast[2])})"
        when 'ne'
          "(#{emit(ast[1])} != #{emit(ast[2])})"
        when 'le'
          "(#{emit(ast[1])} <= #{emit(ast[2])})"
        when 'ge'
          "(#{emit(ast[1])} >= #{emit(ast[2])})"
        when 'lt'
          "(#{emit(ast[1])} < #{emit(ast[2])})"
        when 'gt'
          "(#{emit(ast[1])} > #{emit(ast[2])})"
        when 'in'
          "_helpers['idxof'](#{emit(ast[1])}, #{emit(ast[2])})"
        when 'like'
          "_helpers['match'](#{emit(ast[1])}, #{emit(ast[2])})"
        when 'match'
          new RegExp(ast[2])
          "_helpers['regex'](#{emit(ast[1])}, #{JSON.stringify(ast[2])})"
        when 'nomatch'
          emit(['not', ['match'].concat(ast.slice(1))])

class Zerkel
  @MIN_GZIP_SIZE = Infinity
  @parse: (query) ->
    ret = emit(parser.parse(query))
    if zlib and ret.length >= Zerkel.MIN_GZIP_SIZE
      ret = "GZ:#{zlib.gzipSync(new Buffer(ret)).toString('base64')}"
    ret

if `window`?
  `window.zerkelParser = Zerkel`
else
  module.exports = Zerkel
