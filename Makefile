.PHONY: all test runtime

export PATH := ./node_modules/.bin:$(PATH)

%.js: %.jison
	jison $< -o $@

%.js: %.coffee
	./node_modules/.bin/coffee -c $<

%.gz: %
	cat $< |gzip -9c > $@

all: src/zerkel-parser.js src/zerkel-parser-impl.js dist/zerkel-runtime.min.js.gz

test: src/zerkel-parser-impl.js
	mocha

dist/zerkel-runtime.min.js: src/zerkel-runtime.js
	mkdir -p dist
	uglifyjs $< -c -m --mangle-props reserved=[module,exports,zerkelRuntime,makePredicate,match,regex,idxof,getIn] > $@
