:- include('coups_possibles.pl').




/*
	* Ce fichier est destine a l'evaluation d'une serie de coups afin de determine quel est le meilleur a jouer
*/














/*
	* coupGagnant(Coup).
	* Ce predicat determine si le coup passe en argument est un coup gagnant
*/

coupGagnant([Joueur, _, Destination]) :- coordonneeArrivee(Joueur, Destination).


/*
	* existeCoupGagnant(ListeCoups, CoupGagnant).
	* Ce predicat inspecte une liste de coups et instancie CoupGagnant avec la premiere occurrence d'un coup gagnant qu'il trouve
*/

existeCoupGagnant([T|_], T) :-
	coupGagnant(T),
	!.
existeCoupGagnant([_|Q], CoupGagnant) :-
	existeCoupGagnant(Q, CoupGagnant).


% ##################################################################################################################################################


/*
	* meilleurCoup(ListeDeCoups, MeilleurCoup, Memoire).
	* Ce predicat determine le meilleur coup a jouer parmi la liste ListeDeCoups
*/

meilleurCoup(Coups, Coup, Memoire) :-
	existeCoupGagnant(Coups, Coup),
	\+ appartient(Coup, Memoire),
	!.
meilleurCoup([[Joueur, Origine, Destination]|Q], Coup, Memoire) :-
	distanceCases(Origine, Destination, D),
	meilleurCoup_aux(Q, ([Joueur, Origine, Destination], D), Coup, Memoire).
	
meilleurCoup_aux([], (C, _), C, Memoire) :- \+ appartient(C, Memoire).
meilleurCoup_aux([[Joueur, Origine, Destination]|Q], (_, D), Resultat, Memoire) :-
	distanceCases(Origine, Destination, D2),
	D2 > D,
	\+ appartient([Joueur, Origine, Destination], Memoire),
	meilleurCoup_aux(Q, ([Joueur, Origine, Destination], D2), Resultat, Memoire),
	!.
meilleurCoup_aux([_|Q], (C, D), Resultat, Memoire) :- meilleurCoup_aux(Q, (C, D), Resultat, Memoire).
