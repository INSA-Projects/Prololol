/*        
TP 8 Traitement Automatique de la Langue (TAL) - Prolog

@author Valentin ESMIEU
@author Florent MALLARD
@version Annee scolaire 2014-2015
*/
/*
===============================================================================
 Question 1.1 : définition de la grammaire
===============================================================================
*/
/*
phrase_simple ::= gp_nominal gp_verbal
		| gp_nominal gp_verbal gp_prepositionnel

gp_nominal ::=    article nom_commun
		| article nom_commun relatif
		| article nom_commun adjectif	
		| article nom_commun adjectif relatif
		| nom_propre		
		| nom_propre relatif

gp_verbal ::= 	verbe
		| verbe gp_nominal

gp_prepositionnel ::= prep gp_nominal 

relatif ::= 	  pronom gp_verbal
		| pronom gp_verbal 

article ::= "le"|"la"|"les"|"un"|"une"
nom_commun ::= "chien"|"enfants"|"steack"|"pull"|"rue"|"femme"
nom_propre ::= "paul"
adjectif ::= "noir"
prep ::= "dans"
verbe ::= "aboie"|"jouent"|"marche"|"mange"|"porte"
pronom ::= "qui"
*/
/*
===============================================================================
 Question 2.1 : analyseur en Prolog
===============================================================================
*/
/*
% phrase simple
phrase_simple(Phrase):- 
	gp_nominal(Phrase,Verb),
	gp_verbal(Verb,[]).

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
*/
/* 
----------------------------------------------------------------------------------------------------
 [Tests]
 
?- phrase_simple([le,chien,aboie,dans,la,rue]).
Yes
 
?- phrase_simple([le,chien,qui,aboie,mange]).
Yes 

?- phrase_simple([le,chien,qui,aboie,qui,aboie,mange]).
No

?- phrase_simple(X).
X = [le,chien,aboie]
X = [le,chien,aboie,les,enfants] 
X = [le,chien,aboie,le,chien,qui,aboie,le,chien,qui,aboie,le,chien,qui,aboie,le,chien,qui,aboie,le,chien]
etc.
------------------------------------------------------------------------------------------------------
*/
/*   
===============================================================================
 Question 2.2 : arbre syntaxique
===============================================================================
*/
% phrase simple
phrase_simple(GrpN,phrase(AGrpN,AVerb)):- 
	gp_nominal(GrpN,Verb,AGrpN),
	gp_verbal(Verb,[],AVerb).
	
phrase_simple(GrpN,phrase(AGrpN,AVerb,AGrP)):- 
	gp_nominal(GrpN,Verb,AGrpN),
	gp_verbal(Verb,GroupPrep,AVerb),
	gp_prep(GroupPrep,[],AGrP).

	
	
% gp_nominal 
gp_nominal(Article,Suite,gp_nom(AArticle,ANomCom)):-
	article(Article,NomCom,AArticle),
	nom_commun(NomCom,Suite,ANomCom).

gp_nominal(Article,Suite,gp_nom(AArticle,ANomCom,ARelat)):-
	article(Article,NomCom,AArticle),
	nom_commun(NomCom,Relat,ANomCom),
	relatif(Relat,Suite,ARelat).

gp_nominal(Article,Suite,gp_nom(AArticle,ANomCom,AAdj)):-
	article(Article,NomCom,AArticle),
	nom_commun(NomCom,Adj,ANomCom),
	adj(Adj,Suite,AAdj).

gp_nominal(Article,Suite,gp_nom(AArticle,ANomCom,AAdj,ARelat)):-
	article(Article,NomCom,AArticle),
	nom_commun(NomCom,Adj,ANomCom),
	adj(Adj,Relat,AAdj),
	relatif(Relat,Suite,ARelat).

gp_nominal(NomP,Suite,gp_nom(ANomP)):-
	nom_propre(NomP,Suite,ANomP).

gp_nominal(NomP,Suite,gp_nom(ANomP,ARelat)):-
	nom_propre(NomP,Relat,ANomP),
	relatif(Relat,Suite,ARelat).
	
	
	
% groupe_verbal
gp_verbal(Verbe,Suite,gp_verb(AVerbe)):-
	verbe(Verbe,Suite,AVerbe).

gp_verbal(Verbe,Suite,gp_verb(AVerbe,AGrpNom)):-
	verbe(Verbe,GrpNom,AVerbe),
	gp_nominal(GrpNom,Suite,AGrpNom).
	
	
	
	
% groupe prepositionnel
gp_prep(GroupPrep,Suite,gp_prep(APrep,AGrpN)):-
	prep(GroupPrep,GroupNom,APrep),
	gp_nominal(GroupNom,Suite,AGrpN).

	
% relatif 
relatif(Pronom,Suite,relat(APronom,AGpV)):-
	pronom(Pronom,Verb,APronom),
	gp_verbal(Verb,Suite,AGpV).
	
	
% terminaux

article([le|Suite],Suite,art(le)).
article([la|Suite],Suite,art(la)).
article([les|Suite],Suite,art(les)).
article([un|Suite],Suite,art(un)).
article([une|Suite],Suite,art(une)).

nom_commun([chien|Suite],Suite,nom_commun(chien)).
nom_commun([enfants|Suite],Suite,nom_commun(enfants)).
nom_commun([steack|Suite],Suite,nom_commun(steack)).
nom_commun([pull|Suite],Suite,nom_commun(pull)).
nom_commun([femme|Suite],Suite,nom_commun(femme)).
nom_commun([rue|Suite],Suite,nom_commun(rue)).

nom_propre([paul|Suite],Suite,nom_propre(paul)).

adj([noir|Suite],Suite,adj(noir)).

prep([dans|Suite],Suite,prep(dans)).

verbe([aboie|Suite],Suite,verbe(aboie)).
verbe([mange|Suite],Suite,verbe(mange)).
verbe([porte|Suite],Suite,verbe(porte)).
verbe([jouent|Suite],Suite,verbe(jouent)).
verbe([marche|Suite],Suite,verbe(marche)).

pronom([qui|Suite],Suite,pronom(qui)).


/* 
----------------------------------------------------------------------------------------------------
 [Tests]
 ?- phrase_simple([le,chien,qui,aboie,mange,les,enfants,dans,la,rue],Arbre).

Arbre = phrase(
				gp_nom(
					art(le),
					nom_commun(chien),
					relat(
						pronom(qui),
						gp_verb(
							verbe(aboie)))),
				gp_verb(
					verbe(mange),
					gp_nom(
						art(les),
						nom_commun(enfants))),
				gp_prep(
					prep(dans),
					gp_nom(
						art(la),
						nom_commun(rue)))) 
------------------------------------------------------------------------------------------------------
*/
