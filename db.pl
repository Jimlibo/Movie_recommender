/* Basic rules to be used later on */

/* Escalating common_genre */
common_genre1(X, Y):- genre(X, G1), genre(Y, G1), X \= Y. 
common_genre2(X, Y):- genre(X, G1), genre(Y, G1), genre(X, G2), genre(Y, G2), G1 \= G2,  X \= Y.
common_genre3(X, Y):- genre(X, G1), genre(Y, G1),  genre(X, G2), genre(Y, G2), genre(X, G3), genre(Y,G3), G1 \= G2, G1 \= G3, G2 \= G3, X \= Y. 

common_director(X, Y):- director_name(X,D), director_name(Y,D), X \= Y.


/* having some keywords of the plot the same */
common_plot1(X,Y):- plot_keyword(X,W1), plot_keyword(Y, W1), plot_keyword(X,W2), plot_keyword(Y,W2), W1 \= W2, X\=Y.
common_plot2(X,Y):- 
    plot_keyword(X,W1), plot_keyword(Y, W1), plot_keyword(X,W2), plot_keyword(Y,W2),plot_keyword(X,W3), plot_keyword(Y,W3), 
    plot_keyword(X,W4), plot_keyword(Y, W4), W1 \= W2, W1 \= W3, W1\= W4, W2 \= W3, W2 \= W4, W3 \= W4, X\=Y.
common_plot3(X,Y):- 
    plot_keyword(X,W1), plot_keyword(Y, W1), plot_keyword(X,W2), plot_keyword(Y,W2),plot_keyword(X,W3), plot_keyword(Y,W3),
    plot_keyword(X,W4), plot_keyword(Y,W4), plot_keyword(X,W5), plot_keyword(Y,W5), plot_keyword(X,W6), plot_keyword(Y,W6), W1 \= W2, W1 \= W3,
    W1\= W4, W1 \= W5, W1 \= W6, W2 \= W3, W2 \= W4, W2 \= W5, W2 \= W6, W3 \= W4, W3 \= W5, W3 \= W6, W4 \= W5, W4 \= W6, W5 \= W6, X\=Y.


/* having one, two or three actors in common */
common_actor3(X, Y):- actor_name(X, A1), actor_name(Y, A1), actor_name(X, A2), actor_name(Y, A2), actor_name(X, A3), actor_name(Y, A3),  A1 \= A2, A1 \= A3, A2 \= A3, X \= Y.
common_actor2(X, Y):- actor_name(X, A1), actor_name(Y, A1), actor_name(X, A2), actor_name(Y, A2), A1 \= A2,  X \= Y.
common_actor1(X, Y):- actor_name(X, A1), actor_name(Y, A1), X \= Y.

% having common language
common_language(X, Y):- language(X, L1), language(Y, L1), X \= Y.

% having common production studio
common_prod_company(X, Y):- production_companies(X, C1), production_companies(Y, C1), X \= Y.

% have been producted in the same country
common_prod_country(X, Y):- production_country(X, C1), production_country(Y, C1), X \= Y.

% have been produced the same decade
sameDecade(X, Y):-
    year(X, Y1), year(Y, Y2), atom_number(Y1, N1), atom_number(Y2, N2), A is div(N1, 1000), B is div(N2, 1000), A==B, 
    S1 is mod(N1, 100), S2 is mod(N2, 100), F1 is div(S1, 10), F2 is div(S2, 10), F1==F2, X \= Y.


% whether a movie is black and white 
black_and_white(X):- plot_keyword(X, W), W=='black and white'.

% helping rule
dif(X,Y,Z) :- (X < Y -> Z is Y - X ;  Z is X - Y).

% duration of movie X is 20 minutes longer or 20 minutes smaller than the duration of movie Y
common_duration(X,Y):-
    duration(X,D1), duration(Y,D2), atom_number(D1, N1), atom_number(D2, N2), dif(N1,N2,DUR), DUR < 20, X \= Y.  

% the average voting of the two movies is at most different by 1 (i.e. 6, 7)
common_vote(X, Y):-
    vote_average(X, P1), vote_average(Y, P2), atom_number(P1, N1), atom_number(P2, N2), dif(N1,N2,POP), POP < 1, X \= Y.


/* For movie recommender , find_similar 1-6 (escalating similarity) based on
the previous rules  */

find_sim_1(X, Y):- common_genre1(X,Y); common_plot1(X,Y).

find_sim_2(X, Y):- common_genre2(X,Y); common_plot2(X,Y).

find_sim_3(X, Y):- common_genre2(X,Y), language(X,Y); common_plot1(X,Y), sameDecade(X,Y); common_genre2(X,Y), common_duration(X,Y).

find_sim_4(X, Y):- common_genre2(X,Y), common_plot1(X,Y), sameDecade(X,Y); common_director(X,Y), common_prod_company(X,Y).

find_sim_5(X,Y):- common_genre2(X,Y), common_plot2(X,Y); common_director(X,Y), common_prod_company(X,Y); sameDecade(X, Y), common_actor1(X,Y).


find_sim_6(X,Y):- common_genre2(X,Y), common_plot2(X,Y), common_duration(X,Y);  common_genre2(X,Y), common_plot2(X,Y), common_vote(X,Y).

% if we want higher relativity, we can uncomment some or all of the above. although the python code does not support them right now
/*
find_sim_7(X,Y):- common_genre2(X,Y), common_plot2(X,Y), common_duration(X,Y), common_vote(X,Y), common_actor1(X,Y).

find_sim_8(X,Y):- common_genre3(X,Y), common_plot2(X,Y), common_duration(X,Y), common_vote(X,Y), common_actor1(X,Y); common_genre3(X,Y), common_plot2(X,Y), common_duration(X,Y), common_vote(X,Y), common_director(X,Y).

find_sim_9(X,Y):- common_genre3(X,Y), common_plot2(X,Y), common_duration(X,Y), common_vote(X,Y), common_language(X,Y), common_actor2(X,Y); common_genre2(X,Y), common_plot3(X,Y), common_duration(X,Y), common_vote(X,Y), common_director(X,Y).
*/