/**
TP 10 Prolog

@author Valentin ESMIEU
@author Florent MALLARD
@version Annee scolaire 2014/2015
*/
/*
===============================================================================
 Question 1.1 : make_all_pairs(+ListPeople,-ListLikes)
===============================================================================
*/
make_all_pairs([],[]).
make_all_pairs([Someone|Others],ListLikes):-
	make_all_pairs_for_someone(Someone,Others,[],ListTemp),
	make_all_pairs(Others,ListTemp2),
	append(ListTemp,ListTemp2,ListLikes).


make_all_pairs_for_someone(Someone,[],ListLikes,Res):-
	append([likes(Someone,Someone)],ListLikes,Res).	
make_all_pairs_for_someone(Someone,[Somebody|Others],ListLikes,Res):-
	%\==(Somebody,Someone),
	make_all_pairs_for_someone(Someone,Others,[likes(Somebody,Someone),likes(Someone,Somebody)|ListLikes],Res).

/*
===============================================================================
 Question 1.2 : sub_list(+ListPeople,-SubList)
===============================================================================
*/

sub_list([],[]):-
	!.
sub_list(List,List).
sub_list([Someone|_],[Someone]).
sub_list([_|Others],Somebody):-
	sub_list(Others,Somebody).
sub_list([Someone,Somebody|Others],[Someone,Somebody]).
sub_list([Someone,Somebody|Others],Res):-
	sub_list([Someone|Others],Res).
sub_list([Someone,Somebody|Others],Res):-
	sub_list([Somebody|Others],Res).


% dana likes cody
% bess does not like dana
% cody does not like abby
% nobody likes someone who does not like her
% abby likes everyone who likes bess
% dana likes everyone bess likes
% everybody likes somebody

people([abby, bess, cody, dana]).

% Questions 1.6 and 1.7
test_possible_worlds :-
        possible_worlds(World),
        writeln(World),
        fail.



/* 
----------------------------------------------------------------------------------------------------
 [Tests]

make_all_pairs([coco,valou,flobear],Res).

Res = [likes(coco, coco), likes(flobear, coco), likes(coco, flobear), likes(valou, coco), likes(coco, valou), likes(valou, valou), likes(flobear, valou), likes(valou, flobear), likes(flobear, flobear)]
Yes

----------------------------------------------------------------------------------------------------



*/
