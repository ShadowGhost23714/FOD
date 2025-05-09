{10. Se necesita contabilizar los votos de las diferentes mesas electorales registradas por
provincia y localidad. Para ello, se posee un archivo con la siguiente información: código de
provincia, código de localidad, número de mesa y cantidad de votos en dicha mesa.
Presentar en pantalla un listado como se muestra a continuación:

Código de Provincia
Código de Localidad Total de Votos
................................ ......................
................................ ......................
Total de Votos Provincia: ____
Código de Provincia
Código de Localidad Total de Votos
................................ ......................
Total de Votos Provincia: ___
…………………………………………………………..
Total General de Votos: ___

NOTA: La información está ordenada por código de provincia y código de localidad.}


program Ejercicio010;
const
    valorAlto = 999;
type
    registro = record
        provincia: integer;
        localidad: integer;
        mesa: integer;
        votos: integer;
    end;
    
    archivo = file of registro;
    
    procedure CrearNuevoArchivo (var a: archivo);
    var
        info: registro;
        nom: string;
        txt: text;
    begin
        assign (txt, 'Casos.txt');
        reset (txt);
        write ('Ingrese un nombre para el nuevo archivo: '); readln (nom);
        writeln;
        assign (a, nom);
        rewrite (a);
        while not EOF (txt) do begin
            readln (txt, info.provincia, info.localidad, info.mesa, info.votos);
            write (a, info);
        end;
        close (a);
    end;
    
    procedure Leer (var a: archivo; var info: registro);
    begin
        if not eof (a) then
            read (a, info)
        else
            info.provincia := valorAlto;
    end;
    
    procedure ImprimirArchivo (var a: archivo);
    var
        info: registro;
        cantLocalidad, cantProvicia, actLocalidad, actProvincia, total: integer;
    begin
        reset (a);
        Leer (a, info);
        total := 0;
        while info.provincia <> valorAlto do begin
            actProvincia := info.provincia;
            cantProvicia := 0;
            writeln ('Código de Provincia ',info.provincia);
            writeln ('Código de Localidad / Total de Votos');
            while (info.provincia = actProvincia) do begin
                actLocalidad := info.localidad;
                cantLocalidad := 0;
                while (info.localidad = actLocalidad) and (info.provincia = actProvincia) do begin
                    cantLocalidad := cantLocalidad + info.votos;
                    Leer (a, info);
                end;
                cantProvicia := cantProvicia + cantLocalidad;
                writeln (actLocalidad,' / ',cantLocalidad);
            end;
            total := total + cantProvicia;
            writeln ('Total de Votos Provincia ',cantProvicia);
            writeln;
        end;
        writeln ('Total general de votos ',total);
        close (a);
    end;
var
    a: archivo;
begin
    writeln;
    writeln ('--- Programa "Práctica 2, Ejercicio 10" ---');
    writeln;
    CrearNuevoArchivo (a);
    ImprimirArchivo (a);
    writeln ('--- Fin del Programa ---');
end.