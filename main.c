#include <stdio.h>
/* Parser de Bison */
int yyparse(void);

int main() {
    printf("🧮 Bienvenido a la Calculadora Científica 🧮\n");
    printf("Escribe una expresión matemática o 'exit' para salir.\n\n");

    /* Se espera la entrada del usuario */
    yyparse();

    return 0;
}