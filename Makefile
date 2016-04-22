.PHONY: test demo

src/zerkel-parser.js: src/zerkel-parser.jison
	(cd src && ../node_modules/.bin/jison zerkel-parser.jison)

demo/demo.js: src/zerkel-parser.js src/zerkel.coffee
	bash -c "cat $< <(./node_modules/.bin/coffee -p -c src/) > $@"

test: src/zerkel-parser.js
	mocha

demo: demo/demo.js
