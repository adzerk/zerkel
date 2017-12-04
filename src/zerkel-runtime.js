(function(root) {
  // https://developer.mozilla.org/en-US/docs/Web/JavaScript/Guide/Regular_Expressions
  function requote(s) {
    return s.replace(/[.*+?^${}()|[\]\\]/g, "\\$&");
  }

  var helpers = {
    match: function(val, pattern) {
      if (pattern === '*') return true;
      var pat = requote(pattern.replace(/(^\*|\*$)/g, ''));
      if (pattern[0] === '*') pat = '.+' + pat;
      if (pattern[pattern.length - 1] === '*') pat = pat + '.+';
      return new RegExp(pat).test(val);
    },
    regex: function(val, re) {
      return new RegExp(re).test(val);
    },
    idxof: function(val, x) {
      var type = (Object.prototype.toString.call(val).match(/^\[object (.*)]$/)||[])[1];
      return val && (type === 'String' || type === 'Array') && val.indexOf(x) >= 0;
    },
    // deprecated
    getIn: function(env, varName) {
      var levels = varName.split(".");
      var out = env;
      for (var i=0; i<levels.length; i++) {
        if (out == null || typeof out !== 'object') {
          out = undefined;
          break;
        }
        out = out[levels[i]];
      }
      return out;
    }
  };

  var zerkelRuntime = {
    makePredicate: function(body) {
      var fn = new Function('_helpers', '_env', "return " + body);
      return function(env) { return Boolean(fn(helpers, env)); };
    }
  };

  if (typeof define !== 'undefined' && define.amd) {
    define([], function () { return zerkelRuntime });
  } else if (typeof module !== 'undefined' && module.exports) {
    module.exports = zerkelRuntime;
  } else {
    root.zerkelRuntime = zerkelRuntime;
  }
})(this);
