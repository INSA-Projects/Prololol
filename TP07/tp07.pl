/**
TP 7 Base de Données Déductives (BDD) - Prolog

@author Valentin ESMIEU
@author Florent MALLARD
@version Annee scolaire 2014/2015
*/

% ===============================================================================
% ===============================================================================
% Définition des prédicats
% ===============================================================================


% ============================================================================= 
% SECTION 1 : Base de données
% ============================================================================= 

assemblage(voiture, porte, 4).
assemblage(voiture, roue, 4).
assemblage(voiture, moteur, 1).
assemblage(roue, jante, 1).
assemblage(porte, tole, 1).
assemblage(porte, vitre, 1).
assemblage(roue, pneu, 1).
assemblage(moteur, piston, 4).
assemblage(moteur, soupape, 16).

           
piece(p1, tole, lyon).
piece(p2, jante, lyon).
piece(p3, jante, marseille).
piece(p4, pneu, clermontFerrand).
piece(p5, piston, toulouse).
piece(p6, soupape, lille).
piece(p7, vitre, nancy).
piece(p8, tole, marseille).
piece(p9, vitre, marseille).

                  
demandeFournisseur(dupont, lyon).
demandeFournisseur(michel, clermontFerrand).
demandeFournisseur(durand, lille).
demandeFournisseur(dupond, lille).
demandeFournisseur(martin, rennes).
demandeFournisseur(smith, paris).
demandeFournisseur(brown, marseille).
          
          
fournisseurReference(f1, dupont, lyon).
fournisseurReference(f2, durand, lille).
fournisseurReference(f3, martin, rennes).
fournisseurReference(f4, michel, clermontFerrand).
fournisseurReference(f5, smith, paris).
fournisseurReference(f6, brown, marseille).

                  
livraison(f1, p1, 300).
livraison(f2, p2, 200).
livraison(f3, p3, 200).
livraison(f4, p4, 400).
livraison(f6, p5, 500).
livraison(f6, p6, 1000).
livraison(f6, p7, 300).
livraison(f1, p2, 300).
livraison(f4, p2, 300).
livraison(f4, p1, 300).


% ============================================================================= 
% SECTION 2 : Opération relationnelles
% ============================================================================= 
union_fournisseur(fournisseur(Nom,Ville)):-
	demandeFournisseur(Nom,Ville).
union_fournisseur(fournisseur(Nom,Ville)):-
	not(demandeFournisseur(Nom,Ville)),
	fournisseurReference(_,Nom,Ville).

% ============================================================================= 
intersection_fournisseur(fournisseur(Nom,Ville)):-
	demandeFournisseur(Nom,Ville),
	fournisseurReference(_,Nom,Ville).

% ============================================================================= 
difference_fournisseur(fournisseur(Nom,Ville)):-
	demandeFournisseur(Nom,Ville),
	not(fournisseurReference(_,Nom,Ville)).

% ============================================================================= 
produit_cartesien(table(NumF1,Nom,Ville,NumF2,NumPiece,Quantite)):-
	fournisseurReference(NumF1,Nom,Ville),
	livraison(NumF2,NumPiece,Quantite).
	
% ============================================================================= 
jointure(table(NumF,Nom,Ville,NumPiece,Quantite)):-
	fournisseurReference(NumF,Nom,Ville),
	livraison(NumF,NumPiece,Quantite).

jointureSup350(table(NumF,Nom,Ville,NumPiece,Quantite)):-
	fournisseurReference(NumF,Nom,Ville),
	livraison(NumF,NumPiece,Quantite),
	Quantite > 350.

% ============================================================================= 
division(Nom):-
	piece(NumPiece,_,lyon),
	livraison(NumFournisseur,NumPiece,_),
	fournisseurReference(NumFournisseur,Nom,_).
	
% =============================================================================
total_piece(NumFourn, Total):-
	fournisseurReference(NumFourn,_,_),
	findall(Quantite, livraison(NumFourn, _ , Quantite), Liste),
	somme(Liste, Total).

somme([], 0).
somme([X|R],Total):-
	somme(R,Total2),
	Total is X + Total2.

% ============================================================================= 
% SECTION 3 : Au delà de l’algèbre relationnelle
% ============================================================================= 

composants(Composant, ListeRes):-
	findall(Piece, assemblage(Composant, Piece, _ ),ListeComposants),
	composants2(ListeComposants, ListeTemp),
	append(ListeComposants,ListeTemp,ListeRes).


composants2([],[]).
composants2([Composant|Reste],ListeTemp):-
	findall(Elem,assemblage(Composant, Elem, _),ListeTemp1),
	composants2(Reste, ListeTemp2),
	append(ListeTemp1,ListeTemp2, ListeTemp).



/*
===============================================================================
 Tests
===============================================================================
?- piece(_,X,lyon).
X = tole
X = jante

===============================================================================
?- piece(_,X,Y).
X = tole
Y = lyon

X = jante
Y = lyon

X = jante
Y = marseille

X = pneu
Y = clermontFerrand

X = piston
Y = toulouse

X = soupape
Y = lille
...

===============================================================================
?- union_fournisseur(Y).

Y = fournisseur(dupont, lyon)
Y = fournisseur(michel, clermontFerrand)
Y = fournisseur(durand, lille)
Y = fournisseur(dupond, lille)
Y = fournisseur(martin, rennes)
Y = fournisseur(smith, paris)
Y = fournisseur(brown, marseille)

===============================================================================
?- intersection_fournisseur(Y).

Y = fournisseur(dupont, lyon)
Y = fournisseur(michel, clermontFerrand)
Y = fournisseur(durand, lille)
Y = fournisseur(martin, rennes)
Y = fournisseur(smith, paris)
Y = fournisseur(brown, marseille)

===============================================================================
?- difference_fournisseur(Y).
Y = fournisseur(dupond, lille)

===============================================================================
?- produit_cartesien(Y).
Y = table(f1, dupont, lyon, f1, p1, 300)
Y = table(f1, dupont, lyon, f2, p2, 200)
Y = table(f1, dupont, lyon, f3, p3, 200)
Y = table(f1, dupont, lyon, f4, p4, 400)
Y = table(f1, dupont, lyon, f6, p5, 500)
...

===============================================================================
?- jointure(Y).
Y = table(f1, dupont, lyon, p1, 300)
Y = table(f1, dupont, lyon, p2, 300)
Y = table(f2, durand, lille, p2, 200)
Y = table(f3, martin, rennes, p3, 200)
...

?- jointureSup350(Y).
Y = table(f4, michel, clermontFerrand, p4, 400)
Y = table(f6, brown, marseille, p5, 500)
Y = table(f6, brown, marseille, p6, 1000)

===============================================================================
division(X).
X = dupont
X = michel
X = durand

===============================================================================
?- total_piece(NumFourn,Total).
NumFourn = f1
Total = 600

NumFourn = f2
Total = 200

NumFourn = f3
Total = 200

===============================================================================
?- composants(voiture, Liste).
Liste = [porte,roue,moteur,tole,vitre,jante,pneu,piston,soupape]
Yes
===============================================================================

===============================================================================

===============================================================================

===============================================================================

===============================================================================
*/

