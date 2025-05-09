{2. Definir un programa que genere un archivo con registros de longitud fija conteniendo
información de asistentes a un congreso a partir de la información obtenida por
teclado. Se deberá almacenar la siguiente información: nro de asistente, apellido y
nombre, email, teléfono y D.N.I. Implementar un procedimiento que, a partir del
archivo de datos generado, elimine de forma lógica todos los asistentes con nro de
asistente inferior a 1000.

Para ello se podrá utilizar algún carácter especial situándolo delante de algún campo
String a su elección. Ejemplo: ‘@Saldaño’.}

program Ejercicio2;
type
    asistente = record
        num: integer;
        ape: string[20];
        nom: string[20];
        email: string[50];
        tel: string[15];
        dni: string[10];
    end;
    
    archivo = file of asistente;
    
    procedure Imprimir (a: asistente);
    begin
        writeln ('Número de empleado: ', a.num);
        writeln ('Nombre completo: ', a.nom,' ', a.ape);
        writeln ('DNI: ', a.dni);
        writeln ('Teléfono: ',a.tel);
        writeln ('Email: ',a.email);
        writeln;
    end;
    
    procedure Leer (var a: asistente);
    begin
        write ('Ingrese el apellido: '); readln (a.ape);
        if (a.ape <> 'fin') then begin
            write ('Ingrese el nombre: '); readln (a.nom);
            write ('Ingrese el email: '); readln (a.email);
            write ('Ingrese el teléfono: '); readln (a.tel);
            write ('Ingrese el dni: '); readln (a.dni);
            write ('Ingrese el número: '); readln (a.num);
        end;
        writeln;
    end;
    
    procedure CargarArchivo (var arc: archivo);
    var
        a: asistente;
        nombre: string;
    begin
        writeln ('---------- Cargar el archivo ----------');
        write ('Ingrese un nuevo nombre para el archivo: '); readln (nombre);
        assign (arc, nombre);
        rewrite (arc);
        Leer (a);
        while (a.ape <> 'fin') do begin
            write (arc, a);
            Leer (a);
        end;
        close (arc);
        writeln ('----- Fin de Cargar empleados -----');
        writeln;
    end;
    
    procedure ImprimirAsistentes (var arc: archivo);
    var
        a: asistente;
    begin
        writeln ('A continuación todos los asistentes: ');
        writeln;
        reset (arc);
        while not (EOF (arc)) do begin
            read (arc, a);
            Imprimir (a);
        end;
        close (arc);
    end;
    
    function Existe (var arc: archivo; num: integer): boolean;
    var
        ok: boolean;
        a: asistente;
    begin
        ok:= false;
        seek (arc, 0);
        while not (EOF(arc)) and not (ok) do begin
            read (arc, a);
            if (a.num = num) then
                ok:= true;
        end;
        seek (arc, 0);
        Existe:= ok;
    end;
    
    procedure AgregarAtras (var arc: archivo);
    var
        cant, i: integer;
        a: asistente;
    begin
        write ('¿Cuántos empleados desea agregar? '); readln (cant);
        reset (arc);
        for i:= 1 to cant do begin
            Leer (a);
            while (Existe (arc, a.num)) do begin
                write ('El nro de asistente ya existe. Ingrese otro.');
                Leer (a);
            end;
            seek (arc, filesize(arc));
            write (arc, a);
        end;
        writeln ('Nuevos asistentes agregados');
        writeln;
        close (arc);
    end;
    
    procedure EliminarAsistentes (var arc: archivo);
    var
        num: integer;
        a: asistente;
    begin
        reset(arc);
        while not eof(arc) do begin
            read(arc, a);
            if a.num < 1000 then begin
                a.nom := '@' + a.nom;
                seek (arc, filepos(arc)-1);
                write (arc, a);
            end;
        end;
        writeln ('Asistente con nro menor a 1000 eliminados');
        writeln;
        close(arc);
    end;
    
var
    asistentes: archivo;
    valor: byte;
    nombre: string;
begin
    writeln;
    writeln ('--- Programa "Práctica 3, Ejercicio 2" ---');
    writeln;
    write('Ingrese el nombre del archivo a abrir: '); readln(nombre);
    writeln;
    assign (asistentes, nombre);
    repeat
        writeln('----- Menú de opciones -----');
        writeln ('1. Crear nuevo archivo');
        writeln ('2. Agregar asistentes');
        writeln ('3. Eliminar asistentes');
        writeln ('4. Imprimir asistentes');
        writeln ('0. Salir');
        writeln;
        write ('Ingresar opción '); readln(valor);
        writeln;
        case valor of
            1: CargarArchivo (asistentes);
            2: AgregarAtras (asistentes);
            3: EliminarAsistentes (asistentes);
            4: ImprimirAsistentes (asistentes);
        end;
    until (valor = 0 );
    write ('Fin del programa.');
end.
