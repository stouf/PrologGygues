:- include('jouer_coup.pl').




/*
	* Ce fichier contient les predicats qui seront utilises dans le but de generer tous les coups possibles pour un plateau donne
*/



% ######################################################################################################################################


% joueurValide(Joueur).
% Ce predicat teste la validite d'un joueur renseigne

joueurValide(n) :- !.
joueurValide(s).


% ######################################################################################################################################


% eliminerDoublons(L1, L2)
% Ce predicat elimine les doubles de la liste L1 en renvoyant une liste L2 sans doublon

eliminerDoublons([], []).
eliminerDoublons([T1|Q1], [T1|Q2]) :- \+appartient(T1, Q1), eliminerDoublons(Q1, Q2), !.
eliminerDoublons([_|Q1], L2) :- eliminerDoublons(Q1, L2).


% ######################################################################################################################################


% transformationPionsCoup(Joueur, Origine, Destinations, Coups).
% Ce predicat transforme une destination donnee en un coup sous la forme [Joueur, Origine, Destination]
% Exemple: Le coup du joueur Sud de la case 11 a la case 21 donnera:
% 21 => [s, 11, 21]

transformationPionsCoups(_, _, [], []) :- !.
transformationPionsCoups(Joueur, Origine, [T|Q], [X|Coups]) :-
	X = [Joueur, Origine, T],
	transformationPionsCoups(Joueur, Origine, Q, Coups).


% ######################################################################################################################################

	
% purifierListe(Plateau, AnciensCoups, NouveauxCoups).
% Ce predicat enleve les coups invalides dans le cas d'un deplacement au-dessus d'un pion existant sur le plateau de jeu

purifierListe(_, [], []) :- !.
purifierListe(Plateau, [T1|Q1], [T1|Q2]) :-
	neRencontrePasDePion(Plateau, T1),
	purifierListe(Plateau, Q1, Q2),
	!.
purifierListe(Plateau, [_|Q1], Q2) :- purifierListe(Plateau, Q1, Q2).


% ######################################################################################################################################


% purifierListeEcrasement(Plateau, AnciensCoups, NouveauxCoups).
% Ce predicat est une adaptation du predicat precedent pour les coups avec ecrasements

purifierListeEcrasement(_, [], []) :- !.
purifierListeEcrasement(Plateau, [[Joueur, Origine, Destination]|Q1], [[Joueur, Origine, Destination]|Q2]) :-
	neRencontrePasDePionEcrasement(Plateau, Origine, Destination),
	purifierListeEcrasement(Plateau, Q1, Q2),
	!.
purifierListeEcrasement(Plateau, [_|Q1], Q2) :- purifierListeEcrasement(Plateau, Q1, Q2).


% ######################################################################################################################################


% coupsPossibles(Plateau, CoupsPossibles)
% Ce predicat calcule la liste des coups possibles pour un plateau donne
% Tout le traitement sera fait dans version a trois arguments de ce predicat

coupsPossibles(Plateau, CoupsPossibles) :-
	repeat,
	write('Quel joueur doit jouer ?'),
	nl,
	read(Joueur),
	joueurValide(Joueur),
	!,
	coupsPossibles(Plateau, Joueur, CoupsPossibles).
	
	
	
% Predicat appele apres controle de l'entree du joueur faite ci-dessus
% Tout le traitement est en fait fait ici

coupsPossibles(Plateau, Joueur, CoupsPossibles) :-
	pionsJouables(Plateau, Joueur, Pions),
	casesLibresAtteignables(Plateau, Joueur, Pions, CoupsPossibles1),
	casesOccupeesAtteignables(Plateau, Joueur, Pions, CoupsPossibles2),
	rebondsPossibles(Plateau, Joueur, Pions, CoupsPossibles3),
	append(CoupsPossibles1, CoupsPossibles2, CoupsPossibles_tmp1),
	append(CoupsPossibles_tmp1, CoupsPossibles3, CoupsPossibles_tmp),
	eliminerDoublons(CoupsPossibles_tmp, CoupsPossibles).
	

% ######################################################################################################################################

	
% casesLibresAtteignables(Plateau, Joueur, Pions, Resultats)
% Ce predicat retourne une liste de coups possibles
% Les coups retournes seront des couts simples
% (pas d'ecrasement ni de rebondissement)

casesLibresAtteignables(Plateau, Joueur, [T1|Q1], Resultats) :-
	nombreCercles(Plateau, T1, Nb),
	casesLibresAtteignablesAux(Plateau, Joueur, T1, Nb, L1_tmp),
	transformationPionsCoups(Joueur, T1, L1_tmp, L1_tmp2),
	purifierListe(Plateau, L1_tmp2, L1),
	casesLibresAtteignables(Plateau, Joueur, Q1, L2),
	append(L1, L2, Resultats),
	!.
casesLibresAtteignables(_, _, [], []).




% casesLibresAtteignablesAux(Plateau, Joueur, Pion, NombreCercleDuPion, Resultat).
% Ce predicat retourne la liste Resultat dans laquelle seront contenues toutes les positions atteignables par le pion Pion, sans ecrasement

casesLibresAtteignablesAux(Plateau, Joueur, Pion, Nb, [Pion]) :-
	\+existePion(Plateau, Pion),
	coordonneeValide(Pion),
	\+coordonneeDepart(Joueur, Pion),
	Nb = 0,
	!.
casesLibresAtteignablesAux(_, _, _, Nb, []) :-
	Nb =< 0,
	!.
casesLibresAtteignablesAux(Plateau, Joueur, Pion, Nb, Pions) :-
	Nb1 is Nb - 1,
	C1 is Pion + 1,
	casesLibresAtteignablesAux(Plateau, Joueur, C1, Nb1, P1),
	C2 is Pion - 1,
	casesLibresAtteignablesAux(Plateau, Joueur, C2, Nb1, P2),
	C3 is Pion + 10,
	casesLibresAtteignablesAux(Plateau, Joueur, C3, Nb1, P3),
	C4 is Pion - 10,
	casesLibresAtteignablesAux(Plateau, Joueur, C4, Nb1, P4),
	append(P1, P2, P5),
	append(P5, P3, P6),
	append(P6, P4, Pions).
	
	
% ######################################################################################################################################


% casesOccupeesAtteignables(Plateau, Joueur, Pions, Resultats)
% Ce predicat retourne une liste de coups possibles, avec ecrasement

casesOccupeesAtteignables(Plateau, Joueur, [T1|Q1], Resultats) :-
	nombreCercles(Plateau, T1, Nb),
	casesOccupeesAtteignablesAux(Plateau, Joueur, T1, T1, Nb, L1_tmp),
	transformationPionsCoups(Joueur, T1, L1_tmp, L1_tmp2),
	purifierListeEcrasement(Plateau, L1_tmp2, L1),
	casesOccupeesAtteignables(Plateau, Joueur, Q1, L2),
	append(L1, L2, Resultats),
	!.
casesOccupeesAtteignables(_, _, [], []).




% casesOccupeesAtteignablesAux(Plateau, Joueur, Origine, Pion, NombreCercleDuPion, Resultat).
% Ce predicat retourne la liste Resultat dans laquelle seront contenues toutes les positions atteignables par le pion Pion, avec ecrasement

casesOccupeesAtteignablesAux(Plateau, Joueur, Origine, Pion, Nb, [Pion]) :-
	existePion(Plateau, Pion),
	coordonneeValide(Pion),
	\+coordonneeDepart(Joueur, Pion),
	Origine \= Pion,
	Nb = 0,
	!.
casesOccupeesAtteignablesAux(_, _, _, _, Nb, []) :-
	Nb =< 0,
	!.
casesOccupeesAtteignablesAux(Plateau, Joueur, Origine, Pion, Nb, Pions) :-
	Nb1 is Nb - 1,
	C1 is Pion + 1,
	casesOccupeesAtteignablesAux(Plateau, Joueur, Origine, C1, Nb1, P1),
	C2 is Pion - 1,
	casesOccupeesAtteignablesAux(Plateau, Joueur, Origine, C2, Nb1, P2),
	C3 is Pion + 10,
	casesOccupeesAtteignablesAux(Plateau, Joueur, Origine, C3, Nb1, P3),
	C4 is Pion - 10,
	casesOccupeesAtteignablesAux(Plateau, Joueur, Origine, C4, Nb1, P4),
	append(P1, P2, P5),
	append(P5, P3, P6),
	append(P6, P4, Pions).


% ######################################################################################################################################


% rebondsPossibles(Plateau, Joueur, Pions, Resultats).
% Ce predicat calcule toutes les positions atteignables par rebond pour tous les pions composant la liste Pions
% Ce calcul se fera selon l'heuristique de limitation posee

rebondsPossibles(Plateau, Joueur, [T|Q], Resultats) :-
	pionsAutour(Plateau, T, Pions),
	rebondsPossibles_aux1(Plateau, Joueur, T, Pions, R10),
	eliminerDoublons(R10, R11),
	rebondsPossibles(Plateau, Joueur, Q, R2),
	append(R11, R2, Resultats),
	!.
rebondsPossibles(_, _, [], []).
	

rebondsPossibles_aux1(Plateau, Joueur, Origine, [T|Q], Resultat) :-
	peutRebondir(Plateau, Origine, T),
	nombreCercles(Plateau, T, Nb),
	casesLibresAtteignablesAux(Plateau, Joueur, T, Nb, R10),
	transformationPionsCoups(Joueur, Origine, R10, R11),
	purifierListe(Plateau, R11, R12),
	casesOccupeesAtteignablesAux(Plateau, Joueur, T, T, Nb, R20),
	transformationPionsCoups(Joueur, Origine, R20, R21),
	purifierListeEcrasement(Plateau, R21, R22),
	append(R12, R22, R3),
	rebondsPossibles_aux1(Plateau, Joueur, Origine, Q, R4),
	append(R3, R4, Resultat),
	!.
rebondsPossibles_aux1(Plateau, Joueur, Origine, [_|Q], Resultat) :-
	rebondsPossibles_aux1(Plateau, Joueur, Origine, Q, Resultat),
	!.
rebondsPossibles_aux1(_, _, _, [], []).
