%{

/***********************************************************************
* Brandon Conn
* CIS-343
* Professor Woodring
* March 2018
*
* Lexer for the zoomjoystrong language which is used to draw
* trivial pictures akin to the likes of MS Paint 
************************************************************************/

#include <stdio.h>
#include "zoomjoystrong.h"

int yylex();
void point(int x, int y);
void circle(int x, int y, int r);
void rectangle(int x, int y, int w, int h);
void line(int x, int y, int u, int v);
void checkValidColor(int r, int g, int b);
int checkValues(int x, int y);
void yyerror(const char* s);
%}

%union {
  int iVal;
  float fVal;
  char* sVal;
}

%start program

%token END
%token END_STATEMENT
%token <sVal> POINT
%token <sVal> LINE
%token <sVal> CIRCLE
%token <sVal> RECTANGLE
%token <sVal> SET_COLOR
%token <iVal> INT
%token <fVal> FLOAT

%%

program: statement_list end_command;

statement_list: statement
	      | statement statement_list
		;

statement: command END_STATEMENT;

command: LINE INT INT INT INT { line($2, $3, $4, $5); }
       | POINT INT INT { point($2, $3); }
       | CIRCLE INT INT INT { circle($2, $3, $4); }
       | RECTANGLE INT INT INT INT { rectangle($2, $3, $4, $5); }
       | SET_COLOR INT INT INT { checkValidColor($2, $3, $4); }
         ;

end_command: END END_STATEMENT;

%%

/***************************************************************************
* Main function to run the program
* @param argc Argument counte
* @param argv Argument vector
***************************************************************************/
int main(int argc, char** argv){

    setup();
    yyparse();
    finish();
    return 0; 
}

/***************************************************************************
* Draws a line 
* @param x The beginning X coordinate
* @param y The beginning Y coordinate
* @param u The ending X coordinate
* @param v The ending Y coordinate
***************************************************************************/
void line(int x, int y, int u, int v) {

    if(checkValues(x, y) == 1) {
        line(x, y, u, v);
    }
}

/***************************************************************************
* Draws a point but with validation
* @param x The X coordinate
* @param y The Y coordinate
***************************************************************************/
void point(int x, int y) {

    if(checkValues(x, y) == 1) {
	point(x, y);
    }
}

/***************************************************************************
* Draws a circle with validation
* @param x The X coordinate of the circle
* @param y The Y coordinate of the circle
* @param r The radius of the circle
***************************************************************************/
void circle(int x, int y, int r) {

    if(checkValues(x, y) == 1) {
	circle(x, y, r);
    }
}

/***************************************************************************
* Draws a rectangle 
* Uses checkValues() to ensure coordinates are in bounds
* @param x The X coordinate
* @param y The Y coordinate 
* @param w The width of the rectangle
* @param h The height of the rectangle
***************************************************************************/
void rectangle(int x, int y, int w, int h) {

    if(checkValues(x, y) == 1) {
	rectangle(x, y, w, h);
    }
}

/***************************************************************************
* Checks if the values are valid RGB values between 0 and 255
* Sets the color if they are valid
* Prints an error message if they are invalid (i.e. out of range)
* @param r Red intensity
* @param g Green intensity
* @param b Blue intensity
***************************************************************************/
void checkValidColor(int r, int g, int b) {

    if((r >= 0 && r <= 255) && (g >= 0 && g <= 255) && (b >= 0 && b <= 255)) {
        set_color(r, g, b);
    } else {
        fprintf(stderr, "*****You have input an invalid color*****\n");
    }
}

/***************************************************************************
* Checks for valid coordinates within the width and height of the screen
* @param x The X coordinate to check
* @param y The Y coordinate to check
* @return 1 if valid, 0 if invalid
***************************************************************************/
int checkValues(int x, int y) {

    if(x < 0 || x > WIDTH || y < 0 || y > HEIGHT) {
	fprintf(stderr, "*****You have input coordinates that are out of bounds*****\n");
        return 0;
    } else {
	return 1;
    }
}

int yywrap() {

	return 1;
}

void yyerror(const char* s) {

    fprintf(stderr, "%s\n", s);
}

