{Una empresa posee un archivo con información de los ingresos percibidos por diferentes
empleados en concepto de comisión, de cada uno de ellos se conoce: código de empleado,
nombre y monto de la comisión. La información del archivo se encuentra ordenada por
código de empleado y cada empleado puede aparecer más de una vez en el archivo de
comisiones.

Realice un procedimiento que reciba el archivo anteriormente descripto y lo compacte. En
consecuencia, deberá generar un nuevo archivo en el cual, cada empleado aparezca una
única vez con el valor total de sus comisiones.

NOTA: No se conoce a priori la cantidad de empleados. Además, el archivo debe ser
recorrido una única vez.}

program Ejercicio01;
type
    empleado = record
        codigo: integer;
        nombre: string[30];
        monto: real;
    end;
    
    archivo = file of empleado;
    
    procedure compactarArchivo (var a: archivo; var t: text);
    var
        e: empleado;
        nombre: string;
    begin
        write ('Ingrese el nombre del nuevo archivo: '); readln (nombre);
        writeln;
        assign (a, nombre);
        rewrite (a);
        reset (t);
        while not EOF (a) do begin
            readln (t, e.codigo, e.nombre, e.monto);
            write (a, e);
        end;
        close (a); close (t);
    end;
    
    procedure leer (var a: archivo; var e: empleado);
    begin
        if not EOF (a) then
            read(a, e)
        else
            e.codigo := -1;
    end;
    
    procedure actualizarArchivo (var a: archivo; var nue: archivo);
    var
        e, act: empleado;
        total: real;
    begin
        assign (nue, 'ArchivoActualizado');
        rewrite (nue);
        reset (a);
        leer (a, e);
        while (e.codigo <> -1) do begin
            act := e;
            total := 0;
            while (e.codigo = act.codigo) do begin
                total:= total + e.monto;
                leer (a, e);
            end;
            act.monto := total;
            write (nue, act);
        end;
        close (a); close (nue);
    end;
    
    procedure imprimirArchivo (var a: archivo);
    var
        e: empleado;
    begin
        writeln ('Todos los empleados: ');
        writeln;
        reset (a);
        while not EOF (a) do begin
            read (a, e);
            writeln ('Código = ',e.codigo,', Nombre = ',e.nombre,', Monto = ',e.monto);
        end;
        close (a);
    end;

var
    texto: text;
    nombre: string;
    archCompact, arch: archivo;
begin
    writeln;
    writeln ('--- Programa "Práctica 2, Ejercicio 1" ---');
    writeln;
    assign (texto, 'empleados.txt');
    compactarArchivo (archCompact, texto);
    actualizarArchivo (archCompact, arch);
    imprimirArchivo (arch);
    writeln ('--- Fin del Programa ---');
end.