%{
#include <stdio.h>
#include<stdlib.h>
int result[100][20] = {0};
int i=0;
int j = 0;
%}

%start expr
%token  NUMBER UNIVERSAL
%token  UNION NOT MINUS INTERSECTION OPENBRACKET CLOSEBRACKET
%right MINUS
%left UNION INTERSECTION
%left NOT
%%                   

SET :    SET UNION SET
         {
		printf("{ ");
		for(i=0;i<20;i++)
		{
			if(result[$1][i]==1)
			 printf("%d ",i+1);
		}
		printf("}UNION{");
		for(i=0;i<20;i++)
		{
			if(result[$3][i]==1)
			printf("%d ",i+1);
		}
		printf("}\t=\t{");
		// Calculating union of two sets.

 		for(i=0;i<20;i++)
		{
			if(result[$1][i]==0)
				result[$1][i]=result[$3][i];			
		}
		$$=$1;
		// Printing the union operation result.
		for(i=0;i<20;i++)
		{
                	if(result[$1][i] == 1)
                		printf("%d,",i+1);
		}
		printf("}\n");
         }
	|
	 SET INTERSECTION SET
	 {
		printf("{ ");
		for(i=0;i<20;i++)
		{
			if(result[$1][i]==1)
			printf("%d ",i+1);
		}
		printf("}INTERSECTION{");
		for(i=0;i<20;i++)
		{
			if(result[$3][i]==1)
			printf("%d ",i+1);
		}
		printf("}\t=\t{");
		// Calculating Intersection
	 	
		for(i=0;i<20;i++)
		{
			if(result[$1][i]==result[$3][i]&&result[$1][i]==1)
				result[$1][i]=1;
			else
				result[$1][i]=0;
		}
		$$=$1;
		
		// Printing the intersection result
	
		for(i=0;i<20;i++)
		{
			if(result[$1][i]==1)
				printf("%d,",i+1);
		}
		printf("}\n");
	 }
	|
	 SET MINUS SET
	 {
		printf("{ ");
		for(i=0;i<20;i++)
		{
			if(result[$1][i]==1)
			printf("%d ",i+1);
		}
		printf("}MINUS{");
		for(i=0;i<20;i++)
		{
			if(result[$3][i]==1)
			printf("%d ",i+1);
		}
		printf("}\t=\t{");
	 	for(i=0;i<20;i++)
		{
			if(result[$1][i]==result[$3][i])
				result[$1][i]=0;
		}
		$$=$1;
		for(i=0;i<20;i++)
		{
			if(result[$1][i]==1)
				printf("%d,",i+1);
		}
		printf("}\n");
	 }	
	|
	 NOT SET
	 {
		printf("NOT{");
		for(i=0;i<20;i++)
		{
			if(result[$2][i]==1)
			{
				printf("%d ",i+1);
				result[$2][i]=0;
			}
			else
				result[$2][i]=1;
		}
		printf("}\t=\t{");
		$$=$2;
		for(i=0;i<20;i++)
		{
			if(result[$2][i]==1)
				printf("%d,",i+1);
		}
		printf("}\n");
	 }
	|
	 OPENBRACKET SET CLOSEBRACKET
	 {
		$$=$2;
	 }
	|
	 '{' numbers '}'
	 {
	 	$$=$2;
	 }
	|
	 '{' '}'
	 {
	 	for(i=0;i<20;i++)
		{
			result[j][i]=0;
		}
		$$=j;
		j++;
	 }
	|
	 UNIVERSAL
	 {
	 	for(i=0;i<20;i++)
		{
			result[j][i]=1;
		}
		$$ = j;
		j++;

	 }
	 
;

numbers: NUMBER
        {	
		result[j][$1-1] = 1;
		$$ = j;
		j++;
		
        }       
	|
         numbers ',' NUMBER
        {
		result[$1][$3-1] = 1;
		$$ = $1;    	
 	}
;
expr:
	|
	 expr SET '\n'
	 {
		printf("ANSWER:\n{");
		for(i=0;i<20;i++)
		{
			if(result[$2][i] == 1)
			{
				printf("%d ",i+1);
			}
		}
		printf("}\n");
	 }
        |
	 expr error '\n'
         {
            yyerrok;
 	 }
;       
%%
main()
{
 return(yyparse());
}

yyerror(s)
char *s;
{
  fprintf(stderr, "%s\n",s);
}

yywrap()
{
  return(1);
}
