/* parser generated by jison 0.4.13 */
/*
  Returns a Parser object of the following structure:

  Parser: {
    yy: {}
  }

  Parser.prototype: {
    yy: {},
    trace: function(),
    symbols_: {associative list: name ==> number},
    terminals_: {associative list: number ==> name},
    productions_: [...],
    performAction: function anonymous(yytext, yyleng, yylineno, yy, yystate, $$, _$),
    table: [...],
    defaultActions: {...},
    parseError: function(str, hash),
    parse: function(input),

    lexer: {
        EOF: 1,
        parseError: function(str, hash),
        setInput: function(input),
        input: function(),
        unput: function(str),
        more: function(),
        less: function(n),
        pastInput: function(),
        upcomingInput: function(),
        showPosition: function(),
        test_match: function(regex_match_array, rule_index),
        next: function(),
        lex: function(),
        begin: function(condition),
        popState: function(),
        _currentRules: function(),
        topState: function(),
        pushState: function(condition),

        options: {
            ranges: boolean           (optional: true ==> token location info will include a .range[] member)
            flex: boolean             (optional: true ==> flex-like lexing behaviour where the rules are tested exhaustively to find the longest match)
            backtrack_lexer: boolean  (optional: true ==> lexer regexes are tested in order and for each matching regex the action code is invoked; the lexer terminates the scan when a token is returned by the action code)
        },

        performAction: function(yy, yy_, $avoiding_name_collisions, YY_START),
        rules: [...],
        conditions: {associative list: name ==> set},
    }
  }


  token location info (@$, _$, etc.): {
    first_line: n,
    last_line: n,
    first_column: n,
    last_column: n,
    range: [start_number, end_number]       (where the numbers are indexes into the input string, regular zero-based)
  }


  the parseError function receives a 'hash' object with these members for lexer and parser errors: {
    text:        (matched text)
    token:       (the produced terminal token, if any)
    line:        (yylineno)
  }
  while parser (grammar) errors will also provide these members, i.e. parser errors deliver a superset of attributes: {
    loc:         (yylloc)
    expected:    (string describing the set of expected tokens)
    recoverable: (boolean: TRUE when the parser has a error recovery rule available for this particular error)
  }
*/
var zerkelParser = (function(){
var parser = {trace: function trace() { },
yy: {},
symbols_: {"error":2,"expressions":3,"e":4,"EOF":5,"NOT":6,"(":7,")":8,"AND":9,"OR":10,"value":11,"=":12,"<>":13,"<=":14,">=":15,"<":16,">":17,"arrayvalue":18,"CONTAINS":19,"LIKE":20,"=~":21,"STRING":22,"!~":23,"arrayitems":24,"INTEGER":25,",":26,"[":27,"]":28,"variable":29,"VAR":30,".":31,"$accept":0,"$end":1},
terminals_: {2:"error",5:"EOF",6:"NOT",7:"(",8:")",9:"AND",10:"OR",12:"=",13:"<>",14:"<=",15:">=",16:"<",17:">",19:"CONTAINS",20:"LIKE",21:"=~",22:"STRING",23:"!~",25:"INTEGER",26:",",27:"[",28:"]",30:"VAR",31:"."},
productions_: [0,[3,2],[4,2],[4,3],[4,3],[4,3],[4,3],[4,3],[4,3],[4,3],[4,3],[4,3],[4,3],[4,3],[4,3],[4,3],[4,3],[4,1],[24,1],[24,1],[24,3],[24,3],[18,2],[18,3],[11,1],[11,1],[11,1],[29,1],[29,3]],
performAction: function anonymous(yytext, yyleng, yylineno, yy, yystate /* action[1] */, $$ /* vstack */, _$ /* lstack */) {
/* this == yyval */

var $0 = $$.length - 1;
switch (yystate) {
case 1: return ($$[$0-1].length >= exports.MIN_GZIP_SIZE) ? "GZ:" + require('node-zlib-backport').gzipSync(new Buffer(""+$$[$0-1])).toString('base64') : $$[$0-1]; 
break;
case 2:this.$ = "!" + $$[$0];
break;
case 3:this.$ = "(" + $$[$0-1] + ")";
break;
case 4:this.$ = $$[$0-2] + " && " + $$[$0];
break;
case 5:this.$ = $$[$0-2] + " || " + $$[$0];
break;
case 6:this.$ = $$[$0-2] + "==" + $$[$0];
break;
case 7:this.$ = $$[$0-2] + "!=" + $$[$0];
break;
case 8:this.$ = $$[$0-2] + $$[$0-1] + $$[$0]
break;
case 9:this.$ = $$[$0-2] + $$[$0-1] + $$[$0]
break;
case 10:this.$ = $$[$0-2] + $$[$0-1] + $$[$0]
break;
case 11:this.$ = $$[$0-2] + $$[$0-1] + $$[$0]
break;
case 12:this.$ = "_helpers['idxof'](" + $$[$0-2] + "," + $$[$0] + ")"; 
break;
case 13:this.$ = "_helpers['idxof'](" + $$[$0-2] + "," + $$[$0] + ")"; 
break;
case 14:this.$ = "_helpers['match'](" + $$[$0-2] + "," + $$[$0] + ")";
break;
case 15:this.$ = "_helpers['regex'](" + $$[$0-2] + "," + JSON.stringify($$[$0].substr(1, $$[$0].length - 2)) + ")";
break;
case 16:this.$ = "!_helpers['regex'](" + $$[$0-2] + "," + JSON.stringify($$[$0].substr(1, $$[$0].length - 2)) + ")";
break;
case 17:this.$ = $$[$0];
break;
case 18:this.$ = $$[$0];
break;
case 19:this.$ = $$[$0];
break;
case 20:this.$ = $$[$0-2]+$$[$0-1]+$$[$0];
break;
case 21:this.$ = $$[$0-2]+$$[$0-1]+$$[$0];
break;
case 22:this.$ = $$[$0-1]+$$[$0];
break;
case 23:this.$ = $$[$0-2]+$$[$0-1]+$$[$0];
break;
case 24:this.$ = Number(yytext);
break;
case 25:this.$ = yytext;
break;
case 26:this.$ = $$[$0];
break;
case 27:this.$ = "_env." + yytext;
break;
case 28:this.$ = "(" + $$[$0-2] + "||{})." + $$[$0];
break;
}
},
table: [{3:1,4:2,6:[1,3],7:[1,4],11:5,18:6,22:[1,8],25:[1,7],27:[1,10],29:9,30:[1,11]},{1:[3]},{5:[1,12],9:[1,13],10:[1,14]},{4:15,6:[1,3],7:[1,4],11:5,18:6,22:[1,8],25:[1,7],27:[1,10],29:9,30:[1,11]},{4:16,6:[1,3],7:[1,4],11:5,18:6,22:[1,8],25:[1,7],27:[1,10],29:9,30:[1,11]},{5:[2,17],8:[2,17],9:[2,17],10:[2,17],12:[1,17],13:[1,18],14:[1,19],15:[1,20],16:[1,21],17:[1,22],19:[1,23],20:[1,24],21:[1,25],23:[1,26]},{19:[1,27]},{5:[2,24],8:[2,24],9:[2,24],10:[2,24],12:[2,24],13:[2,24],14:[2,24],15:[2,24],16:[2,24],17:[2,24],19:[2,24],20:[2,24],21:[2,24],23:[2,24]},{5:[2,25],8:[2,25],9:[2,25],10:[2,25],12:[2,25],13:[2,25],14:[2,25],15:[2,25],16:[2,25],17:[2,25],19:[2,25],20:[2,25],21:[2,25],23:[2,25]},{5:[2,26],8:[2,26],9:[2,26],10:[2,26],12:[2,26],13:[2,26],14:[2,26],15:[2,26],16:[2,26],17:[2,26],19:[2,26],20:[2,26],21:[2,26],23:[2,26],31:[1,28]},{22:[1,32],24:30,25:[1,31],28:[1,29]},{5:[2,27],8:[2,27],9:[2,27],10:[2,27],12:[2,27],13:[2,27],14:[2,27],15:[2,27],16:[2,27],17:[2,27],19:[2,27],20:[2,27],21:[2,27],23:[2,27],31:[2,27]},{1:[2,1]},{4:33,6:[1,3],7:[1,4],11:5,18:6,22:[1,8],25:[1,7],27:[1,10],29:9,30:[1,11]},{4:34,6:[1,3],7:[1,4],11:5,18:6,22:[1,8],25:[1,7],27:[1,10],29:9,30:[1,11]},{5:[2,2],8:[2,2],9:[2,2],10:[2,2]},{8:[1,35],9:[1,13],10:[1,14]},{11:36,22:[1,8],25:[1,7],29:9,30:[1,11]},{11:37,22:[1,8],25:[1,7],29:9,30:[1,11]},{11:38,22:[1,8],25:[1,7],29:9,30:[1,11]},{11:39,22:[1,8],25:[1,7],29:9,30:[1,11]},{11:40,22:[1,8],25:[1,7],29:9,30:[1,11]},{11:41,22:[1,8],25:[1,7],29:9,30:[1,11]},{11:42,22:[1,8],25:[1,7],29:9,30:[1,11]},{11:43,22:[1,8],25:[1,7],29:9,30:[1,11]},{22:[1,44]},{22:[1,45]},{11:46,22:[1,8],25:[1,7],29:9,30:[1,11]},{30:[1,47]},{19:[2,22]},{26:[1,49],28:[1,48]},{26:[2,18],28:[2,18]},{26:[2,19],28:[2,19]},{5:[2,4],8:[2,4],9:[2,4],10:[2,4]},{5:[2,5],8:[2,5],9:[2,5],10:[2,5]},{5:[2,3],8:[2,3],9:[2,3],10:[2,3]},{5:[2,6],8:[2,6],9:[2,6],10:[2,6]},{5:[2,7],8:[2,7],9:[2,7],10:[2,7]},{5:[2,8],8:[2,8],9:[2,8],10:[2,8]},{5:[2,9],8:[2,9],9:[2,9],10:[2,9]},{5:[2,10],8:[2,10],9:[2,10],10:[2,10]},{5:[2,11],8:[2,11],9:[2,11],10:[2,11]},{5:[2,13],8:[2,13],9:[2,13],10:[2,13]},{5:[2,14],8:[2,14],9:[2,14],10:[2,14]},{5:[2,15],8:[2,15],9:[2,15],10:[2,15]},{5:[2,16],8:[2,16],9:[2,16],10:[2,16]},{5:[2,12],8:[2,12],9:[2,12],10:[2,12]},{5:[2,28],8:[2,28],9:[2,28],10:[2,28],12:[2,28],13:[2,28],14:[2,28],15:[2,28],16:[2,28],17:[2,28],19:[2,28],20:[2,28],21:[2,28],23:[2,28],31:[2,28]},{19:[2,23]},{22:[1,51],25:[1,50]},{26:[2,20],28:[2,20]},{26:[2,21],28:[2,21]}],
defaultActions: {12:[2,1],29:[2,22],48:[2,23]},
parseError: function parseError(str, hash) {
    if (hash.recoverable) {
        this.trace(str);
    } else {
        throw new Error(str);
    }
},
parse: function parse(input) {
    var self = this, stack = [0], vstack = [null], lstack = [], table = this.table, yytext = '', yylineno = 0, yyleng = 0, recovering = 0, TERROR = 2, EOF = 1;
    var args = lstack.slice.call(arguments, 1);
    this.lexer.setInput(input);
    this.lexer.yy = this.yy;
    this.yy.lexer = this.lexer;
    this.yy.parser = this;
    if (typeof this.lexer.yylloc == 'undefined') {
        this.lexer.yylloc = {};
    }
    var yyloc = this.lexer.yylloc;
    lstack.push(yyloc);
    var ranges = this.lexer.options && this.lexer.options.ranges;
    if (typeof this.yy.parseError === 'function') {
        this.parseError = this.yy.parseError;
    } else {
        this.parseError = Object.getPrototypeOf(this).parseError;
    }
    function popStack(n) {
        stack.length = stack.length - 2 * n;
        vstack.length = vstack.length - n;
        lstack.length = lstack.length - n;
    }
    function lex() {
        var token;
        token = self.lexer.lex() || EOF;
        if (typeof token !== 'number') {
            token = self.symbols_[token] || token;
        }
        return token;
    }
    var symbol, preErrorSymbol, state, action, a, r, yyval = {}, p, len, newState, expected;
    while (true) {
        state = stack[stack.length - 1];
        if (this.defaultActions[state]) {
            action = this.defaultActions[state];
        } else {
            if (symbol === null || typeof symbol == 'undefined') {
                symbol = lex();
            }
            action = table[state] && table[state][symbol];
        }
                    if (typeof action === 'undefined' || !action.length || !action[0]) {
                var errStr = '';
                expected = [];
                for (p in table[state]) {
                    if (this.terminals_[p] && p > TERROR) {
                        expected.push('\'' + this.terminals_[p] + '\'');
                    }
                }
                if (this.lexer.showPosition) {
                    errStr = 'Parse error on line ' + (yylineno + 1) + ':\n' + this.lexer.showPosition() + '\nExpecting ' + expected.join(', ') + ', got \'' + (this.terminals_[symbol] || symbol) + '\'';
                } else {
                    errStr = 'Parse error on line ' + (yylineno + 1) + ': Unexpected ' + (symbol == EOF ? 'end of input' : '\'' + (this.terminals_[symbol] || symbol) + '\'');
                }
                this.parseError(errStr, {
                    text: this.lexer.match,
                    token: this.terminals_[symbol] || symbol,
                    line: this.lexer.yylineno,
                    loc: yyloc,
                    expected: expected
                });
            }
        if (action[0] instanceof Array && action.length > 1) {
            throw new Error('Parse Error: multiple actions possible at state: ' + state + ', token: ' + symbol);
        }
        switch (action[0]) {
        case 1:
            stack.push(symbol);
            vstack.push(this.lexer.yytext);
            lstack.push(this.lexer.yylloc);
            stack.push(action[1]);
            symbol = null;
            if (!preErrorSymbol) {
                yyleng = this.lexer.yyleng;
                yytext = this.lexer.yytext;
                yylineno = this.lexer.yylineno;
                yyloc = this.lexer.yylloc;
                if (recovering > 0) {
                    recovering--;
                }
            } else {
                symbol = preErrorSymbol;
                preErrorSymbol = null;
            }
            break;
        case 2:
            len = this.productions_[action[1]][1];
            yyval.$ = vstack[vstack.length - len];
            yyval._$ = {
                first_line: lstack[lstack.length - (len || 1)].first_line,
                last_line: lstack[lstack.length - 1].last_line,
                first_column: lstack[lstack.length - (len || 1)].first_column,
                last_column: lstack[lstack.length - 1].last_column
            };
            if (ranges) {
                yyval._$.range = [
                    lstack[lstack.length - (len || 1)].range[0],
                    lstack[lstack.length - 1].range[1]
                ];
            }
            r = this.performAction.apply(yyval, [
                yytext,
                yyleng,
                yylineno,
                this.yy,
                action[1],
                vstack,
                lstack
            ].concat(args));
            if (typeof r !== 'undefined') {
                return r;
            }
            if (len) {
                stack = stack.slice(0, -1 * len * 2);
                vstack = vstack.slice(0, -1 * len);
                lstack = lstack.slice(0, -1 * len);
            }
            stack.push(this.productions_[action[1]][0]);
            vstack.push(yyval.$);
            lstack.push(yyval._$);
            newState = table[stack[stack.length - 2]][stack[stack.length - 1]];
            stack.push(newState);
            break;
        case 3:
            return true;
        }
    }
    return true;
}};


MIN_GZIP_SIZE = exports.MIN_GZIP_SIZE = Infinity;

/* generated by jison-lex 0.2.1 */
var lexer = (function(){
var lexer = {

EOF:1,

parseError:function parseError(str, hash) {
        if (this.yy.parser) {
            this.yy.parser.parseError(str, hash);
        } else {
            throw new Error(str);
        }
    },

// resets the lexer, sets new input
setInput:function (input) {
        this._input = input;
        this._more = this._backtrack = this.done = false;
        this.yylineno = this.yyleng = 0;
        this.yytext = this.matched = this.match = '';
        this.conditionStack = ['INITIAL'];
        this.yylloc = {
            first_line: 1,
            first_column: 0,
            last_line: 1,
            last_column: 0
        };
        if (this.options.ranges) {
            this.yylloc.range = [0,0];
        }
        this.offset = 0;
        return this;
    },

// consumes and returns one char from the input
input:function () {
        var ch = this._input[0];
        this.yytext += ch;
        this.yyleng++;
        this.offset++;
        this.match += ch;
        this.matched += ch;
        var lines = ch.match(/(?:\r\n?|\n).*/g);
        if (lines) {
            this.yylineno++;
            this.yylloc.last_line++;
        } else {
            this.yylloc.last_column++;
        }
        if (this.options.ranges) {
            this.yylloc.range[1]++;
        }

        this._input = this._input.slice(1);
        return ch;
    },

// unshifts one char (or a string) into the input
unput:function (ch) {
        var len = ch.length;
        var lines = ch.split(/(?:\r\n?|\n)/g);

        this._input = ch + this._input;
        this.yytext = this.yytext.substr(0, this.yytext.length - len - 1);
        //this.yyleng -= len;
        this.offset -= len;
        var oldLines = this.match.split(/(?:\r\n?|\n)/g);
        this.match = this.match.substr(0, this.match.length - 1);
        this.matched = this.matched.substr(0, this.matched.length - 1);

        if (lines.length - 1) {
            this.yylineno -= lines.length - 1;
        }
        var r = this.yylloc.range;

        this.yylloc = {
            first_line: this.yylloc.first_line,
            last_line: this.yylineno + 1,
            first_column: this.yylloc.first_column,
            last_column: lines ?
                (lines.length === oldLines.length ? this.yylloc.first_column : 0)
                 + oldLines[oldLines.length - lines.length].length - lines[0].length :
              this.yylloc.first_column - len
        };

        if (this.options.ranges) {
            this.yylloc.range = [r[0], r[0] + this.yyleng - len];
        }
        this.yyleng = this.yytext.length;
        return this;
    },

// When called from action, caches matched text and appends it on next action
more:function () {
        this._more = true;
        return this;
    },

// When called from action, signals the lexer that this rule fails to match the input, so the next matching rule (regex) should be tested instead.
reject:function () {
        if (this.options.backtrack_lexer) {
            this._backtrack = true;
        } else {
            return this.parseError('Lexical error on line ' + (this.yylineno + 1) + '. You can only invoke reject() in the lexer when the lexer is of the backtracking persuasion (options.backtrack_lexer = true).\n' + this.showPosition(), {
                text: "",
                token: null,
                line: this.yylineno
            });

        }
        return this;
    },

// retain first n characters of the match
less:function (n) {
        this.unput(this.match.slice(n));
    },

// displays already matched input, i.e. for error messages
pastInput:function () {
        var past = this.matched.substr(0, this.matched.length - this.match.length);
        return (past.length > 20 ? '...':'') + past.substr(-20).replace(/\n/g, "");
    },

// displays upcoming input, i.e. for error messages
upcomingInput:function () {
        var next = this.match;
        if (next.length < 20) {
            next += this._input.substr(0, 20-next.length);
        }
        return (next.substr(0,20) + (next.length > 20 ? '...' : '')).replace(/\n/g, "");
    },

// displays the character position where the lexing error occurred, i.e. for error messages
showPosition:function () {
        var pre = this.pastInput();
        var c = new Array(pre.length + 1).join("-");
        return pre + this.upcomingInput() + "\n" + c + "^";
    },

// test the lexed token: return FALSE when not a match, otherwise return token
test_match:function (match, indexed_rule) {
        var token,
            lines,
            backup;

        if (this.options.backtrack_lexer) {
            // save context
            backup = {
                yylineno: this.yylineno,
                yylloc: {
                    first_line: this.yylloc.first_line,
                    last_line: this.last_line,
                    first_column: this.yylloc.first_column,
                    last_column: this.yylloc.last_column
                },
                yytext: this.yytext,
                match: this.match,
                matches: this.matches,
                matched: this.matched,
                yyleng: this.yyleng,
                offset: this.offset,
                _more: this._more,
                _input: this._input,
                yy: this.yy,
                conditionStack: this.conditionStack.slice(0),
                done: this.done
            };
            if (this.options.ranges) {
                backup.yylloc.range = this.yylloc.range.slice(0);
            }
        }

        lines = match[0].match(/(?:\r\n?|\n).*/g);
        if (lines) {
            this.yylineno += lines.length;
        }
        this.yylloc = {
            first_line: this.yylloc.last_line,
            last_line: this.yylineno + 1,
            first_column: this.yylloc.last_column,
            last_column: lines ?
                         lines[lines.length - 1].length - lines[lines.length - 1].match(/\r?\n?/)[0].length :
                         this.yylloc.last_column + match[0].length
        };
        this.yytext += match[0];
        this.match += match[0];
        this.matches = match;
        this.yyleng = this.yytext.length;
        if (this.options.ranges) {
            this.yylloc.range = [this.offset, this.offset += this.yyleng];
        }
        this._more = false;
        this._backtrack = false;
        this._input = this._input.slice(match[0].length);
        this.matched += match[0];
        token = this.performAction.call(this, this.yy, this, indexed_rule, this.conditionStack[this.conditionStack.length - 1]);
        if (this.done && this._input) {
            this.done = false;
        }
        if (token) {
            return token;
        } else if (this._backtrack) {
            // recover context
            for (var k in backup) {
                this[k] = backup[k];
            }
            return false; // rule action called reject() implying the next rule should be tested instead.
        }
        return false;
    },

// return next match in input
next:function () {
        if (this.done) {
            return this.EOF;
        }
        if (!this._input) {
            this.done = true;
        }

        var token,
            match,
            tempMatch,
            index;
        if (!this._more) {
            this.yytext = '';
            this.match = '';
        }
        var rules = this._currentRules();
        for (var i = 0; i < rules.length; i++) {
            tempMatch = this._input.match(this.rules[rules[i]]);
            if (tempMatch && (!match || tempMatch[0].length > match[0].length)) {
                match = tempMatch;
                index = i;
                if (this.options.backtrack_lexer) {
                    token = this.test_match(tempMatch, rules[i]);
                    if (token !== false) {
                        return token;
                    } else if (this._backtrack) {
                        match = false;
                        continue; // rule action called reject() implying a rule MISmatch.
                    } else {
                        // else: this is a lexer rule which consumes input without producing a token (e.g. whitespace)
                        return false;
                    }
                } else if (!this.options.flex) {
                    break;
                }
            }
        }
        if (match) {
            token = this.test_match(match, rules[index]);
            if (token !== false) {
                return token;
            }
            // else: this is a lexer rule which consumes input without producing a token (e.g. whitespace)
            return false;
        }
        if (this._input === "") {
            return this.EOF;
        } else {
            return this.parseError('Lexical error on line ' + (this.yylineno + 1) + '. Unrecognized text.\n' + this.showPosition(), {
                text: "",
                token: null,
                line: this.yylineno
            });
        }
    },

// return next match that has a token
lex:function lex() {
        var r = this.next();
        if (r) {
            return r;
        } else {
            return this.lex();
        }
    },

// activates a new lexer condition state (pushes the new lexer condition state onto the condition stack)
begin:function begin(condition) {
        this.conditionStack.push(condition);
    },

// pop the previously active lexer condition state off the condition stack
popState:function popState() {
        var n = this.conditionStack.length - 1;
        if (n > 0) {
            return this.conditionStack.pop();
        } else {
            return this.conditionStack[0];
        }
    },

// produce the lexer rule set which is active for the currently active lexer condition state
_currentRules:function _currentRules() {
        if (this.conditionStack.length && this.conditionStack[this.conditionStack.length - 1]) {
            return this.conditions[this.conditionStack[this.conditionStack.length - 1]].rules;
        } else {
            return this.conditions["INITIAL"].rules;
        }
    },

// return the currently active lexer condition state; when an index argument is provided it produces the N-th previous condition state, if available
topState:function topState(n) {
        n = this.conditionStack.length - 1 - Math.abs(n || 0);
        if (n >= 0) {
            return this.conditionStack[n];
        } else {
            return "INITIAL";
        }
    },

// alias for begin(condition)
pushState:function pushState(condition) {
        this.begin(condition);
    },

// return the number of states currently on the stack
stateStackSize:function stateStackSize() {
        return this.conditionStack.length;
    },
options: {},
performAction: function anonymous(yy,yy_,$avoiding_name_collisions,YY_START) {

var YYSTATE=YY_START;
switch($avoiding_name_collisions) {
case 0:/* skip comments*/
break;
case 1:/* skip comments*/
break;
case 2:/* skip whitespace */
break;
case 3:return 9;
break;
case 4:return 10;
break;
case 5:return 6;
break;
case 6:return 21;
break;
case 7:return 23;
break;
case 8:return 12;
break;
case 9:return 13;
break;
case 10:return 14;
break;
case 11:return 15;
break;
case 12:return 16;
break;
case 13:return 17;
break;
case 14:return 19;
break;
case 15:return 20;
break;
case 16:return 25;
break;
case 17:return 22;
break;
case 18:return 30;
break;
case 19:return 7;
break;
case 20:return 8;
break;
case 21:return 27;
break;
case 22:return 28;
break;
case 23:return 26;
break;
case 24:return 31;
break;
case 25:return 5;
break;
}
},
rules: [/^(?:\/\*(.|\r|\n)*?\*\/)/,/^(?:\/\/.*($|\r\n|\r|\n))/,/^(?:\s+)/,/^(?:and|AND\b)/,/^(?:or|OR\b)/,/^(?:not|NOT\b)/,/^(?:=~)/,/^(?:!~)/,/^(?:=)/,/^(?:<>)/,/^(?:<=)/,/^(?:>=)/,/^(?:<)/,/^(?:>)/,/^(?:contains|CONTAINS\b)/,/^(?:like|LIKE\b)/,/^(?:[\-]?[0-9]+)/,/^(?:"[^\"]*")/,/^(?:[A-Za-z_$]([A-Za-z0-9_$]+)*)/,/^(?:\()/,/^(?:\))/,/^(?:\[)/,/^(?:\])/,/^(?:,)/,/^(?:\.)/,/^(?:$)/],
conditions: {"INITIAL":{"rules":[0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25],"inclusive":true}}
};
return lexer;
})();
parser.lexer = lexer;
function Parser () {
  this.yy = {};
}
Parser.prototype = parser;parser.Parser = Parser;
return new Parser;
})();


if (typeof require !== 'undefined' && typeof exports !== 'undefined') {
exports.parser = zerkelParser;
exports.Parser = zerkelParser.Parser;
exports.parse = function () { return zerkelParser.parse.apply(zerkelParser, arguments); };
exports.main = function commonjsMain(args) {
    if (!args[1]) {
        console.log('Usage: '+args[0]+' FILE');
        process.exit(1);
    }
    var source = require('fs').readFileSync(require('path').normalize(args[1]), "utf8");
    return exports.parser.parse(source);
};
if (typeof module !== 'undefined' && require.main === module) {
  exports.main(process.argv.slice(1));
}
}// Generated by CoffeeScript 1.7.1
(function() {
  var getIn, helpers, idxof, makePredicate, match, parser, regex, requote, zlib;

  parser = require('./zerkel-parser') || (typeof window !== "undefined" && window !== null ? window.zerkelParser : void 0);

  zlib = require('node-zlib-backport');

  requote = function(s) {
    return s.replace(/[.*+?^${}()|[\]\\]/g, "\\$&");
  };

  module.exports.match = match = function(val, pattern) {
    var pat;
    if (pattern === '*') {
      return true;
    }
    pat = requote(pattern.replace(/(^\*|\*$)/g, ''));
    if (pattern[0] === '*') {
      pat = '.+' + pat;
    }
    if (pattern[pattern.length - 1] === '*') {
      pat = pat + '.+';
    }
    return new RegExp(pat).test(val);
  };

  module.exports.regex = regex = function(val, re) {
    return new RegExp(re).test(val);
  };

  module.exports.idxof = idxof = function(val, x) {
    var idx;
    if (val && (idx = val.indexOf) && idx === String.prototype.indexOf || idx === Array.prototype.indexOf) {
      return val.indexOf(x) >= 0;
    }
  };

  module.exports.getIn = getIn = function(env, varName) {
    var level, levels, out, _i, _len;
    levels = varName.split(".");
    out = env;
    for (_i = 0, _len = levels.length; _i < _len; _i++) {
      level = levels[_i];
      if (!((out != null) && typeof out === 'object')) {
        out = void 0;
        break;
      }
      out = out[level];
    }
    return out;
  };

  module.exports.helpers = helpers = {
    match: match,
    getIn: getIn,
    regex: regex,
    idxof: idxof
  };

  module.exports.makePredicate = makePredicate = function(body) {
    var fn;
    if (body.substr(0, 3) === "GZ:") {
      body = zlib.unzipSync(new Buffer(body.substr(3), 'base64')).toString();
    }
    fn = new Function('_helpers', '_env', "return " + body);
    return function(env) {
      return Boolean(fn(helpers, env));
    };
  };

  module.exports.compile = function(query) {
    return makePredicate(parser.parse(query));
  };

}).call(this);
