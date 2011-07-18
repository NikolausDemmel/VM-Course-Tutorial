% This runs in SWI Prolog

even(0).
even(X) :- succ(Y,X), odd(Y).
odd(X) :- succ(Y,X), even(Y).

odd([],[]).
odd([X|T],[X|OT]) :- odd(X), odd(T,OT).
odd([X|T],OT) :- even(X), odd(T,OT).

even([],[]).
even([X|T],[X|OT]) :- even(X), even(T,OT).
even([X|T],OT) :- odd(X), even(T,OT).

last([X],X).
last([_|T],L) :- last(T,L).

append([],Y,Y).
append([X|T],Y,[X|Z]) :- append(T,Y,Z).

reverse([],[]).
reverse([X|T],R) :- reverse(T,TR), append(TR,[X],R).

% L1 begins with L2
beginnswith(_,[]).
beginnswith([H|T],[H|T2]) :- beginnswith(T,T2).

chain(L,S) :- beginnswith(L,S).
chain([_|T],S) :- chain(T,S).

remove(_, [], []).
remove(X, [X|T], T2) :- remove(X,T,T2).
remove(X, [Y|T], [Y|T2]) :- X \= Y, remove(X,T,T2).