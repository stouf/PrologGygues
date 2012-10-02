:- include('afficher_plateau.pl').
:- include('plateau_depart.pl').





% On representera un coup de la facon suivante:
% (J, Origine, Destination)
% J represente quel joueur joue le coup: {N, S}
% Origine represente la coordonnee d'origine sous la forme XY (exp: 13 pour ligne 1, colonne 3)
% Meme chose pour destination









coordonneeValide(X) :- X > 00, X < 07, !.
coordonneeValide(X) :- X > 10, X < 17, !.
coordonneeValide(X) :- X > 20, X < 27, !.
coordonneeValide(X) :- X > 30, X < 37, !.
coordonneeValide(X) :- X > 40, X < 47, !.
coordonneeValide(X) :- X > 50, X < 57, !.
coordonneeValide(X) :- X > 60, X < 67, !.
coordonneeValide(X) :- X > 70, X < 77.




coordonneeDepart(n, X) :- X > 00, X < 07, !.
coordonneeDepart(s, X) :- X > 70, X < 77.

coordonneeArrivee(s, X) :- X > 00, X < 07, !.
coordonneeArrivee(n, X) :- X > 70, X < 77.



% existePion(Plateau, Pion).
% Ce predicat verifie l'existance d'un pion a un coordonnee donnee, dans un plateau donnee.
existePion([T|_], X) :- appartient(X, T), !.
existePion([_|Q], X) :- existePion(Q, X).




% pionsSurLigne(Plateau, NumeroLigne, ListeDePions).
% Ce predicat retourne la liste ListeDePions contenant tous les pions sur la ligne NumeroLigne
% pionsSurLigne retournera la liste vide si aucun pion n'est situe sur NumeroLigne
pionsSurLigne(Plateau, N, L) :- pionsSurLigne_aux(Plateau, N, L, 1).

pionsSurLigne_aux(_, _, [], 7):- !.
pionsSurLigne_aux(Plateau, N, [X|L], I) :- X is (N*10)+I, existePion(Plateau, X), I2 is I+1, pionsSurLigne_aux(Plateau, N, L, I2), !.
pionsSurLigne_aux(Plateau, N, L, I) :- I2 is I+1, pionsSurLigne_aux(Plateau, N, L, I2).



% pionsJouables(Plateau, J, L).
% Ce predicat retourne la liste L contenant les pions que le joueur J peut jouer sur le plateau Plateau
pionsJouables(Plateau, n, L) :- pionsJouables_aux(Plateau, n, 1, L), !.
pionsJouables(Plateau, s, L) :- pionsJouables_aux(Plateau, s, 6, L).

pionsJouables_aux(_, n, 7, []) :- !.
pionsJouables_aux(_, s, 1, []) :- !.
pionsJouables_aux(Plateau, _, I, L) :- pionsSurLigne(Plateau, I, L), \+L=[], !.
pionsJouables_aux(Plateau, n, I, L) :- I2 is I+1, pionsJouables_aux(Plateau, n, I2, L).
pionsJouables_aux(Plateau, s, I, L) :- I2 is I-1, pionsJouables_aux(Plateau, s, I2, L).




% nombreCercles(Plateau, X, R).
% Ce predicat retourne le nombre de cercle R que comporte le pion X
nombreCercles(Plateau, X, 1) :- listePions1(Plateau, L), appartient(X, L), !.
nombreCercles(Plateau, X, 2) :- listePions2(Plateau, L), appartient(X, L), !.
nombreCercles(Plateau, X, 3) :- listePions3(Plateau, L), appartient(X, L).




% numeroLigne(P, NumeroLigne).
% Ce predicat retourne le numero de ligne NumeroLigne du pion P
numeroLigne(C1, NL) :- NL is C1//10.

% numeroColonne(P, NumeroColonne).
% Ce predicat retourne le numero de colonne NumeroColonne du pion P
numeroColonne(C1, NC) :- NC is C1 mod 10.


% valeurAbsolue(X1, X2).
% Simple predicat de calcul de valeur absolue
valeurAbsolue(X1, X1) :- X1 > 0, !.
valeurAbsolue(X1, X2) :- X2 is X1 * -1.



% distanceCases(C1, C2, D)
% Ce predicat calcule la distance D entre les cases C1 et C2
distanceCases(C1, C2, D) :-
	numeroLigne(C1, NumeroLigneC1),
	numeroLigne(C2, NumeroLigneC2),
	numeroColonne(C1, NumeroColonneC1),
	numeroColonne(C2, NumeroColonneC2),
	Tmp1 is NumeroLigneC1 - NumeroLigneC2,
	valeurAbsolue(Tmp1, Tmp2),
	Tmp3 is NumeroColonneC1 - NumeroColonneC2,
	valeurAbsolue(Tmp3, Tmp4),
	D is Tmp2 + Tmp4.







% neRencontrePasDePion(Plateau, Coup)
% Ce predicat teste si un deplacement de la case Origine vers la case Destination sur le plateau Plateau n'engendre pas de rencontre avec un autre pion

neRencontrePasDePion(_, [Joueur, X, X]) :- coordonneeArrivee(Joueur, X), !.
neRencontrePasDePion(_, [_, X, X]) :- !.
neRencontrePasDePion(Plateau, [Joueur, Origine, Destination]) :-
	nombreCercles(Plateau, Origine, Nb),
	neRencontrePasDePion2(Plateau, [Joueur, Origine, Destination], Nb).

neRencontrePasDePion2(_, [Joueur, X, X], 0) :- coordonneeArrivee(Joueur, X), !.
neRencontrePasDePion2(_, [_, X, X], 0) :- !.
neRencontrePasDePion2(Plateau, [Joueur, Origine, Destination], Nb) :-
	Nb > 0,
	Nb2 is Nb - 1,
	neRencontrePasDePion3(Plateau, [Joueur, Origine, Destination], Nb2).
	
neRencontrePasDePion3(Plateau, [Joueur, Origine, Destination], Nb) :-
	C is Origine + 1,
	coordonneeValide(C),
	\+ existePion(Plateau, C),
	neRencontrePasDePion2(Plateau, [Joueur, C, Destination], Nb),
	!.
neRencontrePasDePion3(Plateau, [Joueur, Origine, Destination], Nb) :-
	C is Origine - 1,
	coordonneeValide(C),
	\+ existePion(Plateau, C),
	neRencontrePasDePion2(Plateau, [Joueur, C, Destination], Nb),
	!.
neRencontrePasDePion3(Plateau, [Joueur, Origine, Destination], Nb) :-
	C is Origine + 10,
	coordonneeValide(C),
	\+ existePion(Plateau, C),
	neRencontrePasDePion2(Plateau, [Joueur, C, Destination], Nb),
	!.
neRencontrePasDePion3(Plateau, [Joueur, Origine, Destination], Nb) :-
	C is Origine - 10,
	coordonneeValide(C),
	\+ existePion(Plateau, C),
	neRencontrePasDePion2(Plateau, [Joueur, C, Destination], Nb).
	
	
	
	
	
	
	
	
% neRencontrePasDePionEcrasement(Plateau, Origine, Destination).
% Ce predicat est une adaptation du predicat neRencontrePasDePion\3, qui sera utilise dans le cas d'un ecrasement de pion
% Ce predicat admet des conditions propres a l'ecrasement d'un pion qui en doivent pas etre prises en compte dans tous les autres cas
neRencontrePasDePionEcrasement(Plateau, Origine, Destination) :-
	existePion(Plateau, Origine),
	existePion(Plateau, Destination),
	nombreCercles(Plateau, Origine, NbCercles),
	distanceCases(Origine, Destination, Distance),
	NbCercles = Distance,
	neRencontrePasDePionEcrasement2(Plateau, Origine, Destination, NbCercles).

neRencontrePasDePionEcrasement2(_, X, X, 0) :- !.
neRencontrePasDePionEcrasement2(_, Origine, Destination, 1) :-
	Destination is Origine + 1,
	!.
neRencontrePasDePionEcrasement2(_, Origine, Destination, 1) :-
	Destination is Origine - 1,
	!.
neRencontrePasDePionEcrasement2(_, Origine, Destination, 1) :-
	Destination is Origine + 10,
	!.
neRencontrePasDePionEcrasement2(_, Origine, Destination, 1) :-
	Destination is Origine - 10,
	!.
neRencontrePasDePionEcrasement2(Plateau, Origine, Destination, N) :-
	N > 0,
	C is Origine + 1,
	coordonneeValide(C),
	N1 is N - 1,
	\+ existePion(Plateau, C),
	neRencontrePasDePionEcrasement2(Plateau, C, Destination, N1).
neRencontrePasDePionEcrasement2(Plateau, Origine, Destination, N) :-
	N > 0,
	C is Origine - 1,
	coordonneeValide(C),
	N1 is N - 1,
	\+ existePion(Plateau, C),
	neRencontrePasDePionEcrasement2(Plateau, C, Destination, N1).
neRencontrePasDePionEcrasement2(Plateau, Origine, Destination, N) :-
	N > 0,
	C is Origine + 10,
	coordonneeValide(C),
	N1 is N - 1,
	\+ existePion(Plateau, C),
	neRencontrePasDePionEcrasement2(Plateau, C, Destination, N1).
neRencontrePasDePionEcrasement2(Plateau, Origine, Destination, N) :-
	N > 0,
	C is Origine - 10,
	coordonneeValide(C),
	N1 is N - 1,
	\+ existePion(Plateau, C),
	neRencontrePasDePionEcrasement2(Plateau, C, Destination, N1).
	
	
	
	
	
	
	
	
	
	
	


% pionsAutour(Plateau, Pion, L).
% Ce predicat retourne une liste contenant les coordonnees des pions a la portee du pion renseigne en parametre
pionsAutour(Plateau, Pion, L) :-
	existePion(Plateau, Pion),
	nombreCercles(Plateau, Pion, Nb),
	pionsAutour2(Plateau, Pion, [Pion], [Pion|L], Nb).
	
pionsAutour2(Plateau, Pion, L, L, 0) :- \+ existePion(Plateau, Pion), !.
pionsAutour2(Plateau, Pion, L, L, 0) :- existePion(Plateau, Pion), appartient(Pion, L), !.
pionsAutour2(Plateau, Pion, L1, L, 0) :- existePion(Plateau, Pion), ajoutListe(Pion, L1, L), !.
pionsAutour2(_, Pion, L, L, _) :- \+ coordonneeValide(Pion), !.
pionsAutour2(Plateau, Pion, L1, L, Nb) :-
	Nb2 is Nb - 1,
	C1 is Pion + 1,
	C2 is Pion - 1,
	C3 is Pion + 10,
	C4 is Pion - 10,
	pionsAutour2(Plateau, C1, L1, LTmp1, Nb2),
	pionsAutour2(Plateau, C2, LTmp1, LTmp2, Nb2),
	pionsAutour2(Plateau, C3, LTmp2, LTmp3, Nb2),
	pionsAutour2(Plateau, C4, LTmp3, L, Nb2).
	
	
	
	
	
	

	
	
% peutRebondir(Plateau, Origine, Destination)
% Ce predicat teste si le pion a la coordonnee Origine peut rebondir sur le pion a la coordonee Destination
% Il testera egalement si le pion ne rencontre pas d'autres pions sur sa route
peutRebondir(Plateau, Origine, Destination) :-
	coordonneeValide(Origine),
	coordonneeValide(Destination),
	C is Origine  + 1,
	coordonneeValide(C),
	nombreCercles(Plateau, Origine, Nb),
	Nb2 is Nb - 1,
	peutRebondir2(Plateau, C, Destination, Nb2),
	!.
peutRebondir(Plateau, Origine, Destination) :-
	coordonneeValide(Origine),
	coordonneeValide(Destination),
	C is Origine  - 1,
	coordonneeValide(C),
	nombreCercles(Plateau, Origine, Nb),
	Nb2 is Nb - 1,
	peutRebondir2(Plateau, C, Destination, Nb2),
	!.
peutRebondir(Plateau, Origine, Destination) :-
	coordonneeValide(Origine),
	coordonneeValide(Destination),
	C is Origine  + 10,
	coordonneeValide(C),
	nombreCercles(Plateau, Origine, Nb),
	Nb2 is Nb - 1,
	peutRebondir2(Plateau, C, Destination, Nb2),
	!.
peutRebondir(Plateau, Origine, Destination) :-
	coordonneeValide(Origine),
	coordonneeValide(Destination),
	C is Origine  - 10,
	coordonneeValide(C),
	nombreCercles(Plateau, Origine, Nb),
	Nb2 is Nb - 1,
	peutRebondir2(Plateau, C, Destination, Nb2).
	
peutRebondir2(_, X, X, 0) :- !.
peutRebondir2(Plateau, X, Destination, Nb) :-
	\+ existePion(Plateau, X),
	Nb > 0,
	Nb2 is Nb - 1,
	C is X + 1,
	peutRebondir2(Plateau, C, Destination, Nb2),
	!.
peutRebondir2(Plateau, X, Destination, Nb) :-
	\+ existePion(Plateau, X),
	Nb > 0,
	Nb2 is Nb - 1,
	C is X - 1,
	peutRebondir2(Plateau, C, Destination, Nb2),
	!.
peutRebondir2(Plateau, X, Destination, Nb) :-
	\+ existePion(Plateau, X),
	Nb > 0,
	Nb2 is Nb - 1,
	C is X + 10,
	peutRebondir2(Plateau, C, Destination, Nb2),
	!.
peutRebondir2(Plateau, X, Destination, Nb) :-
	\+ existePion(Plateau, X),
	Nb > 0,
	Nb2 is Nb - 1,
	C is X - 10,
	peutRebondir2(Plateau, C, Destination, Nb2).
	
peutRebondirListe(Plateau, X, [Y|_]) :- peutRebondir(Plateau, X, Y), !.
peutRebondirListe(Plateau, X, [_|L]) :- peutRebondirListe(Plateau, X, L).












% coupPossible(Plateau, Coup)
% Ce predicat teste si le coup Coup est possible dans l'etat actuel du plateau Plateau
% La premiere regle du predicat coupPossible2 prend en compte le cas d'un coup simple, sans rebondissement ni effacement de pion
% La seconde regle du predicat coupPossible2 traite le cas d'un rebondissement

coupPossible(Plateau, [Joueur, Origine, Destination]) :-
	pionsJouables(Plateau, Joueur, L),
	appartient(Origine, L),
	\+coordonneeDepart(Joueur, Destination),
	coupPossible2(Plateau, [Joueur, Origine, Destination], []).
	
coupPossible2(Plateau, [Joueur, Origine, Destination], _) :-
	\+existePion(Plateau, Destination),
	distanceCases(Origine, Destination, Distance),
	nombreCercles(Plateau, Origine, NbCercles),
	NbCercles = Distance,
	neRencontrePasDePion(Plateau, [Joueur, Origine, Destination]),
	!.
	
coupPossible2(Plateau, [_, Origine, Destination], Memoire) :-
	\+appartient(Origine, Memoire),
	existePion(Plateau, Destination),
	distanceCases(Origine, Destination, Distance),
	nombreCercles(Plateau, Origine, NbCercles),
	NbCercles = Distance,
	neRencontrePasDePionEcrasement(Plateau, Origine, Destination),
	write('Possible, avec effacement du pion adverse en position '), 
	write(Destination),
	nl,
	!.
	
coupPossible2(Plateau, [Joueur, Origine, Destination], Memoire) :-
	pionsAutour(Plateau, Origine, Pions),
	peutRebondirListe(Plateau, Origine, Pions),
	coupPossible3(Plateau, Pions, Joueur, Destination, Memoire).


coupPossible3(Plateau, [X|_], Joueur, Destination, Memoire) :- 
	\+appartient(X, Memoire),
	ajoutListe(X, Memoire, NouvelleMemoire),
	coupPossible2(Plateau, [Joueur, X, Destination], NouvelleMemoire),
	!.
coupPossible3(Plateau, [_|Q], Joueur, Destination, Memoire) :- coupPossible3(Plateau, Q, Joueur, Destination, Memoire).



















% ########################################################################
% Variante du predicat coupPossible\3 et des predicats qu'il engendre
% Fonctionne exactement de la meme facon, mais trace le chemin emprunte
% ########################################################################




neRencontrePasDePion(_, [Joueur, X, X], []) :- coordonneeArrivee(Joueur, X), !.
neRencontrePasDePion(_, [_, X, X], []) :- !.
neRencontrePasDePion(Plateau, [Joueur, Origine, Destination], Chemin) :-
	nombreCercles(Plateau, Origine, Nb),
	neRencontrePasDePion2(Plateau, [Joueur, Origine, Destination], Nb, Chemin).

neRencontrePasDePion2(_, [Joueur, X, X], 0, []) :- coordonneeArrivee(Joueur, X), !.
neRencontrePasDePion2(_, [_, X, X], 0, []) :- !.
neRencontrePasDePion2(Plateau, [Joueur, Origine, Destination], Nb, Chemin) :-
	Nb > 0,
	Nb2 is Nb - 1,
	neRencontrePasDePion3(Plateau, [Joueur, Origine, Destination], Nb2, Chemin).
	
neRencontrePasDePion3(Plateau, [Joueur, Origine, Destination], Nb, [C|Chemin]) :-
	C is Origine + 1,
	coordonneeValide(C),
	\+ existePion(Plateau, C),
	neRencontrePasDePion2(Plateau, [Joueur, C, Destination], Nb, Chemin),
	!.
neRencontrePasDePion3(Plateau, [Joueur, Origine, Destination], Nb, [C|Chemin]) :-
	C is Origine - 1,
	coordonneeValide(C),
	\+ existePion(Plateau, C),
	neRencontrePasDePion2(Plateau, [Joueur, C, Destination], Nb, Chemin),
	!.
neRencontrePasDePion3(Plateau, [Joueur, Origine, Destination], Nb, [C|Chemin]) :-
	C is Origine + 10,
	coordonneeValide(C),
	\+ existePion(Plateau, C),
	neRencontrePasDePion2(Plateau, [Joueur, C, Destination], Nb, Chemin),
	!.
neRencontrePasDePion3(Plateau, [Joueur, Origine, Destination], Nb, [C|Chemin]) :-
	C is Origine - 10,
	coordonneeValide(C),
	\+ existePion(Plateau, C),
	neRencontrePasDePion2(Plateau, [Joueur, C, Destination], Nb, Chemin).
	
	
	
	
	
	
	
neRencontrePasDePionEcrasement(Plateau, Origine, Destination, Chemin) :-
	existePion(Plateau, Origine),
	existePion(Plateau, Destination),
	nombreCercles(Plateau, Origine, NbCercles),
	distanceCases(Origine, Destination, Distance),
	NbCercles = Distance,
	neRencontrePasDePionEcrasement2(Plateau, Origine, Destination, NbCercles, Chemin).

neRencontrePasDePionEcrasement2(_, X, X, 0, [X]) :- !.
neRencontrePasDePionEcrasement2(_, Origine, Destination, 1, [Destination]) :-
	Destination is Origine + 1,
	!.
neRencontrePasDePionEcrasement2(_, Origine, Destination, 1, [Destination]) :-
	Destination is Origine - 1,
	!.
neRencontrePasDePionEcrasement2(_, Origine, Destination, 1, [Destination]) :-
	Destination is Origine + 10,
	!.
neRencontrePasDePionEcrasement2(_, Origine, Destination, 1, [Destination]) :-
	Destination is Origine - 10,
	!.
neRencontrePasDePionEcrasement2(Plateau, Origine, Destination, N, [C|Chemin]) :-
	N > 0,
	C is Origine + 1,
	coordonneeValide(C),
	N1 is N - 1,
	\+ existePion(Plateau, C),
	neRencontrePasDePionEcrasement2(Plateau, C, Destination, N1, Chemin).
neRencontrePasDePionEcrasement2(Plateau, Origine, Destination, N, [C|Chemin]) :-
	N > 0,
	C is Origine - 1,
	coordonneeValide(C),
	N1 is N - 1,
	\+ existePion(Plateau, C),
	neRencontrePasDePionEcrasement2(Plateau, C, Destination, N1, Chemin).
neRencontrePasDePionEcrasement2(Plateau, Origine, Destination, N, [C|Chemin]) :-
	N > 0,
	C is Origine + 10,
	coordonneeValide(C),
	N1 is N - 1,
	\+ existePion(Plateau, C),
	neRencontrePasDePionEcrasement2(Plateau, C, Destination, N1, Chemin).
neRencontrePasDePionEcrasement2(Plateau, Origine, Destination, N, [C|Chemin]) :-
	N > 0,
	C is Origine - 10,
	coordonneeValide(C),
	N1 is N - 1,
	\+ existePion(Plateau, C),
	neRencontrePasDePionEcrasement2(Plateau, C, Destination, N1, Chemin).






coupPossible(Plateau, [Joueur, Origine, Destination], [Origine|Chemin]) :-
	pionsJouables(Plateau, Joueur, L),
	appartient(Origine, L),
	\+coordonneeDepart(Joueur, Destination),
	coupPossible2(Plateau, [Joueur, Origine, Destination], [], Chemin).

coupPossible2(Plateau, [Joueur, Origine, Destination], _, Chemin) :-
	\+existePion(Plateau, Destination),
	distanceCases(Origine, Destination, Distance),
	nombreCercles(Plateau, Origine, NbCercles),
	NbCercles = Distance,
	neRencontrePasDePion(Plateau, [Joueur, Origine, Destination], Chemin),
	!.
	
coupPossible2(Plateau, [_, Origine, Destination], Memoire, Chemin) :-
	\+appartient(Origine, Memoire),
	existePion(Plateau, Destination),
	distanceCases(Origine, Destination, Distance),
	nombreCercles(Plateau, Origine, NbCercles),
	NbCercles = Distance,
	neRencontrePasDePionEcrasement(Plateau, Origine, Destination, Chemin),
	write('Possible, avec effacement du pion adverse en position '),
	write(Destination),
	nl,
	!.
	
coupPossible2(Plateau, [Joueur, Origine, Destination], Memoire, Chemin) :-
	pionsAutour(Plateau, Origine, Pions),
	peutRebondirListe(Plateau, Origine, Pions),
	coupPossible3(Plateau, Pions, Joueur, Destination, Memoire, Chemin).


coupPossible3(Plateau, [X|_], Joueur, Destination, Memoire, [X|Chemin]) :- 
	\+appartient(X, Memoire),
	ajoutListe(X, Memoire, NouvelleMemoire),
	coupPossible2(Plateau, [Joueur, X, Destination], NouvelleMemoire, Chemin),
	!.
coupPossible3(Plateau, [_|Q], Joueur, Destination, Memoire, Chemin) :- coupPossible3(Plateau, Q, Joueur, Destination, Memoire, Chemin).
