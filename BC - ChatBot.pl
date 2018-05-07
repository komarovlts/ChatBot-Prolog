%Hechos
%Constructor:
cb([]).
seed(0).
seed(1).

%Reglas
%Pertenencia (Log):
esLog([]).
esLog([X|Xs]):-
     string(X).
%Pertenencia (Chatbot):
esChatbot([]).
esChatbot([X|Xs]):-
     (X = 0;X = 1).

% Agregar elemento ELEM a una lista
agregar([], [ELEM], ELEM).
agregar([X|Xs], [X|Ys], ELEM):-
     agregar(Xs, Ys, ELEM).

beginDialog(Chatbot, InputLog, Seed, OutputLog):-
     agregar(InputLog, OutputLog, "Bienvenido! :D!").
