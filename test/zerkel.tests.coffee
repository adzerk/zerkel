assert   = require('chai').assert
compiler = require('../')
version  = require('../package.json').version
fs       = require('fs')
parser   = compiler.parser

map = (f, xs) ->
  ret = []
  for x in xs
    ret.push(f(x))
  return ret

versionCompare = (v1, v2) ->
  return 0 if v1 is v2
  [x1, y1, z1] = map(parseInt, v1.split(/\./))
  [x2, y2, z2] = map(parseInt, v2.split(/\./))
  return x1 - x2 if x1 isnt x2
  return y1 - y2 if y1 isnt y2
  return z1 - z2 if z1 isnt z2

isBackwardCompatible = (v1, v2) ->
  [x1, y1, z1] = map(parseInt, v1.split(/\./))
  [x2, y2, z2] = map(parseInt, v2.split(/\./))
  x2 is x1 and y2 >= y1 and z2 >= z1

compileTests = (tests) ->
  ret = []
  for test in tests
    [zerkel, env, expected] = test
    try
      compiled = parser.parse zerkel
    catch e
      compiled = false
    ret.push {zerkel, compiled, env, expected}
  return ret

runTest = ({zerkel, compiled, env, expected}) ->
  describe zerkel, ->
    if expected is "a compiler error"
      it "should throw a parser exception", ->
        assert.equal compiled, false
    else
      describe "with #{JSON.stringify(env)}", ->
        it "should be #{expected}", ->
          assert.equal expected, compiler.makePredicate(compiled)(env)

tests = compileTests [
  ['"foo" like "Foo*"', {}, false]
  ['"foo" like "f*"', {}, true]
  ['"foo" like "*oo"', {}, true]
  ['"loop" like "*oo*"', {}, true]
  ['"a" like "*"', {}, true]
  ['"abc" like "d*"', {}, false]
  ['x > 1', {x: 2}, true]
  ['x>1', {x: 1}, false]
  ['_x>1', {_x: 1}, false]
  ['x_x>1', {x_x: 1}, false]
  ['x = "Hi Bob"', {x: 'Hi Bob'}, true]
  ['x="Hi Bob"', {x: 'hi'}, false]
  ['x <> "Hi Bob"', {x: 'Hi Bob'}, false]
  ['x<>"Hi Bob"', {x: 'hi'}, true]
  ['x = "string with \\\\ backslash"', {x: 'string with \\ backslash'}, true]
  ['x > 1 and y < 10', {x: 5, y: 5}, true]
  ['x > 1 and y < 10', {x: 5, y: 15}, false]
  ['x > 1 or y < 10', {x: 5, y: 15}, true]
  ['x > 1 or y < 10', {x: 1, y: 15}, false]
  ['x >= 1', {x: 1}, true]
  ['x1 >= 1', {x1: 1}, true]
  ['x <= -1', {x: -4}, true]
  ['x >= -10', {x: -6}, true]
  ['(x > 1 and y < 10) or (x = 0)', {x: 5, y:5}, true]
  ['(x > 1 and y<10) or (x = 0)', {x: 0, y:15}, true]
  ['(x > 1 and y < 10) or (x = 0)', {x: 1, y:15}, false]
  ['x > 1 and not (y < 10)', {x: 2, y:15}, true]
  ['x > 1 and not (y < 10)', {x: 2, y:5}, false]
  ['(x > 1 and y < 10) and not (z > 10 or k = 0)', {x: 2, y: 5, z: 5, k:5}, true]
  ['(x>1 and y < 10) and not (z > 10 or k = 0)', {x: 2, y: 5, z: 5, k:0}, false]
  ['(x > 1 and y < 10) and not (z > 10 or k = 0)', {x: 2, y: 5, z: 15, k:1}, false]
  ['(x > 1 and y < 10) and not (z > 10 or k = 0)', {x: 1, y: 5, z: 5, k:5}, false]
  ['array contains "Foo"', {}, false]
  ['array contains "foo"', {array:4}, false]
  ['array contains "foo"', {array:{foo:true}}, false]
  ['4 contains "foo"', {array:4}, false]
  ['x contains "foo"', {x: ["foo", "bar"]}, true]
  ['x contains "foo"', {x: ["bar"]}, false]
  ['x contains "foo"', {x: "foobarbaz"}, true]
  ['x contains "foop"', {x: "foobarbaz"}, false]
  ['[111, 2] contains foo', {foo: 111}, true]
  ['[ 11 , 22 ] contains foo', {foo: 3}, false]
  ['[    11   ,  22      ]  contains foo', {foo: 3}, false]
  ['[3,22] contains foo', {foo: 3}, true]
  ['["lox",22] contains bagels', {bagels: "lox", jotnar: 292}, true]
  ['["herring",22] contains bagels', {bagels: "lox", jotnar: 292}, false]
  ['["lox",292] contains bagels', {bagels: "lox", jotnar: 292}, true]
  ['["lox",292] contains jotnar', {bagels: "lox", jotnar: 292}, true]
  ['["l\\\\ox",292] contains bagels', {bagels: "l\\ox", jotnar: 292}, true]
  ['((keywords contains "c#" and keywords contains "performance") or (keywords contains "sql server")) and not (keywords contains "android")',{keywords:["sql server"]}, true]
  ['((keywords contains "c#" and keywords contains "performance") or (keywords contains "sql server")) and not (keywords contains "android")', {keywords:["c#", "performance"]}, true]
  ['((keywords contains "c#" and keywords contains "performance") or (keywords contains "sql server")) and not (keywords contains "android")', {keywords:["sql server", "android"]}, false]
  ['((keywords contains "c#" and keywords contains "performance") or (keywords contains "sql server")) and not (keywords contains "android")', {keywords:["c#", "performance", "android"]}, false]
  ['((keywords contains "c#" and keywords contains "performance") or (keywords contains "sql server")) and not (keywords contains "android")', {keywords:["c#"]}, false]
  ['"foo" = x', {x: "foo"}, true]
  ['"foo" = x /* this still works! */', {x: "foo"}, true]
  ['/* so \n does \n this */ \n "foo" = x', {x: "foo"}, true]
  ['// and this!\n "foo" = x', {x: "foo"}, true]
  ['x like "foo*"', {x: "foobar"}, true]
  ['"foo*" like x', {x: "foobar"}, false]
  ['x like "foo*"', {x: "foo"}, false]
  ['x like "*bar*"', {x: "foobarbaz"}, true]
  ['"*bar*" like x', {x: "foobarbaz"}, false]
  ['x like "*bar*"', {x: "bar"}, false]
  ['x like "*bar*"', {x: "foobazbaf"}, false]
  ['foo.bar = 1', {foo: {bar: 1}}, true]
  ['foo.bar = zip', {foo: {bar: 1}, zip: 1}, true]
  ['1 > foo.bar', {foo: {bar: 1}}, false]
  ['foo.bar < zip.ping', {foo: {bar: 1}, zip: {ping: 2}}, true]
  ['$foo.bar = 1', {"$foo": {bar: 1}}, true]
  ['$foo.bar.baz = 1', {"$foo": {bar: {baz: 1}}}, true]
  ['$foo.bar.baz = 1', {"$foo": {bar: {baz: 2}}}, false]
  ['x =~ "^foo"', {x:"fooptydoo"}, true]
  ['x =~ "^foo"', {x:"looptydoo"}, false]
  ['x =~ "^([^./]+\\.)*(foo\\.com\\.au|bar\\.net|baz\\.omg\\.io)$"', {x:"hi.there.foo.com.au"}, true]
  ['x =~ "^([^./]+\\.)*(foo\\.com\\.au|bar\\.net|baz\\.omg\\.io)$"', {x:"hi.there.foo.com"   }, false]
  ['x =~ "^([^./]+\\.)*(foo\\.com\\.au|bar\\.net|baz\\.omg\\.io)$"', {x:"hi/there.foo.com.au"}, false]
  ['x !~ "^([^./]+\\.)*(foo\\.com\\.au|bar\\.net|baz\\.omg\\.io)$"', {x:"hi.there.foo.com.au"}, false]
  ['x !~ "^([^./]+\\.)*(foo\\.com\\.au|bar\\.net|baz\\.omg\\.io)$"', {x:"hi.there.foo.com"   }, true]
  ['x !~ "^([^./]+\\.)*(foo\\.com\\.au|bar\\.net|baz\\.omg\\.io)$"', {x:"hi/there.foo.com.au"}, true]
  ['x =~ "\\bfoo\\.com\\.au$"', {x:"hi.there.foo.com.au"}, true]
  ['[bar, baz] contains bar', {}, "a compiler error"]
  ['[] contains bar', {}, false]
  ['[,,,] contains bar', {}, "a compiler error"]
  ['[1,,,2] contains bar', {}, "a compiler error"]
  ['[1,] contains bar', {}, "a compiler error"]
  ['[1 2] contains bar', {}, "a compiler error"]
  ['[1223,-45   ,678] contains bar', {}, false]
  ['["1223","-45"   ,678] contains bar', {}, false]
  ['["1223","-45 is a cool number"   ,678] contains bar', {}, false]
  ['[-] contains foo', {}, "a compiler error"]
  ['[123,-,2345] contains foo', {}, "a compiler error"]
  ['[123,----,2345] contains foo', {}, "a compiler error"]
]

fs.writeFileSync("test-data/#{version}.json", JSON.stringify(tests))

files = fs.readdirSync('test-data')
files = map(((x) -> x.replace(/\.json$/, "")), files)
files = files.sort(versionCompare).reverse()
files = map(((x) -> "test-data/#{x}.json"), files)

describe "version #{version}", ->
  for file in files
    describe "\n\n## #{file} \n\n", ->
      runTest test for test in JSON.parse(fs.readFileSync(file))

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
    q = '[42, 43] contains foo and [100, 200, 300] contains bar'
    c = parser.parse q
    p = compiler.makePredicate c

    it "should be gzipped", ->
      assert(c.match(/^GZ:/) isnt null)

    it "should evaluate correctly", ->
      assert(p({foo:42, bar:100}) is true)
      assert(p({foo:43, bar:100}) is true)
      assert(p({foo:"bar", bar:100}) is false)
