%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "y.tab.h" // Include token definitions

extern int yylineno;
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

{RESERVED}          {
                        if (strcmp(yytext, "start") == 0) return START;
                        if (strcmp(yytext, "finish") == 0) return FINISH;
                        if (strcmp(yytext, "let") == 0) return LET;
                        if (strcmp(yytext, "begin") == 0) return BEGIN_BLOCK;
                        if (strcmp(yytext, "end") == 0) return END;
                        if (strcmp(yytext, "if") == 0) return IF;
                        if (strcmp(yytext, "then") == 0) return THEN;
                        if (strcmp(yytext, "else") == 0) return ELSE;
                        if (strcmp(yytext, "endif") == 0) return ENDIF;
                        if (strcmp(yytext, "while") == 0) return WHILE;
                        if (strcmp(yytext, "do") == 0) return DO;
                        if (strcmp(yytext, "done") == 0) return DONE;
                        if (strcmp(yytext, "input") == 0) return INPUT;
                        if (strcmp(yytext, "output") == 0) return OUTPUT;
                        if (strcmp(yytext, "increment") == 0) return INCREMENT;
                        if (strcmp(yytext, "integer") == 0) return INTEGER_TYPE;
                        if (strcmp(yytext, "float") == 0) return FLOAT_TYPE;
                        if (strcmp(yytext, "bool") == 0) return BOOL_TYPE;
                        if (strcmp(yytext, "string") == 0) return STRING_TYPE;
                        if (strcmp(yytext, "array") == 0) return ARRAY;
                        if (strcmp(yytext, "struct") == 0) return STRUCT;
                    }
{IDENTIFIER}        { yylval.strval = strdup(yytext); return IDENTIFIER; }
{DIGIT}+            { yylval.intval = atoi(yytext); return INTEGER; }
{DIGIT}+"."{DIGIT}+ { yylval.floatval = atof(yytext); return FLOAT; }
{STRING}            { yylval.strval = strdup(yytext); return STRING; }
":="                { return ASSIGN; }
"+"                 { return PLUS; }
"-"                 { return MINUS; }
"*"                 { return MULT; }
"/"                 { return DIV; }
"%"                 { return MOD; }
"<"                 { return LT; }
"<="                { return LE; }
"="                 { return EQ; }
">="                { return GE; }
">"                 { return GT; }
"!="                { return NE; }
";"                 { return SEMICOLON; }
":"                 { return COLON; }
","                 { return COMMA; }
"{"                 { return LBRACE; }
"}"                 { return RBRACE; }
"["                 { return LBRACKET; }
"]"                 { return RBRACKET; }
"("                 { return LPAREN; }
")"                 { return RPAREN; }
{COMMENT}           { /* Ignore comments */ }
[ \t\r]+            { /* Ignore whitespace */ }
\n                  { yylineno++; }
.                   { printf("Lexical error at line %d: Invalid token '%s'\n", yylineno, yytext); }

%%

