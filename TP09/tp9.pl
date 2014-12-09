/**
TP 9 Prolog

@author Valentin ESMIEU
@author Florent MALLARD
@version Annee scolaire 2014/2015
*/
/*
===============================================================================
 Question 1.1 : combiner(+Copains,-Binomes)
===============================================================================
*/

combiner([],[]).
combiner([Tete|Reste],Binomes):-
	combiner2(Tete,Reste,BinomesTete),
	combiner(Reste,BinomesReste),
	append(BinomesTete,BinomesReste,Binomes).

combiner2(_,[],[]).
combiner2(Copain,[Tete|Reste],Binomes):-
	combiner2(Copain,Reste,AutresBinomes),
	append([(Copain,Tete)],AutresBinomes,Binomes).



/*
===============================================================================
 Question 1.2 : extraire(+AllPossibleBinomes,+NbBinomes,-Tp,-RemainingBinomes)
===============================================================================
*/

extraire2(Binomes,0,[],Binomes,_).

extraire2([(A,B)|Rest],NbBinomes,[(A,B)|Tp],Remaining,BinDejaFait):-
	\==(NbBinomes,0),
	not(member(A,BinDejaFait)),
	not(member(B,BinDejaFait)),
	NbBinomes2 is NbBinomes - 1,
	extraire2(Rest,NbBinomes2,Tp,Remaining,[A,B|BinDejaFait]).

extraire2([(A,B)|Rest],NbBinomes,Tp,[A,B|Remaining],BinDejaFait):-
	\==(NbBinomes,0),
	extraire2(Rest,NbBinomes,Tp,Remaining,BinDejaFait).


extraire(Binomes,NbBinomes,Tp,Remaining):-
	extraire2(Binomes,NbBinomes,Tp,Remaining,[]).


/*
===============================================================================
 Question 1.3 : lesTps(+Copains,-Tps)
===============================================================================
*/
nombre_binome([],0).
nombre_binome([_,_|Rest],Res) :-
	nombre_binome(Rest,Res2),
	Res is Res2+1.

lesTps([],[]).

lesTps(Copains, Tps):-
	combiner(Copains,Binomes),
	nombre_binome(Copains,L),
	Nb is L//2,
	extraireAll(Binomes, Nb, Tps).

extraireAll([],_,[]).
extraireAll(Binomes, Nb,[Tp|Tps]):-
	extraire(Binomes, Nb, Tp, R),
	extraireAll(R, Nb, Tps).

/* 
----------------------------------------------------------------------------------------------------
 [Tests]


----------------------------------------------------------------------------------------------------


combiner([pluto,riri,fifi,loulou],Binomes).
Binomes = [(pluto, riri), (pluto, fifi), (pluto, loulou), (riri, fifi), (riri, loulou), (fifi, loulou)]
Yes

---------------------------------------------------------------------------------------------------

combiner([pluto,riri,fifi,loulou],Binomes), extraire(Binomes,2,Tp,Remaining).

Binomes = [(pluto, riri), (pluto, fifi), (pluto, loulou), (riri, fifi), (riri, loulou), (fifi, loulou)]
Tp = [(pluto, riri), (fifi, loulou)]
Remaining = [pluto, fifi, pluto, loulou, riri, fifi, riri, loulou]
Yes (0.00s cpu, solution 1, maybe more) ? ;

Binomes = [(pluto, riri), (pluto, fifi), (pluto, loulou), (riri, fifi), (riri, loulou), (fifi, loulou)]
Tp = [(pluto, fifi), (riri, loulou)]
Remaining = [pluto, riri, pluto, loulou, riri, fifi, (fifi, loulou)]
Yes (0.00s cpu, solution 2, maybe more) ? ;

Binomes = [(pluto, riri), (pluto, fifi), (pluto, loulou), (riri, fifi), (riri, loulou), (fifi, loulou)]
Tp = [(pluto, loulou), (riri, fifi)]
Remaining = [pluto, riri, pluto, fifi, (riri, loulou), (fifi, loulou)]
Yes

---------------------------------------------------------------------------------------------------

lesTps([pluto,riri,fifi,loulou],Tps).
Tps = [[(pluto, riri)], [(pluto, fifi)], [(pluto, loulou)], [(riri, fifi)], [(riri, loulou)], [(fifi, loulou)]]
Yes

*/
