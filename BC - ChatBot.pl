%Hechos
iC1(0).
iC2(1,0).
iC3(1,1).
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

beginDialog(Chatbot, InputLog, Seed, OutputLog):-
     get_time(T), stamp_date_time(T, date(_, _, _, Hour, _, _, _, _, _), 'local'),
     horaYfechaActual(StringTime),
     agregar(InputLog, NuevoInputLog, 'BeginDialog'),
     inicioConversacion(Chatbot, NuevoInputLog, Hour, StringTime, OutputLog).
%Llamada: beginDialog(1,[],0,OutputLog).
inicioConversacion(Chatbot, InputLog, Hour, StringTime, OutputLog):-
     (iC1(Chatbot), (Hour >= 6), (Hour < 12), atom_concat(StringTime, 'Chatbot: Buenos Dias, Cual es tu nombre?', String1), agregar(InputLog, OutputLog, String1)),!;
     (iC1(Chatbot), (Hour >= 12), (Hour < 20), atom_concat(StringTime, 'Chatbot: Buenas Tardes, Cual es tu nombre?', String2), agregar(InputLog, OutputLog, String2)),!;
     (iC1(Chatbot), (Hour > 20), atom_concat(StringTime, 'Chatbot: Buenas Noches, Cual es tu nombre?', String3), agregar(InputLog, OutputLog, String3)),!;
     (iC1(Chatbot), (Hour < 6), (Hour >= 0), atom_concat(StringTime, 'Chatbot: Buenas, Cual es tu nombre?', String4), agregar(InputLog, OutputLog, String4)),!;
     (iC2(Chatbot,Seed), atom_concat(StringTime, 'Chatbot: Hola!, Como te llamai?', String5), agregar(InputLog, OutputLog, String5)),!;
     (iC3(Chatbot,Seed), atom_concat(StringTime, 'Chatbot: Buena!, Como te llamas?', String6), agregar(InputLog, OutputLog, String6)).


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
     atom_concat(NUEVE, S2, DIEZ),
     atom_concat(DIEZ, " ", StringTime).


logToStr([], X).
logToStr([X|Xs], X).
logToStr([X|Xs], StrRep):-
     logToStr(Xs, StrRep).
