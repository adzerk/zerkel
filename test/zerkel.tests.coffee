assert = require('chai').assert
compiler = require '../'

makeTest = (query, bindings, expected) ->
  it "#{query} with #{JSON.stringify(bindings)} should be #{expected}", ->
    assert.equal expected, compiler.compile(query)(bindings)

makeTest 'x > 1', {x: 2}, true
makeTest 'x > 1', {x: 1}, false
makeTest 'x is "Hi Bob"', {x: 'hi bob'}, true
makeTest 'x is "Hi Bob"', {x: 'hi'}, false
makeTest 'x > 1 and y < 10', {x: 5, y: 5}, true
makeTest 'x > 1 and y < 10', {x: 5, y: 15}, false
makeTest 'x > 1 or y < 10', {x: 5, y: 15}, true
makeTest 'x > 1 or y < 10', {x: 1, y: 15}, false
makeTest '(x > 1 and y < 10) or (x is 0)', {x: 5, y:5}, true
makeTest '(x > 1 and y < 10) or (x is 0)', {x: 0, y:15}, true
makeTest '(x > 1 and y < 10) or (x is 0)', {x: 1, y:15}, false
makeTest '(x > 1 and y < 10) and not (z > 10 or k is 0)', {x: 2, y: 5, z: 5, k:5}, true
makeTest '(x > 1 and y < 10) and not (z > 10 or k is 0)', {x: 2, y: 5, z: 5, k:0}, false
makeTest '(x > 1 and y < 10) and not (z > 10 or k is 0)', {x: 2, y: 5, z: 15, k:1}, false
makeTest '(x > 1 and y < 10) and not (z > 10 or k is 0)', {x: 1, y: 5, z: 5, k:5}, false
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
