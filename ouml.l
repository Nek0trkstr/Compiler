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

enum type{
    UNRECOGNIZED,
    SIZE,
    START_ML,
    END_ML,
    NEW_LINE,
    STRING,
    START_BEGIN_HEADING_MARK,
    START_END_HEADING_MARK,
    END_HEADING_MARK,
    BEGIN_BOLD,
    END_BOLD,
    BEGIN_ITALICS,
    END_ITALICS,
    BEGIN_COMMENT,
    END_COMMENT,
    START_CENTER,
    END_CENTER,
    START_TEXT_COLOR,
    END_TEXT_COLOR,
    COLOR,
    BEGIN_NUMBER_BULLET,
    END_NUMBER_BULLET,
    BEGIN_REGULLAR_BULLET,
    END_REGGULAR_BULLET,
};

%}

COLOR                       ?i:(red|blue|black)
SIZE                        [0-6]
START_ML                    <(?i:oubegin)>
END_ML                      <(?i:ouend)>
NEW_LINE                    <(?i:nl)>
STRING                      [^(<|>|"\n")|(<!!)|(!!>)]+
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
BEGIN_NUMBER_BULLET         <(?i:bln)>
END_NUMBER_BULLET           <\/(?i:bln)>
BEGIN_REGULLAR_BULLET       <(?i:bl)>
END_REGGULAR_BULLET         <\/(?i:bl)>

%x end_heading_mark heading_mark comment set_text_color

%%
\n                                      { yylineno++; }
[\t]                                    ;
{COLOR}                                 return COLOR;
{SIZE}                                  return SIZE;
{START_ML}                              return START_ML;
{END_ML}                                return END_ML;
{NEW_LINE}                              return NEW_LINE;
{STRING}                                return STRING;
{BEGIN_BOLD}                            return BEGIN_BOLD;
{END_BOLD}                              return END_BOLD;
{BEGIN_ITALICS}                         return BEGIN_ITALICS;
{END_ITALICS}                           return END_ITALICS;
{START_CENTER}                          return START_CENTER;
{END_CENTER}                            return END_CENTER;
{BEGIN_NUMBER_BULLET}                   return BEGIN_NUMBER_BULLET;
{END_NUMBER_BULLET}                     return END_NUMBER_BULLET;
{BEGIN_REGULLAR_BULLET}                 return BEGIN_REGULLAR_BULLET;
{END_REGGULAR_BULLET}                   return END_NUMBER_BULLET;
{START_BEGIN_HEADING_MARK}              return START_BEGIN_HEADING_MARK;
{END_HEADING_MARK}                      return END_HEADING_MARK;
{START_END_HEADING_MARK}                return START_END_HEADING_MARK;
{START_TEXT_COLOR}                      return START_TEXT_COLOR;
{END_TEXT_COLOR}                        return END_TEXT_COLOR;
{BEGIN_COMMENT}                         BEGIN(comment);
<comment>[^!]*                          ;
<comment>{END_COMMENT}                  BEGIN(0);
.       			                    fprintf(yyout ,"Unrecognized character!: %s\n", yytext );
%%

void printToken(char *tokenName, char* lexeme)
{
    fprintf(yyout, "%-*s%s\n",40,tokenName,lexeme);
}

void printTokenWithArg(char *tokenName, char* lexeme, char *argValue)
{
    fprintf(yyout, "%-*s%-*s%s\n",40 ,tokenName, 80,lexeme, argValue);
}

void setAttribute(char *attributeValue)
{
    int size = strlen(attributeValue);
    currentAttribute = (char*)realloc(NULL,sizeof(char)*size);
    int i = 0;
    for(i; i<size; i++)
    {
        currentAttribute[i] = attributeValue[i];
    }
}

void setLexeme(char *lexemeValue)
{
    int size = strlen(lexemeValue);
    currentLexeme = (char*)realloc(NULL,sizeof(char)*size);
    int i = 0;
    for(i; i<size; i++)
    {
        currentLexeme[i] = lexemeValue[i];
    }
}

void appendLexeme(char *lexemeToAppend)
{
    char * new_str ;
    new_str = malloc(strlen(currentLexeme)+strlen(lexemeToAppend)+1);
    new_str[0] = '\0';
    strcat(new_str,currentLexeme);
    strcat(new_str,lexemeToAppend);
    setLexeme(new_str);
}

int main(int argc, char **argv ){
    ++argv, --argc;  /* skip over program name */
    if ( argc > 0 ) {
        yyin = fopen( argv[0], "r" );
    }
    else {
        yyin = stdin;
    }

    yyout = fopen( "output.tok", "w" );

    fprintf(yyout,"Token\t\t\t\t\t\t\t\t\tLexeme\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\tAttribute\n");
    int token = yylex();
    while(token) {
        switch(token) {
            case START_ML:
                printToken("startML", yytext);
                break;
            case END_ML:
                printToken("endML", yytext);
                break;
            case NEW_LINE:
                printToken("newline", yytext);
                break;
            case STRING:
                printToken("string", yytext);
                break;
            case BEGIN_BOLD:
                printToken("begin_bold_mark", yytext);
                break;
            case END_BOLD:
                printToken("end_bold_mark", yytext);
                break;
            case BEGIN_ITALICS:
                printToken("begin_italics_mark", yytext);
                break;
            case END_ITALICS:
                printToken("end_italics_mark", yytext);
                break;
            case START_CENTER:
                printToken("start_center", yytext);
                break;
            case END_CENTER:
                printToken("end_center", yytext);
                break;
            case BEGIN_NUMBER_BULLET:
                printToken("begin_number_bullet", yytext);
                break;
            case END_NUMBER_BULLET:
                printToken("end_number_bullet", yytext);
                break;
            case BEGIN_REGULLAR_BULLET:
                printToken("begin_regullar_bullet", yytext);
                break;
            case END_REGGULAR_BULLET:
                printToken("END_REGGULAR_BULLET", yytext);
                break;
            case START_BEGIN_HEADING_MARK:
                setLexeme(yytext);
                if (yylex() != SIZE) {
                    fprintf(yyout, "Line %d, Syntax Error. Expected a size (1-6), but got %s\n", yylineno, yytext);
                    break;
                }
                appendLexeme(yytext);
                setAttribute(yytext);
                if (yylex() != END_HEADING_MARK) {
                    fprintf(yyout, "Line %d, Syntax Error. Expected a '>', but got %s\n", yylineno, yytext);
                    break;
                }
                appendLexeme(yytext);
                printTokenWithArg("beging_heading_mark", currentLexeme, currentAttribute);
                break;
            case START_END_HEADING_MARK:
                setLexeme(yytext);
                if (yylex() != SIZE) {
                    fprintf(yyout, "Line %d, Syntax Error. Expected a size (1-6), but got %s\n", yylineno, yytext);
                    break;
                }
                appendLexeme(yytext);
                setAttribute(yytext);
                if (yylex() != END_HEADING_MARK) {
                    fprintf(yyout, "Line %d, Syntax Error. Expected a '>', but got %s\n", yylineno, yytext);
                    break;
                }
                appendLexeme(yytext);
                printTokenWithArg("end_heading_mark", currentLexeme, currentAttribute);
                break;
            case START_TEXT_COLOR:
                setLexeme(yytext);
                if (yylex() != COLOR) {
                    fprintf(yyout, "Line %d, Syntax Error. Expected a color, but got %s\n", yylineno, yytext);
                    break;
                }
                appendLexeme(yytext);
                setAttribute(yytext);
                if (yylex() != END_TEXT_COLOR) {
                    fprintf(yyout, "Line %d, Syntax Error. Expected a '>', but got %s\n", yylineno, yytext);
                    break;
                }
                appendLexeme(yytext);
                printTokenWithArg("set_text_color", currentLexeme, currentAttribute);
                break;
        }
        token = yylex();
    }
    free(currentAttribute);
    free(currentLexeme);
}
