/**
TP6 arithmetique

@author Valentin ESMIEU
@author Florent MALLARD
@version Annee scolaire 2014-2015
*/


% ============================================================================= 
%	next(+Prog,+State0,+Symbol0,-Symbol1,-Dir,-State1)
% =============================================================================


next(P,State0,Symbole0,Symbole1,Dir,State1):-
	transitions(P,Deltas),
	find_transition(State0,Symbole0,Deltas,delta(State0,Symbole0,Symbole1,Dir,State1)).

% transition(+L,+E,+S,-D) rend le delta correspondant
find_transition(EtatCourant, SymboleCourant,	
		[delta(EtatCourant,SymboleCourant,SymboleSuivant,Dir,EtatSuivant)|_],
		delta(EtatCourant,SymboleCourant,SymboleSuivant,Dir,EtatSuivant)):-
		!.

find_transition(EtatCourant, SymboleCourant, [delta(_,_,_,_,_)|R], DeltaRes):-
	find_transition(R,EtatCourant, SymboleCourant, DeltaRes).


% ============================================================================= 
%	update_tape(+Tape,+Symbol,+Direction,-UpdatedTape)
% =============================================================================
	% -----------------------------------------
	% remove_last_element(+L,-E,-Lres)
	% return E, last element of L, and Lres, L without its last element
	% -----------------------------------------
	remove_last_element([LastElement],LastElement,[]):-
		!.
	remove_last_element([Element|Rest],LastElement,[Element|Lres]):-
		remove_last_element(Rest,LastElement,Lres).
		
	% -----------------------------------------
	% add_at_end(+L,+E,-Resul)
	% return Resul, the list with E at the end of the list L
	% -----------------------------------------
	add_at_end([],Element,[Element]):-
		!.
	add_at_end([E|R],Element,[E|Resul]):-
		add_at_end(R,Element,Resul).
		
	% -----------------------------------------
	% udate_tape
	% -----------------------------------------
update_tape(tape(LG,[Tete|LD]),Symbol,left,tape(Left,[LastElementOfLG|Right])):-
	Right = [Symbol|LD],
	remove_last_element(LG,LastElementOfLG,Left),
	!.
	
update_tape(tape(LG,[Tete|LD]),Symbol,right,tape(Left,LD)):-
	add_at_end(LG,Symbol,Left).

	% -----------------------------------------
	% tape for tests
	% -----------------------------------------
		tape_test(tape([1,1],[1,1,1])).
	


% ============================================================================= 
%	run_turing_machine(+Prog,+Input,-Output,-FinalState)
% =============================================================================

	% -----------------------------------------
	% make_tape(+Input,-Tape)
	% return Tape, the tape corresponding to the Input
	% -----------------------------------------
	make_tape(Input,tape([' '],Input)).
	
	
run_turing_machine(Prog,Input,Output,FinalState):-
	make_tape(Input,Tape),
	run_machine(Prog,Tape,start).
	
	
	run_machine(Prog,tape(_,[Symbol|Rest]),stop):-
		!.
	
	run_machine(Prog,tape(_,[Symbol|Rest]),State):-
		next(Prog,State,Symbol,SymbolOut,DirOut,StateOut),
		update_tape([Symbol|Rest],SymbolOut,DirOut,UpdatedTape),
		run_machin(Prog,UpdatedTape,StateOut).
	

	
	

% =============================================================================
%%%%%%%%%%% First part

copy_prog(program(
                     start, 
                     [stop], 
                     [delta(start, ' ', ' ', right, stop),
                      delta(start, 1, ' ', right, s2),
                      delta(s2, 1, 1, right, s2),
                      delta(s2, ' ', ' ', right, s3),
                      delta(s3, 1, 1, right, s3),
                      delta(s3, ' ', 1, left, s4),
                      delta(s4, 1, 1, left, s4),
                      delta(s4, ' ', ' ', left, s5),
                      delta(s5, 1, 1, left, s5),
                      delta(s5, ' ', 1, right, start)
                     ]
                 )
         ).

initial_state(program(InitialState, _, _), InitialState).

final_states(program(_, FinalStates, _), FinalStates).

transitions(program(_, _, Deltas), Deltas).

/*
%write to meta post format
%compile result with: 
% mpost filename
% epstopdf filename.1
dump_to_mpost(Filename, Dump) :-
        open(Filename, write, Stream),
	        write_header(Stream),
        write_dump(0, Dump, Stream),
        write_end(Stream),
        close(Stream).

write_header(Stream) :-
        write(Stream, 'prologues := 1;\n'),
        write(Stream, 'input turing;\n'),
        write(Stream, 'beginfig(1)\n').

write_end(Stream) :-
        write(Stream, 'endfig;\n'),
        write(Stream, 'end').

write_dump(_, [], _).
write_dump(Y, [(State, Tape) | Tapes], Stream) :-
        write(Stream, 'tape(0, '),
        write(Stream, Y),
        write(Stream, 'cm, 1cm, \"'),
        write(Stream, State),
        write(Stream, '\", '),
        write_tape(Tape, Stream),
        write(Stream, ');\n'),
        Y1 is Y - 2,
        write_dump(Y1, Tapes, Stream).

write_tape(tape(Left, Right), Stream) :-
        length(Left, N),
        write(Stream, '\"'),
        append(Left, Right, L),
        (param(Stream), foreach(X, L) do 
            write(Stream, X)        
        ),
        write(Stream, '\", '),
        write(Stream, N),
        write('\n').
*/
% =============================================================================
/* TESTS

?-copy_prog(P),initial_state(P,Init),next(P,Init,' ',X,Y,Z).

P = program(...)
Init = start
X = ' '
Y = right
Z = stop
Yes 

====================

?- tape_test(T),update_tape(T,' ',left,TapeRes).

T = tape([1,1],[1,1,1])
TapeRes = tape([1],[1,' ',1,1])
yes


?- tape_test(T),update_tape(T,' ',right,TapeRes).

T = tape([1,1],[1,1,1])
TapeRes = tape([1,1,' '],[1,1])
yes

*/
