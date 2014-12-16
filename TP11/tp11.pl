/**
TP 11 Prolog

@author Valentin ESMIEU
@author Florent MALLARD
@version Annee scolaire 2014/2015
*/
/*
===============================================================================
 Question 1.1 : choose(+List,-Elt,-Rest)
===============================================================================
*/

choose(List,E,ListWithoutE):-
	member(E,List),
	subtract(List,[E],ListWithoutE).





	

stones([stone(2, 2), stone(4, 6), stone(1, 2), stone(2, 4), stone(6, 2)]).

% stones([stone(2, 2), stone(4, 6), stone(1, 2), stone(2, 4), stone(6, 2), stone(5, 1), stone(5, 5), stone(4, 5), stone(2, 3), stone(3, 6)]).
% stones([stone(6, 6), stone(6, 5), stone(6, 4), stone(6, 3), stone(6, 2), stone(6, 1), stone(6, 0),
%         stone(5, 5), stone(5, 4), stone(5, 3), stone(5, 2), stone(5, 1), stone(5, 0),
%         stone(4, 4), stone(4, 3), stone(4, 2), stone(4, 1), stone(4, 0),
%         stone(3, 3), stone(3, 2), stone(3, 1), stone(3, 0),
%         stone(2, 2), stone(2, 1), stone(2, 0),
%         stone(1, 1), stone(1, 0),
%         stone(0, 0)]).

/*
===============================================================================
 Question 1.2 : dominos(+Stones,+Partial,-Res)
===============================================================================
*/
chains([],[],[]).
chains([],Partial,Partial).
chains([stone(X,Y)|ResteS],[chains([X|Z]|ResteP)|ResteC],Res):-
    \==(X,Y),
    chains(ResteS,chains([[Y,X|Z]|ResteP]),Res).
chains([stone(X,Y)|ResteS],[chains([Y|Z]|ResteP)|ResteC],Res):-
    \==(X,Y),
    chains(ResteS,chains([[X,Y|Z]|ResteP]),Res).
chains([stone(X,Y)|ResteS],[chains([V|Z]|ResteP)|ResteC],Res):-
    \==(X,Y),
    \==(X,V),
    \==(Y,V),
    chains(ResteS,chains([[Y,X|Z]|ResteP]),Res).





chains_to_list_of_list([], []).
chains_to_list_of_list([chain(L, [double]) | Rest], LL) :-
        length(L, 1),
        chains_to_list_of_list(Rest, LL).
chains_to_list_of_list([chain(L1, L2) | Rest], [Stones | LL]) :-
        (
            length(L1, N), N > 1 
        ; 
            L2 \== [double]
        ),
        reverse(L2, RevL2),
        append(L1, RevL2, L),
        create_stones(L, Stones),
        chains_to_list_of_list(Rest, LL).

create_stones([_], []).
create_stones([A, B | Rest], [stone(A, B) | Stones]) :-
        create_stones([B | Rest], Stones).

print_chains(Chains) :-
        chains_to_list_of_list(Chains, LL),
        (foreach(Chain, LL) do 
            writeln(Chain)).

/* 
----------------------------------------------------------------------------------------------------
 [Tests]

choose([1,2,3],Elt,Rest).
Elt = 1
Rest = [2, 3]
Yes (0.00s cpu, solution 1, maybe more) ? ;
Elt = 2
Rest = [1, 3]
Yes (0.00s cpu, solution 2, maybe more) ? ;
Elt = 3
Rest = [1, 2]

----------------------------------------------------------------------------------------------------


*/
