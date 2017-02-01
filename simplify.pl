%NEGATION FUNCTION
negate([],[]).
negate([A|AX],[AN|R]):-
	AN is -A,
	negate(AX,R).

%ADDITION FUNCTION
sum(A,SA,B,SB,R,SR):-
	append(A,B,C),
	append(SA,SB,SC),
	compress(C,SC,R,SR).

%SUBTRACTON FUNCTION
difference(A,SA,B,SB,R,SR):-
	negate(B,BR),
	sum(A,SA,BR,SB,R,SR).

%MULTIPLICATION FUNCTION
prod_S2(_,[],[]).
prod_S2(X,[H|T],L):-prod_S2(X,T,L1),cat(X,H,W),L = [W|L1].
prod_S([],_,[]).
prod_S([H|T],Y,L):-prod_S2(H,Y,L1),prod_S(T,Y,L2),append(L1,L2,L).
prod_X2(_,[],[]).
prod_X2(X,[H|T],L):-prod_X2(X,T,L1),W is X * H,L = [W|L1].
prod_X([],_,[]).
prod_X([H|T],Y,L):-prod_X2(H,Y,L1),prod_X(T,Y,L2),append(L1,L2,L).
product(A,SA,B,SB,R,SR):-
	prod_X(A,B,X),
	prod_S(SA,SB,SX),
	compress(X,SX,R,SR),!.

%REMOVE ELEMENTS OF FIRST LIST WHICH APPEAR IN SECOND LIST
dividelist([],_,[]).                  
dividelist([X|XS],[X|YS],Z):-
	dividelist(XS,YS,Z),!.
dividelist([X|XS],Y,[X|ZS]):-
	dividelist(XS,Y,ZS).

%REMOVE CHARACTERS OF FIRST ATOM WHICH APPEAR IN SECOND ATOM 
divideatom(X,X,1).
divideatom(AB,A,B):-
	AB \== A,
	atom_codes(AB,ABX),
	atom_codes(A,AX),
	dividelist(ABX,AX,BX),
	atom_codes(B,BX),!.

%DIVIDE ALL ATOMS OF FIRST LIST BY GIVEN ATOM
divideatomlist([],_,[]).
divideatomlist([AB|ABX],A,[B|BX]):-
	divideatom(AB,A,B),
	divideatomlist(ABX,A,BX).

%DIVISION FUCTION 
quotient([0],_,_,_,[],[]).
quotient([],_,_,_,[],[]).
quotient([A|_],S,[B|_],S,[C],[1]):-C is A/B.
quotient(A,SA,[B],[1],R,SA):-
	product(A,SA,[1/B],[1],R,SA),!.
quotient(A,SA,[B],[SB],R,SR):-
	divideatomlist(SA,SB,SR),
	product(A,SA,[1/B],[1],R,SA),!.


%CONCATENATE 2 SORTED ATOMS SUCH THAT CHARACTERS REMAIN SORTED
cat(1,Y,Y).
cat(X,1,X).
cat(X,Y,Z):-
	X \== 1,Y \== 1,
	atom_codes(X,X1),
	atom_codes(Y,Y1),
	merge(X1,Y1,Z1),
	atom_codes(Z,Z1),!.

%SPLIT LIST INTO 2 SUBPARTS
split([],[],[]).
split([H|T],E,[H|O]):-split(T,O,E).

%MERGE 2 SORTED LISTS INTO NEW SORTED LIST
merge([],L,L).
merge(L,[],L):-L\=[].
merge([X|T1],[Y|T2],[X|T]):-
	X@=<Y,
	merge(T1,[Y|T2],T).
merge([X|T1],[Y|T2],[Y|T]):-
	X@>Y,
	merge([X|T1],T2,T).

%MERGE SORT ALGORITHM
merge_sort([],[]).     
merge_sort([X],[X]).   
merge_sort(List,Sorted):-
    List=[_,_|_],split(List,L1,L2),
	merge_sort(L1,Sorted1),merge_sort(L2,Sorted2), 
	merge(Sorted1,Sorted2,Sorted).   

%COMBINE 2 LISTS TOGETHER
zip([],[],[]).	
zip([H1|T1],[H2|T2],[[H1,H2]|T3]):-
	zip(T1,T2,T3).

%ADJACENT LIKE TERMS COMBINED
fuse([],[]).
fuse([A],[A]).
fuse([[S,A],[S,B]|X],Z):-
	C is A+B,
	fuse([[S,C]|X],Z).
fuse([[S1,A],[S2,B]|X],[[S1,A]|Z]):-
	S1 \== S2,
	fuse([[S2,B]|X],Z).

%REMOVE EMPTY TERMS
remove0([],[],[],[]).
remove0([0|A],[_|B],C,D):-
	remove0(A,B,C,D).
remove0([X|A],[Y|B],[X|C],[Y|D]):-
	X \== 0,
	remove0(A,B,C,D).

%ALL LIKE TERMS IN EXPRESSION ARE GROUPED, AND ORDERED 
compress(X,S,XR,SR):-
	remove0(X,S,X1,S1),
	zip(S1,X1,SX1),	
	merge_sort(SX1,SX2),
	fuse(SX2,SXR),
	zip(SR1,XR1,SXR),
	remove0(XR1,SR1,XR,SR).

%EVALUATES THE RPN STACK
evaluate([],[Z|_],[SZ|_],Z,SZ).
evaluate([+|T],[A,B|X],[SA,SB|SX],Z,SZ) :-
	sum(A,SA,B,SB,R,SR),
	evaluate(T,[R|X],[SR|SX],Z,SZ).
evaluate([-|T],[A,B|X],[SA,SB|SX],Z,SZ) :-
	difference(B,SB,A,SA,R,SR),
	evaluate(T,[R|X],[SR|SX],Z,SZ).
evaluate([*|T],[A,B|X],[SA,SB|SX],Z,SZ):-
	product(A,SA,B,SB,R,SR),
	evaluate(T,[R|X],[SR|SX],Z,SZ).
evaluate(['/'|T],[A,B|X],[SA,SB|SX],Z,SZ):-
	quotient(B,SB,A,SA,R,SR),
	evaluate(T,[R|X],[SR|SX],Z,SZ).
evaluate([H|T],X,S,Z,SZ) :-
	H \== +, H \== -, H \== *,
	integer(H) ->	evaluate(T,[[H]|X],[[1]|S],Z,SZ)
				;	evaluate(T,[[1]|X],[[H]|S],Z,SZ).

%CALL THIS FUNCTION WITH <RPN STACK>,<X>,<Y>
%ALL INPUTS ARE ASSUMED TO BE VALID!
simplify(XP,[0],[1]):-
	evaluate(XP,[],[],[],[]),!.
simplify(XP,[0],[1]):-
	evaluate(XP,[],[],[0],[_]),!.
simplify(XP,Z,ZS):-	
	evaluate(XP,[],[],Z,ZS),!.

%COMPARES EXPRESSIONS A, B FOR EQUALTIY
equality(A,B):-
	simplify(A,ZA,SA),
	simplify(B,ZB,SB),
	ZA == ZB,
	SA == SB.
