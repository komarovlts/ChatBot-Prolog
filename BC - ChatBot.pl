%Hechos
iC1(1,0).
iC2(1,1).
%Constructor:
cb(0).
cb(1).
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

inicioConversacion(Chatbot, InputLog, Seed, OutputLog):-
     (iC1(Chatbot,Seed),agregar(InputLog, OutputLog, 'Chatbot: Hola!, Como te llamai?')),!;
     (iC2(Chatbot,Seed),agregar(InputLog, OutputLog, 'Chatbot: Buena!, Como te llamas?')).

beginDialog(Chatbot, InputLog, Seed, OutputLog):-
     inicioConversacion(Chatbot, InputLog, Seed, OutputLog).
%Llamada: beginDialog(1,[],0,OutputLog).

horaYfechaActual(StringTime):-
     get_time(T), stamp_date_time(T, date(Y, MO, D, H, M, S, _, _, _), 'local'),
     S2 is round(S),
     atom_concat(D,'/', UNO),
     atom_concat(UNO, MO, DOS),
     atom_concat(DOS,'/', TRES),
     atom_concat(TRES, Y, CUATRO),
     atom_concat(CUATRO, ' ', CINCO),
     atom_concat(CINCO, H, SEIS),
     atom_concat(SEIS, ':', SIETE),
     atom_concat(SIETE, M, OCHO),
     atom_concat(OCHO, ':', NUEVE),
     atom_concat(NUEVE, S2, StringTime).


logToStr([], X).
logToStr([X|Xs], X).
logToStr([X|Xs], StrRep):-
     logToStr(Xs, StrRep).
