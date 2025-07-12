/* Analizador léxico, patrones a seguir */
%{
#include "calc.tab.h"
#include <stdlib.h>
%}

%%

[0-9]+\.[0-9]+         { yylval.fval = atof(yytext); return FLOAT; }
[0-9]+                 { yylval.ival = atoi(yytext); return INT; }

"sin"                  { return SIN; }
"cos"                  { return COS; }
"tan"                  { return TAN; }
"log10"                { return LOG10; }
"log"                  { return LOG; }
"sqrt"                 { return SQRT; }
"pow"                  { return POW; }

"PI"                   { return PI_CONST; }
"E"                    { return E_CONST; }

"exit"                 { return EXIT; }

"("                    { return '('; }
")"                    { return ')'; }
"+"                    { return '+'; }
"-"                    { return '-'; }
"*"                    { return '*'; }
"/"                    { return '/'; }
"%"                    { return '%'; }
","                    { return ','; }

[ \t\r]+               ;      /* Esto ignora espacios y tabs */
\n                     { return '\n'; } /* Retorna salto de línea */

.                      { printf("Caracter no reconocido: %s\n", yytext); }

%%

int yywrap(void) {
    return 1;
}
