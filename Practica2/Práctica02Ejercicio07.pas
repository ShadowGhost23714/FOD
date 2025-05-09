{7. Se dispone de un archivo maestro con información de los alumnos de la Facultad de
Informática. Cada registro del archivo maestro contiene: código de alumno, apellido, nombre,
cantidad de cursadas aprobadas y cantidad de materias con final aprobado. El archivo
maestro está ordenado por código de alumno.

Además, se tienen dos archivos detalle con información sobre el desempeño académico de
los alumnos: un archivo de cursadas y un archivo de exámenes finales. El archivo de
cursadas contiene información sobre las materias cursadas por los alumnos. Cada registro
incluye: código de alumno, código de materia, año de cursada y resultado (solo interesa si la
cursada fue aprobada o desaprobada). Por su parte, el archivo de exámenes finales
contiene información sobre los exámenes finales rendidos. Cada registro incluye: código de
alumno, código de materia, fecha del examen y nota obtenida. Ambos archivos detalle
están ordenados por código de alumno y código de materia, y pueden contener 0, 1 o
más registros por alumno en el archivo maestro. Un alumno podría cursar una materia
muchas veces, así como también podría rendir el final de una materia en múltiples
ocasiones.

Se debe desarrollar un programa que actualice el archivo maestro, ajustando la cantidad
de cursadas aprobadas y la cantidad de materias con final aprobado, utilizando la
información de los archivos detalle. Las reglas de actualización son las siguientes:

● Si un alumno aprueba una cursada, se incrementa en uno la cantidad de cursadas aprobadas.

● Si un alumno aprueba un examen final (nota >= 4), se incrementa en uno la cantidad de materias con final aprobado.

Notas:

● Los archivos deben procesarse en un único recorrido.

● No es necesario comprobar que no haya inconsistencias en la información de los
archivos detalles. Esto es, no puede suceder que un alumno apruebe más de una
vez la cursada de una misma materia (a lo sumo la aprueba una vez), algo similar
ocurre con los exámenes finales.}


program Ejercicio07;
const
    valorAlto = 9999;
    df = 3;
type
    rango = 1..df;
    
    infoMae = record
        cod: integer;
        ape: string;
        nom: string;
        cursadas: integer;
        finales: integer;
    end;
    
    master = file of infoMae;
    
    infoCursada = record
        codAlu: integer;
        codMateria: integer;
        ano: integer;
        result: string;
    end;
    
    cursadas = file of infoCursada;
    
    infoFinal = record
        codAlu: integer;
        codMateria: integer;
        fecha: string;
        nota: integer;
    end;
    
    finales = file of infoFinal;
    
    procedure LeerCursada(var c: cursadas; var info: infoCursada);
    begin
        if not eof(c) then
            read(c, info)
        else
            info.codAlu := valorAlto;
    end;

    procedure LeerFinal(var f: finales; var info: infoFinal);
    begin
        if not eof(f) then
            read(f, info)
        else
            info.codAlu := valorAlto;
    end;
    
    procedure CrearNuevoMaestro (var m: master);
    var
        info: infoMae;
        nom: string;
        txt: text;
    begin
        assign (txt, 'Casos.txt');
        reset (txt);
        write ('Ingrese un nombre para el nuevo archivo maestro: '); readln (nom);
        writeln;
        assign (m, nom);
        rewrite (m);
        while not EOF (txt) do begin
            readln (txt, info.cod, info.ape, info.nom, info.cursadas, info.finales);
            write (m, info);
        end;
        close (m);
    end;
    
    procedure CrearUnArchivoCursada (var c: cursadas);
    var
        info: infoCursada;
        nom: string;
        txt: text;
    begin
        write ('Ingrese la ruta del archivo cursada: '); readln (nom);
        writeln;
        assign (txt, nom);
        reset (txt);
        write ('Ingrese un nombre para el nuevo archivo cursada: '); readln (nom);
        writeln;
        assign (c, nom);
        rewrite (c);
        while not EOF (txt) do begin
            readln (txt, info.codAlu, info.codMateria, info.ano, info.result);
            write (c, info);
        end;
        close (c);
    end;
    
    procedure CrearUnArchivoFinal (var f: finales);
    var
        info: infoFinal;
        nom: string;
        txt: text;
    begin
        write ('Ingrese la ruta del archivo final: '); readln (nom);
        writeln;
        assign (txt, nom);
        reset (txt);
        write ('Ingrese un nombre para el nuevo archivo final: '); readln (nom);
        writeln;
        assign (f, nom);
        rewrite (f);
        while not EOF (txt) do begin
            readln (txt, info.codAlu, info.codMateria, info.fecha, info.nota);
            write (f, info);
        end;
        close (f);
    end;
    
    procedure ActualizarMaestro (var m: master; var c: cursadas; var f: finales);
    var
        infoM: infoMae;
        infoC: infoCursada;
        infoF: infoFinal;
    begin
        reset (m); reset (c); reset (f);
        LeerCursada (c, infoC);
        LeerFinal (f, infoF);
        while not eof(m) do begin
            read(m, infoM);
            while (infoC.codAlu = infoM.cod) do begin
                if (infoC.result = 'Aprobada') then
                    infoM.cursadas := infoM.cursadas + 1;
                LeerCursada(c, infoC);
            end;
            while (infoF.codAlu = infoM.cod) do begin
                if (infoF.nota >= 4) then
                    infoM.finales := infoM.finales + 1;
                LeerFinal(f, infoF);
            end;
            seek (m, filepos(m)-1);
            write (m, infoM);
        end;
        close (m); close (c); close (f);
    end;

    procedure ImprimirMaestro (var m: master);
    var
        info: infoMae;
    begin
        reset (m);
        while not EOF (m) do begin
            read (m, info);
            writeln ('código=', info.cod, ' apellido=', info.ape, ' nombre=', info.nom, ' cursadas=', info.cursadas, ' finales=', info.finales);
        end;
        close (m);
    end;
var
    maestro: master;
    cursada: cursadas;
    final: finales;
begin
    writeln;
    writeln ('--- Programa "Práctica 2, Ejercicio 7" ---');
    writeln;
    CrearNuevoMaestro (maestro);
    CrearUnArchivoCursada (cursada);
    CrearUnArchivoFinal (final);
    ActualizarMaestro (maestro, cursada, final);
    ImprimirMaestro (maestro);
    writeln ('--- Fin del Programa ---');
end.