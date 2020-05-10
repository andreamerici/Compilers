%{

        /* From M. Tim Jones, GNU/Linux Application Programming, CHARLES RIVER MEDIA, INC.
	   adapted to the LFC course by M. Leoncini. */

#include <stdio.h>
#include <string.h>

char address[10][80];
int  addrCount = 0;

%}

%token ALLOW OPEN_BRACE CLOSE_BRACE DISALLOW ATSYM PERIODSYM USRDOM

%%

configs: 
	| configs config
	;

config:
	allowed 
	|
	disallowed 
	;

allowed: ALLOW OPEN_BRACE targets CLOSE_BRACE
	{
		int i;
		printf("Allow these addresses:\n");
		for (i = 0 ; i < addrCount ; i++) {
			printf( "\t%s\n", address[i] );
		}
		addrCount = 0;
	}
	;

disallowed: DISALLOW OPEN_BRACE targets CLOSE_BRACE
	{	
		int i;
		printf("Deny these addresses:\n");
		for (i = 0 ; i < addrCount ; i++) {
			printf( "\t%s\n", address[i] );
		}
		addrCount = 0;
	}
	;

targets: 
	|
	targets email_address
	;

email_address:
	USRDOM ATSYM USRDOM
	{
		if (addrCount < 10) {
		  sprintf(address[addrCount++], "%s@%s", $1, $3);
		}
	}
	;

%%

void yyerror( const char *str )
{
	fprintf( stderr, "error: %s\n", str );
}

int main()
{
	FILE *infp;
	infp = fopen("config.file", "r");
	yyrestart( infp );
	yyparse();
	fclose( infp );
	return 0;
}
