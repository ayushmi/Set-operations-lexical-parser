%{
 
#include <stdio.h>
#include <string.h>
#include "y.tab.h"
int unknown;

%}
%%
[ \t]* {;}
"Universe"		return UNIVERSAL;
"union"		return UNION;
"not"		return NOT;
"minus"		return MINUS;
"intersection"	return INTERSECTION;
"("		return OPENBRACKET;
")"		return CLOSEBRACKET;
[0-n]+ {
	if(strlen(yytext) > 1)
		yylval= 10*(yytext[0] - '0') + (yytext[1]-'0'); 
	else
		yylval = yytext[0] - '0';
	return(NUMBER);
	}


[^a-z0-9\b] {
                 unknown = yytext[0];
                 return(unknown);
            }
