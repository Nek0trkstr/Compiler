# Compiler
This is a compiler for OUML language.  
## How to run
The scanner is generated using [Flex](https://en.wikipedia.org/wiki/Flex_(lexical_analyser_generator)).  
Running Flex on .lex file will generate a source code for scanner lex.yy.c
Compiling lex.yy.c will give us an executable of the scanner
```
flex ouml.lex
gcc lex.yy.c
./a.out test.txt
```
## OUML Definition
Token               | Lexeme
------              | ------
startML             | \<oubegin\>
endML               | \<ouend>
newline             | \<nl\>
string              | non-empty sequence of characters not including \> \<
begin_heading_mark  | \<hN\> where N is a digit 1-6
end_heading_mark    | \<\/hN\> where N is a digit 1-6
begin_bold_mark     | \<bold\>
end_bold_mark       | \<\/bold>
begin_italics_mark  | \<it\>
end_italics_mark    | \<\/it\>
begin_comment       | \<!!
end_comment         | !!\>
start_center        | \<c\>
end_center          | <\/c>
set_text_color      | \<text color="some_color"> where some_color is red or black or blue
begin_number_bullet | \<bln\> 
end_number_bullet   | \<\/bln\>
begin_regular_bullet| \<bl\>
end_regular_bullet  | \<\/bl>