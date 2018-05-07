/*% Mínimo entre 2 números (Regla Compuesta)
minimo(X,Y,X):- X=<Y.
minimo(X,Y,Y):- X>Y.
%Llamada: minimo(45, 65, MIN).

% Promedio de 3 números (Forzar Valor)
promedio(X,Y,Z,RES):-
    RES is (X+Y+Z)/3.
%Llamada: promedio(4.5, 6.8, 3.3, PROM).
*/
/*
% Verificar si Y está contenido en la Lista
contiene([X|Xs], X).
contiene([X|Xs], Y):- contiene(Xs, Y).
%LLamada: contiene([1,2,3], 5).

% Agregar elemento ELEM a una lista
agregar([], [ELEM], ELEM).
agregar([X|Xs], [X|Ys], ELEM):- agregar(Xs, Ys, ELEM).
%LLamada: agregar([1,2,3], L, 4).

% Contar elementos de una lista
contar([],0).
contar([X|L],C):- contar(L,C_ant), C is C_ant+1.
%LLamada: contar([1,2,3], LEN).
*/

% atom_concat('Usuario: ', 'Hola', X).
% X is random(10).
% get_time(T), stamp_date_time(T, date(Y, MO, D, H, M, S, _, _, _), 'local').
% https://www.tek-tips.com/viewthread.cfm?qid=1612213
% http://www.swi-prolog.org/pldoc/man?section=timedate
