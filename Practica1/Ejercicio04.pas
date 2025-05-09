{Agregar al menú del programa del ejercicio 3, opciones para:

a. Añadir uno o más empleados al final del archivo con sus datos ingresados por
teclado. Tener en cuenta que no se debe agregar al archivo un empleado con
un número de empleado ya registrado (control de unicidad).

b. Modificar la edad de un empleado dado.

c. Exportar el contenido del archivo a un archivo de texto llamado
“todos_empleados.txt”.

d. Exportar a un archivo de texto llamado: “faltaDNIEmpleado.txt”, los empleados
que no tengan cargado el DNI (DNI en 00).}

program Ejercicio04;
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
    
    function menu1 (): integer;
    begin
        writeln('----- Menú de opciones -----');
        writeln ('1. Crear archivo');
        writeln ('2. Abrir archivo');
        writeln ('3. Crear un archivo de texto');
        writeln ('4. Exportar un archivo de texto');
        writeln ('0. Salir');
        writeln;
        write ('Ingresar opción: '); readln(menu1);
        writeln;
    end;
    
    function menu2():integer;
    begin
        writeln('----- Abrir archivo -----');
        writeln ('1. Listar empleados con determinado nombre o apellido');
        writeln ('2. Listar todos los empleados');
        writeln ('3. Listar empleados mayores de 70');
        writeln ('4. Agregar empleado/s al final del archivo');
        writeln ('5. Modificar edad de un empleado');
        writeln ('0. Volver al menú de opciones.');
        writeln;
        write ('Ingresar opción: '); readln(menu2);
        writeln;
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
    
    procedure AbrirArchivo (var empleados: arch_emple);
    var
        nombre: string;
        valor: integer;
    begin
        write('Ingrese el nombre del archivo a abrir: '); readln(nombre);
        valor:= menu2;
        while (valor <> 0 ) do begin
            case valor of
                1: Listar_i (empleados);
                2: Listar_ii (empleados);
                3: Listar_iii (empleados);
                4: AgregarAtras (empleados);
                5: ModificarEdad (empleados);
            else
                writeln ('Opcion no válida');
            end;
            valor:= menu2;
        end;
    end;
    
var
    archivo: arch_emple;
    valor: integer;
    texto: Text;
    e : empleado;
begin
    valor:= menu1;
    while (valor <> 0 ) do begin
        case valor of
            1: CargarArchivo (archivo);
            2: AbrirArchivo (archivo);
            3: begin
                assign (texto, 'todos_empleados.txt');
                rewrite (texto);
                reset (archivo);
                while (not eof(archivo)) do begin
                    read (archivo, e);
                    writeln (texto, e.num,' ', e.nom,' ', e.ape,' ', e.edad,' ', e.dni);
                end;
                writeln ('Archivo cargado.');
                close(archivo); close(texto);
            end;
            4: begin
                assign (texto, 'faltaDNIEmpleado.txt');
                rewrite (texto);
                reset (archivo);
                while (not eof(archivo)) do begin
                    read (archivo, e);
                    if (e.dni = 0) then
                        writeln (texto, e.num,' ',e.nom,' ',e.ape,' ',e.edad,' ',e.dni);
                end;
                writeln ('Archivo exportado.');
                close (archivo); close (texto);
            end;
        else
            writeln ('Opcion no válida');
        end;
        writeln;
        valor:= menu1;
    end;
    write ('Fin del programa.');
end.