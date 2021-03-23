%option noyywrap

%{
#include <string.h>
#include <stdio.h>
#include <string.h>

char *currentAttribute = NULL;
char *currentLexeme = NULL;
void printToken(char tokenName[], char* lexeme);
void printTokenWithArg(char *tokenName, char* lexeme, char *argValue);
void setAttribute(char *attribute);
%}

N                           [0-6]
ALPHA                       [a-zA-Z]
START_ML                    <(?i:oubegin)>
END_ML                      <(?i:ouend)>
NEW_LINE                    <(?i:nl)>
STRING                      [^<>]*
START_BEGIN_HEADING_MARK    <(?i:h)
START_END_HEADING_MARK      <\/(?i:h)
END_HEADING_MARK            >
BEGIN_BOLD                  <(?i:bold)>
END_BOLD                    <\/(?i:bold)>
BEGIN_ITALICS               <(?i:it)>
END_ITALICS                 <\/(?i:it)>
BEGIN_COMMENT               <!!
END_COMMENT                 !!>
START_CENTER                <(?i:c)>
END_CENTER                  <\/(?i:c)>
START_TEXT_COLOR            <(?i:text)\ (?i:color)=\"
END_TEXT_COLOR              \">
COLOR                       ?i:(red|blue|black)
BEGIN_NUMBER_BULLET         <(?i:bln)>
END_NUMBER_BULLET           <\/(?i:bln)>
BEGIN_REGULLAR_BULLET       <(?i:bl)>
END_REGGULAR_BULLET         <\/(?i:bl)>

%x end_heading_mark heading_mark comment set_text_color

%%
[ \t\n]                 {}
.       			    fprintf(yyout ,"Unrecognized character!: %s\n", yytext );

{START_ML}              printToken("startML", yytext);
{END_ML}                printToken("endML", yytext);
{NEW_LINE}              printToken("newline", yytext);
{STRING}                printToken("string", yytext);
{BEGIN_BOLD}            printToken("begin_bold_mark", yytext);
{END_BOLD}              printToken("end_bold_mark", yytext);
{BEGIN_ITALICS}         printToken("begin_italics_mark", yytext);
{END_ITALICS}           printToken("end_italics_mark", yytext);
{START_CENTER}          printToken("start_center", yytext);
{END_CENTER}            printToken("end_center", yytext);
{BEGIN_NUMBER_BULLET}   printToken("begin_number_bullet", yytext);
{END_NUMBER_BULLET}     printToken("end_number_bullet", yytext);
{BEGIN_REGULLAR_BULLET} printToken("begin_regular_bullet", yytext);
{END_REGGULAR_BULLET}   printToken("end_regular_bullet", yytext);

{BEGIN_COMMENT}                         BEGIN(comment);
<comment>[^{ENDCOMMENT}]                {}
<comment>{END_COMMENT}                  BEGIN(0);

{START_BEGIN_HEADING_MARK}              BEGIN(heading_mark);
<heading_mark>{N}                       setAttribute(yytext);
<heading_mark>{END_HEADING_MARK}        fprintf(yyout, "Token: begin_heading_mark, Lexeme: <h%s>, Attribute= %s\n", currentAttribute, currentAttribute); BEGIN(0);

{START_END_HEADING_MARK}                BEGIN(end_heading_mark);
<end_heading_mark>{N}                   setAttribute(yytext);
<end_heading_mark>{END_HEADING_MARK}    fprintf(yyout, "Token: end_heading_mark, Lexeme: </h%s>, Attribute= %s\n", currentAttribute, currentAttribute); BEGIN(0);

{START_TEXT_COLOR}                      BEGIN(set_text_color);
<set_text_color>{COLOR}                 setAttribute(yytext);
<set_text_color>{END_TEXT_COLOR}        fprintf(yyout, "Token: set_text_color, Lexeme: <set_text_color=\"%s\">, Attribute= %s\n", currentAttribute, currentAttribute); BEGIN(0);

%%

void printToken(char *tokenName, char* lexeme)
{
    fprintf(yyout, "Token: %s, Lexeme: %s\n",tokenName, lexeme);
}

void printTokenWithArg(char *tokenName, char* lexeme, char *argValue)
{
    fprintf(yyout, "Token: %s, Lexeme: %s, Attribute=%s\n",tokenName, lexeme, argValue);
}

void setAttribute(char *attributeValue)
{
    int size = strlen(attributeValue);
    //printf("originalAttr: %s, size %d\n", attributeValue, size);
    currentAttribute = (char*)realloc(NULL,sizeof(char)*size);
    int i = 0;
    for(i; i<size; i++)
    {
        currentAttribute[i] = attributeValue[i];
    }
    //printf("attribute: %s, size: %d\n", currentAttribute, strlen(currentAttribute));
}

int main(int argc, char **argv ){
++argv, --argc;  /* skip over program name */
if ( argc > 0 )
yyin = fopen( argv[0], "r" );
else
yyin = stdin;


if ( argc > 1 )
yyout = fopen( argv[1], "w" );
else
yyout = stdout;

yylex();}
