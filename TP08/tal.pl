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
% ---  phrase simple ---
phrase_simple(Phrase):- 
	gp_nominal(Phrase,Verb),
	gp_verbal(Verb,[]).

phrase_simple(Phrase):- 
	gp_nominal(Phrase,Verb),
	gp_verbal(Verb,GroupPrep),
	gp_prep(GroupPrep,[]).
	

% ---  gp_nominal ---
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

	
% ---  groupe_verbal ---
gp_verbal(Verbe,Suite):-
	verbe(Verbe,Suite).

gp_verbal(Verbe,Suite):-
	verbe(Verbe,GrpNom),
	gp_nominal(GrpNom,Suite).

	
% ---  groupe prepositionnel ---
gp_prep(GroupPrep,Suite):-
	prep(GroupPrep,GroupNom),
	gp_nominal(GroupNom,Suite).

	
% ---  relatif ---
relatif(Pronom,Suite):-
	pronom(Pronom,Verb),
	gp_verbal(Verb,Suite).


% ---  terminaux ---
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
/*
% ---  phrase simple ---
phrase_simple(GrpN,phrase(AGrpN,AVerb)):- 
	gp_nominal(GrpN,Verb,AGrpN),
	gp_verbal(Verb,[],AVerb).
	
phrase_simple(GrpN,phrase(AGrpN,AVerb,AGrP)):- 
	gp_nominal(GrpN,Verb,AGrpN),
	gp_verbal(Verb,GroupPrep,AVerb),
	gp_prep(GroupPrep,[],AGrP).

	
	
% ---  gp_nominal ---
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
	
	
	
% ---  groupe_verbal ---
gp_verbal(Verbe,Suite,gp_verb(AVerbe)):-
	verbe(Verbe,Suite,AVerbe).

gp_verbal(Verbe,Suite,gp_verb(AVerbe,AGrpNom)):-
	verbe(Verbe,GrpNom,AVerbe),
	gp_nominal(GrpNom,Suite,AGrpNom).
	
	
	
	
% ---  groupe prepositionnel ---
gp_prep(GroupPrep,Suite,gp_prep(APrep,AGrpN)):-
	prep(GroupPrep,GroupNom,APrep),
	gp_nominal(GroupNom,Suite,AGrpN).

	
% ---  relatif ---
relatif(Pronom,Suite,relat(APronom,AGpV)):-
	pronom(Pronom,Verb,APronom),
	gp_verbal(Verb,Suite,AGpV).
	
	
% ---  terminaux ---

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
*/
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
/*   
===============================================================================
 Question 2.3 : accord en genre et en nombre
===============================================================================
*/

% ---  phrase simple ---
phrase_simple(GrpN,phrase(AGrpN,AVerb)):- 
	gp_nominal(GrpN,Verb,AGrpN,Genre,Nombre),
	gp_verbal(Verb,[],AVerb,Genre,Nombre).
	

phrase_simple(GrpN,phrase(AGrpN,AVerb,AGrP)):- 
	gp_nominal(GrpN,Verb,AGrpN,Genre,Nombre),
	gp_verbal(Verb,GroupPrep,AVerb,Genre,Nombre),
	gp_prep(GroupPrep,[],AGrP).

	
	
% ---  gp_nominal ---
gp_nominal(Article,Suite,gp_nom(AArticle,ANomCom),Genre,Nombre):-
	article(Article,NomCom,AArticle,Genre,Nombre),
	nom_commun(NomCom,Suite,ANomCom,Genre,Nombre).


gp_nominal(Article,Suite,gp_nom(AArticle,ANomCom,ARelat),Genre,Nombre):-
	article(Article,NomCom,AArticle,Genre,Nombre),
	nom_commun(NomCom,Relat,ANomCom,Genre,Nombre),
	relatif(Relat,Suite,ARelat,Genre,Nombre).

gp_nominal(Article,Suite,gp_nom(AArticle,ANomCom,AAdj),Genre,Nombre):-
	article(Article,NomCom,AArticle,Genre,Nombre),
	nom_commun(NomCom,Adj,ANomCom,Genre,Nombre),
	adj(Adj,Suite,AAdj,Genre,Nombre).

gp_nominal(Article,Suite,gp_nom(AArticle,ANomCom,AAdj,ARelat),Genre,Nombre):-
	article(Article,NomCom,AArticle,Genre,Nombre),
	nom_commun(NomCom,Adj,ANomCom,Genre,Nombre),
	adj(Adj,Relat,AAdj,Genre,Nombre),
	relatif(Relat,Suite,ARelat,Genre,Nombre).

gp_nominal(NomP,Suite,gp_nom(ANomP),Genre,Nombre):-
	nom_propre(NomP,Suite,ANomP,Genre,Nombre).

gp_nominal(NomP,Suite,gp_nom(ANomP,ARelat),Genre,Nombre):-
	nom_propre(NomP,Relat,ANomP,Genre,Nombre),
	relatif(Relat,Suite,ARelat,Genre,Nombre).
	
	
	
% ---  groupe_verbal ---
gp_verbal(Verbe,Suite,gp_verb(AVerbe),Genre,Nombre):-
	verbe(Verbe,Suite,AVerbe,Genre,Nombre).

gp_verbal(Verbe,Suite,gp_verb(AVerbe,AGrpNom),Genre,Nombre):-
	verbe(Verbe,GrpNom,AVerbe,Genre,Nombre),
	gp_nominal(GrpNom,Suite,AGrpNom,_,_).
	

	
% ---  groupe prepositionnel ---
gp_prep(GroupPrep,Suite,gp_prep(APrep,AGrpN)):-
	prep(GroupPrep,GroupNom,APrep,Genre,Nombre),
	gp_nominal(GroupNom,Suite,AGrpN,Genre,Nombre).

	
% ---  relatif ---
relatif(Pronom,Suite,relat(APronom,AGpV),Genre,Nombre):-
	pronom(Pronom,Verb,APronom,Genre,Nombre),
	gp_verbal(Verb,Suite,AGpV,Genre,Nombre).
	

% ---  terminaux ---

article([le|Suite],Suite,art(le),masc,sing).
article([la|Suite],Suite,art(la),fem,sing).
article([les|Suite],Suite,art(les),masc,plur).
article([les|Suite],Suite,art(les),fem,plur).
article([un|Suite],Suite,art(un),masc,sing).
article([une|Suite],Suite,art(une),fem,sing).

nom_commun([chien|Suite],Suite,nom_commun(chien),masc,sing).
nom_commun([enfants|Suite],Suite,nom_commun(enfants),masc,plur).
nom_commun([enfants|Suite],Suite,nom_commun(enfants),fem,plur).
nom_commun([steack|Suite],Suite,nom_commun(steack),masc,sing).
nom_commun([pull|Suite],Suite,nom_commun(pull),masc,sing).
nom_commun([femme|Suite],Suite,nom_commun(femme),fem,sing).
nom_commun([rue|Suite],Suite,nom_commun(rue),fem,sing).

nom_propre([paul|Suite],Suite,nom_propre(paul),masc,sing).

adj([noir|Suite],Suite,adj(noir),masc,sing).

prep([dans|Suite],Suite,prep(dans),masc,sing).
prep([dans|Suite],Suite,prep(dans),masc,plur).
prep([dans|Suite],Suite,prep(dans),fem,sing).
prep([dans|Suite],Suite,prep(dans),fem,plur).

verbe([aboie|Suite],Suite,verbe(aboie),masc,sing).
verbe([mange|Suite],Suite,verbe(mange),masc,sing).
verbe([porte|Suite],Suite,verbe(porte),masc,sing).
verbe([jouent|Suite],Suite,verbe(jouent),masc,plur).
verbe([marche|Suite],Suite,verbe(marche),masc,sing).

verbe([aboie|Suite],Suite,verbe(aboie),fem,sing).
verbe([mange|Suite],Suite,verbe(mange),fem,sing).
verbe([porte|Suite],Suite,verbe(porte),fem,sing).
verbe([jouent|Suite],Suite,verbe(jouent),fem,plur).
verbe([marche|Suite],Suite,verbe(marche),fem,sing).

pronom([qui|Suite],Suite,pronom(qui),masc,sing).
pronom([qui|Suite],Suite,pronom(qui),masc,plur).
pronom([qui|Suite],Suite,pronom(qui),fem,sing).
pronom([qui|Suite],Suite,pronom(qui),fem,plur).

/* 
----------------------------------------------------------------------------------------------------
 [Tests]
?- phrase_simple([le,chien,aboie],Arbre).
Arbre = phrase(gp_nom(art(le),nom_commun(chien)),gp_verb(verbe(aboie))) ? ;
yes

?- phrase_simple([la,chien,aboie],Arbre).
no

?- phrase_simple([le,chien,jouent],Arbre).
no

?- phrase_simple([le,chien,qui,marche,aboie,la,femme,qui,marche,dans,la,rue],Arbre).
Arbre = ...
yes

?- phrase_simple([le,chien,qui,marche,aboie,les,enfants,qui,jouent,dans,la,rue],Arbre).
Arbre = ...
yes

?- phrase_simple([le,chien,qui,marche,mange,les,enfants,qui,jouent,dans,le,pull,noir],Arbre).
Arbre = ...
yes

?- phrase_simple([le,chien,qui,jouent,aboie,les,enfants,qui,jouent,dans,la,rue],Arbre).
no
------------------------------------------------------------------------------------------------------
*/
