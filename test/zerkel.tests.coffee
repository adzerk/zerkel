assert = require('chai').assert
compiler = require '../'

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
  makeTest 'x like "foo*"', {x: "foobar"}, true
  makeTest 'x like "foo*"', {x: "foo"}, false
  makeTest 'array contains "Foo"', {}, false
  makeTest 'foo.bar = 1', {foo: {bar: 1}}, true
  makeTest 'foo.bar = zip', {foo: {bar: 1}, zip: 1}, true
  makeTest '1 > foo.bar', {foo: {bar: 1}}, false
  makeTest 'foo.bar < zip.ping', {foo: {bar: 1}, zip: {ping: 2}}, true
  makeTest '$foo.bar = 1', {"$foo": {bar: 1}}, true
