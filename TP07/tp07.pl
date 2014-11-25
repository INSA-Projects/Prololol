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


% =============================================================================

nbPieces(Composant, Total):-
	composants(Composant, ListeElems),
	nbPieces2(ListeElems, Total).

nbPieces2([], 0):-
	!.
nbPieces2([ComposantTete|Reste], Total):-
	assemblage(_,ComposantTete,Nb),
	not(assemblage(ComposantTete,_, _)),
	nbPieces2(Reste,Accu),
	Total is Accu + Nb.

nbPieces2([ComposantTete|Reste], Total):-
	assemblage(_,ComposantTete,Nb),
	assemblage(ComposantTete,_, Quantite),
	nbPieces2(Reste,Accu),
	Total is Accu + (Nb * Quantite).

% =============================================================================
/*
quantite_piece(Piece, Total):-
	findall(Pi,piece(Pi,Piece,_),ListeDesPi),
	get_quantite(ListeDesPi,Quantite).

get_quantite([Pi|Reste],Quantite):-
	findall(Nb,livraison(_,Pi,Nb),ListNb),
	somme(ListNb,Quantite),
	get_quantite(Reste,Total),
	Total is Quantite+Nb.
	
*/

% chaque pièce i (notée Pi) peut être fournie par différents fournisseurs.
% livraison_total rend donc le couple (Pi,Quantité totale de Pi livrée par l'ensemble des fournisseurs).
% exemple : livraison_total(couple(p1,600)).
livraison_total(couple(Pi,QuantiteTotale)):-
	livraison(_,Pi,_),
	findall(Quantite, livraison(_,Pi,Quantite),ListQuantite),
	somme(ListQuantite, QuantiteTotale).

% rend la liste de tous les couples (Pi,Quantité totale de Pi livrée par l'ensemble des fournisseurs).
% sort(+L,-Ltriee) permet de supprimer les doublons (et aussi de rendre la liste plus jolie).
get_all_couples_of_pi(ListPiTriee):-
	findall(couple(Pi,Qt), livraison_total(couple(Pi,Qt)),RawListPi),
	sort(RawListPi, ListPiTriee).

% différents Pi correspondent à la même pièce (p1 et p8 sont une tôle)
% get_all_pi_for_a_piece rend donc un couple (piece réelle, liste de tous les Pi que peut avoir cette pièce)
% exemple : get_all_pi_for_a_piece(tole,[p1,p8]).
get_all_pi_for_a_piece(Nom, ListOfPi):-
	findall(Pi,piece(Pi,Nom,_),ListOfPi).


% rend la quatité finale de piece pour une pièce Nom
regroup(Nom,QuantiteFinale):-
	get_all_couples_of_pi(ListOfCouples),
	get_all_pi_for_a_piece(Nom,ListOfPi),
	regroup_for_each(ListOfCouples,ListOfPi,QuantiteFinale).

% fonction recursive qui additionne la quantité de pièce de chaque couple si le pi correspond.
% exemple :
% ListOfCouples = [couple(p1, 600), couple(p2, 800), couple(p3, 200),etc.
% ListOfPi = [p1, p8] (pour la piece tole)
% regroup va examiner chaque couple de ListOfCouple et additionner les quantité si le pi correspond à l'un de ceux de ListOfPi.
regroup_for_each(ListOfCouples,ListOfPi,Quantite):-
	% hardcore
	!.



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
nbPieces(voiture, Total).
Total = 36
Yes

nbPieces(moteur, Total).
Total = 20
Yes
===============================================================================

===============================================================================

===============================================================================

===============================================================================
*/

