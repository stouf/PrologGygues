% Ce predicat est un simple predicat d'ajout dans une liste
ajoutListe(X, [], [X]) :- !.
ajoutListe(X, [T|Q], [T|Res]) :- ajoutListe(X, Q, Res).



% Ce predicat est un simple predicat de retrait d'une liste
retraitListe(_, [], []) :- !.
retraitListe(X, [X|Q], Q) :- !.
retraitListe(X, [Y|Q1], [Y|Q2]) :- retraitListe(X, Q1, Q2).





% ajoutDansSousListe(rang, valeur, listeDepart, listeArrivee)
% Ce predicat unifie listeArrivee de sorte a ce qu'elle soit le resultat de l'ajout de valeur dans la rang-eme sous-liste de listeDepart
% Exemple: ajoutDansSousListe(1, 5, [[], [1, 2, 3], [4, 5, 6], n], Res) => Res = [[5], [1, 2, 3], [4, 5, 6], n]
% Le rang est une valeur comprise entre 1 et 3 inclus
ajoutDansSousListe(1, X, [L1|Q], [Res|Q]) :- ajoutListe(X, L1, Res).
ajoutDansSousListe(2, X, [L1|[L2|Q]], [L1|[Res|Q]]) :- ajoutListe(X, L2, Res).
ajoutDansSousListe(3, X, [L1|[L2|[L3|Q]]], [L1|[L2|[Res|Q]]]) :- ajoutListe(X, L3, Res).


% retireDeSousListe(rang, valeur, listeDepart, listeArrivee)
% Ce predicat fonctionne de facon analogue au predicat ajoutDansSousListe\3, sauf que ce dernier supprimer une valeur au lieu de l'ajouter
% Ce predicat s'arretera a la premiere occurence rencontre; cette decision est justifiee par le fait qu'un plateau valide ne dispose que d'une occurence possible
retireDeSousListe(1, X, [L1|Q1], [R|Q1]) :- retraitListe(X, L1, R).
retireDeSousListe(2, X, [L1, L2|Q1], [L1, R|Q1]) :- retraitListe(X, L2, R).
retireDeSousListe(3, X, [L1, L2, L3|Q1], [L1, L2, R|Q1]) :- retraitListe(X, L3, R).





% Ce predicat indique a l'utilisateur le systeme de numerotation du jeu dans le cadre de l'initialisation du plateau de jeu
afficherConsignes :-
	write('Vous allez etre invites a saisir le tableau de depart.'), nl,
	write('Les lignes et colonnes sont numerotees de 1 a 6 en partant respectivement du haut vers le bas, et de la gauche vers la droite'), nl,
	write('Une case donnee est identifiee par son numero de ligne collee a son numero de colonne.'), nl,
	write('Ainsi, on notera la 3eme case de la premiere ligne 13'), nl,
	write('Rappelons que les pions ne peuvent places initialement que sur la premier ligne de chacun des joueurs.'), nl,
	write('Remarque: lors de la saisie, terminez votre entree par un point.'), nl, nl.
	


% Ces predicats vont etre utiles pour controle si les entrees saisies sont correctes lors de l'initialisation
caseValide(1, 11, L) :- \+appartient(11, L), !.
caseValide(1, 12, L) :- \+appartient(12, L), !.
caseValide(1, 13, L) :- \+appartient(13, L), !.
caseValide(1, 14, L) :- \+appartient(14, L), !.
caseValide(1, 15, L) :- \+appartient(15, L), !.
caseValide(1, 16, L) :- \+appartient(16, L), !.
caseValide(2, 61, L) :- \+appartient(61, L), !.
caseValide(2, 62, L) :- \+appartient(62, L), !.
caseValide(2, 63, L) :- \+appartient(63, L), !.
caseValide(2, 64, L) :- \+appartient(64, L), !.
caseValide(2, 65, L) :- \+appartient(65, L), !.
caseValide(2, 66, L) :- \+appartient(66, L).





% Ce predicat demande sequentiellement au joueur d'ajouter ses pions a leur position initiale
% Il controle la validite des entrees initiales de sortes a respecter les regles du jeu
plateauDepartAux(Joueur, Plateau, L_tmp, Res) :-
	write('Ou voulez-vous placer votre premier pion a un cercle ?'), nl,
	read(P11),
	caseValide(Joueur, P11, L_tmp),
	ajoutListe(P11, L_tmp, L_tmp1),
	ajoutDansSousListe(1, P11, Plateau, Tmp1),
	
	write('Ou voulez-vous placer votre second pion a un cercle ?'), nl,
	read(P12),
	caseValide(Joueur, P12, L_tmp1),
	ajoutListe(P12, L_tmp1, L_tmp2),
	ajoutDansSousListe(1, P12, Tmp1, Tmp2),
	
	write('Ou voulez-vous placer votre premier pion a deux cercles ?'), nl,
	read(P21),
	caseValide(Joueur, P21, L_tmp2),
	ajoutListe(P21, L_tmp2, L_tmp3),
	ajoutDansSousListe(2, P21, Tmp2, Tmp3),
	
	write('Ou voulez-vous placer votre second pion a deux cercles ?'), nl,
	read(P22),
	caseValide(Joueur, P22, L_tmp3),
	ajoutListe(P22, L_tmp3, L_tmp4),
	ajoutDansSousListe(2, P22, Tmp3, Tmp4),
	
	write('Ou voulez-vous placer votre premier pion a trois cercles ?'), nl,
	read(P31),
	caseValide(Joueur, P31, L_tmp4),
	ajoutListe(P31, L_tmp4, L_tmp5),
	ajoutDansSousListe(3, P31, Tmp4, Tmp5),
	
	write('Ou voulez-vous placer votre second pion a trois cercles ?'), nl,
	read(P32),
	caseValide(Joueur, P32, L_tmp5),
	ajoutDansSousListe(3, P32, Tmp5, Res).
	
	




% Predicat a appeler pour initialiser une partie entre deux joueurs
plateauDepart(Plateau) :-
	afficherConsignes,
	write('Joueur Nord:'), nl,
	plateauDepartAux(1, [[], [], [], s], [], Plateau_tmp), nl,
	write('Joueur Sud:'), nl,
	plateauDepartAux(2, Plateau_tmp, [], Plateau), nl,
	afficherPlateau(Plateau).
