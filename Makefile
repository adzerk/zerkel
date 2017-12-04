.PHONY: all test demo runtime

export PATH := ./node_modules/.bin:$(PATH)

%.js: %.jison
	jison $< -o $@

%.gz: %
	cat $< |gzip -9c > $@

all: src/zerkel-parser.js demo/demo.js dist/zerkel-runtime.min.js.gz

test: src/zerkel-parser.js
	mocha

demo/demo.js: src/zerkel-parser.js src/zerkel.coffee
	bash -c "cat $< <(./node_modules/.bin/coffee -pc src/) > $@"

dist/zerkel-runtime.min.js: src/zerkel-runtime.js
	mkdir -p dist
	uglifyjs $< -c -m --mangle-props reserved=[module,exports,zerkelRuntime,makePredicate,match,regex,idxof,getIn] > $@
