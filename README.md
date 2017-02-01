# Prolog
Team Members:
ANMOL SINGHAL - 2015A7PS069P
AADI JAIN - 2015A7PS104P


Q1: Simplifying algebraic multi-variable expression.

File "q1.pl" contains the prolog implementation for simplifying the required expression.
Code is capable of adding, subtracting, multiplying, and dividing multi-variable expression by implementing the laws of commutativity, associativity, and distribution.

Input Format:
predicate simplify(S,X,Y) evaluates to true if expression S, simplifies to X,Y. 
-S refers to the expression in RPN/PostFix format
-Y is a list of the variables which appear in the simplified expression
-X is a list of coefficients corresponding to the variables in y

-predicate equality(XP1,XP2) evaluates to true if XP1 can be simpified to XP2.
-XP1, XP2 are expressed in PRN/PostFix form.

Sample Input:

NOTE: The prolog code does not have error correction and assumes all inputs are valid.   

1+2(x+y)	-> [1,2,x,y,+,*,+][RPN FORM] 
1+2x+2y		-> [1,2,2][COEFFICIENTS], [1,x,y][VARIABLES]

(1+x)+((2+y)-(x-z))	-> [1,x,+,2,y,+,x,z,-,-,+][RPN FORM] 
3+y+z            	-> [3,1,1][COEFFICIENTS],[1,y,z][VARIABLES]

1+2+z+y	-> [1,2,+,z,+,y,+][RPN FORM]
3+y+z   -> [3,1,1][COEFFICIENTS],[1,y,z][VARIABLES]

equality([1,2,x,y,+,*,+],[1,x,+,2,y,+,x,z,-,-,+]).
false.
equality([1,2,x,y,+,*,+],[1,2,+,z,+,y,+]).
false.
equality([1,2,+,z,+,y,+],[1,x,+,2,y,+,x,z,-,-,+]).
true.


5(1+2x)(1-3y)	-> [5,1,2,x,*,+,1,3,y,*,-,*,*][RPN FORM]
5-10x-30xy-15y	-> [5,10,-30,-15][COEFFICIENTS], [1,x,xy,y][VARIABLES]
simplify([5,1,2,x,*,+,1,3,y,*,-,*,*],A,B).
A = [5, 10, -30, -15],
B = [1, x, xy, y].

(xx+2xy+xxy)/(2x)	-> [x,x,*,2,x,y,*,*,x,x,y,*,*,+,+,2,x,*,/][RPN FORM] 
0.5x+0.5xy+y 	-> [0.5,0.5,1.0][COEFFICIENTS],[x,xy,y][VARIABLES]
simplify([x,x,*,2,x,y,*,*,x,x,y,*,*,+,+,2,x,*,/],A,B).
A = [0.5, 0.5, 1.0],
B = [x, xy, y].

x/2 + x/3	-> [x,2,/,x,3,/,+][RPN FORM]
5x/6		-> [0.83333333333333][COEFFICIENTS],[x][VARIABLES]
simplify([x,2,/,x,3,/,+],A,B).
A = [0.8333333333333333],
B = [x].
