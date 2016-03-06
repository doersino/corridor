% PROLOG

% alle Zeichen einlesen bis Delimiter
read_string(DelChar,String) :-
	get0(C),
	read_string(DelChar,C,String).

read_string(DelChar,DelChar,[]) :-
	!.
read_string(DelChar,C,[C|RestString]) :-
	get0(Cnew),
	read_string(DelChar,Cnew,RestString).

% Liste trennen in Wörter
split_string(_,[],[]).
split_string(SepChar,CharList,[Chunk|SingleLists]) :-
	get_chunk(SepChar,CharList,Chunk,RestCharList),
	split_string(SepChar,RestCharList,SingleLists).

% einzelne Wörter erkennen
get_chunk(_,[],[],[]).
get_chunk(SepChar,[SepChar|RestCharList],[],RestCharList) :-
	!.
get_chunk(SepChar,[OtherChar|RestCharList],[OtherChar|RestChunk],UnusedCharList) :-
	get_chunk(SepChar,RestCharList,RestChunk,UnusedCharList).

% String-Darstellung (Zahlenlisten) in Atome umwandeln
strings_to_atoms([],[]).
strings_to_atoms([X|Xs],[Y|Ys]) :-
	name(Ytemp,X),
	downcase_atom(Ytemp,Y),
	strings_to_atoms(Xs,Ys).

% alles zusammen: ganzen Satz einlesen
read_sentence(Sentence) :-
	read_string(10,String),
	split_string(32,String,Words),
	strings_to_atoms(Words,Sentence).