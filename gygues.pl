:- include('meilleur_coup.pl').



/*
	* Ce fichier est le fichier principal de jeu
	* Il inclut tous les autres fichiers, necessaires au projet
	* Le predicat start\0 est le predicat a appeler afin de lancer tout le deroulement de jeu
*/

















/*
	* bonChoixPartie(Choix).
	* Ce predicat s'unifie si le choix Choix est un choix valide de partie
*/

bonChoixPartie(1).
bonChoixPartie(2).
bonChoixPartie(3).


% ########################################################################################################################################


/*
	* partieJoueurIA.
	* Ce predicat lance une partie entre un joueur en une intelligence artificielle
*/

partieJoueurIA :-
	plateauDepart(Plateau),
	retractall(plateau(_)),
	retractall(memoire(_)),
	asserta(plateau(Plateau)),
	asserta(memoire([])),
	partieJoueurIA_aux1(n).
	
partieJoueurIA_aux1(_) :-
	plateau(P),
	plateauGagnant(P),
	!.
partieJoueurIA_aux1(n) :-
	repeat,
	plateau(Plateau1),
	saisirCoup(s, Coup),
	jouerCoup(Plateau1, Coup, Plateau2),
	!,
	afficherPlateau(Plateau2),
	retractall(plateau(_)),
	asserta(plateau(Plateau2)),
	partieJoueurIA_aux1(s).
partieJoueurIA_aux1(s) :-
	write('Lancer le coup de l\'IA ?'),
	nl,
	write('[Entrez n\'importe quelle valeur terminant par un point pour continuer...]'),
	nl,
	read(_),
	plateau(Plateau1),
	memoire(Memoire),
	coupsPossibles(Plateau1, s, Coups),
	meilleurCoup(Coups, Coup, Memoire),
	jouerCoup(Plateau1, Coup, Plateau2),
	afficherPlateau(Plateau2),
	retractall(plateau(_)),
	retractall(memoire(_)),
	asserta(plateau(Plateau2)),
	asserta(memoire([Coup|Memoire])),
	partieJoueurIA_aux1(n).


% ########################################################################################################################################


/*
	* partieIA
	* Ce predicat lance une partie entre deux IA
*/

partieIA :-
	plateauDepart(Plateau),
	retractall(plateau(_)),
	retractall(memoire(_)),
	asserta(plateau(Plateau)),
	asserta(memoire([])),
	partieIA_aux1(n).
	
partieIA_aux1(_) :-
	plateau(P),
	plateauGagnant(P),
	!.
partieIA_aux1(Joueur) :-
	write('Lancer le coup de l\'IA ?'),
	nl,
	write('[Entrez n\'importe quelle valeur terminant par un point pour continuer...]'),
	nl,
	read(_),
	plateau(Plateau1),
	memoire(Memoire),
	coupsPossibles(Plateau1, Joueur, Coups),
	meilleurCoup(Coups, Coup, Memoire),
	jouerCoup(Plateau1, Coup, Plateau2),
	afficherPlateau(Plateau2),
	retractall(plateau(_)),
	retractall(memoire(_)),
	asserta(plateau(Plateau2)),
	asserta(memoire([Coup|Memoire])),
	joueurOppose(Joueur, Joueur2),
	partieIA_aux1(Joueur2).


% ########################################################################################################################################


/*
	* start.
	* Predicat principal lancant la boucle interactive pour le jeu de gygues
*/

start :-
	repeat,
	write('Quel type de partie voulez-vous jouer ?'),
	nl,
	write('1. Humain VS Humain'),
	nl,
	write('2. Humain VS IA'),
	nl,
	write('3. IA VS IA'),
	nl,
	write('=> '),
	read(ChoixPartie),
	bonChoixPartie(ChoixPartie),
	!,
	start(ChoixPartie).
	
start(1):-
	partie2Joueurs.
start(2) :-
	partieJoueurIA.
start(3) :-
	partieIA.
