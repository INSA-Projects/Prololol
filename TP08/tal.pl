/**
TP 8 Traitement Automatique de la Langue (TAL) - Prolog

@author Valentin ESMIEU
@author Florent MALLARD
@version Annee scolaire 2014/2015
*/


/*
===============================================================================
===============================================================================
 Définition des prédicats
===============================================================================

Afin de simplifier la correction, merci de conserver dans votre grammaire
l'ordre ci-dessous
 

phrase_simple ::= gp_nominal gp_verbal
		| gp_nominal gp_verbal gp_nominal
		| gp_nominal gp_verbal gp_prepositionnel

gp_nominal ::=    article nom_commun
		| article nom_commun relatif
		| article nom_commun adjectif	
		| article nom_commun adjectif relatif
		| nom_propre		
		| nom_propre relatif

gp_verbal ::= 	verbe

gp_prepositionnel ::= prep gp_nominal 

relatif ::= 	  pronom gp_verbal
		| pronom gp_verbal gp_nominal
		| pronom gp_verbal gp_prepositionnel



article ::= "le"|"la"|"les"|"un"|"une"
nom_commun ::= "chien"|"enfants"|"steack"|"pull"|"rue"|"femme"
nom_propre ::= "paul"
adjectif ::= "noir"
prep ::= "dans"
verbe ::= "aboie"|"jouent"|"marche"|"mange"|"porte"
pronom ::= "qui"
        


===============================================================================
===============================================================================
 Analyseur en Prolog
===============================================================================
*/

% phrase simple
phrase_simple(Phrase):- 
	gp_nominal(Phrase,Verb),
	gp_verbal(Verb,[]).
/*
phrase_simple(Phrase):- 
	gp_nominal(Phrase,Verb),
	gp_verbal(Verb,GroupNom),
	gp_nominal(GroupNom,[]).
*/	
phrase_simple(Phrase):- 
	gp_nominal(Phrase,Verb),
	gp_verbal(Verb,GroupPrep),
	gp_prep(GroupPrep,[]).
	

% gp_nominal 
gp_nominal(Article,Suite):-
	article(Article,NomCom),
	nom_commun(NomCom,Suite).

gp_nominal(Article,Suite):-
	article(Article,NomCom),
	nom_commun(NomCom,Relat),
	relatif(Relat,Suite).

gp_nominal(Article,Suite):-
	article(Article,NomCom),
	nom_commun(NomCom,Adj),
	adj(Adj,Suite).

gp_nominal(Article,Suite):-
	article(Article,NomCom),
	nom_commun(NomCom,Adj),
	adj(Adj,Relat),
	relatif(Relat,Suite).

gp_nominal(NomP,Suite):-
	nom_propre(NomP,Suite).

gp_nominal(NomP,Suite):-
	nom_propre(NomP,Relat),
	relatif(Relat,Suite).

% groupe_verbal
gp_verbal(Verbe,Suite):-
	verbe(Verbe,Suite).

gp_verbal(Verbe,Suite):-
	verbe(Verbe,GrpNom),
	gp_nominal(GrpNom,Suite).

% groupe prepositionnel
gp_prep(GroupPrep,Suite):-
	prep(GroupPrep,GroupNom),
	gp_nominal(GroupNom,Suite).



% relatif 
relatif(Pronom,Suite):-
	pronom(Pronom,Verb),
	gp_verbal(Verb,Suite).
/*
relatif(Pronom,Suite):-
	pronom(Pronom,Verb),
	gp_verbal(Verb,GrpNom),
	gp_nominal(GrpNom,Suite).

relatif(Pronom,Suite):-
	pronom(Pronom,Verb),
	gp_verbal(Verb,Prep),
	gp_prep(Prep,Suite).	
*/

% terminaux
article([le|Suite],Suite).
article([la|Suite],Suite).
article([les|Suite],Suite).
article([un|Suite],Suite).
article([une|Suite],Suite).

nom_commun([chien|Suite],Suite).
nom_commun([enfants|Suite],Suite).
nom_commun([steack|Suite],Suite).
nom_commun([pull|Suite],Suite).
nom_commun([femme|Suite],Suite).
nom_commun([rue|Suite],Suite).

nom_propre([paul|Suite],Suite).

adj([noir|Suite],Suite).

prep([dans|Suite],Suite).

verbe([aboie|Suite],Suite).
verbe([mange|Suite],Suite).
verbe([porte|Suite],Suite).
verbe([jouent|Suite],Suite).
verbe([marche|Suite],Suite).

pronom([qui|Suite],Suite).


/*
===============================================================================
===============================================================================
 Tests
===============================================================================


Quelques phrases de test à copier coller pour vous faire gagner du temps, mais
n'hésitez pas à en définir d'autres


analyse([le,chien,aboie]).
analyse([les,enfants,jouent]).
analyse([paul,marche,dans,la,rue]).
analyse([la,femme,qui,porte,un,pull,noir,mange,un,steack]).
analyse([les,chien,aboie]).
analyse([la,femme,qui,porte,un,pull,noir,mange,un,chien]).              


phrase_simple([le,chien,aboie,dans,la,rue]).
Yes
 
phrase_simple([le,chien,qui,aboie,mange]).
Yes 

phrase_simple([le,chien,qui,aboie,qui,aboie,mange]).
No

*/



