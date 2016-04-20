.PHONY: test

SHA = `git rev-parse HEAD`

all: parser browserify

test:
	(cd src && ../node_modules/.bin/jison zerkel-parser.jison)
	mocha

parser:
	./node_modules/.bin/pegjs ./src/zerkel-parser.pegjs ./src/zerkel-parser.js

browserify:
	mkdir -p build
	./node_modules/.bin/browserify -r ./src/zerkel-parser.js:zerkel-parser -o ./build/zerkel-parser-$(SHA).js
