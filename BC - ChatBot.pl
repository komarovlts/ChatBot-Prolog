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

endDialog(Chatbot, InputLog, Seed, OutputLog):-
     get_time(T), stamp_date_time(T, date(_, _, _, Hour, _, _, _, _, _), 'local'),
     horaYfechaActual(StringTime),
     finalizarConversacion(Chatbot, InputLog, Seed, Hour, StringTime, PrevioOutputLog),
     agregar(PrevioOutputLog, OutputLog, "|EndDialog|").
%Llamada: endDialog(1,[loganterior],0,OutputLog).
finalizarConversacion(Chatbot, InputLog, Seed, Hour, StringTime, OutputLog):-
     ((cb(Chatbot,Seed);cb1(Chatbot,Seed)), (Hour >= 6), (Hour < 12), string_concat(StringTime, "Chatbot: Espero haberte sido de utilidad, que tengas un buen día,¡Adios!.", String1), agregar(InputLog, OutputLog, String1)),!;
     ((cb(Chatbot,Seed);cb1(Chatbot,Seed)), (Hour >= 12), (Hour < 20), string_concat(StringTime, "Chatbot: Espero haberte sido de utilidad, que tengas una buena tarde,¡Adios!.", String2), agregar(InputLog, OutputLog, String2)),!;
     ((cb(Chatbot,Seed);cb1(Chatbot,Seed)), (Hour > 20), string_concat(StringTime, "Chatbot: Espero haberte sido de utilidad, que tengas un buena noche,¡Adios!.", String3), agregar(InputLog, OutputLog, String3)),!;
     ((cb(Chatbot,Seed);cb1(Chatbot,Seed)), (Hour < 6), (Hour >= 0), string_concat(StringTime, "Chatbot: Espero haberte sido de utilidad, ¡Hasta luego!.", String4), agregar(InputLog, OutputLog, String4)),!;
     (cb2(Chatbot,Seed), string_concat(StringTime, "Chatbot: Chao, ¡Nos vimoh!.", String5), agregar(InputLog, OutputLog, String5)),!;
     (cb3(Chatbot,Seed), string_concat(StringTime, "Chatbot: Dale compa, ¡Nos vemos!.", String6), agregar(InputLog, OutputLog, String6)).

horaYfechaActual(StringTime):-
     get_time(T), stamp_date_time(T, date(Y, MO, D, H, M, S, _, _, _), 'local'),
     S2 is round(S),
     string_concat("[", D, UNO),
     string_concat(UNO,"/", DOS),
     string_concat(DOS, MO, TRES),
     string_concat(TRES,"/", CUATRO),
     string_concat(CUATRO, Y, CINCO),
     string_concat(CINCO, " ", SEIS),
     string_concat(SEIS, H, SIETE),
     string_concat(SIETE, ":", OCHO),
     string_concat(OCHO, M, NUEVE),
     string_concat(NUEVE, ":", DIEZ),
     string_concat(DIEZ, S2, ONCE),
     string_concat(ONCE, "]", DOCE),
     string_concat(DOCE, " ", StringTime).

getLast([], X).
getLast([X], X).
getLast([X|Xs], LastElement):-
     getLast(Xs, LastElement).

logToStr([], X).
logToStr([X|Xs], X).
logToStr([X|Xs], StrRep):-
     logToStr(Xs, StrRep).
