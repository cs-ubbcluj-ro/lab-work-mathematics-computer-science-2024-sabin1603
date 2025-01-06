%{
#include <stdio.h>
#include <stdlib.h>

// Declare yyin to allow input redirection for yylex
extern FILE *yyin;

// Function declarations
void yyerror(const char *msg);
extern int yylex();
extern int yylineno; // Line number
%}

// Tokens from Lex 
%token START FINISH BEGIN END LET INTEGER FLOAT BOOL STRING STRUCT ARRAY INPUT OUTPUT IF THEN ELSE ENDIF WHILE DO DONE INCREMENT
%token IDENTIFIER INTEGER_CONST FLOAT_CONST STRING_CONST TRUE FALSE
%token ASSIGN PLUS MINUS MULTIPLY DIVIDE MODULO LT LEQ EQ GEQ GT NEQ
%token SEMICOLON COLON LBRACE RBRACE LBRACKET RBRACKET LPAREN RPAREN

// Precedence and associativity for operators
%left ELSE // Handle "else" ambiguity with precedence
%left '+' '-'
%left '*' '/' '%'

// Grammar Rules
%%
program:
    START decllist mainstmt FINISH { printf("Program syntactic correct\n"); }
    ;

decllist:
    declaration SEMICOLON decllist
    | declaration
    ;

declaration:
    LET IDENTIFIER COLON type
    ;

type:
    INTEGER
    | FLOAT
    | BOOL
    | STRING
    | structdecl
    | arraydecl
    ;

structdecl:
    STRUCT LBRACE decllist RBRACE
    ;

arraydecl:
    ARRAY LBRACKET INTEGER_CONST RBRACKET LPAREN basictype RPAREN
    ;

basictype:
    INTEGER
    | FLOAT
    ;

mainstmt:
    BEGIN stmtlist END
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
    | term MULTIPLY factor
    | term DIVIDE factor
    | term MODULO factor
    ;

factor:
    IDENTIFIER
    | INTEGER_CONST
    | FLOAT_CONST
    | LPAREN expression RPAREN
    ;

condition:
    expression relop expression
    ;

relop:
    LT
    | LEQ
    | EQ
    | GEQ
    | GT
    | NEQ
    ;

%%

// Error handler
void yyerror(const char *msg) {
    fprintf(stderr, "Error at line %d: %s\n", yylineno, msg);
}

// Main function
int main(int argc, char **argv) {
    if (argc > 1) {
        FILE *file = fopen(argv[1], "r");
        if (!file) {
            fprintf(stderr, "Could not open file %s\n", argv[1]);
            return 1;
        }
        yyin = file; // Assign input file to yyin
    }
    if (yyparse() == 0) {
        printf("Parsing completed successfully.\n");
    } else {
        printf("Parsing failed.\n");
    }
    return 0;
}
