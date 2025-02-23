%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define MAX_SYMBOLS 100

typedef struct {
    char symbol[50];
    int code;
} SymbolTableEntry;

typedef struct {
    char token[50];
    int position;
} PIFEntry;

SymbolTableEntry symbolTable[MAX_SYMBOLS];
int symbolCount = 0;

PIFEntry pif[MAX_SYMBOLS];
int pifCount = 0;

int addSymbol(const char *symbol) {
    for (int i = 0; i < symbolCount; i++) {
        if (strcmp(symbolTable[i].symbol, symbol) == 0) {
            return i;
        }
    }
    strcpy(symbolTable[symbolCount].symbol, symbol);
    symbolTable[symbolCount].code = symbolCount;
    return symbolCount++;
}

void addPIF(const char *token, int position) {
    strcpy(pif[pifCount].token, token);
    pif[pifCount].position = position;
    pifCount++;
}

void printSymbolTable() {
    printf("Symbol Table:\n");
    for (int i = 0; i < symbolCount; i++) {
        printf("%d: %s\n", symbolTable[i].code, symbolTable[i].symbol);
    }
}

void printPIF() {
    printf("Program Internal Form:\n");
    for (int i = 0; i < pifCount; i++) {
        printf("%s: %d\n", pif[i].token, pif[i].position);
    }
}
%}

%option noyywrap

DIGIT       [0-9]
LETTER      [a-zA-Z]
IDENTIFIER  {LETTER}({LETTER}|{DIGIT})*
RESERVED    start|finish|let|begin|end|if|then|else|endif|while|do|done|input|output|increment|integer|float|bool|string|array|struct
OPERATOR    \+|\-|\*|\/|%|:=|<|<=|=|>=|>|!=
SEPARATOR   \[|\]|\{|\}|:|\(|\)|;|,|\.
STRING      \"[^\"]*\"
COMMENT     \/\/[^\n]*

%%

{RESERVED}          { addPIF(yytext, 0); }
{IDENTIFIER}        { int pos = addSymbol(yytext); addPIF(yytext, pos); }
{DIGIT}+            { int pos = addSymbol(yytext); addPIF(yytext, pos); }
{STRING}            { int pos = addSymbol(yytext); addPIF(yytext, pos); }
{OPERATOR}          { addPIF(yytext, 0); }
{SEPARATOR}         { addPIF(yytext, 0); }
{COMMENT}           { /* ignore comments */ }
{DIGIT}+{LETTER}+   { printf("Lexical error at line %d: Identifier must start with a letter: %s\n", yylineno, yytext); }
\n                  { yylineno++; /* increment line number */ }
[ \t\r]+            { /* ignore whitespace */ }
.                   { printf("Lexical error at line %d: Invalid token: %s\n", yylineno, yytext); }

%%

int main(int argc, char **argv) {
    if (argc != 2) {
        fprintf(stderr, "Usage: %s <inputfile>\n", argv[0]);
        exit(1);
    }

    FILE *file = fopen(argv[1], "r");
    if (!file) {
        fprintf(stderr, "Error: could not open file %s\n", argv[1]);
        exit(1);
    }

    yyin = file;
    yylex();
    fclose(file);

    printSymbolTable();
    printPIF();

    return 0;
}
