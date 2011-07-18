% nations:   brit swede dane norwegian german
% colors:    red green white yellow blue
% pets:      dog bird cat horse fish
% drinks:    coffee milk beer water tea
% smokes:    pallmall dunhill marlboro dunhill rothmanns

house([N,C,P,D,S], Houses) :-
    member(N,[brit,swede,dane,norwegian,german]),
    forall( member([N1,_,_,_,_], Houses), N \= N1 ),
    member(C,[red,green,white,yellow,blue]),
    forall( member([_,C1,_,_,_], Houses), C \= C1 ),
    member(P,[dog,bird,cat,horse,fish]),
    forall( member([_,_,P1,_,_], Houses), P \= P1 ),
    member(D,[coffee,milk,beer,water,tea]),
    forall( member([_,_,_,D1,_], Houses), D \= D1 ),
    member(S,[pallmall,dunhill,marlboro,winfield,rothmanns]),
    forall( member([_,_,_,_,S1], Houses), S \= S1 ).

left_constraints([_,C1,_,_,_],[_,C2,_,_,_]) :-
    (C1 = green     ; C2 \= white).     % 4.

side_constraints([N1,_,P1,_,S1],[_,C2,P2,D2,S2]) :-
     (S1 \= marlboro  ; P2 = cat),     % 10.
     (P1 \= horse     ; S2 = dunhill), % 11.
     (N1 \= norwegian ; C2 = blue),    % 13.
     (S1 \= marlboro  ; D2 = water).   % 15.

triple_constraints([N1,C1,P1,D1,S1],[N2,C2,P2,D2,S2],[N3,C3,P3,D3,S3]) :-
     (S2 \= marlboro  ; P1 = cat ; P3 = cat),         % 10.
     (P2 \= horse     ; S1 = dunhill ; S3 = dunhill), % 11.
     (N2 \= norwegian ; C1 = blue ; C3 = blue),       % 13.
     (S2 \= marlboro  ; D1 = water ; D3 = water).     % 15.
    
constraints(H, Houses) :-
    [N,C,P,D,S] = H,
    house(H, Houses),
    (N = brit ; C \= red),       % 1.
    (N = swede ; P \= dog),      % 2.
    (N = dane ; D \= tea),       % 3.
    (C = green ; D \= coffee),   % 5.
    (S = pallmall ; P \= bird),  % 6.
    (C = yellow ; S \= dunhill), % 8. 
    (S = winfield ; D \= beer),  % 12.
    (N = german ; S \= rothmanns). % 14.
    
rules([H1,H2,H3,H4,H5]) :-
    H1 = [norwegian,_,_,_,_], % 9.
    constraints(H1, []),   
    constraints(H2, [H1]),
    side_constraints(H1,H2),
    left_constraints(H1,H2),
    H3 = [_,_,_,milk,_],      % 7.
    constraints(H3, [H1,H2]),
    left_constraints(H2,H3),
    triple_constraints(H1,H2,H3),
    constraints(H4, [H1,H2,H3]),
    left_constraints(H3,H4),
    triple_constraints(H2,H3,H4),
    constraints(H5, [H1,H2,H3,H4]),
    left_constraints(H4,H5),
    triple_constraints(H3,H4,H5),
    side_constraints(H5,H4).

% calling "rules([H1,H2,H3,H4,H5)" gives the (only) solution:
% H1 = [norwegian, yellow, cat, water, dunhill],
% H2 = [dane, blue, horse, tea, marlboro],
% H3 = [brit, red, bird, milk, pallmall],
% H4 = [german, green, fish, coffee, rothmanns],
% H5 = [swede, white, dog, beer, winfield]
% and thus the answer is:
%
% The German owns the fish.