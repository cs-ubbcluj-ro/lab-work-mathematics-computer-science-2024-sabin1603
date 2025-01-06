%{
#include <stdio.h>
#include <stdlib.h>

extern int yylineno; // Line number from lex
extern char *yytext; // Text of the current token

void yyerror(const char *msg);
int yylex(void);

%}

%union {
    int intval;
    float floatval;
    char *strval;
}

%token <strval> IDENTIFIER STRING
%token <intval> INTEGER
%token <floatval> FLOAT
%token START FINISH LET BEGIN_BLOCK END IF THEN ELSE ENDIF WHILE DO DONE INPUT OUTPUT INCREMENT
%token INTEGER_TYPE FLOAT_TYPE BOOL_TYPE STRING_TYPE ARRAY STRUCT
%token ASSIGN PLUS MINUS MULT DIV MOD
%token LT LE EQ GE GT NE
%token SEMICOLON COLON COMMA LBRACE RBRACE LBRACKET RBRACKET LPAREN RPAREN

%%

// Grammar rules
program:
    START decllist mainstmt FINISH { printf("Program parsed successfully.\n"); }
    ;

decllist:
    declaration SEMICOLON decllist
    | declaration
    ;

declaration:
    LET IDENTIFIER COLON type
    ;

type:
    INTEGER_TYPE
    | FLOAT_TYPE
    | BOOL_TYPE
    | STRING_TYPE
    ;

mainstmt:
    BEGIN_BLOCK stmtlist END
    ;

stmtlist:
    stmt SEMICOLON stmtlist
    | stmt
    ;

stmt:
    assignstmt
    | iostmt
    | ifstmt
    | loopstmt
    | incrementstmt
    ;

assignstmt:
    IDENTIFIER ASSIGN expression
    ;

iostmt:
    INPUT LPAREN IDENTIFIER RPAREN
    | OUTPUT LPAREN IDENTIFIER RPAREN
    ;

ifstmt:
    IF condition THEN stmtlist ELSE stmtlist ENDIF
    | IF condition THEN stmtlist ENDIF
    ;

loopstmt:
    WHILE condition DO stmtlist DONE
    ;

incrementstmt:
    INCREMENT LPAREN IDENTIFIER RPAREN
    ;

expression:
    term
    | expression PLUS term
    | expression MINUS term
    ;

term:
    factor
    | term MULT factor
    | term DIV factor
    ;

factor:
    IDENTIFIER
    | INTEGER
    | FLOAT
    | LPAREN expression RPAREN
    ;

condition:
    expression relop expression
    ;

relop:
    LT
    | LE
    | EQ
    | GE
    | GT
    | NE
    ;

%%

// Error handling
void yyerror(const char *msg) {
    fprintf(stderr, "Error: %s at line %d, near '%s'\n", msg, yylineno, yytext);
}

int main() {
    printf("Starting parsing...\n");
    if (yyparse() == 0) {
        printf("Parsing completed successfully.\n");
    } else {
        printf("Parsing failed.\n");
    }
    return 0;
}
