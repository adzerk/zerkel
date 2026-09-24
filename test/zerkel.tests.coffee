assert   = require('chai').assert
compiler = require('../')
version  = require('../package.json').version
fs       = require('fs')
fc       = require('fast-check')
vm       = require('vm')
parser   = compiler.parser
makePredicate = require('../dist/zerkel-runtime.min.js').makePredicate
makeDetailedPredicate = require('../dist/zerkel-runtime.min.js').makeDetailedPredicate

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
          assert.equal expected, makePredicate(compiled)(env)
          assert.equal expected, makeDetailedPredicate(compiled)(env).matched

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
  ['not (z > 10)', {z: 5}, true]
  ['NOT (z > 10)', {z: 5}, true]
  ['not (z < 10)', {z: 5}, false]
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
  ['x =~ "^\\(foo"', {}, false]
  ['x =~ "^(foo"', {}, "a compiler error"]
  ['x =~ "^foo"', {x:"looptydoo"}, false]
  ['x =~ "^([^./]+\\.)*(foo\\.com\\.au|bar\\.net|baz\\.omg\\.io)$"', {x:"hi.there.foo.com.au"}, true]
  ['x =~ "^([^./]+\\.)*(foo\\.com\\.au|bar\\.net|baz\\.omg\\.io)$"', {x:"hi.there.foo.com"   }, false]
  ['x =~ "^([^./]+\\.)*(foo\\.com\\.au|bar\\.net|baz\\.omg\\.io)$"', {x:"hi/there.foo.com.au"}, false]
  ['x !~ "^\\(foo"', {}, true]
  ['x !~ "^(foo"', {}, "a compiler error"]
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
  # ch20651 - property starting with a keyword is handled correctly
  ['foo.bar.norder contains "some"', {foo: {bar: {norder: "it's something"}}}, true]
  ['foo.bar.order contains "some"', {foo: {bar: {order: "it's something"}}}, true]
  ['foo.bar.ORder contains "some"', {foo: {bar: {ORder: "it's something"}}}, true]
  ['foo.bar.oRder contains "some"', {foo: {bar: {oRder: "it's something"}}}, true]
  ['foo.bar.Order contains "some"', {foo: {bar: {Order: "it's something"}}}, true]
  ['foo.andiron = 1', {foo: {andiron: 1}}, true]
  # sc-28856: Allow 'and' 'or' 'not' inside variable names
  ['original.raw contains "Hiring"', {original: {raw: "We are Hiring"}}, true]
  ['notable = 1', {notable: 1}, true]
  ['andy = 1', {andy: 1}, true]
  ['caseMatters = 1', {casematters: 1}, false ]
  ['1 = 1 AND 1 = 2', {}, false]
  ['1 = 1 AND 2 = 2', {}, true]
  ['1 = 1 OR 1 = 2', {}, true]
  ['1 = 1 and 1 = 2', {}, false]
  ['1 = 1 or 1 = 2', {}, true]
  ['foo.or = 1', {foo: {or: 1}}, true]
  ['foo.and = 1', {foo: {and: 1}}, true]
  ['foo.like = 1', {foo: {like: 1}}, true]
  ['foo.likely = 1', {foo: {likely: 1}}, true]
  ['foo.contains = 1', {foo: {contains: 1}}, true]
  ['foo.format = 1', {foo: {format: 1}}, true]
  ['foo.blandishment = 1', {foo: {blandishment: 1}}, true]
  ['foo.itcontainsmultitudes = 1', {foo: {itcontainsmultitudes: 1}}, true]
  ['foo.alike = 1', {foo: {alike: 1}}, true]
  ['foo.not = 1', {foo: {not: 1}}, true]
  ['foo.donot = 1', {foo: {donot: 1}}, true]
  ['And = 1', {And: 1}, true] # <- Kinda ugly, but this is currently supported
  # Parens shouldn't screw up AND, OR, NOT
  ['foo = 1 and (not(bar=1))', {foo:1, bar:2}, true]
  ['foo = 1 and(not(bar=1))', {foo:1, bar:2}, true]
  ['foo = 2 or(bar=1)', {foo:1, bar:1}, true]
  # Keywords cannot appear as root properties with the current grammar - these tests wouldn't pass
  # ['or.foo = 1', {or: {foo: 1}}, true]
  # ['and.foo = 1', {and: {foo: 1}}, true]
  # Etc.
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

  describe "small zerkel queries", ->
    parser.MIN_GZIP_SIZE = 500
    q = 'foo = 42'
    c = parser.parse q
    p = compiler.makePredicate c

    it "should not be gzipped", ->
      assert(c.match(/^GZ:/) is null)

    it "should evaluate correctly", ->
      assert(p({foo:42}) is true)
      assert(p({foo:"bar"}) is false)

  describe "large zerkel queries", ->
    parser.MIN_GZIP_SIZE = 50
    q = '[42, 43] contains foo and [100, 200, 300] contains bar'
    c = parser.parse q
    p = compiler.makePredicate c

    it "should be gzipped", ->
      assert(c.match(/^GZ:/) isnt null)

    it "should evaluate correctly", ->
      assert(p({foo:42, bar:100}) is true)
      assert(p({foo:43, bar:100}) is true)
      assert(p({foo:"bar", bar:100}) is false)

  describe "[ZDE-BOOLEAN-COMPAT] additive APIs", ->
    it "keeps legacy predicates Boolean", ->
      assert.strictEqual compiler.compile('foo = 42')({foo: 42}), true
      assert.strictEqual compiler.makePredicate(parser.parse('foo = 42'))({foo: 0}), false

    it "returns detailed results without changing the verdict", ->
      query = '$user.segments CONTAINS 7 and country = "US"'
      env = {$user: {segments: [7]}, country: 'US'}
      assert.deepEqual compiler.compileDetailed(query)(env),
        matched: true
        referencedSegmentIds: [7]
        metadataComplete: true
      assert.strictEqual compiler.compile(query)(env), true

    it "throws synchronously from factories and predicates", ->
      assert.throws -> compiler.compile('foo =')
      predicate = compiler.compileDetailed('foo.bar = 1')
      env = {}
      Object.defineProperty env, 'foo', get: -> throw new Error('boom')
      assert.throws -> predicate(env)

  describe "[ZDE-REFERENCE-METADATA] segment metadata", ->
    evaluate = (query, env = {$user: {segments: []}}) ->
      compiler.compileDetailed(query)(env)

    it "collects unique sorted references from every branch", ->
      result = evaluate '$user.segments CONTAINS 9 OR NOT ($user.segments contains -2) OR $user.segments CONTAINS 9'
      assert.deepEqual result.referencedSegmentIds, [-2, 9]
      assert.strictEqual result.metadataComplete, true

    it "ignores unrelated integers", ->
      result = evaluate '$user.age = 42 AND country = "US"',
        $user: {age: 42, segments: []}
        country: 'US'
      assert.deepEqual result.referencedSegmentIds, []
      assert.strictEqual result.metadataComplete, true

    it "marks dynamic and reversed segment uses incomplete", ->
      dynamic = evaluate '$user.segments CONTAINS wanted',
        $user: {segments: [7]}
        wanted: 7
      reversed = evaluate 'candidate CONTAINS $user.segments',
        $user: {segments: [7]}
        candidate: [[7]]
      assert.strictEqual dynamic.metadataComplete, false
      assert.strictEqual reversed.metadataComplete, false

    it "marks unsafe segment literals incomplete without changing the verdict", ->
      query = '$user.segments CONTAINS 9007199254740992'
      env = {$user: {segments: [9007199254740992]}}
      result = evaluate query, env
      assert.strictEqual result.matched, compiler.compile(query)(env)
      assert.deepEqual result.referencedSegmentIds, []
      assert.strictEqual result.metadataComplete, false

    it "includes both safe integer endpoints", ->
      query = '$user.segments CONTAINS -9007199254740991 OR $user.segments CONTAINS 9007199254740991'
      result = evaluate query, {$user: {segments: [9007199254740991]}}
      assert.deepEqual result.referencedSegmentIds,
        [-9007199254740991, 9007199254740991]
      assert.strictEqual result.metadataComplete, true

    it "marks both unsafe boundaries incomplete", ->
      positive = evaluate '$user.segments CONTAINS 9007199254740992'
      negative = evaluate '$user.segments CONTAINS -9007199254740992'
      assert.strictEqual positive.metadataComplete, false
      assert.strictEqual negative.metadataComplete, false

    it "normalizes negative zero metadata to zero", ->
      result = evaluate '$user.segments CONTAINS -0', {$user: {segments: [0]}}
      assert.deepEqual result.referencedSegmentIds, [0]
      assert.strictEqual result.matched, true

    it "marks a mixed supported and unsupported rule incomplete", ->
      result = evaluate '$user.segments CONTAINS 7 OR $user.segments CONTAINS wanted',
        $user: {segments: [7]}
        wanted: 9
      assert.deepEqual result.referencedSegmentIds, [7]
      assert.strictEqual result.metadataComplete, false

    it "does not confuse nearby variable paths with user segments", ->
      result = evaluate '$user.segment CONTAINS 7', {$user: {segment: [7], segments: []}}
      assert.deepEqual result.referencedSegmentIds, []
      assert.strictEqual result.metadataComplete, true

    it "distinguishes legacy and new segment-free compiled expressions", ->
      legacy = makeDetailedPredicate('_env.foo==42')({foo: 42})
      current = evaluate('foo = 42', {foo: 42})
      assert.deepEqual legacy,
        matched: true
        referencedSegmentIds: []
        metadataComplete: false
      assert.deepEqual current,
        matched: true
        referencedSegmentIds: []
        metadataComplete: true

    it "returns independently owned metadata arrays", ->
      predicate = compiler.compileDetailed '$user.segments CONTAINS 7'
      first = predicate {$user: {segments: [7]}}
      first.referencedSegmentIds.push 9
      second = predicate {$user: {segments: []}}
      assert.deepEqual second,
        matched: false
        referencedSegmentIds: [7]
        metadataComplete: true

    it "isolates nested detailed predicate evaluations", ->
      outer = compiler.compileDetailed '$user.segments CONTAINS 7'
      inner = compiler.compileDetailed '$user.segments CONTAINS 9'
      env = {$user: {segments: [7]}}
      Object.defineProperty env.$user.segments, 'indexOf',
        value: (value) ->
          nested = inner({$user: {segments: [9]}})
          assert.deepEqual nested.referencedSegmentIds, [9]
          return Array::indexOf.call(this, value)
      result = outer(env)
      assert.deepEqual result.referencedSegmentIds, [7]
      assert.strictEqual result.metadataComplete, true

    it "keeps metadata stable across environments and short-circuiting", ->
      predicate = compiler.compileDetailed 'country = "US" OR $user.segments CONTAINS 7'
      first = predicate {country: 'US', $user: {segments: []}}
      second = predicate {country: 'CA', $user: {segments: [7]}}
      assert.deepEqual first.referencedSegmentIds, second.referencedSegmentIds
      assert.strictEqual first.metadataComplete, second.metadataComplete

  describe "[ZDE-ENCODING] generated runtime", ->
    it "exposes both API families in the minified runtime", ->
      parser.MIN_GZIP_SIZE = Infinity
      compiled = parser.parse '$user.segments CONTAINS 7'
      env = {$user: {segments: [7]}}
      assert.strictEqual makePredicate(compiled)(env), true
      assert.deepEqual makeDetailedPredicate(compiled)(env),
        matched: true
        referencedSegmentIds: [7]
        metadataComplete: true

    it "preserves detailed evaluation through Node gzip decoding", ->
      parser.MIN_GZIP_SIZE = 1
      compiled = parser.parse '$user.segments CONTAINS 7'
      assert.match compiled, /^GZ:/
      assert.deepEqual compiler.makeDetailedPredicate(compiled)({$user: {segments: [7]}}),
        matched: true
        referencedSegmentIds: [7]
        metadataComplete: true

    it "exports both factories to browser globals and AMD", ->
      source = fs.readFileSync('src/zerkel-runtime.js', 'utf8')
      browser = {}
      vm.runInNewContext(source, browser)
      assert.strictEqual typeof browser.zerkelRuntime.makePredicate, 'function'
      assert.strictEqual typeof browser.zerkelRuntime.makeDetailedPredicate, 'function'

      amdModule = null
      define = (dependencies, factory) -> amdModule = factory()
      define.amd = true
      vm.runInNewContext(source, {define})
      assert.strictEqual typeof amdModule.makePredicate, 'function'
      assert.strictEqual typeof amdModule.makeDetailedPredicate, 'function'

  describe "[ZDE-EVIDENCE-MATRIX] generated properties", ->
    it "matches an independent OR-of-segments evaluator", ->
      fc.assert fc.property(
        fc.uniqueArray(fc.integer({min: -1000, max: 1000}), {maxLength: 20})
        fc.uniqueArray(fc.integer({min: -1000, max: 1000}), {maxLength: 20})
        (references, userSegments) ->
          clauses = ("$user.segments CONTAINS #{id}" for id in references)
          query = if clauses.length then clauses.join(' OR ') else '1 = 2'
          env = {$user: {segments: userSegments}}
          detailed = compiler.compileDetailed(query)(env)
          expected = references.some (id) -> id in userSegments
          assert.strictEqual detailed.matched, expected
          assert.strictEqual compiler.compile(query)(env), expected
          assert.deepEqual detailed.referencedSegmentIds,
            references.slice().sort((left, right) -> left - right)
          assert.strictEqual detailed.metadataComplete, true
      ), {numRuns: 1000}

    it "keeps metadata stable under branch order and duplication", ->
      fc.assert fc.property(
        fc.uniqueArray(fc.integer({min: -1000, max: 1000}), {minLength: 1, maxLength: 20})
        (references) ->
          clauses = ("$user.segments CONTAINS #{id}" for id in references)
          forward = compiler.compileDetailed(clauses.join(' OR '))({$user: {segments: references}})
          transformed = compiler.compileDetailed(clauses.slice().reverse().concat(clauses[0]).join(' or '))(
            {$user: {segments: references}}
          )
          assert.deepEqual transformed.referencedSegmentIds, forward.referencedSegmentIds
          assert.strictEqual transformed.metadataComplete, forward.metadataComplete
          assert.strictEqual transformed.matched, forward.matched
      ), {numRuns: 1000}
