%Hechos
%Constructor:
cb(0,0).
cb1(0,1).
cb2(1,0).
cb3(1,1).

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
     agregar(InputLog, NuevoInputLog, "|BeginDialog|"),
     inicioConversacion(Chatbot, NuevoInputLog, Seed, Hour, StringTime, PrevioOutputLog),
     agregar(PrevioOutputLog, OutputLog, "|Nombre|").
%Llamada: beginDialog(1,[],0,OutputLog).
inicioConversacion(Chatbot, InputLog, Seed, Hour, StringTime, OutputLog):-
     ((cb(Chatbot,Seed);cb1(Chatbot,Seed)), (Hour >= 6), (Hour < 12), string_concat(StringTime, "Chatbot: Buenos Dias, Cual es tu nombre?", String1), agregar(InputLog, OutputLog, String1)),!;
     ((cb(Chatbot,Seed);cb1(Chatbot,Seed)), (Hour >= 12), (Hour < 20), string_concat(StringTime, "Chatbot: Buenas Tardes, Cual es tu nombre?", String2), agregar(InputLog, OutputLog, String2)),!;
     ((cb(Chatbot,Seed);cb1(Chatbot,Seed)), (Hour > 20), string_concat(StringTime, "Chatbot: Buenas Noches, Cual es tu nombre?", String3), agregar(InputLog, OutputLog, String3)),!;
     ((cb(Chatbot,Seed);cb1(Chatbot,Seed)), (Hour < 6), (Hour >= 0), string_concat(StringTime, "Chatbot: Buenas, Cual es tu nombre?", String4), agregar(InputLog, OutputLog, String4)),!;
     (cb2(Chatbot,Seed), string_concat(StringTime, "Chatbot: Hola!, Como te llamai?", String5), agregar(InputLog, OutputLog, String5)),!;
     (cb3(Chatbot,Seed), string_concat(StringTime, "Chatbot: Buena!, Como te llamas?", String6), agregar(InputLog, OutputLog, String6)).

sendMessage(Msg, Chatbot, InputLog, Seed, OutputLog):-
     getLast(InputLog, OutputLog).

horaYfechaActual(StringTime):-
     get_time(T), stamp_date_time(T, date(Y, MO, D, H, M, S, _, _, _), 'local'),
     S2 is round(S),
     string_concat(D,"/", UNO),
     string_concat(UNO, MO, DOS),
     string_concat(DOS,"/", TRES),
     string_concat(TRES, Y, CUATRO),
     string_concat(CUATRO, " ", CINCO),
     string_concat(CINCO, H, SEIS),
     string_concat(SEIS, ":", SIETE),
     string_concat(SIETE, M, OCHO),
     string_concat(OCHO, ":", NUEVE),
     string_concat(NUEVE, S2, DIEZ),
     string_concat(DIEZ, " ", StringTime).

getLast([], X).
getLast([X], X).
getLast([X|Xs], LastElement):-
     getLast(Xs, LastElement).

logToStr([], X).
logToStr([X|Xs], X).
logToStr([X|Xs], StrRep):-
     logToStr(Xs, StrRep).
