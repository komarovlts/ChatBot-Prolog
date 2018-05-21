%Gran parte de las entradas con "a devolver", son variables/constantes para el resultado a revolver del predicado.

%Hechos
%Constructores:
%Hecho chatbot conformado por la personalidad del chatbot (número entero desde 0 al 1)
%junto a la seed dada por el usuario,
cb(0,0).
cb1(0,1).
cb2(1,0).
cb3(1,1).

%UserN para predicado test, modificables en contendio, pero no largo.
user1(["Omar", "bien", "1", "5", "no"]).
user2(["Antonio", "mal", "3", "1", "No"]).
user3(["Sofia", "bien", "4", "20", "si", "1", "2", "no"]).

%Reglas
%Pertenencia (Log):
/*
Nombre predicado: esLog
Parámetros:
    Entrada: Lista.
    Salida: Boolean -> true or false.
Descripción: Se verifica que la lista entrante efectivamente tenga la forma de un log, es decir,
             que sea una lista de strings.
*/
esLog([]).
esLog([X|Xs]):-
     string(X).
%Consulta: esLog(Lista).


/*
Nombre predicado: agregar.
Parámetros:
    Entrada: Lista, Lista a devolver, String.
    Salida: Lista inicial con el string y/o elemento en ella.
Descripción: Agregar elemento ELEM a una lista. predicado adquirida desde:
     https://docs.google.com/presentation/d/1ItijAGxgPl6MREQwld20tZqPRaYN9k7XxGEMSXzt9lk/edit#slide=id.g393c889367_0_93
*/
agregar([], [ELEM], ELEM).
agregar([X|Xs], [X|Ys], ELEM):-
     agregar(Xs, Ys, ELEM).
%Consulta: agregar(Lista, ListaFinal, Elemento).


/*
Nombre predicado: begingDialog.
Parámetros:
    Entrada: Número entero del 0 al 1, Lista con el historial de conversación en strings, Número entero del 0 al 1, Lista a devolver.
    Salida: Lista con el historial de convesación actualizado.
Descripción: Se da inicio a la conversación adquiriendo los datos necesarios para los metadatos de tiempo, se agregan los delimitadores de inicio,
             se agrega el mensaje de al log con el predicado inicioConversacion y se añade otro delimitador para reconocer la siguiente parte de la conversación.
*/
beginDialog(Chatbot, InputLog, Seed, OutputLog):-
     get_time(T), stamp_date_time(T, date(_, _, _, Hour, _, _, _, _, _), 'local'),
     horaYfechaActual(StringTime),
     agregar(InputLog, NuevoInputLog, "|BeginDialog|"),
     inicioConversacion(Chatbot, NuevoInputLog, Seed, Hour, StringTime, PrevioOutputLog),
     agregar(PrevioOutputLog, OutputLog, "|Nombre|").
%Consulta: beginDialog(0,[],0,OutputLog).

/*
Nombre predicado: inicioConversacion.
Parámetros:
    Entrada: Número entero del 0 al 1, Lista con el historial de conversación en strings, Número entero del 0 al 1,
            Metadato de hora, Metadato completo de hora y fecha en string, Lista a devolver.
    Salida: Lista con el historial de convesación actualizado.
Descripción: Se añade mensaje de inicio de conversación según la hora actual, la seed y la personalidad del chatbot.
*/
inicioConversacion(Chatbot, InputLog, Seed, Hour, StringTime, OutputLog):-
     ((cb(Chatbot,Seed); cb1(Chatbot,Seed)), (Hour >= 6), (Hour < 12), string_concat(StringTime, "Chatbot: Buenos Dias, Cual es tu nombre?", String1), agregar(InputLog, OutputLog, String1)),!;
     ((cb(Chatbot,Seed); cb1(Chatbot,Seed)), (Hour >= 12), (Hour < 20), string_concat(StringTime, "Chatbot: Buenas Tardes, Cual es tu nombre?", String2), agregar(InputLog, OutputLog, String2)),!;
     ((cb(Chatbot,Seed); cb1(Chatbot,Seed)), (Hour >= 20), string_concat(StringTime, "Chatbot: Buenas Noches, Cual es tu nombre?", String3), agregar(InputLog, OutputLog, String3)),!;
     ((cb(Chatbot,Seed); cb1(Chatbot,Seed)), (Hour < 6), (Hour >= 0), string_concat(StringTime, "Chatbot: Buenas, Cual es tu nombre?", String4), agregar(InputLog, OutputLog, String4)),!;
     (cb2(Chatbot,Seed), string_concat(StringTime, "Chatbot: Hola!, Como te llamai?", String5), agregar(InputLog, OutputLog, String5)),!;
     (cb3(Chatbot,Seed), string_concat(StringTime, "Chatbot: Buena!, Como te llamas?", String6), agregar(InputLog, OutputLog, String6)).
%Consulta: inicioConversacion(0, ListaLog, 0, Hour, StringTime, OutputLog).


/*
Nombre predicado: sendMessage.
Parámetros:
    Entrada: Mensaje dado por el usuario, Número entero del 0 al 1, Lista con el historial de conversación en strings, Número entero del 0 al 1,
            Lista a devolver.
    Salida: Lista con el historial de convesación actualizado.
Descripción: Se añade mensaje a la conversación según el último delimitador en el InputLog dado, utilizando el predicado correspondiente.
*/
sendMessage(Msg, Chatbot, InputLog, Seed, OutputLog):-
     (horaYfechaActual(StringTime), getLast(InputLog, LastElement)),
     ((LastElement = "|Nombre|", respuestaNombre(Chatbot, InputLog, Msg, Seed, StringTime, PrevioOutputLog), agregar(PrevioOutputLog, OutputLog, "|respuesta1|")),!;
     (LastElement = "|respuesta1|", respuesta1(Chatbot, InputLog, Msg, Seed, StringTime, PrevioOutputLog), agregar(PrevioOutputLog, OutputLog, "|respuesta2|")),!;
     (LastElement = "|respuesta2|", respuesta2(InputLog, Msg, StringTime, PrevioOutputLog), agregar(PrevioOutputLog, OutputLog, "|respuesta3|")),!;
     (LastElement = "|respuesta3|", respuesta3(InputLog, Msg, StringTime, PrevioOutputLog), agregar(PrevioOutputLog, OutputLog, "|respuesta4|")),!;
     (LastElement = "|respuesta4|", respuesta4(InputLog, Msg, StringTime, OutputLog))).
%Consulta: sendMessage("MiNombre", 0, ListaLog, 0, OutputLog).

/*
Nombre predicado: respuestaNombre.
Parámetros:
    Entrada: Número entero del 0 al 1, Lista con el historial de conversación en strings, Número entero del 0 al 1, Mensaje dado por el usuario,
            Metadato completo de hora y fecha en string, Lista a devolver.
    Salida: Lista con el historial de convesación actualizado.
Descripción: Se añade mensaje a la conversación según el tipo de chatbot dado.
*/
respuestaNombre(Chatbot, InputLog, Msg, Seed, StringTime, OutputLog):-
     (cb(Chatbot,Seed), string_concat(StringTime, "Usuario: ", String1), string_concat(String1, Msg, String2), agregar(InputLog, MensajeUsuario, String2), string_concat(StringTime, "Chatbot: Como estas?", String3), agregar(MensajeUsuario, OutputLog, String3)),!;
     (cb1(Chatbot,Seed), string_concat(StringTime, "Usuario: ", String1), string_concat(String1, Msg, String2), agregar(InputLog, MensajeUsuario, String2), string_concat(StringTime, "Chatbot: Que tal estas?", String3), agregar(MensajeUsuario, OutputLog, String3)),!;
     (cb2(Chatbot,Seed), string_concat(StringTime, "Usuario: ", String1), string_concat(String1, Msg, String2), agregar(InputLog, MensajeUsuario, String2), string_concat(StringTime, "Chatbot: Como estay?", String3), agregar(MensajeUsuario, OutputLog, String3)),!;
     (cb3(Chatbot,Seed), string_concat(StringTime, "Usuario: ", String1), string_concat(String1, Msg, String2), agregar(InputLog, MensajeUsuario, String2), string_concat(StringTime, "Chatbot: Como estai?", String3), agregar(MensajeUsuario, OutputLog, String3)).
%Consulta: respuestaNombre(0, ListaLog, "MiNombre", 0, StringTime, OutputLog).

/*
Nombre predicado: respuesta1.
Parámetros:
    Entrada: Número entero del 0 al 1, Lista con el historial de conversación en strings, Mensaje dado por el usuario, Número entero del 0 al 1,
            Metadato completo de hora y fecha en string, Lista a devolver.
    Salida: Lista con el historial de convesación actualizado .
Descripción: Se añade el mensaje del usuario y del chatbot a la conversación según el tipo de chatbot dado y la respuesta del usuario, si la respuesta
             no es la esperada no se añadirá nada al log por lo que toca repetir el llamado de este predicado.
*/
respuesta1(Chatbot, InputLog, Msg, Seed, StringTime, OutputLog):-
     (cb(Chatbot,Seed), Msg = "Bien", string_concat(StringTime, "Usuario: ", String1), string_concat(String1, Msg, String2), agregar(InputLog, MensajeUsuario, String2), string_concat(StringTime, "Chatbot: Oh, Perfecto!. Estos son las marcas/modelos de autos de las homocineticas que disponemos: 1.-Toyota Rav4, 2.-Renault Duster, 3.-Hyundai Tucson, 4.-Nissan Qashqai, 5.-Nissan Kicks, elija la opcion que desea.", String3), agregar(MensajeUsuario, OutputLog, String3)),!;
     (cb(Chatbot,Seed), Msg = "bien", string_concat(StringTime, "Usuario: ", String1), string_concat(String1, Msg, String2), agregar(InputLog, MensajeUsuario, String2), string_concat(StringTime, "Chatbot: Oh, Perfecto!. Estos son las marcas/modelos de autos de las homocineticas que disponemos: 1.-Toyota Rav4, 2.-Renault Duster, 3.-Hyundai Tucson, 4.-Nissan Qashqai, 5.-Nissan Kicks, elija la opcion que desea.", String3), agregar(MensajeUsuario, OutputLog, String3)),!;
     (cb1(Chatbot,Seed), Msg = "Bien", string_concat(StringTime, "Usuario: ", String1), string_concat(String1, Msg, String2), agregar(InputLog, MensajeUsuario, String2), string_concat(StringTime, "Chatbot: Que bien!. Estos son las marcas/modelos de autos de las homocineticas que disponemos: 1.-Toyota Rav4, 2.-Renault Duster, 3.-Hyundai Tucson, 4.-Nissan Qashqai, 5.-Nissan Kicks, elija la opcion que desea.", String3), agregar(MensajeUsuario, OutputLog, String3)),!;
     (cb1(Chatbot,Seed), Msg = "bien", string_concat(StringTime, "Usuario: ", String1), string_concat(String1, Msg, String2), agregar(InputLog, MensajeUsuario, String2), string_concat(StringTime, "Chatbot: Que bien!. Estos son las marcas/modelos de autos de las homocineticas que disponemos: 1.-Toyota Rav4, 2.-Renault Duster, 3.-Hyundai Tucson, 4.-Nissan Qashqai, 5.-Nissan Kicks, elija la opcion que desea.", String3), agregar(MensajeUsuario, OutputLog, String3)),!;
     (cb2(Chatbot,Seed), Msg = "Bien", string_concat(StringTime, "Usuario: ", String1), string_concat(String1, Msg, String2), agregar(InputLog, MensajeUsuario, String2), string_concat(StringTime, "Chatbot: Buena!. Estos son las marcas/modelos de autos de las homocineticas que disponemos: 1.-Toyota Rav4, 2.-Renault Duster, 3.-Hyundai Tucson, 4.-Nissan Qashqai, 5.-Nissan Kicks, elija la opcion que desea.", String3), agregar(MensajeUsuario, OutputLog, String3)),!;
     (cb2(Chatbot,Seed), Msg = "bien", string_concat(StringTime, "Usuario: ", String1), string_concat(String1, Msg, String2), agregar(InputLog, MensajeUsuario, String2), string_concat(StringTime, "Chatbot: Buena!. Estos son las marcas/modelos de autos de las homocineticas que disponemos: 1.-Toyota Rav4, 2.-Renault Duster, 3.-Hyundai Tucson, 4.-Nissan Qashqai, 5.-Nissan Kicks, elija la opcion que desea.", String3), agregar(MensajeUsuario, OutputLog, String3)),!;
     (cb3(Chatbot,Seed), Msg = "Bien", string_concat(StringTime, "Usuario: ", String1), string_concat(String1, Msg, String2), agregar(InputLog, MensajeUsuario, String2), string_concat(StringTime, "Chatbot: Buena po!. Estos son las marcas/modelos de autos de las homocineticas que disponemos: 1.-Toyota Rav4, 2.-Renault Duster, 3.-Hyundai Tucson, 4.-Nissan Qashqai, 5.-Nissan Kicks, elija la opcion que desea.", String3), agregar(MensajeUsuario, OutputLog, String3)),!;
     (cb3(Chatbot,Seed), Msg = "bien", string_concat(StringTime, "Usuario: ", String1), string_concat(String1, Msg, String2), agregar(InputLog, MensajeUsuario, String2), string_concat(StringTime, "Chatbot: Buena po!. Estos son las marcas/modelos de autos de las homocineticas que disponemos: 1.-Toyota Rav4, 2.-Renault Duster, 3.-Hyundai Tucson, 4.-Nissan Qashqai, 5.-Nissan Kicks, elija la opcion que desea.", String3), agregar(MensajeUsuario, OutputLog, String3)),!;
     (cb(Chatbot,Seed), Msg = "Mal", string_concat(StringTime, "Usuario: ", String1), string_concat(String1, Msg, String2), agregar(InputLog, MensajeUsuario, String2), string_concat(StringTime, "Chatbot: Oh, Que mal, espero poder ayudarte!. Estos son las marcas/modelos de autos de las homocineticas que disponemos: 1.-Toyota Rav4, 2.-Renault Duster, 3.-Hyundai Tucson, 4.-Nissan Qashqai, 5.-Nissan Kicks, elija la opcion que desea.", String3), agregar(MensajeUsuario, OutputLog, String3)),!;
     (cb(Chatbot,Seed), Msg = "mal", string_concat(StringTime, "Usuario: ", String1), string_concat(String1, Msg, String2), agregar(InputLog, MensajeUsuario, String2), string_concat(StringTime, "Chatbot: Oh, Que mal, espero poder ayudarte!", String3), agregar(MensajeUsuario, OutputLog, String3)),!;
     (cb1(Chatbot,Seed), Msg = "Mal", string_concat(StringTime, "Usuario: ", String1), string_concat(String1, Msg, String2), agregar(InputLog, MensajeUsuario, String2), string_concat(StringTime, "Chatbot: Espero poder subirte el animo cuando lleves lo que buscabas.. Estos son las marcas/modelos de autos de las homocinéticas que disponemos: 1.-Toyota Rav4, 2.-Renault Duster, 3.-Hyundai Tucson, 4.-Nissan Qashqai, 5.-Nissan Kicks, elija la opcion que desea.", String3), agregar(MensajeUsuario, OutputLog, String3)),!;
     (cb1(Chatbot,Seed), Msg = "mal", string_concat(StringTime, "Usuario: ", String1), string_concat(String1, Msg, String2), agregar(InputLog, MensajeUsuario, String2), string_concat(StringTime, "Chatbot: Espero poder subirte el animo cuando lleves lo que buscabas.. Estos son las marcas/modelos de autos de las homocinéticas que disponemos: 1.-Toyota Rav4, 2.-Renault Duster, 3.-Hyundai Tucson, 4.-Nissan Qashqai, 5.-Nissan Kicks, elija la opcion que desea.", String3), agregar(MensajeUsuario, OutputLog, String3)),!;
     (cb2(Chatbot,Seed), Msg = "Mal", string_concat(StringTime, "Usuario: ", String1), string_concat(String1, Msg, String2), agregar(InputLog, MensajeUsuario, String2), string_concat(StringTime, "Chatbot: Oh, que mala!. Estos son las marcas/modelos de autos de las homocineticas que disponemos: 1.-Toyota Rav4, 2.-Renault Duster, 3.-Hyundai Tucson, 4.-Nissan Qashqai, 5.-Nissan Kicks, elija la opcion que desea.", String3), agregar(MensajeUsuario, OutputLog, String3)),!;
     (cb2(Chatbot,Seed), Msg = "mal", string_concat(StringTime, "Usuario: ", String1), string_concat(String1, Msg, String2), agregar(InputLog, MensajeUsuario, String2), string_concat(StringTime, "Chatbot: Oh, que mala!. Estos son las marcas/modelos de autos de las homocineticas que disponemos: 1.-Toyota Rav4, 2.-Renault Duster, 3.-Hyundai Tucson, 4.-Nissan Qashqai, 5.-Nissan Kicks, elija la opcion que desea.", String3), agregar(MensajeUsuario, OutputLog, String3)),!;
     (cb3(Chatbot,Seed), Msg = "Mal", string_concat(StringTime, "Usuario: ", String1), string_concat(String1, Msg, String2), agregar(InputLog, MensajeUsuario, String2), string_concat(StringTime, "Chatbot: De perro!. Estos son las marcas/modelos de autos de las homocineticas que disponemos: 1.-Toyota Rav4, 2.-Renault Duster, 3.-Hyundai Tucson, 4.-Nissan Qashqai, 5.-Nissan Kicks, elija la opcion que desea.", String3), agregar(MensajeUsuario, OutputLog, String3)),!;
     (cb3(Chatbot,Seed), Msg = "mal", string_concat(StringTime, "Usuario: ", String1), string_concat(String1, Msg, String2), agregar(InputLog, MensajeUsuario, String2), string_concat(StringTime, "Chatbot: De perro!. Estos son las marcas/modelos de autos de las homocineticas que disponemos: 1.-Toyota Rav4, 2.-Renault Duster, 3.-Hyundai Tucson, 4.-Nissan Qashqai, 5.-Nissan Kicks, elija la opcion que desea.", String3), agregar(MensajeUsuario, OutputLog, String3)).
%Consulta: respuesta1(0, ListaLog, "Bien", 0, StringTime, OutputLog).

/*
Nombre predicado: respuesta2.
Parámetros:
    Entrada: Lista con el historial de conversación en strings, Mensaje dado por el usuario, Metadato completo de hora y fecha en string, Lista a devolver.
    Salida: Lista con el historial de convesación actualizado .
Descripción: Se añade el mensaje del usuario y del chatbot a la conversación según la respuesta del usuario, si la respuesta
             no es la esperada no se añadirá nada al log por lo que toca repetir el llamado de este predicado.
*/
respuesta2(InputLog, Msg, StringTime, OutputLog):-
     (Msg = "1";Msg = "2";Msg = "3";Msg = "4";Msg = "5"), string_concat(StringTime, "Usuario: ", String1), string_concat(String1, Msg, String2), agregar(InputLog, MensajeUsuario, String2), string_concat(StringTime, "Chatbot: Tomo nota...  Perfecto, Cuantas querra?", String3), agregar(MensajeUsuario, OutputLog, String3).
%Consulta: respuesta2(ListaLog, "1", StringTime, OutputLog).

/*
Nombre predicado: respuesta3.
Parámetros:
    Entrada: Lista con el historial de conversación en strings, Mensaje dado por el usuario, Metadato completo de hora y fecha en string, Lista a devolver.
    Salida: Lista con el historial de convesación actualizado .
Descripción: Se añade el mensaje del usuario y del chatbot a la conversación.
*/
respuesta3(InputLog, Msg, StringTime, OutputLog):-
     string_concat(StringTime, "Usuario: ", String1), string_concat(String1, Msg, String2), agregar(InputLog, MensajeUsuario, String2), string_concat(StringTime, "Chatbot: Excelente, su pedido ha sido agregado a su carro. Desea comprar algo mas?", String3), agregar(MensajeUsuario, OutputLog, String3).
%Consulta: respuesta3(ListaLog, "1000", StringTime, OutputLog).


/*
Nombre predicado: respuesta4.
Parámetros:
    Entrada: Lista con el historial de conversación en strings, Mensaje dado por el usuario, Metadato completo de hora y fecha en string, Lista a devolver.
    Salida: Lista con el historial de convesación actualizado .
Descripción: Se añade el mensaje del usuario y del chatbot a la conversación según la respuesta del usuario, si la respuesta
             no es la esperada no se añadirá nada al log por lo que toca repetir el llamado de este predicado.
*/
respuesta4(InputLog, Msg, StringTime, OutputLog):-
     %Si
     (Msg = "Si", string_concat(StringTime, "Usuario: ", String1), string_concat(String1, Msg, String2), agregar(InputLog, MensajeUsuario, String2), string_concat(StringTime, "Chatbot: Okey! Estos son las marcas/modelos de autos de las homocineticas que disponemos: 1.-Toyota Rav4, 2.-Renault Duster, 3.-Hyundai Tucson, 4.-Nissan Qashqai, 5.-Nissan Kicks, elija la opcion que desea.", String3), agregar(MensajeUsuario, PrevioOutputLog, String3), agregar(PrevioOutputLog, OutputLog, "|respuesta2|")),!;
     (Msg = "si", string_concat(StringTime, "Usuario: ", String1), string_concat(String1, Msg, String2), agregar(InputLog, MensajeUsuario, String2), string_concat(StringTime, "Chatbot: Okey! Estos son las marcas/modelos de autos de las homocineticas que disponemos: 1.-Toyota Rav4, 2.-Renault Duster, 3.-Hyundai Tucson, 4.-Nissan Qashqai, 5.-Nissan Kicks, elija la opcion que desea.", String3), agregar(MensajeUsuario, PrevioOutputLog, String3), agregar(PrevioOutputLog, OutputLog, "|respuesta2|")),!;
     (Msg = "Si, me gustaría comprar algo más", string_concat(StringTime, "Usuario: ", String1), string_concat(String1, Msg, String2), agregar(InputLog, MensajeUsuario, String2), string_concat(StringTime, "Chatbot: Okey! Estos son las marcas/modelos de autos de las homocineticas que disponemos: 1.-Toyota Rav4, 2.-Renault Duster, 3.-Hyundai Tucson, 4.-Nissan Qashqai, 5.-Nissan Kicks, elija la opcion que desea.", String3), agregar(MensajeUsuario, PrevioOutputLog, String3), agregar(PrevioOutputLog, OutputLog, "|respuesta2|")),!;
     (Msg = "si, me gustaría comprar algo más", string_concat(StringTime, "Usuario: ", String1), string_concat(String1, Msg, String2), agregar(InputLog, MensajeUsuario, String2), string_concat(StringTime, "Chatbot: Okey! Estos son las marcas/modelos de autos de las homocineticas que disponemos: 1.-Toyota Rav4, 2.-Renault Duster, 3.-Hyundai Tucson, 4.-Nissan Qashqai, 5.-Nissan Kicks, elija la opcion que desea.", String3), agregar(MensajeUsuario, PrevioOutputLog, String3), agregar(PrevioOutputLog, OutputLog, "|respuesta2|")),!;
     %No
     (Msg = "No", string_concat(StringTime, "Usuario: ", String1), string_concat(String1, Msg, String2), agregar(InputLog, MensajeUsuario, String2), string_concat(StringTime, "Chatbot: Esta bien! Todo el stock se ha confirmado y todos sus items han sido agregados a su carro.", String3), agregar(MensajeUsuario, OutputLog, String3)),!;
     (Msg = "no", string_concat(StringTime, "Usuario: ", String1), string_concat(String1, Msg, String2), agregar(InputLog, MensajeUsuario, String2), string_concat(StringTime, "Chatbot: Esta bien! Todo el stock se ha confirmado y todos sus items han sido agregados a su carro.", String3), agregar(MensajeUsuario, OutputLog, String3)),!;
     (Msg = "No, gracias", string_concat(StringTime, "Usuario: ", String1), string_concat(String1, Msg, String2), agregar(InputLog, MensajeUsuario, String2), string_concat(StringTime, "Chatbot: Esta bien! Todo el stock se ha confirmado y todos sus items han sido agregados a su carro.", String3), agregar(MensajeUsuario, OutputLog, String3)),!;
     (Msg = "no, gracias", string_concat(StringTime, "Usuario: ", String1), string_concat(String1, Msg, String2), agregar(InputLog, MensajeUsuario, String2), string_concat(StringTime, "Chatbot: Esta bien! Todo el stock se ha confirmado y todos sus items han sido agregados a su carro.", String3), agregar(MensajeUsuario, OutputLog, String3)).
%Consulta: respuesta4(ListaLog, "Si", StringTime, OutputLog).


/*
Nombre predicado: endDialog.
Parámetros:
    Entrada: Número entero del 0 al 1, Lista con el historial de conversación en strings, Número entero del 0 al 1, Lista a devolver.
    Salida: Lista con el historial de convesación actualizado.
Descripción: Se da inicio a la conversación adquiriendo los datos necesarios para los metadatos de tiempo, se agrega el mensaje de al log con el predicado finalizarConversacion y
             se añade el delimitador de termino de la conversación.
*/
endDialog(Chatbot, InputLog, Seed, OutputLog):-
     get_time(T), stamp_date_time(T, date(_, _, _, Hour, _, _, _, _, _), 'local'),
     horaYfechaActual(StringTime),
     finalizarConversacion(Chatbot, InputLog, Seed, Hour, StringTime, PrevioOutputLog),
     agregar(PrevioOutputLog, OutputLog, "|EndDialog|").
%Consulta: endDialog(1,LogAnterior,0,OutputLog).


/*
Nombre predicado: finalizarConversacion.
Parámetros:
    Entrada: Número entero del 0 al 1, Lista con el historial de conversación en strings, Número entero del 0 al 1,
            Metadato de hora, Metadato completo de hora y fecha en string, Lista a devolver.
    Salida: Lista con el historial de convesación actualizado.
Descripción: Se añade mensaje de inicio de conversación según la hora actual, la seed y la personalidad del chatbot.
*/
finalizarConversacion(Chatbot, InputLog, Seed, Hour, StringTime, OutputLog):-
     ((cb(Chatbot,Seed);cb1(Chatbot,Seed)), (Hour >= 6), (Hour < 12), string_concat(StringTime, "Chatbot: Espero haberte sido de utilidad, que tengas un buen dia, Adios!.", String1), agregar(InputLog, OutputLog, String1)),!;
     ((cb(Chatbot,Seed);cb1(Chatbot,Seed)), (Hour >= 12), (Hour < 20), string_concat(StringTime, "Chatbot: Espero haberte sido de utilidad, que tengas una buena tarde, Adios!.", String2), agregar(InputLog, OutputLog, String2)),!;
     ((cb(Chatbot,Seed);cb1(Chatbot,Seed)), (Hour >= 20), string_concat(StringTime, "Chatbot: Espero haberte sido de utilidad, que tengas un buena noche, Adios!.", String3), agregar(InputLog, OutputLog, String3)),!;
     ((cb(Chatbot,Seed);cb1(Chatbot,Seed)), (Hour < 6), (Hour >= 0), string_concat(StringTime, "Chatbot: Espero haberte sido de utilidad, ¡Hasta luego!.", String4), agregar(InputLog, OutputLog, String4)),!;
     (cb2(Chatbot,Seed), string_concat(StringTime, "Chatbot: Chao, ¡Nos vimoh!.", String5), agregar(InputLog, OutputLog, String5)),!;
     (cb3(Chatbot,Seed), string_concat(StringTime, "Chatbot: Dale compa, ¡Nos vemos!.", String6), agregar(InputLog, OutputLog, String6)).
%Consulta: finalizarConversacion(0, ListaLog, 0, Hour, StringTime, OutputLog).

/*
Nombre predicado: horaYfechaActual.
Parámetros:
    Entrada: String final a devolver.
    Salida: String con metadatos de hora y fecha.
Descripción: Se adquieren los metadatos y se concatenan de una manera agradable a la vista del usuario, los segundos se redondean.
*/
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
%Consulta: horaYfechaActual(StringTime).

/*
SELECTOR:
Nombre predicado: getLast.
Parámetros:
    Entrada: Lista, Último elemento de la lista (a devolver).
    Salida: Último elemento de la lista.
Descripción: Se recorre la lista hasta llegar al último elemento de esta y se devuelve este.
*/
getLast([], X).
getLast([X], X).
getLast([X|Xs], LastElement):-
     getLast(Xs, LastElement).
%Consulta: getLast(InputLog, LastElement).

/*
Modificador:
Nombre predicado: logToStr.
Parámetros:
    Entrada: Lista, String unión de todos los strings de la Lista (a devolver).
    Salida: String unión de todos los strings de la Lista.
Descripción: Se recorre la lista hasta llegar al último elemento de esta y se devuelve este.
*/
logToStr(Log, StrRep):-
     atomic_list_concat(Log," ", LogAuxiliar),
	atom_string(LogAuxiliar,StrRep).
%Consulta: logToStr(OutputLog, StrRep).

/*
Nombre predicado: test.
Parámetros:
    Entrada: Lista de strings, Número entero del 0 al 1, Lista con el historial de conversación en strings, Número entero del 0 al 1,
            Lista a devolver.
    Salida: Lista con la conversación completa .
Descripción: Se recorre la lista hasta llegar al último elemento de esta y se devuelve este.
*/
test(User, Chatbot, InputLog, Seed, OutputLog):-
     beginDialog(Chatbot, InputLog, Seed,OutputLog1),
     ((nth1(1, User, PrimerMsg), sendMessage(PrimerMsg, Chatbot, OutputLog1,Seed,OutputLog2)),
     (nth1(2, User, SegundoMsg), sendMessage(SegundoMsg, Chatbot, OutputLog2,Seed,OutputLog3)),
     (nth1(3, User, TercerMsg), sendMessage(TercerMsg, Chatbot, OutputLog3,Seed,OutputLog4)),
     (nth1(4, User, CuartoMsg), sendMessage(CuartoMsg, Chatbot, OutputLog4,Seed,OutputLog5)),
     (nth1(5, User, QuintoMsg), sendMessage(QuintoMsg, Chatbot, OutputLog5,Seed,OutputLog6)),
     endDialog(Chatbot,OutputLog6,Seed,OutputLog))
     ,!;
     (user3(User),(nth1(1, User, PrimerMsg), sendMessage(PrimerMsg, Chatbot, OutputLog1,Seed,OutputLog2)),
     (nth1(2, User, SegundoMsg), sendMessage(SegundoMsg, Chatbot, OutputLog2,Seed,OutputLog3)),
     (nth1(3, User, TercerMsg), sendMessage(TercerMsg, Chatbot, OutputLog3,Seed,OutputLog4)),
     (nth1(4, User, CuartoMsg), sendMessage(CuartoMsg, Chatbot, OutputLog4,Seed,OutputLog5)),
     (nth1(5, User, QuintoMsg), sendMessage(QuintoMsg, Chatbot, OutputLog5,Seed,OutputLog6)),
     (nth1(6, User, SextoMsg), sendMessage(SextoMsg, Chatbot, OutputLog6,Seed,OutputLog7)),
     (nth1(7, User, SeptimoMsg), sendMessage(SeptimoMsg, Chatbot, OutputLog7,Seed,OutputLog8)),
     (nth1(8, User, OctavoMsg), sendMessage(OctavoMsg, Chatbot, OutputLog8,Seed,OutputLog9)),
     endDialog(Chatbot,OutputLog9,Seed,OutputLog)).
%Consulta: test(["Omar", "bien", "1", "5", "no"], 0, [], 0, OutputLog).
%Lista de palabras para User: ["Omar", "bien", "1", "5", "no"]
%                             ["Antonio", "mal", "3", "1", "No"]
%                             ["Sofia", "bien", "4", "20", "si", "1", "2", "no"]

/*
Consultas útiles:
Conversación completa: beginDialog(0,InputLog,0,OutputLog1), sendMessage("Omar", 0, OutputLog1,0,OutputLog2), sendMessage("bien", 0, OutputLog2,0,OutputLog3), sendMessage("1", 0, OutputLog3,0,OutputLog4), sendMessage("5", 0, OutputLog4,0,OutputLog5), sendMessage("no", 0, OutputLog5,0,OutputLog6), endDialog(0,OutputLog6,0,OutputLog7), logToStr(OutputLog7, StrRep), display(StrRep).
Conversación completa con 2do requerimiento de compra: beginDialog(0,InputLog,0,OutputLog1), sendMessage("Omar", 0, OutputLog1,0,OutputLog2), sendMessage("bien", 0, OutputLog2,0,OutputLog3), sendMessage("1", 0, OutputLog3,0,OutputLog4), sendMessage("5", 0, OutputLog4,0,OutputLog5), sendMessage("si", 0, OutputLog5,0,OutputLog6), sendMessage("1", 0, OutputLog6,0,OutputLog7), sendMessage("5", 0, OutputLog7,0,OutputLog8), sendMessage("no", 0, OutputLog8,0,OutputLog9), endDialog(0,OutputLog9,0,OutputLog10), logToStr(OutputLog10, StrRep), display(StrRep).
Test1 = test(["Omar", "bien", "1", "5", "no"], 0, [], 0, OutputLog), logToStr(OutputLog, StrRep), display(StrRep).
Test2 = test(["Antonio", "mal", "3", "1", "No"], 1, [], 1, OutputLog), logToStr(OutputLog, StrRep), display(StrRep).
Test3 = test(["Sofia", "bien", "4", "20", "si", "1", "2", "no"], 0, [], 1, OutputLog), logToStr(OutputLog, StrRep), display(StrRep).
*/
