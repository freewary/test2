﻿CodeMirror.multiplexingMode=function(f){function j(a,c,b){return"string"==typeof c?a.indexOf(c,b):(a=c.exec(b?a.slice(b):a))?a.index+b:-1}var i=Array.prototype.slice.call(arguments,1),k=i.length;return{startState:function(){return{outer:CodeMirror.startState(f),innerActive:null,inner:null}},copyState:function(a){return{outer:CodeMirror.copyState(f,a.outer),innerActive:a.innerActive,inner:a.innerActive&&CodeMirror.copyState(a.innerActive.mode,a.inner)}},token:function(a,c){if(c.innerActive){var b=
c.innerActive,d=a.string,e=j(d,b.close,a.pos);if(e==a.pos)return a.match(b.close),c.innerActive=c.inner=null,b.delimStyle;-1<e&&(a.string=d.slice(0,e));var g=b.mode.token(a,c.inner);-1<e&&(a.string=d);d=a.current();e=d.indexOf(b.close);-1<e&&a.backUp(d.length-e);return g}for(var b=Infinity,d=a.string,g=0;g<k;++g){var h=i[g],e=j(d,h.open,a.pos);if(e==a.pos)return a.match(h.open),c.innerActive=h,c.inner=CodeMirror.startState(h.mode,f.indent?f.indent(c.outer,""):0),h.delimStyle;-1!=e&&e<b&&(b=e)}Infinity!=
b&&(a.string=d.slice(0,b));e=f.token(a,c.outer);Infinity!=b&&(a.string=d);return e},indent:function(a,c){var b=a.innerActive?a.innerActive.mode:f;return!b.indent?CodeMirror.Pass:b.indent(a.innerActive?a.inner:a.outer,c)},blankLine:function(a){var c=a.innerActive?a.innerActive.mode:f;c.blankLine&&c.blankLine(a.innerActive?a.inner:a.outer);if(a.innerActive)"\n"===c.close&&(a.innerActive=a.inner=null);else for(var b=0;b<k;++b){var d=i[b];"\n"===d.open&&(a.innerActive=d,a.inner=CodeMirror.startState(d.mode,
c.indent?c.indent(a.outer,""):0))}},electricChars:f.electricChars,innerMode:function(a){return a.inner?{state:a.inner,mode:a.innerActive.mode}:{state:a.outer,mode:f}}}};