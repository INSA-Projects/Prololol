/**
TP4 arbres binaires

@author Valentin ESMIEU
@author Florent MALLARD
@version Annee scolaire 2014-2015
*/


% ============================================================================= 
%	arbre_binaire(+B)
% =============================================================================

arbre_binaire(vide).
arbre_binaire(arb_bin(R,vide,vide)):-
	integer(R).
arbre_binaire(arb_bin(R,G,D)):- 
	integer(R),
	arbre_binaire(G),
	arbre_binaire(D).

% ============================================================================= 
%	dans_arbre_binaire(+E,+B)
% =============================================================================

dans_arbre_binaire(E,arb_bin(E,G,D)).

dans_arbre_binaire(E,arb_bin(R,G,D)):- 
	dans_arbre_binaire(E,G).
dans_arbre_binaire(E,arb_bin(R,G,D)):-
	dans_arbre_binaire(E,D).



% ============================================================================= 
%	sous_arbre_binaire(+S,+B)
% =============================================================================
sous_arbre_binaire(S,S).
sous_arbre_binaire(S,arb_bin(R,S,D)).
sous_arbre_binaire(S,arb_bin(R,G,S)).
sous_arbre_binaire(S,arb_bin(R,G,D)):-
	sous_arbre_binaire(S,G).
sous_arbre_binaire(S,arb_bin(R,G,D)):-
	sous_arbre_binaire(S,D).


% ============================================================================= 
%	remplacer(+SA1,+SA2, +B, -B1)
% =============================================================================

remplacer(SA1,SA2,SA1,SA2).
remplacer(SA1,SA2,arb_bin(R,SA1,D),arb_bin(R,SA2,D)).
remplacer(SA1,SA2,arb_bin(R,G,SA1),arb_bin(R,G,SA2)).
remplacer(SA1,SA2,arb_bin(R,G,D),B1):-
	remplacer(SA1,SA2,G,B1),
	remplacer(SA1,SA2,D,B1).

% ============================================================================= 
%	isomorphe(+B1,+B2)
% =============================================================================

isomorphe(vide,vide).
isomorphe(arb_bin(R,vide,vide),arb_bin(R,vide,vide)).
isomorphe(arb_bin(R,G,D),arb_bin(R,D,G)).
isomorphe(arb_bin(R,G1,D1),arb_bin(R,G2,D2)):-
	isomorphe(G1,G2),
	isomorphe(D1,D2).
isomorphe(arb_bin(R,G1,D1),arb_bin(R,G2,D2)):-
	isomorphe(G1,D2),
	isomorphe(D1,G2).
	
% ============================================================================= 
%	infixe(+B,-L)
% =============================================================================

% concat(+L1,+L2,-LR)
% construit LR, concaténation de L1 et L2
concat([],L,L).
concat([E|R],L,[E|T]) :-
	concat(R,L,T).

% infixe
infixe(vide,[]).
infixe(arb_bin(R,vide,vide),[R]).
infixe(arb_bin(R,G,D),L) :-
	infixe(G,LG),
	infixe(D,LD),
	concat(LG,[R|LD],L).

	
% ============================================================================= 
%	insertion_arbre_ordonne(+X,B1,B2)
% le parcours d'un arbre ordonné rend une liste d'entiers croissants
% =============================================================================

insertion_arbre_ordonne(X,vide,arb_bin(X,vide,vide)) :-
insertion_arbre_ordonne(X,arb_bin(R,G,D),arb_bin(R,Gres,D) :-
	X<R,(
	!,
	insertion_arbre_oronne(X,G,Gres).
	
insertion_arbre_ordonne(X,abr_bin(R,G,D),Ares) :-
	insertion_arbre_ordonne(X,G,Ares).
	
	



% =============================================================================
/* arbres de test */

grozarbre(arb_bin(1, arb_bin(2, arb_bin(6, vide, vide), vide), arb_bin(3, arb_bin(4, vide, vide), arb_bin(5, vide, vide)))).

petinarbre(arb_bin(3, arb_bin(4, vide, vide), arb_bin(5, vide, vide))).

tisomorphe(arb_bin(3, arb_bin(4, vide, vide), arb_bin(5, vide, vide))).
grozomorphe(arb_bin(3, arb_bin(5, vide, vide), arb_bin(4, vide, vide))).
nomorphe(arb_bin(3, arb_bin(5,vide,vide), vide)).

/* TESTS 

arbre_binaire(arb_bin(1,arb_bin(5,vide,vide),vide)).
Yes
arbre_binaire(arb_bin(1.2,vide,vide)).
No
arbre_binaire(arb_bin(1,vide,vide)).
Yes

-------

dans_arbre_binaire(8,arb_bin(1,arb_bin(5,vide,vide),vide)).
No
dans_arbre_binaire(5,arb_bin(1,arb_bin(5,vide,vide),vide)).
Yes

-------

grozarbre(A),petinarbre(B),sous_arbre_binaire(B,A).

A = arb_bin(1, arb_bin(2, arb_bin(6, vide, vide), vide), arb_bin(3, arb_bin(4, vide, vide), arb_bin(5, vide, vide)))
B = arb_bin(3, arb_bin(4, vide, vide), arb_bin(5, vide, vide))
Yes

grozarbre(A),petinarbre(B),sous_arbre_binaire(A,B).
No

-------

grozarbre(A),petinarbre(B),remplacer(B,vide,A,Resul).

A = arb_bin(1, arb_bin(2, arb_bin(6, vide, vide), vide), arb_bin(3, arb_bin(4, vide, vide), arb_bin(5, vide, vide)))
B = arb_bin(3, arb_bin(4, vide, vide), arb_bin(5, vide, vide))
Resul = arb_bin(1, arb_bin(2, arb_bin(6, vide, vide), vide), vide)
Yes

----------

tisomorphe(A),grozomorphe(B),isomorphe(A,B).

A = arb_bin(3, arb_bin(4, vide, vide), arb_bin(5, vide, vide))
B = arb_bin(3, arb_bin(5, vide, vide), arb_bin(4, vide, vide))
Yes

nomorphe(A),grozomorphe(B),isomorphe(A,B).
No

-----------

?- grozarbre(A), infixe(A,L).

A = arb_bin(1,arb_bin(2,arb_bin(6,vide,vide),vide),arb_bin(3,arb_bin(4,vide,vide),arb_bin(5,vide,vide)))
L = [6,2,1,4,3,5] ? 
yes

?- petinarbre(A), infixe(A,L).

A = arb_bin(3,arb_bin(4,vide,vide),arb_bin(5,vide,vide))
L = [4,3,5] ? 
yes

------------

------------


*/




/*
arb_bin(1, arb_bin(2, arb_bin(6, vide, vide), vide), arb_bin(3, arb_bin(4, vide, vide), arb_bin(5, vide, vide)))

arb_bin(3, arb_bin(4, vide, vide), arb_bin(5, vide, vide))

arb_bin(3, arb_bin(4, vide, vide), arb_bin(5, arb_bin(6, vide, vide), arb_bin(7, vide, vide)))

arb_bin(3, arb_bin(5, arb_bin(6, vide, vide), arb_bin(7, vide, vide)), arb_bin(4, vide, vide))

arb_bin(3, arb_bin(6, vide, vide), arb_bin(5, arb_bin(4, vide, vide), arb_bin(7, vide, vide)))

arb_bin(8, arb_bin(4, arb_bin(2, vide, vide), arb_bin(6, vide, vide)), arb_bin(12, arb_bin(10, vide, vide), vide))

arb_bin(8, arb_bin(4, arb_bin(2, _, _), arb_bin(6, _, _)), arb_bin(12, arb_bin(10, _, _), _))

arb_bin(6,arb_bin(2,arb_bin(1,vide,vide),arb_bin(4,vide,vide)),arb_bin(8,vide,arb_bin(10,vide,vide)))

arb_bin(8,arb_bin(2,arb_bin(1,vide,vide),arb_bin(4,vide,vide)),arb_bin(6,vide,arb_bin(10,vide,vide)))

arb_bin(6,arb_bin(2,arb_bin(1,vide,vide),arb_bin(4,vide,vide)),arb_bin(8,arb_bin(2,arb_bin(1,vide,vide),arb_bin(4,vide,vide)),arb_bin(10,vide,vide)))

*/
