%{
    #include "calculator.tab.h"
    #include "string.h"
    #include "syntax_tree.h"
    #include "math.h"
    int yyerror (const char *);

    size_t offset;
    #define ACTION_BEFORE \
        yylval = create_node(strdup(yytext));
%}

%%
[0-9]+ {
    ACTION_BEFORE
    yylval->value = atoi(yytext);
    return NUM;
}

[0-9]+\.[0-9]+ {
    ACTION_BEFORE
    yylval->value = atof(yytext);
    return NUM;
}

pi {
    ACTION_BEFORE
    yylval->value = M_PI;
    return NUM;
}

log|sin|cos|tan|abs {
    ACTION_BEFORE
    return UNARY_FUNC;
}

[a-zA-Z]+ {
    ACTION_BEFORE
    return VAR;
}

[\n]    { ACTION_BEFORE; return *yytext; }
[-+()=/*^%] { ACTION_BEFORE; return *yytext; }

[ \t]   ;

.   yyerror("invalid character");
%%

int yywrap(void) {
    return 1;
}