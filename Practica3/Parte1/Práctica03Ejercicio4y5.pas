{4. Dada la siguiente estructura:
    
type
    reg_flor = record
        nombre: String[45];
        codigo: integer;
    end;
    
    tArchFlores = file of reg_flor;
    
Las bajas se realizan apilando registros borrados y las altas reutilizando registros
borrados. El registro 0 se usa como cabecera de la pila de registros borrados: el
número 0 en el campo código implica que no hay registros borrados y -N indica que el
próximo registro a reutilizar es el N, siendo éste un número relativo de registro válido.

a. Implemente el siguiente módulo:
(Abre el archivo y agrega una flor, recibida como parámetro
manteniendo la política descrita anteriormente)

procedure agregarFlor (var a: tArchFlores ; nombre: string; codigo:integer);

b. Liste el contenido del archivo omitiendo las flores eliminadas. Modifique lo que
considere necesario para obtener el listado.
    
5. Dada la estructura planteada en el ejercicio anterior, implemente el siguiente módulo:
(Abre el archivo y elimina la flor recibida como parámetro manteniendo
la política descripta anteriormente)

procedure eliminarFlor (var a: tArchFlores; flor:reg_flor);}

program Ejercicio4y5;
type
    reg_flor = record
        nombre: String[45];
        codigo: integer;
    end;
    
    tArchFlores = file of reg_flor;
    
    procedure Leer (var f: reg_flor);
    begin
        write ('Ingrese el codigo: '); readln (f.codigo);
        write ('Ingrese el nombre: '); readln (f.nombre);
        writeln;
    end;
    
    procedure Imprimir (f: reg_flor);
    begin
        writeln ('Código: ',f.codigo);
        writeln ('Nombre: ',f.nombre);
        writeln;
    end;
    
    procedure CargarArchivo (var arc: tArchFlores);
    var
        f: reg_flor;
        nombre: string;
    begin
        writeln ('---------- Cargar el archivo ----------');
        write ('Ingrese un nombre para el archivo: '); readln (nombre);
        assign (arc, nombre);
        rewrite (arc);
        f.nombre:= '';
        f.codigo:= 0;
        write(arc, f);
        Leer (f);
        while (f.codigo <> -1) do begin
            write (arc, f);
            Leer (f);
        end;
        close (arc);
        writeln ('----- Fin de Carga -----');
        writeln;
    end;
    
    procedure agregarFlor (var arc: tArchFlores ; nombre: string; codigo:integer);
    var
        cab, f: reg_flor;
    begin
        reset (arc);
        read (arc, cab);
        f.nombre:= nombre;
        f.codigo:= codigo;
        if (cab.codigo = 0) then begin
            seek (arc, filesize(arc));
            write (arc, f);
        end
        else begin
            seek (arc, cab.codigo * -1);
            read (arc, cab);
            seek (arc, filepos(arc)-1);
            write (arc, f);
            seek (arc, 0);
            write (arc, cab);
        end;
        close (arc);
    end;
    
    procedure ImprimirFlores (var arc: tArchFlores);
    var
        f: reg_flor;
    begin
        writeln ('A continuación todos las flores: ');
        writeln;
        reset (arc);
        while not (EOF (arc)) do begin
            read (arc, f);
            if (f.codigo > 0) then
                Imprimir (f);
        end;
        close (arc);
    end;
    
    procedure eliminarFlor (var arc: tArchFlores; flor:reg_flor);
    var
        cab, f: reg_flor;
        ok: boolean;
    begin
        ok:= false;
        reset (arc);
        read (arc, cab);
        while not eof(arc) and not ok do begin
            read (arc, f);
            if (f.codigo = flor.codigo) then begin
                ok:= true;
                seek (arc, filepos(arc)-1);
                write (arc, cab);
                cab.codigo:= (filepos(arc)-1)*-1;
                seek (arc, 0);
                write (arc, cab);
            end;
        end;
        if ok then
            writeln ('Se elimino la flor con el código ',flor.codigo)
        else
            writeln ('No se encontro la flor con el código ',flor.codigo);
        writeln;
        close (arc);
    end;
    
var
    flores: tArchFlores;
    f: reg_flor;
begin
    writeln;
    writeln ('--- Programa "Práctica 3, Ejercicio 4y5" ---');
    writeln;
    CargarArchivo (flores);
    ImprimirFlores (flores);
    agregarFlor (flores, 'amapola', 5);
    agregarFlor (flores, 'geranio', 6);
    ImprimirFlores (flores);
    f.codigo:= 5;
    eliminarFlor (flores, f);
    ImprimirFlores (flores);
    write ('Fin del programa.');
end.