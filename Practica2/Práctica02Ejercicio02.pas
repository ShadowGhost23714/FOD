{2. Se dispone de un archivo con información de los alumnos de la Facultad de Informática. Por
cada alumno se dispone de su código de alumno, apellido, nombre, cantidad de materias
(cursadas) aprobadas sin final y cantidad de materias con final aprobado. Además, se tiene
un archivo detalle con el código de alumno e información correspondiente a una materia
(esta información indica si aprobó la cursada o aprobó el final).
Todos los archivos están ordenados por código de alumno y en el archivo detalle puede
haber 0, 1 ó más registros por cada alumno del archivo maestro. 

Se pide realizar un programa con opciones para:

a. Crear el archivo maestro a partir de un archivo de texto llamado “alumnos.txt”.

b. Crear el archivo detalle a partir de en un archivo de texto llamado “detalle.txt”.

c. Listar el contenido del archivo maestro en un archivo de texto llamado “reporteAlumnos.txt”.

d. Listar el contenido del archivo detalle en un archivo de texto llamado “reporteDetalle.txt”.

e. Actualizar el archivo maestro de la siguiente manera:

    i.Si aprobó el final se incrementa en uno la cantidad de materias con final aprobado.

    ii.Si aprobó la cursada se incrementa en uno la cantidad de materias aprobadas sin final.

f. Listar en un archivo de texto los alumnos que tengan más de cuatro materias
con cursada aprobada pero no aprobaron el final. Deben listarse todos los campos.

NOTA: Para la actualización del inciso e) los archivos deben ser recorridos sólo una vez.
}

program Ejercicio02;
type
    alumno = record
        codigo: integer;
        apellido: string[30];
        nombre: string[30];
        materiasSinF: integer;
        materiasConF: integer;
    end;
    
    master = file of alumno;
    
    rDetalle = record
        codigo: integer;
        materia: string[10];
    end;
    
    detalle = file of rDetalle;
    
    procedure CrearMaestro (var a: master);
    var
        alum: alumno;
        nombre: string;
        texto: text;
    begin
        assign (texto, 'alumnos.txt');
        write ('Ingrese el nombre del nuevo archivo maestro: '); readln (nombre);
        writeln;
        assign (a, nombre);
        rewrite (a);
        reset (texto);
        while not EOF (a) do begin
            readln (texto, alum.codigo, alum.apellido, alum.nombre, alum.materiasSinF, alum.materiasConF);
            write (a, alum);
        end;
        writeln ('Archivo maestro creado con éxito.');
        writeln;
        close (a); close (texto);
    end;
    
    procedure CrearDetalle (var a: detalle);
    var
        alum: rDetalle;
        nombre: string;
        texto: text;
    begin
        assign (texto, 'detalle.txt');
        write ('Ingrese el nombre del nuevo archivo detalle: '); readln (nombre);
        writeln;
        assign (a, nombre);
        rewrite (a);
        reset (texto);
        while not EOF (a) do begin
            readln (texto, alum.codigo, alum.materia);
            write (a, alum);
        end;
        writeln ('Archivo detalle creado con éxito.');
        writeln;
        close (a); close (texto);
    end;
    
    procedure ExportarMaestro (var a: master);
    var
        alum: alumno;
        texto: text;
    begin
        assign (texto, 'reporteAlumnos.txt');
        rewrite (texto);
        reset (a);
        while not EOF (a) do begin
            read (a, alum);
            writeln (texto, 'codigo ',alum.codigo,', alumno ',alum.apellido,' ',alum.nombre,', materias cursadas = ',alum.materiasSinF,', materias aprobadas = ',alum.materiasConF);
        end;
        writeln ('Archivo exportado.');
        writeln;
        close (a); close (texto);
    end;
    
    procedure ExportarDetalle (var a: detalle);
    var
        alum: rDetalle;
        texto: text;
    begin
        assign (texto, 'reporteDetalle.txt');
        rewrite (texto);
        reset (a);
        while not EOF (a) do begin
            read (a, alum);
            writeln (texto, 'codigo ',alum.codigo,', materia ',alum.materia);
        end;
        writeln ('Archivo exportado.');
        writeln;
        close (a); close (texto);
    end;
    
    procedure leer (var a: detalle; var alum: rDetalle);
    begin
        if not EOF (a) then
            read(a, alum)
        else
            alum.codigo := -1;
    end;
    
    procedure actualizarMaestro (var maestro: master; var det: detalle);
    var
        regMaster: alumno;
        regDetalle: rDetalle;
    begin
        reset (maestro);
        reset (det);
        leer (det, regDetalle);
        while (regDetalle.codigo <> -1) do begin
            read (maestro, regMaster);
            while (regDetalle.codigo = regMaster.codigo) do begin
                if (regDetalle.materia = 'cursada') then
                    regMaster.materiasSinF := regMaster.materiasSinF + 1
                else
                    regMaster.materiasConF := regMaster.materiasConF + 1;
                leer (det, regDetalle);
            end;
            seek(maestro, filepos(maestro)-1);
            write (maestro, regMaster);
        end;
        writeln ('Archivo maestro actualizado con éxito.');
        writeln;
        close (maestro); close (det);
    end;
    
    procedure ExportarCuatroCursadas (var a: master);
    var
        alum: alumno;
        texto: text;
    begin
        assign (texto, 'reporteCursadas.txt');
        rewrite (texto);
        reset (a);
        while not EOF (a) do begin
            read (a, alum);
            if (alum.materiasSinF > 4) and (alum.materiasConF = 0) then 
                writeln (texto, 'codigo ',alum.codigo,', alumno ',alum.apellido,' ',alum.nombre,', materias cursadas = ',alum.materiasSinF,', materias aprobadas = ',alum.materiasConF);
        end;
        writeln ('Archivo exportado.');
        writeln;
        close (a); close (texto);
    end;

var
    m: master;
    d: detalle;
    opcion: byte;
begin
    writeln;
    writeln ('--- Programa "Práctica 2, Ejercicio 2" ---');
    writeln;
    repeat
        writeln ('1. Crear archivo maestro a partir de "alumnos.txt".');
        writeln ('2. Crear archivo detalle a partir de "alumnos.txt".');
        writeln ('3. Exportar archivo maestro a "reporteAlumnos.txt".');
        writeln ('4. Exportar archivo detalle a "reporteDetalle.txt".');
        writeln ('5. Actualizar el archivo maestro.');
        writeln ('6. Exportar alumnos con más de cuatro materias con cursada aprobada pero no aprobaron el final a "reporteCursadas.txt".');
        writeln ('0. Finalizar.');
        writeln;
        write ('Elegir opción '); readln (opcion);
        writeln;
        case opcion of
            1: CrearMaestro (m);
            2: CrearDetalle (d);
            3: ExportarMaestro (m);
            4: ExportarDetalle (d);
            5: actualizarMaestro (m, d);
            6: ExportarCuatroCursadas (m);
        end;
    until (opcion = 0);
    writeln ('--- Fin del Programa ---');
end.