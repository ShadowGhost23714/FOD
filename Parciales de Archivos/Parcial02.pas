{
Suponga que tiene un archivo con información de los partidos de los últimos años de los equipos de primera división del fútbol Argentino. Dicho archivo contiene:

    1. código de equipo
    2. nombre de equipo
    3. año
    4. código de torneo
    5. código de equipo rival
    6. goles a favor
    7. goles en contra
    8. puntos obtenidos (0, 1 o 3 dependiendo de si perdió, ganó o empató el partido).

El archivo está ordenado por los siguientes criterios:
año, código de torneo y código de equipo.

Se le solicita definir las estructuras de datos necesarias y escribir el módulo que reciba el archivo y genere un informe por pantalla con el siguiente formato de ejemplo:
Informe resumen por equipo del fútbol Argentino

Año 1
    cod_torneo 1
        cod_equipo 1 nombre equipo 1
            cantidad total de goles a favor equipo 1
            cantidad total de goles en contra equipo 1
            diferencia de gol (resta de goles a favor - goles en contra) equipo 1
            cantidad de partidos ganados equipo 1
            cantidad de partidos perdidos equipo 1
            cantidad de partidos empatados equipo 1
            cantidad total de puntos en el torneo equipo 1

        -----------------------------------------------------------
        cod_equipo n nombre equipo n
            ídem anterior para equipo n

    El equipo “nombre equipo” fue campeón del torneo código de torneo 1 del año 1

    -----------------------------------------------------------
    cod_torneo n
        ídem anterior para cada equipo en el torneo n

    El equipo “nombre equipo” fue campeón del torneo código de torneo n del año 1

Año n
ídem anterior para cada torneo del año n

}
program Parcial02;
const
    valorAlto = 9999;
type 
    partido = record
        codEquipo: integer;
        nomEquipo: string[25];
        anio: integer;
        codTorneo: integer;
        codEquipoRival: integer;
        goles_a_favor: integer;
        goles_en_contra: integer;
        puntos_obtenidos: integer;
    end;
    
    partidos = file of partido;
    
    procedure leer (var a: partidos; p: partido);
    begin
        if not eof (a) then
            read (a, p)
        else
            p.anio := valorAlto;
    end;
    
    procedure imprimir (var a: partidos);
    var
        p: partido;
        anioActual, torneoActual, equipoActual: integer;
        goles, golesEnContra, partidosGanados, partidosPerdidos, partidosEmpatados, cantPuntos: integer;
        maxPuntos: integer;
        nomEquipo, maxEquipo: string;
    begin
        reset(a);
        leer (a, p);
        while p.anio <> valorAlto do begin
            anioActual := p.anio;
            writeln ('Año ', anioActual);
            while p.anio <> valorAlto and anioActual = p.anio do begin
                torneoActual := p.codTorneo;
                maxEquipo := "";
                maxPuntos := -1;
                writeln ('cod_torneo ', torneoActual);
                while p.anio <> valorAlto and anioActual = p.anio and torneoActual = p.cod_torneo do begin
                    equipoActual := p.codEquipo;
                    nomEquipo := p.nomEquipo;
                    goles := 0;
                    golesEnContra := 0;
                    partidosGanados := 0;
                    partidosPerdidos := 0;
                    partidosEmpatados := 0;
                    cantPuntos := 0;
                    writeln ('cod_equipo ', equipoActual, ', nombre equipo ', nomEquipo);
                    while p.anio <> valorAlto and anioActual = p.anio and torneoActual = p.cod_torneo and equipoActual = p.codEquipo do begin
                        goles := goles + p.goles_a_favor;
                        golesEnContra := golesEnContra + p.goles_en_contra;
                        if (p.goles_a_favor > p.goles_en_contra) then begin
                            partidosGanados := partidosGanados + 1;
                            cantPuntos := cantPuntos + 3;
                        end
                        else if (p.goles_a_favor < p.goles_en_contra) then
                            partidosPerdidos := partidosPerdidos + 1
                        else begin
                            partidosEmpatados := partidosEmpatados + 1;
                            cantPuntos := cantPuntos + 1;
                        end;
                        leer (a, p);
                    end;
                    if (cantPuntos > maxPuntos) then begin
                        maxPuntos := cantPuntos;
                        maxEquipo := nomEquipo;
                    end;
                    writeln('cantidad total de goles a favor equipo ', goles);
                    writeln('cantidad total de goles en contra equipo ', golesEnContra);
                    writeln('diferencia de gol equipo ', goles - golesEnContra);
                    writeln('cantidad de partidos ganados equipo ', partidosGanados);
                    writeln('cantidad de partidos perdidos equipo ', partidosPerdidos);
                    writeln('cantidad de partidos empatados equipo ', partidosEmpatados);
                    writeln('cantidad total de puntos en el torneo equipo ', cantPuntos);
                    writeln('---------------------------------------------------------');
                    end;
                writeln('El equipo ', maxEquipo, ' fue campeón del torneo código de torneo ', torneoActual, ' del año ', anioActual);
                writeln('----------------------------------------------------------------------------------------------------');
            end;
        end;
        close(a);
    end;
    
var
    archivo: partidos
begin
    assign (archivo, 'partidos'); // suponiendo que se dispone
    imprimir (archivo);
end.