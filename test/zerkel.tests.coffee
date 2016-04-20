assert = require('chai').assert
compiler = require '../'
parser   = compiler.parser

describe 'Match helper', ->
  makeTest = (a, b, expected) ->
    it "#{a} like #{b} should be #{expected}", ->
      assert.equal expected, compiler.match(a, b)

  makeTest "foo", "Foo*", false
  makeTest "foo", "f*", true
  makeTest "foo", "*oo", true
  makeTest "loop", "*oo*", true
  makeTest "a", "*", true
  makeTest "abc", "d*", false

describe "Get-in helper", ->
  env = {foo: 1, bar: {zip: 'x'}, stringy: "HO HO HO"}

  makeTest = (env, path, expected) ->
    it "getting #{path} in #{JSON.stringify(env)} should be #{expected}", ->
      assert.equal expected, compiler.getIn(env, path)

  makeTest env, "ping", undefined
  makeTest env, "foo.zip", undefined
  makeTest env, "stringy.2", undefined
  makeTest env, "ping.zip", undefined
  makeTest env, "foo", 1
  makeTest env, "bar.zip", 'x'
  makeTest env, "stringy", "HO HO HO"

describe 'Language tests', ->
  makeTest = (query, bindings, expected) ->
    it "#{query} with #{JSON.stringify(bindings)} should be #{expected}", ->
      assert.equal expected, compiler.compile(query)(bindings)

  makeParserTest = (query, shouldParse) ->
    if shouldParse
      it "#{query} should be parsed", ->
        assert.doesNotThrow(-> compiler.compile(query))
    else
      it "#{query} should throw a parser exception", ->
        assert.throws(-> compiler.compile(query))

  makeTest 'x > 1', {x: 2}, true
  makeTest 'x>1', {x: 1}, false
  makeTest '_x>1', {_x: 1}, false
  makeTest 'x_x>1', {x_x: 1}, false
  makeTest 'x = "Hi Bob"', {x: 'Hi Bob'}, true
  makeTest 'x="Hi Bob"', {x: 'hi'}, false
  makeTest 'x <> "Hi Bob"', {x: 'Hi Bob'}, false
  makeTest 'x<>"Hi Bob"', {x: 'hi'}, true
  makeTest 'x > 1 and y < 10', {x: 5, y: 5}, true
  makeTest 'x > 1 and y < 10', {x: 5, y: 15}, false
  makeTest 'x > 1 or y < 10', {x: 5, y: 15}, true
  makeTest 'x > 1 or y < 10', {x: 1, y: 15}, false
  makeTest 'x >= 1', {x: 1}, true
  makeTest 'x1 >= 1', {x1: 1}, true
  makeTest 'x <= -1', {x: -4}, true
  makeTest 'x >= -10', {x: -6}, true
  makeTest '(x > 1 and y < 10) or (x = 0)', {x: 5, y:5}, true
  makeTest '(x > 1 and y<10) or (x = 0)', {x: 0, y:15}, true
  makeTest '(x > 1 and y < 10) or (x = 0)', {x: 1, y:15}, false
  makeTest '(x > 1 and y < 10) and not (z > 10 or k = 0)', {x: 2, y: 5, z: 5, k:5}, true
  makeTest '(x>1 and y < 10) and not (z > 10 or k = 0)', {x: 2, y: 5, z: 5, k:0}, false
  makeTest '(x > 1 and y < 10) and not (z > 10 or k = 0)', {x: 2, y: 5, z: 15, k:1}, false
  makeTest '(x > 1 and y < 10) and not (z > 10 or k = 0)', {x: 1, y: 5, z: 5, k:5}, false
  makeTest 'x contains "foo"', {x: ["foo", "bar"]}, true
  makeTest 'x contains "foo"', {x: ["bar"]}, false
  makeTest('((keywords contains "c#" and keywords contains "performance") or (keywords contains "sql server")) and not (keywords contains "android")',
           {keywords:["sql server"]}, true)
  makeTest('((keywords contains "c#" and keywords contains "performance") or (keywords contains "sql server")) and not (keywords contains "android")',
           {keywords:["c#", "performance"]}, true)
  makeTest('((keywords contains "c#" and keywords contains "performance") or (keywords contains "sql server")) and not (keywords contains "android")',
           {keywords:["sql server", "android"]}, false)
  makeTest('((keywords contains "c#" and keywords contains "performance") or (keywords contains "sql server")) and not (keywords contains "android")',
           {keywords:["c#", "performance", "android"]}, false)
  makeTest('((keywords contains "c#" and keywords contains "performance") or (keywords contains "sql server")) and not (keywords contains "android")',
           {keywords:["c#"]}, false)
  makeTest '"foo" = x', {x: "foo"}, true
  makeTest '"foo" = x /* this still works! */', {x: "foo"}, true
  makeTest '/* so \n
  does \n
  this */
  "foo" = x', {x: "foo"}, true
  makeTest '// and this!\n 
  "foo" = x', {x: "foo"}, true
  makeTest 'x like "foo*"', {x: "foobar"}, true
  makeTest '"foo*" like x', {x: "foobar"}, true
  makeTest 'x like "foo*"', {x: "foo"}, false
  makeTest 'x like "*bar*"', {x: "foobarbaz"}, true
  makeTest 'x like "*bar*"', {x: "bar"}, false
  makeTest 'x like "*bar*"', {x: "foobazbaf"}, false
  makeTest '"*bar*" like x', {x: "foobazbaf"}, false
  makeTest '["foo", "foobarbaz", "baz"] like "*bar*"', {}, true
  makeTest '["foo", "foobarbaz", "baz"] like "*barf*"', {}, false
  makeTest '"*bar*" like ["foo", "foobarbaz", "baz"]', {}, true
  makeTest '"*barf*" like ["foo", "foobarbaz", "baz"]', {}, false
  makeTest '["*shmoo*", "*bar*"] like ["foo", "foobarbaz", "baz"]', {}, true
  makeTest '["*shmoo*", "*barf*"] like ["foo", "foobarbaz", "baz"]', {}, false
  makeTest 'array contains "Foo"', {}, false
  makeTest 'foo.bar = 1', {foo: {bar: 1}}, true
  makeTest 'foo.bar = zip', {foo: {bar: 1}, zip: 1}, true
  makeTest '1 > foo.bar', {foo: {bar: 1}}, false
  makeTest 'foo.bar < zip.ping', {foo: {bar: 1}, zip: {ping: 2}}, true
  makeTest '$foo.bar = 1', {"$foo": {bar: 1}}, true
  makeTest '$foo.bar.baz = 1', {"$foo": {bar: {baz: 1}}}, true
  makeTest '$foo.bar.baz = 1', {"$foo": {bar: {baz: 2}}}, false
  makeTest '[111, 2] contains foo', {foo: 111}, true
  makeTest '[ 11 , 22 ] contains foo', {foo: 3}, false
  makeTest '[    11   ,  22      ]  contains foo', {foo: 3}, false
  makeTest '[3,22] contains foo', {foo: 3}, true
  makeParserTest '[bar, baz] contains bar', false
  makeParserTest '[] contains bar', true
  makeParserTest '[,,,] contains bar', false
  makeParserTest '[1,,,2] contains bar', false
  makeParserTest '[1,] contains bar', false
  makeParserTest '[1 2] contains bar', false
  makeParserTest '[1223,-45   ,678] contains bar', true
  makeParserTest '["1223","-45"   ,678] contains bar', true
  makeParserTest '["1223","-45 is a cool number"   ,678] contains bar', true
  makeParserTest '[-] contains foo', false
  makeParserTest '[123,-,2345] contains foo', false
  makeParserTest '[123,----,2345] contains foo', false
  makeTest '["lox",22] contains bagels', {bagels: "lox", jotnar: 292}, true
  makeTest '["herring",22] contains bagels', {bagels: "lox", jotnar: 292}, false
  makeTest '["lox",292] contains bagels', {bagels: "lox", jotnar: 292}, true

describe "Parser tests", ->

  parser.MIN_GZIP_SIZE = 50

  describe "small zerkel queries", ->
    q = 'foo = 42'
    c = parser.parse q
    p = compiler.makePredicate c

    it "should not be gzipped", ->
      assert(c.match(/^GZ:/) is null)

    it "should evaluate correctly", ->
      assert(p({foo:42}) is true)
      assert(p({foo:"bar"}) is false)

  describe "large zerkel queries", ->
    q = '[42, 43] contains foo'
    c = parser.parse q
    p = compiler.makePredicate c

    it "should be gzipped", ->
      assert(c.match(/^GZ:/) isnt null)

    it "should evaluate correctly", ->
      assert(p({foo:42}) is true)
      assert(p({foo:43}) is true)
      assert(p({foo:"bar"}) is false)
