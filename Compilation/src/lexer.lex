%{
#include "parser.h"
int lineno = 1;
int charno = 1;
%}

%option noinput
%option nounput
%x comment

 
%%
^.*[\n<<EOF>>]  				{strcpy(yylval.error, yylval.error); REJECT;}
void 							{charno += yyleng; return VOID;}
int|char 						{charno += yyleng; strcpy(yylval.type, yytext); return TYPE;}
print 							{charno += yyleng; return PRINT;}
\|\|							{charno += yyleng; return OR;}
&& 								{charno += yyleng; return AND;}
[=!]= 							{charno += yyleng; strcpy(yylval.equal, yytext); return EQ;}
if 								{charno += yyleng; return IF;}
else 							{charno += yyleng; return ELSE;}
return 							{charno += yyleng; return RETURN;}
while 							{charno += yyleng; return WHILE;}
readc 							{charno += yyleng; return READC;}
reade 							{charno += yyleng; return READE;}
[\<\>]=? 						{charno += yyleng; sscanf(yytext, "%s", yylval.order); return ORDER;}
\+|\- 							{charno += yyleng; yylval.signe = yytext[0]; return ADDSUB;}
[a-zA-Z][a-zA-Z0-9_]*			{charno += yyleng; strcpy(yylval.ident, yytext); return IDENT;}
'\\?.'							{charno += yyleng; yylval.character = yytext[1]; return CHARACTER;}
[0-9]+							{charno += yyleng; yylval.integer = atoi(yytext); return NUM; }
[/][*]							BEGIN comment;
<comment>[*][/] 				BEGIN INITIAL;
<comment>.						{charno += yyleng;}
<comment>\n 					{lineno += 1; charno = 1;}
\/\/.*\n 						{lineno += 1; charno = 1;}
\t 								{charno += 3;} 	
" "								{charno += 1;}
[\=\+\-*\/%!&,;\(\)\{\}\[\]]	{charno += 1; return yytext[0];}
\n 								{lineno += 1; charno =1;}
.								{return 0;}
%%
