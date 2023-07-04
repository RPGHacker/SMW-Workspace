hljsAsar = {
  init : function() {
    hljs.registerLanguage("powershell", function(e) {
      return {
          aliases: ["ps"],
          l: /-?[A-z\.\-]+/,
          cI: !0,
          k: {
          }
      }
    });

    // I know this is ugly, but I don't know how else to solve Asar's label rules...
    var asar_opcodes = ["db", "dw", "dl", "dd", "adc", "and", "asl", "bcc", "blt", "bcs", "bge", "beq", "bit", "bmi", "bne", "bpl", "bra", "brk", "brl", "bvc", "bvs", "clc", "cld", "cli", "clv", "cmp", "cop", "cpx", "cpy", "dec", "dea", "dex", "dey", "eor", "inc", "ina", "inx", "iny", "jmp", "jml", "jsr", "jsl", "lda", "ldx", "ldy", "lsr", "mvn", "mvp", "nop", "ora", "pea", "pei", "per", "pha", "phb", "phd", "phk", "php", "phx", "phy", "pla", "plb", "pld", "plp", "plx", "ply", "rep", "rol", "ror", "rti", "rtl", "rts", "sbc", "sec", "sed", "sei", "sep", "sta", "stp", "stx", "sty", "stz", "tax", "tay", "tcd", "tcs", "tdc", "trb", "tsc", "tsb", "tsx", "txa", "txs", "txy", "tya", "tyx", "wai", "wdm", "xba", "xce", "r0", "r1", "r2", "r3", "r4", "r5", "r6", "r7", "r8", "r9", "r10", "r11", "r12", "r13", "r14", "r15", "add", "alt1", "alt2", "alt3", "asr", "bic", "cache", "cmode", "color", "div2", "fmult", "from", "getb", "getbh", "getbl", "getbs", "getc", "hib", "ibt", "iwt", "ldb", "ldw", "link", "ljmp", "lm", "lms", "lmult", "lob", "loop", "merge", "mult", "not", "or", "plot", "ramb", "romb", "rpix", "sbk", "sex", "sm", "sms", "stb", "stop", "stw", "sub", "swap", "to", "umult", "with", "xor", "addw", "ya", "and1", "bbc0", "bbc1", "bbc2", "bbc3", "bbc4", "bbc5", "bbc6", "bbc7", "bbs0", "bbs1", "bbs2", "bbs3", "bbs4", "bbs5", "bbs6", "bbs7", "call", "cbne", "clr0", "clr1", "clr2", "clr3", "clr4", "clr5", "clr6", "clr7", "clrc", "clrp", "clrv", "cmpw", "daa", "das", "dbnz", "decw", "di", "div", "ei", "eor1", "incw", "mov", "sp", "mov1", "movw", "mul", "not1", "notc", "or1", "pcall", "pop", "push", "ret", "reti", "set0", "set1", "set2", "set3", "set4", "set5", "set6", "set7", "setc", "setp", "sleep", "subw", "tcall", "tclr", "tset", "xcn", "lea", "move", "moves", "moveb", "movew"];
    
    var asar_keywords = ["lorom", "hirom", "exlorom", "exhirom", "sa1rom", "fullsa1rom", "sfxrom", "norom", "macro", "endmacro", "struct", "endstruct", "extends", "incbin", "incsrc", "fillbyte", "fillword", "filllong", "filldword", "fill", "padbyte", "pad", "padword", "padlong", "paddword", "table", "cleartable", "ltr", ",rtl", "skip", "namespace", "import", "print", "org", "warnpc", "base", "on", "off", "reset", "freespaceuse", "pc", "bytes", "hex", "freespace", "freecode", "freedata", "ram", "noram", "align", "cleaned", "static", "autoclean", "autoclear", "prot", "pushpc", "pullpc", "pushbase", "pullbase", "function", "if", "else", "elseif", "endif", "while", "assert", "arch", "65816", "spc700", "inline", "superfx", "math", "pri", "round", "xkas", "bankcross", "bank", "noassume", "auto", "asar", "includefrom", "includeonce", "include", "error", "skip", "double", "round", "pushtable", "pulltable", "undef", "check", "title", "nested", "warnings", "push", "pull", "disable", "enable", "warn", "address", "dpbase", "optimize", "dp", "none", "always", "default", "mirrors"];
    
    var asar_intrinsic_functions = ["read1", "read2", "read3", "read4", "canread1", "canread2", "canread4", "sqrt", "sin", "cos", "tan", "asin", "acos", "atan", "arcsin", "arccos", "arctan", "log", "log10", "log2", "_read1", "_read2", "_read3", "_read4", "_canread1", "_canread2", "_canread4", "_sqrt", "_sin", "_cos", "_tan", "_asin", "_acos", "_atan", "_arcsin", "_arccos", "_arctan", "_log", "_log10", "_log2", "readfile1", "_readfile1", "readfile2", "_readfile2", "readfile3", "_readfile3", "readfile4", "_readfile4", "canreadfile1", "_canreadfile1", "canreadfile2", "_canreadfile2", "canreadfile3", "_canreadfile3", "canreadfile4", "_canreadfile4", "canreadfile", "_canreadfile", "filesize", "_filesize", "getfilestatus", "_getfilestatus", "snestopc", "_snestopc", "pctosnes", "_pctosnes", "max", "_max", "min", "_min", "clamp", "_clamp", "safediv", "_safediv", "select", "_select", "not", "_not", "equal", "_equal", "notequal", "_notequal", "less", "_less", "lessequal", "_lessequal", "greater", "_greater", "greaterequal", "_greaterequal", "and", "_and", "or", "_or", "nand", "_nand", "nor", "_nor", "xor", "_xor", "defined", "_defined", "sizeof", "_sizeof", "objectsize", "_objectsize", "stringsequal", "_stringsequal", "stringsequalnocase", "_stringsequalnocase"];
    
    var asar_opcodes_not = asar_opcodes.join("|");
    var asar_keywords_not = asar_keywords.join("|");
    var asar_intrinsic_functions_not = asar_intrinsic_functions.join("|");
    
    hljs.registerLanguage("65c816_asar",
    	function(s)
    	{
    		return {
    			cI: !0,
    			aliases: ["asar"],
    			l: s.IR,
    			k:
    			{
    				opcodes: asar_opcodes.join(' '),
    				keywords: asar_keywords.join(' '),
    				built_in: asar_intrinsic_functions.join(' ')
    			},
    			c:
    			[
    				{
    					cN: "built_in",
    					b: "(" + asar_intrinsic_functions.join('|') + ")\\(",
    					e: "\\)"
    				},
    				s.C("[;]", "$"),
    				s.CBCM,
    				s.QSM,
    				{
    					cN: "string",
    					b: '"',
    					e: '"',
    					r: 0
    				},
    				{
    					cN: "string",
    					b: '\'',
    					e: '\'',
    					r: 0
    				},
    				{
    					cN: "special",
    					b: '\\s*^@',
    					e: '$',
    					r: 0
    				},
    				{
    					cN: "keywords",
    					b: asar_keywords.join('\\b|').concat('\\b')
    				},
    				{
    					cN: "number",
    					v:
    					[
    						{
    							b: "#?[+\\-~]?0x[0-9a-fA-F]+"
    						},
    						{
    							b: "#?[+\\-~]?[0-9]+(\\.[0-9]+)?"
    						},
    						{
    							b: "#?[+\\-~]?%[0-1]+"
    						},
    						{
    							b: "#?[+\\-~]?\\$[0-9a-fA-F]+"
    						}/*,
    						{
    							b: "#?(\\(|\\)|\\+|\\-|\\*|\\/|\\%|\\<\\<|\\>\\>|\\&|\\||\\^|\\~|\\*\\*)+"
    						}*/
    					],
    					r: 0
    				},
    				{
    					cN: "function",
    					v:
    					[
    						{
    							b: "%?[a-zA-Z0-9_]+\\(",
    							e: "\\)"
    						}
    					],
    					r: 0
    				},
    				{
    					cN: "define",
    					v:
    					[
    						{
    							b: "!\\^*[a-zA-Z0-9_{}]+"
    						},
    						{
    							b: "<\\^*[a-zA-Z0-9_]+>"
    						},
    					],
    					r: 0
    				},
    				{
    					cN: "opcodes",
    					b: asar_opcodes.join('(\\.[bwl]|\\b)|').concat('(\\.[bwl]|\\b)')
    				},
    				{
    					cN: "label",
    					v:
    					[
    						{
    							b: "#?\\??\\.*[a-zA-Z0-9_]+:?"
    						},				
    						{
    							b: "\\??(-+|\\++):?"
    						}
    					],
    					r: 0
    				}
    			],
    			i: "/"
    		}
    	}
    );
  }
};