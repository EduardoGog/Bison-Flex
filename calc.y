%{
  /* Inclusión de bibliotecas estándar necesarias para entrada/salida y funciones matemáticas */
  #include <stdio.h>
  #include <stdlib.h>
  #include <math.h>

  /* Declaraciones anticipadas requeridas por Bison */
  void yyerror(const char *s);
  int yylex(void);
%}

/* 
 * Definición del tipo de valor semántico que puede tomar cada token
 * ival → valores enteros (INT)
 * fval → valores flotantes (FLOAT, resultados de expresiones, constantes y funciones)
 */
%union {
    int ival;
    double fval;
}

/* 
 * Definición de tokens junto con el tipo de dato que devuelven
 * INT y FLOAT son valores numéricos
 * PI_CONST y E_CONST representan constantes matemáticas
 * SIN, COS, etc. representan funciones matemáticas
 * EXIT es un comando para finalizar la aplicación
 */
%token <ival> INT
%token <fval> FLOAT
%token PI_CONST E_CONST
%token SIN COS TAN LOG LOG10 SQRT POW
%token EXIT

/* 
 * Se especifica que las producciones con símbolo no terminal 'expr' 
 * retornarán valores de tipo flotante (double)
 */
%type <fval> expr

/* 
 * Definición de precedencia y asociatividad de operadores
 * '+' y '-' tienen igual precedencia (nivel más bajo), asociativos por la izquierda
 * '*' '/' '%' tienen mayor precedencia, también asociativos por la izquierda
 * UMINUS es el operador unario negativo, con precedencia más alta (por la derecha)
 */
%left '+' '-'
%left '*' '/' '%'
%right UMINUS

%%

/* 
 * Producción principal: permite múltiples líneas de entrada.
 * input puede ser vacío o una secuencia de líneas.
 */
input:
    /* vacío */
  | input line
  ;

/* 
 * Una línea puede contener:
 * - Una expresión válida seguida de '\n', se imprime su resultado
 * - El token EXIT seguido de '\n' para terminar el programa
 * - Una línea vacía
 */
line:
    expr '\n'     { printf("= %.6f\n", $1); }
  | EXIT '\n'     { exit(0); }
  | '\n'
  ;

/* 
 * Reglas de formación de expresiones válidas:
 * - Operaciones aritméticas básicas
 * - Paréntesis para agrupación
 * - Números enteros y flotantes
 * - Constantes (PI y e)
 * - Funciones trigonométricas y matemáticas
 * - Potencia con dos argumentos
 */
expr:
    expr '+' expr       { $$ = $1 + $3; }                 /* Suma */
  | expr '-' expr       { $$ = $1 - $3; }                 /* Resta */
  | expr '*' expr       { $$ = $1 * $3; }                 /* Multiplicación */
  | expr '/' expr       {                                /* División con verificación de cero */
        if ($3 == 0) {
            fprintf(stderr, "Error: división por cero\n");
            $$ = 0;
        } else {
            $$ = $1 / $3;
        }
    }
  | expr '%' expr       { $$ = fmod($1, $3); }            /* Módulo flotante (fmod) */
  | '-' expr %prec UMINUS { $$ = -$2; }                   /* Negación unaria */
  | '(' expr ')'        { $$ = $2; }                      /* Agrupación con paréntesis */
  | INT                 { $$ = $1; }                      /* Número entero */
  | FLOAT               { $$ = $1; }                      /* Número con punto decimal */
  | PI_CONST            { $$ = M_PI; }                    /* Constante pi */
  | E_CONST             { $$ = M_E; }                     /* Constante e */
  | SIN '(' expr ')'    { $$ = sin($3); }                 /* Función seno */
  | COS '(' expr ')'    { $$ = cos($3); }                 /* Función coseno */
  | TAN '(' expr ')'    { $$ = tan($3); }                 /* Función tangente */
  | LOG '(' expr ')'    { $$ = log($3); }                 /* Logaritmo natural (base e) */
  | LOG10 '(' expr ')'  { $$ = log10($3); }               /* Logaritmo en base 10 */
  | SQRT '(' expr ')'   { $$ = sqrt($3); }                /* Raíz cuadrada */
  | POW '(' expr ',' expr ')' { $$ = pow($3, $5); }       /* Potencia: base ^ exponente */
;

%%

/* 
 * Función para manejar errores sintácticos detectados por Bison.
 * Muestra un mensaje en la salida estándar de error.
 */
void yyerror(const char *s) {
    fprintf(stderr, "Error de sintaxis: %s\n", s);
}
