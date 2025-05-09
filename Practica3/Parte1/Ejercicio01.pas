{1. Modificar el ejercicio 4 de la práctica 1 (programa de gestión de empleados),
agregándole una opción para realizar bajas copiando el último registro del archivo en
la posición del registro a borrar y luego truncando el archivo en la posición del último
registro de forma tal de evitar duplicados.}

program Ejercicio1;
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
        writeln ('Número de empleado: ', e.num);
        writeln ('Nombre completo: ', e.nom,' ', e.ape);
        writeln ('Edad: ',e.edad);
        writeln ('DNI: ', e.dni);
        writeln ('--------------------');
    end;
    
    procedure Leer (var e: empleado);
    begin
        write ('Ingrese el apellido: '); readln (e.ape);
        if (e.ape <> 'fin') then begin
            write ('Ingrese el nombre: '); readln (e.nom);
            write ('Ingrese la edad: '); readln (e.edad);
            write ('Ingrese el dni: '); readln (e.dni);
            write ('Ingrese el número: '); readln (e.num);
        end;
        writeln ('--------------------');
    end;
    
    procedure CargarArchivo (var empleados: arch_emple);
    var
        e: empleado;
        nombre: string;
    begin
        writeln ('---------- Cargar el archivo ----------');
        write ('Ingrese un nombre para el archivo: '); readln (nombre);
        assign (empleados, nombre);
        rewrite (empleados);
        Leer (e);
        while (e.ape <> 'fin') do begin
            write (empleados, e);
            Leer (e);
        end;
        close (empleados);
        writeln ('----- Fin de Cargar empleados -----');
        writeln;
    end;
    
    procedure Listar_i (var empleados: arch_emple);
    var
        nomape: string;
        e: empleado;
    begin
        write ('Ingrese el a buscar nombre o apellido: '); readln (nomape);
        reset (empleados);
        writeln('Empleados con ese nombre o apellido:');
        while not (EOF (empleados)) do begin
            read (empleados, e);
            if (nomape = e.ape) or (nomape = e.nom) then
                Imprimir (e);
        end;
        close (empleados);
    end;
    
    procedure Listar_ii (var empleados: arch_emple);
    var
        e: empleado;
    begin
        writeln ('Todos los empleados:');
        reset (empleados);
        while not (EOF (empleados)) do begin
            read (empleados, e);
            Imprimir (e);
        end;
        close (empleados);
    end;
    
    procedure Listar_iii (var empleados: arch_emple);
    var
        e: empleado;
    begin
        writeln ('Empleados mayores de 70:');
        reset (empleados);
        while not (EOF (empleados)) do begin
            read (empleados, e);
            if (e.edad > 70) then
            Imprimir (e);
        end;
        close (empleados);
    end;
    
    function Existe (var ae: arch_emple; num: integer): boolean;
    var
        ok: boolean;
        e: empleado;
    begin
        ok:= false;
        seek (ae, 0);
        while not (EOF(ae)) and not (ok) do begin
            read (ae, e);
            if (e.num = num) then
                ok:= true;
        end;
        seek (ae, 0);
        Existe:= ok;
    end;
    
    procedure AgregarAtras (var ae: arch_emple);
    var
        cant, i: integer;
        e: empleado;
    begin
        write ('¿Cuántos empleados desea agregar? '); readln (cant);
        reset (ae);
        for i:= 1 to cant do begin
            Leer (e);
            while (Existe (ae, e.num)) do begin
                write ('El nro de empleado ya existe. Ingrese otro.');
                Leer (e);
            end;
            seek (ae, filesize(ae));
            write (ae, e);
        end;
        close (ae);
    end;
    
    procedure ModificarEdad (var ae: arch_emple);
    var
        e: empleado;
        num, edad: integer;
        encontre: boolean;
    begin
        write ('Ingrese el nro de empleado a modificar su edad: '); readln (num);
        reset (ae);
        if (Existe (ae, num)) then begin
            encontre:= false;
            while not (EOF (ae)) and not (encontre) do begin
                read (ae, e);
                if (e.num = num) then begin
                    encontre:= true;
                    write ('Ingrese la nueva edad  (edad actual: ',e.edad,'): '); readln (edad);
                    e.edad:= edad;
                    seek (ae, filePos(ae)-1);
                    write (ae, e);
                end;
            end;
        end else
            writeln ('Empleado no encontrado');
        close (ae);
    end;
    
    procedure EliminarEmpleado (var a: arch_emple);
    var
        cod: integer;
        ultEmp, e: empleado;
    begin
        reset(a);
        write ('Ingrese el codigo del empleado a eliminar: '); readln(cod);
        seek(a, fileSize(a)-1);
        read(a, ultEmp);
        seek(a, 0);
        read(a, e);
        while(not eof(a) and (e.num <> cod)) do
            read(a, e);
        if(e.num = cod) then begin
            seek(a, filePos(a)-1);
            write(a, ultEmp);
            seek(a, fileSize(a)-1);
            truncate(a);
            writeln ('Se encontro el empleado con código ', cod , ' y se realizo la baja correctamente');
        end
        else
            writeln ('No se encontro el empleado con código ', cod , ' y no se realizo ninguna baja');
        writeln;
        close(a);
    end;
    
    procedure AbrirArchivo (var empleados: arch_emple);
    var
        nombre: string;
        valor: byte;
    begin
        repeat
            writeln('----- Modificar archivo -----');
            writeln ('1. Listar empleados con determinado nombre o apellido');
            writeln ('2. Listar todos los empleados');
            writeln ('3. Listar empleados mayores de 70');
            writeln ('4. Agregar empleado/s al final del archivo');
            writeln ('5. Modificar edad de un empleado');
            writeln ('6. Eliminar un empleado');
            writeln ('0. Volver al menú de opciones.');
            writeln;
            write ('Ingresar opción '); readln(valor);
            writeln;
            case valor of
                1: Listar_i (empleados);
                2: Listar_ii (empleados);
                3: Listar_iii (empleados);
                4: AgregarAtras (empleados);
                5: ModificarEdad (empleados);
                6: EliminarEmpleado (empleados);
            end;
        until (valor = 0);
    end;
    
    procedure ExportarArchivoDeTexto (var a: arch_emple);
    var
        txt: text;
        e: empleado;
    begin
        assign (txt, 'todos_empleados.txt');
        rewrite (txt);
        reset (a);
        while (not eof(a)) do begin
            read (a, e);
            writeln (txt, e.num,' ', e.nom,' ', e.ape,' ', e.edad,' ', e.dni);
        end;
        writeln ('Archivo cargado.');
        close(a); close(txt);
    end;
    
    procedure ExportarDniFaltante (var a: arch_emple);
    var
        txt: text;
        e: empleado;
    begin
        assign (txt, 'faltaDNIEmpleado.txt');
        rewrite (txt);
        reset (a);
        while (not eof(a)) do begin
            read (a, e);
            if (e.dni = 0) then
                writeln (txt, e.num,' ',e.nom,' ',e.ape,' ',e.edad,' ',e.dni);
        end;
        writeln ('Archivo exportado.');
        close (a); close (txt);
    end;
    
var
    archivo: arch_emple;
    valor: byte;
    nombre: string;
begin
    writeln;
    writeln ('--- Programa "Práctica 3, Ejercicio 1" ---');
    writeln;
    write('Ingrese el nombre del archivo a abrir: '); readln(nombre);
    writeln;
    assign (archivo, nombre);
    repeat
        writeln('----- Menú de opciones -----');
        writeln ('1. Crear nuevo archivo');
        writeln ('2. Modificar archivo');
        writeln ('3. Exportar un archivo de texto');
        writeln ('4. Exportar un archivo de texto con los empleadaos sin dni');
        writeln ('0. Salir');
        writeln;
        write ('Ingresar opción '); readln(valor);
        writeln;
        case valor of
            1: CargarArchivo (archivo);
            2: AbrirArchivo (archivo);
            3: ExportarArchivoDeTexto (archivo);
            4: ExportarDniFaltante (archivo);
        end;
    until (valor = 0 );
    write ('Fin del programa.');
end.
