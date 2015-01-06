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







% stones([stone(2, 2), stone(4, 6), stone(1, 2), stone(2, 4), stone(6, 2)]).

% stones([stone(2, 2), stone(4, 6), stone(1, 2), stone(2, 4), stone(6, 2), stone(5, 1), stone(5, 5), stone(4, 5), stone(2, 3), stone(3, 6)]).

 stones([stone(6, 6), stone(6, 5), stone(6, 4), stone(6, 3), stone(6, 2), stone(6, 1), stone(6, 0),
         stone(5, 5), stone(5, 4), stone(5, 3), stone(5, 2), stone(5, 1), stone(5, 0),
         stone(4, 4), stone(4, 3), stone(4, 2), stone(4, 1), stone(4, 0),
         stone(3, 3), stone(3, 2), stone(3, 1), stone(3, 0),
         stone(2, 2), stone(2, 1), stone(2, 0),
         stone(1, 1), stone(1, 0),
         stone(0, 0)]).

/*
===============================================================================
 Question 1.2 : dominos(+Stones,+Partial,-Res)
===============================================================================
*/


% --- add_stone_to_chain : ajoute un domino à une chaine
% domino seul
add_stone_to_chain(stone(X,X),[],[chain([X],[X]),chain([X],[double])]).
add_stone_to_chain(stone(X,Y),[],[chain([X],[Y])]).

% domino double correspondant à la tête de L2
add_stone_to_chain(stone(X,X),chain(L1,[X|L2]),[chain(L1,[X,X|L2]),chain([X],[double])]):-
	!.
% domino double correspondant à la tête de L1
add_stone_to_chain(stone(X,X),chain([X|L1],L2),[chain([X,X|L1],[L2]),chain([X],[double])]):-
	!.

% X correspond à la tête de L1
add_stone_to_chain(stone(X,Y),chain([X|L1],L2),[chain([Y,X|L1],L2)]).
add_stone_to_chain(stone(Y,X),chain([X|L1],L2),[chain([Y,X|L1],L2)]).

% X correspond à la tête de L2
add_stone_to_chain(stone(X,Y),chain(L1,[X|L2]),[chain(L1,[Y,X|L2])]).
add_stone_to_chain(stone(Y,X),chain(L1,[X|L2]),[chain(L1,[Y,X|L2])]).


% --- add_stone_to_list_of_chains : ajoute la pierre à l'une des chaine de la liste

add_stone_to_list_of_chains(Stone,[],Res):-
	add_stone_to_chain(Stone,[],Res),
	!.

add_stone_to_list_of_chains(Stone,[Chain|OtherChains],Res):-
	add_stone_to_chain(Stone,Chain,Temp),
	append(Temp,OtherChains,Res),
	!.

add_stone_to_list_of_chains(Stone,[Chain|OtherChains],[Chain|Res]):-
	add_stone_to_list_of_chains(Stone,OtherChains,Res).
		
% --- chains : ajoute toutes les pierres
chains([Stone],ListOfChains,Res):-
	add_stone_to_list_of_chains(Stone,ListOfChains,Res),
	!.

chains([Stone|OtherStones],ListOfChains,Res):-
	add_stone_to_list_of_chains(Stone,ListOfChains,Temp),
	chains(OtherStones,Temp,Res),
	!.

chains([_|OtherStones],ListOfChains,Res):-
	chains(OtherStones,ListOfChains,Res).

% --- domino ---
domino(Res):-
	stones(S),
	chains(S,[],Res).







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
Avec stones([stone(2, 2), stone(4, 6), stone(1, 2), stone(2, 4), stone(6, 2)]).

domino(X).
X = [chain([1, 2], [4, 2]), chain([6, 2], [double]), chain([4], [6])]
Yes


Avec stones([stone(2, 2), stone(4, 6), stone(1, 2), stone(2, 4), stone(6, 2), stone(5, 1), stone(5, 5), stone(4, 5), stone(2, 3), stone(3, 6)]).

domino(X).
X = [chain([4, 5, 5, 1, 2], [[4, 2]]), chain([5], [double]), chain([3, 6, 2], [double]), chain([4], [6]), chain([2], [3])]
Yes

Avec stones([stone(6, 6), stone(6, 5), stone(6, 4), stone(6, 3), stone(6, 2), stone(6, 1), stone(6, 0),
         stone(5, 5), stone(5, 4), stone(5, 3), stone(5, 2), stone(5, 1), stone(5, 0),
         stone(4, 4), stone(4, 3), stone(4, 2), stone(4, 1), stone(4, 0),
         stone(3, 3), stone(3, 2), stone(3, 1), stone(3, 0),
         stone(2, 2), stone(2, 1), stone(2, 0),
         stone(1, 1), stone(1, 0),
         stone(0, 0)]).

X = [chain([4, 5, 5, 1, 2], [[4, 2]]), chain([5], [double]), chain([3, 6, 2], [double]), chain([4], [6]), chain([2], [3])]
Yes



*/
