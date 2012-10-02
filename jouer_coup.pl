:- include('coup_possible.pl').



% Ce fichier servira a faire evoluer le plateau selon des coups donnes







% min(Min, Liste)
% Cette fonction calcule le minimum d'une liste

min(R, [T|Q]) :- min(R, [T], Q).

min(X, [X|_], []) :- !.
min(R, [T1|Q1], [T2|Q2]) :- T2 < T1, min(R, [T2, T1|Q1], Q2), !.
min(R, [T1|Q1], [T2|Q2]) :- T2 >= T1, min(R, [T1, T2|Q1], Q2).




% max(Max, Liste)
% Cette fonction calcule le maximum d'une liste

max(R, [T|Q]) :- max(R, [T], Q).

max(X, [X|_], []) :- !.
max(R, [T1|Q1], [T2|Q2]) :- T2 > T1, max(R, [T2, T1|Q1], Q2), !.
max(R, [T1|Q1], [T2|Q2]) :- T2 =< T1, max(R, [T1, T2|Q1], Q2).




% premiereLigne(Plateau, Joueur, NL).
% Ce predicat renvoie le numero de la premiere ligne d'un joueur donne

premiereLigne(Plateau, n, NL) :-
	pionsJouables(Plateau, n, PJ),
	min(Min, PJ),
	NL is Min//10,
	!.
premiereLigne(Plateau, s, NL) :-
	pionsJouables(Plateau, s, PJ),
	max(Min, PJ),
	NL is Min//10.
	
	
	



% placeLibre(Plateau, Joueur, PlaceLibre)
% Ce predicat renvoie une coordonnee de libre pour placer un nouveau pion du cote du joueur Joueur

placeLibre(Plateau, n, PL) :-
	premiereLigne(Plateau, n, LigneOrigine),
	premiereLigne(Plateau, s, LigneMax),
	C is LigneOrigine*10+1,
	placeLibre(Plateau, n, C, LigneMax, PL),
	!.
placeLibre(Plateau, s, PL) :-
	premiereLigne(Plateau, s, LigneOrigine),
	premiereLigne(Plateau, n, LigneMax),
	C is LigneOrigine*10+1,
	placeLibre(Plateau, s, C, LigneMax, PL).
	
placeLibre(Plateau, _, C, _, C) :-
	coordonneeValide(C),
	\+ existePion(Plateau, C),
	!.
placeLibre(Plateau, n, C, LigneMax, PL) :-
	NumColonne is C mod 10,
	NumLigne is C // 10,
	NumLigne < LigneMax,
	NumColonne > 6,
	C1 is (NumLigne+1)*10+1,
	placeLibre(Plateau, n, C1, LigneMax, PL),
	!.
placeLibre(Plateau, s, C, LigneMax, PL) :-
	NumColonne is C mod 10,
	NumLigne is C // 10,
	NumLigne > LigneMax,
	NumColonne > 6,
	C1 is (NumLigne-1)*10+1,
	placeLibre(Plateau, s, C1, LigneMax, PL),
	!.
placeLibre(Plateau, n, C, LigneMax, PL) :-
	NumColonne is C mod 10,
	NumColonne < 7,
	NumLigne is C // 10,
	NumLigne < LigneMax,
	C1 is C + 1,
	placeLibre(Plateau, n, C1, LigneMax, PL),
	!.
placeLibre(Plateau, s, C, LigneMax, PL) :-
	NumColonne is C mod 10,
	NumColonne < 7,
	NumLigne is C // 10,
	NumLigne > LigneMax,
	C1 is C + 1,
	placeLibre(Plateau, s, C1, LigneMax, PL).


















% jouerCoup(PlateauOrigine, Coup, PlateauDestination)
% Ce predicat fait evoluer le plateau selon un coup donne
% La deuxieme regle de ce predicat s'applique dans le cas d'un effacement et replace ainsi le pion efface a la premier case de libre
jouerCoup(Plateau1, [Joueur, Origine, Destination], Plateau2) :-
	coupPossible(Plateau1, [Joueur, Origine, Destination]),
	\+ existePion(Plateau1, Destination),
	nombreCercles(Plateau1, Origine, Nb1),
	retireDeSousListe(Nb1, Origine, Plateau1, P_tmp),
	ajoutDansSousListe(Nb1, Destination, P_tmp, Plateau2),
	!.
jouerCoup(Plateau1, [Joueur, Origine, Destination], Plateau2) :-
	coupPossible(Plateau1, [Joueur, Origine, Destination]),
	existePion(Plateau1, Destination),
	nombreCercles(Plateau1, Origine, Nb1),
	nombreCercles(Plateau1, Destination, Nb2),
	retireDeSousListe(Nb1, Origine, Plateau1, P_tmp),
	retireDeSousListe(Nb2, Destination, P_tmp, P_tmp2),
	ajoutDansSousListe(Nb1, Destination, P_tmp2, P_tmp3),
	placeLibre(P_tmp3, Joueur, NouvPosition),
	ajoutDansSousListe(Nb2, NouvPosition, P_tmp3, Plateau2).
	
	
	
	
	
	
	
	

	
	
% flatten(L1, L2).
% flatten est un predicat qui unifie L2 de sortes qu'il s'agisse d'un applatissement de la liste L1
% exemple: flatten([1, [5, [6, 7], 5], [5]], X) => X = [1, 5, 6, 7, 5, 5]
flatten([T|Q], R) :-
	flatten(T, FT),
	flatten(Q, QF),
	append(FT, QF, R),
	!.
flatten([], []) :- !.
flatten(X, [X]).






% plateauGagnant(P).
% Ce predicat s'unifie si le plateau P est gagnant
% Il renverra un message de felicitation egalement

plateauGagnant(P) :- flatten(P, P2), plateauGagnant2(P2).

plateauGagnant2(P) :- appartient(01, P), write('Bravo ! Le joueur SUD gagne!'), nl, !.
plateauGagnant2(P) :- appartient(02, P), write('Bravo ! Le joueur SUD gagne!'), nl, !.
plateauGagnant2(P) :- appartient(03, P), write('Bravo ! Le joueur SUD gagne!'), nl, !.
plateauGagnant2(P) :- appartient(04, P), write('Bravo ! Le joueur SUD gagne!'), nl, !.
plateauGagnant2(P) :- appartient(05, P), write('Bravo ! Le joueur SUD gagne!'), nl, !.
plateauGagnant2(P) :- appartient(06, P), write('Bravo ! Le joueur SUD gagne!'), nl, !.
plateauGagnant2(P) :- appartient(71, P), write('Bravo ! Le joueur NORD gagne!'), nl, !.
plateauGagnant2(P) :- appartient(72, P), write('Bravo ! Le joueur NORD gagne!'), nl, !.
plateauGagnant2(P) :- appartient(73, P), write('Bravo ! Le joueur NORD gagne!'), nl, !.
plateauGagnant2(P) :- appartient(74, P), write('Bravo ! Le joueur NORD gagne!'), nl, !.
plateauGagnant2(P) :- appartient(75, P), write('Bravo ! Le joueur NORD gagne!'), nl, !.
plateauGagnant2(P) :- appartient(76, P), write('Bravo ! Le joueur NORD gagne!'), nl.










origineValide(Joueur, X) :- \+coordonneeDepart(Joueur, X), coordonneeValide(X).














% saisirCoup(X).
% Ce predicat unifie X avec un coup correctement forme et rentre par l'utilisateur

saisirCoup(n, [s, Origine, Destination]) :-
	write('Au joueur SUD de jouer:'),
	nl,
	repeat,
	write('Quelle sera l origine de votre coup ?'),
	nl,
	write('(NOTE: se referer au manuel pour les entrees valides)'),
	nl,
	read(Origine),
	origineValide(s, Origine),
	!,
	repeat,
	write('Quelle sera la destination de votre coup ?'),
	nl,
	write('(NOTE: se referer au manuel pour les entrees valides)'),
	nl,
	read(Destination),
	coordonneeValide(Destination),
	!.

saisirCoup(s, [n, Origine, Destination]) :-
	write('Au joueur NORD de jouer:'),
	nl,
	repeat,
	write('Quelle sera l origine de votre coup ?'),
	nl,
	write('(NOTE: se referer au manuel pour les entrees valides)'),
	nl,
	read(Origine),
	origineValide(n, Origine),
	!,
	repeat,
	write('Quelle sera la destination de votre coup ?'),
	nl,
	write('(NOTE: se referer au manuel pour les entrees valides)'),
	nl,
	read(Destination),
	coordonneeValide(Destination),
	!.
	
	
	
	
	
	joueurOppose(n, s) :- !.
	joueurOppose(s, n).
	
	
	
	
	
	
	
	
	




% partie2Joueurs.
% Ce predicat est a appeler pour initialiser une partie a deux joueurs humains
partie2Joueurs :-
	plateauDepart(X),
	retractall(joueur(_)),
	retractall(plateau(_)),
	asserta(plateau(X)),
	asserta(joueur(s)),
	partie2Joueurs2.
	
partie2Joueurs2 :-
	repeat,
	plateau(Plateau1),
	joueur(Joueur1),
	saisirCoup(Joueur1, Coup),
	jouerCoup(Plateau1, Coup, Plateau2),
	afficherPlateau(Plateau2),
	joueurOppose(Joueur1, Joueur2),
	retractall(joueur(_)),
	retractall(plateau(_)),
	asserta(joueur(Joueur2)),
	asserta(plateau(Plateau2)),
	plateauGagnant(Plateau2),
	!.
