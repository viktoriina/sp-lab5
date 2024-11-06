%code top{
  #include <stdio.h> 
  #include <math.h>   
  #include "utils.h" 
  #include "syntax_tree.h"

  int yylex (void);
  void yyerror (char const *);

}

%locations
%define api.value.type { struct syntax_node* }
%token NUM     /* Double precision number. */
%token VAR UNARY_FUNC
%nterm exp

%precedence '='
%left '-' '+'
%left '*' '/' '%'
%precedence NEG /* negation--unary minus */
%right '^'      /* exponentiation */



%% /* The grammar follows. */
input:
  %empty
| input line  { printf("> "); }
;

line:
  '\n'
| exp '\n'   { printf ("%.10g\n", $1->value); print_syntax_tree($1);}
| statement '\n'
| error '\n' { yyerrok;                }
;

statement:
  VAR '=' exp { add_variable($1->name, $3->value);    }

exp:
  NUM {
    $$ = create_node_value("num", $1->value);
    add_sub_node($$, $1);
  }
| VAR                
{
  variable_node* var = get_variable($1->name);
  if(var == NULL) {
    yyerror("Referencing undefined variable");
    YYERROR;
  }
  $$ = create_node("var");
  add_sub_node($$, $1);
  $$->value = var->value;
}
| UNARY_FUNC '(' exp ')' 
{
  $$ = create_node_list_3("exp", $1, $2, $3);
  add_sub_node($$, $4);
  if(!process_unary_function($1->name, $3->value, &$$->value)) {
    YYERROR;
  } 
}
| exp '+' exp        { $$ = create_node_list_3("exp", $1, $2, $3); $$->value = $1->value + $3->value;}
| exp '-' exp        { $$ = create_node_list_3("exp", $1, $2, $3); $$->value = $1->value - $3->value;}
| exp '*' exp        { $$ = create_node_list_3("exp", $1, $2, $3); $$->value = $1->value * $3->value;}
| exp '/' exp        { $$ = create_node_list_3("exp", $1, $2, $3); $$->value = $1->value / $3->value;}
| exp '%' exp        { $$ = create_node_list_3("exp", $1, $2, $3); $$->value = (int)$1->value % (int)$3->value;}
| '-' exp  %prec NEG { $$ = create_node_list_2("exp", $1, $2); $$->value = -$2->value;}
| exp '^' exp        { $$ = create_node_list_3("exp", $1, $2, $3); $$->value = pow ($1->value, $3->value);}
| '(' exp ')'        { $$ = create_node_list_3("exp", $1, $2, $3); $$->value = $2->value;}
;
/* End of grammar. */
%%

/* Called by yyparse on error. */
void yyerror (char const *s)
{
  fprintf (stderr, "%s\n", s);
}

int main (int argc, char const* argv[])
{
  init_variable_table();
  printf("> ");
  return yyparse ();
}