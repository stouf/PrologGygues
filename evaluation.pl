/*
	* Ce fichier comprend les predicats utiles pour l'evaluation d'un plateau
	* Rappelons que l'evaluation renverra un nombre positif si le plateau tend plus en la faveur du joueur Nord et un nombre negatif si le plateau tend en faveur du joueur Sud
*/
















/*
	* nombreElementsBornes(Liste, BorneInf, BorneSup, Nombre, Coefficient).
	* Ce predicat retourne le nombre d'elements de Liste contenus dans l'intervalle [BorneInf, BorneSup].
	* A la fin, le nombre final sera multiplie par le coefficient Coefficient
*/

nombreElementsBornes(Liste, Inf, Sup, Resultat, Coefficient) :-
	nombreElementsBornes(Liste, Inf, Sup, 0, Resultat, Coefficient).
	
nombreElementsBornes([T|Q], Inf, Sup, Cpt, Resultat, Coefficient) :-
	T >= Inf,
	T =< Sup,
	Cpt2 is Cpt + 1,
	nombreElementsBornes(Q, Inf, Sup, Cpt2, Resultat, Coefficient),
	!.
nombreElementsBornes([_|Q], Inf, Sup, Cpt, Resultat, Coefficient) :-
	nombreElementsBornes(Q, Inf, Sup, Cpt, Resultat, Coefficient),
	!.
nombreElementsBornes([], _, _, Cpt, Resultat, Coefficient) :-
	Resultat is Cpt*Coefficient.


% #############################################################################################################################################


/*
	* evaluation(Plateau, Note).
*/

evaluation([P1, P2, P3], Note) :-
	nombreElementsBornes(P1, 11, 16, N1, 3),
	nombreElementsBornes(P2, 21, 26, N2, 2),
	nombreElementsBornes(P3, 31, 36, N3, 1),
	nombreElementsBornes(P1, 41, 46, S1, 1),
	nombreElementsBornes(P2, 51, 56, S2, 2),
	nombreElementsBornes(P3, 61, 66, S3, 3),
	N is N1+N2+N3,
	S is S1+S2+S3,
	Note is S-N.
