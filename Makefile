.PHONY: syntax lexer calculator clean

syntax: calculator.y
	bison -H calculator.y

lexer: calculator.l
	lex calculator.l

calculator: syntax lexer utils.c utils.h syntax_tree.c syntax_tree.h
	gcc lex.yy.c calculator.tab.c utils.c syntax_tree.c -o calculator -lm

clean:
	rm calculator lex.yy.c calculator.tab.c calculator.tab.h