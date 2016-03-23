SHA = `git rev-parse HEAD`

all: parser browserify

parser:
	./node_modules/.bin/jison ./src/zerkel-parser.jison -o ./src/zerkel-parser.js

browserify:
	mkdir -p build
	./node_modules/.bin/browserify -r ./src/zerkel-parser.js:zerkel-parser -o ./build/zerkel-parser-$(SHA).js
