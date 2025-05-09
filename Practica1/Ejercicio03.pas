{Realizar un programa que presente un menú con opciones para:

a. Crear un archivo de registros no ordenados de empleados y completarlo con
datos ingresados desde teclado. De cada empleado se registra: número de
empleado, apellido, nombre, edad y DNI. Algunos empleados se ingresan con
DNI 00. La carga finaliza cuando se ingresa el String ‘fin’ como apellido.
    
b. Abrir el archivo anteriormente generado y

i. Listar en pantalla los datos de empleados que tengan un nombre o apellido
determinado, el cual se proporciona desde el teclado.

ii. Listar en pantalla los empleados de a uno por línea.

iii. Listar en pantalla los empleados mayores de 70 años, próximos a jubilarse.

NOTA: El nombre del archivo a crear o utilizar debe ser proporcionado por el usuario.}

program Ejercicio03;
type
    empleado = record
        num: integer;
        ape: string;
        nom: string;
        edad: integer;
        dni: integer;
    end;
    
    arch_emple = file of empleado;
    
    procedure Imprimir (e: empleado);
    begin
        writeln ('Empleado número ', e.num);
        writeln ('Nombre completo ', e.ape,' ', e.nom);
        writeln (e.edad, ' años');
        writeln ('DNI ', e.dni);
        writeln ('--------------------');
    end;
    
    procedure Leer (var e: empleado);
    begin
        writeln ('Ingrese el número.');
        readln (e.num);
        writeln ('Ingrese el apellido.');
        readln (e.ape);
        writeln ('Ingrese el nombre.');
        readln (e.nom);
        writeln ('Ingrese la edad.');
        readln (e.edad);
        writeln ('Ingrese el dni.');
        readln (e.dni);
        writeln ('--------------------');
    end;
    
    procedure CargarEmpleados (var empleados: arch_emple);
    var
        e: empleado;
    begin
        writeln ('---------- Cargar empleados ----------');
        Leer (e);
        while (e.ape <> 'fin') do begin
            write (empleados, e);
            Leer (e);
        end;
        writeln ('----- Fin de Cargar empleados -----');
        writeln;
    end;
    
    procedure Listar_i (var empleados: arch_emple);
    var
        apellido: string;
        e: empleado;
    begin
        writeln ('---------- Listar i ----------');
        writeln ('Ingrese el apellido');
        readln (apellido);
        while not (EOF (empleados)) do begin
            read (empleados, e);
            if (apellido = e.ape) then
                Imprimir (e);
        end;
        writeln ('----- Fin de Listar i -----');
        writeln;
    end;
    
    procedure Listar_ii (var empleados: arch_emple);
    var
        e: empleado;
    begin
        writeln ('---------- Listar ii ----------');
        while not (EOF (empleados)) do begin
            read (empleados, e);
            Imprimir (e);
        end;
        writeln ('----- Fin de Listar ii -----');
        writeln;
    end;
    
    procedure Listar_iii (var empleados: arch_emple);
    var
        e: empleado;
    begin
        writeln ('---------- Listar iii ----------');
        while not (EOF (empleados)) do begin
            read (empleados, e);
            if (e.edad > 70) then
            Imprimir (e);
        end;
        writeln ('----- Fin de Listar iii -----');
        writeln;
    end;

var
    empleados: arch_emple;
    nombre: string;
    valor: integer;
begin
    writeln ('Ingrese un nombre para el archivo.');
    readln (nombre);
    assign (empleados, nombre);
    rewrite (empleados);
    writeln ('Ingrese 0 - Finalizar / 1 - Cargar empleados / 2 - Listar_i / 3 - Listar_ii / 4 - Listar_iii.');
    readln (valor);
    while (valor <> 0 ) do begin
        case valor of
            1: CargarEmpleados (empleados);
            2: Listar_i (empleados);
            3: Listar_ii (empleados);
            4: Listar_iii (empleados);
            else
                writeln ('Opcion no válida');
        end;
        seek (empleados, 0); // reset (empleados);
        writeln ('Ingrese 0 - Finalizar / 1 - Cargar empleados / 2 - Listar_i / 3 - Listar_ii / 4 - Listar_iii.');
        readln (valor);
    end;
    close (empleados);
end.