% On definit une liste de depart type
listeDeDepart([[14,16,61,66], [13,15,62,65], [11,12,63,64]]).
listeDeDepart2([[11, 13, 65, 42], [26, 35, 51, 62], [15, 22, 63, 55]]).
listeDeDepart3([[32, 65, 42], [26, 35, 51, 62], [15, 22, 63, 55]]).
listeGagnante([[05, 32, 65, 42], [26, 35, 51, 62], [15, 22, 63, 55]]).


% Predicat testant si le premier parametre appartient au second, qui est une liste du type du premier parametre
appartient(X, [X|_]) :- !.
appartient(X, [_|L]) :- appartient(X, L).




% Predicats d'acces aux n elements d'une liste en premier argument; resultat dans le second argument
listePions1([T|_], T).
listePions2([_|[L2|_]], L2).
listePions3([_|[_|[L3|_]]], L3).
joueurCourant([_|[_|[_|[N|_]]]], N).





% Predicat affichant une nouvelle separation de ligne dans le plateau de jeu
afficherLigneSeparation:- write('-------------------------'), nl.





% Predicat affichant la case L du plateau de jeu
afficherCase(P, Plateau) :-
	listePions1(Plateau, L1),
	appartient(P, L1),
	write('1'),
	!.
afficherCase(P, Plateau) :-
	listePions2(Plateau, L1),
	appartient(P, L1),
	write('2'),
	!.
afficherCase(P, Plateau) :-
	listePions3(Plateau, L1),
	appartient(P, L1),
	write('3'),
	!.
afficherCase(_, _) :- write(' ').





% Predicat affichant La ligne d'indice L du plateau de jeu
afficherLigne(L, Plateau):-
    write('| '),
	L_tmp is L * 10,
	L1 is L_tmp + 1,
	L2 is L_tmp + 2,
	L3 is L_tmp + 3,
	L4 is L_tmp + 4,
	L5 is L_tmp + 5,
	L6 is L_tmp + 6,
    afficherCase(L1, Plateau), write(' | '),
    afficherCase(L2, Plateau), write(' | '),
    afficherCase(L3, Plateau), write(' | '),
    afficherCase(L4, Plateau), write(' | '),
    afficherCase(L5, Plateau), write(' | '),
    afficherCase(L6, Plateau), write(' |'), nl.
	
	
	
	
	
% Predicat affichant le plateau de jeu fourni en argument
afficherPlateau(Plateau):-
    write('        ---------'), nl,
    write('        |      '),
    afficherCase(n, Plateau),
    write('|'), nl,
    afficherLigneSeparation,
    afficherLigne(1, Plateau),
    afficherLigneSeparation,
    afficherLigne(2, Plateau),
    afficherLigneSeparation,
    afficherLigne(3, Plateau),
    afficherLigneSeparation,
    afficherLigne(4, Plateau),
    afficherLigneSeparation,
    afficherLigne(5, Plateau),
    afficherLigneSeparation,
    afficherLigne(6, Plateau),
    afficherLigneSeparation,
    write('        |      '),
    afficherCase(s, +Plateau),
    write('|'), nl,
    write('        ---------'), nl.
