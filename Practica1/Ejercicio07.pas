{7. Realizar un programa que permita:

a. Crear un archivo binario a partir de la información almacenada en un archivo de texto.
El nombre del archivo de texto es: “novelas.txt”

b. Abrir el archivo binario y permitir la actualización del mismo. Se debe poder agregar
una novela y modificar una existente. Las búsquedas se realizan por código de novela.

NOTA: La información en el archivo de texto consiste en: código de novela,
nombre,género y precio de diferentes novelas argentinas. De cada novela se almacena la
información en dos líneas en el archivo de texto. La primera línea contendrá la siguiente
información: código novela, precio, y género, y la segunda línea almacenará el nombre
de la novela.}

program Ejercicio07;
type
    novela = record
        cod: integer;
        nom: string;
        gen: string;
        precio: real;
    end;
    
    archivo = file of novela;
    
    procedure leer (var n: novela);
    begin
        write ('Ingrese el código: '); readln (n.cod);
        if (n.cod <> 0) then begin
            write ('Ingrese el nombre: '); readln (n.nom);
            write ('Ingrese el género: '); readln (n.gen);
            write ('Ingrese el precio: '); readln (n.precio);
        end;
        writeln ('----------');
        writeln;
    end;
    
    procedure crearArchivo (var a: archivo);
    var
        n: novela;
        t: text;
    begin
        writeln ('--- Creación de archivo ---');
        writeln;
        assign (t, 'novelas.txt');
        reset (t);
        rewrite (a);
        while not EOF(t) do begin
            readln (t, n.cod, n.precio, n.gen);
            readln (t, n.nom);
            write (a, n);
        end;
        close (a); close (t);
        writeln ('Archivo guardado con éxito.');
        writeln;
    end;
    
    function Existe (var a: archivo; cod: integer): boolean;
    var
        n: novela;
    begin
        Existe:= false;
        seek (a, 0);
        while not EOF(a) do begin
            read (a, n);
            if (n.cod = cod) then begin
                Existe:= true;
                exit;
            end;
        end;
        seek (a, 0);
    end;
    
    procedure agregarNovela (var a: archivo);
    var
        cant, i: integer;
        n: novela;
    begin
        writeln ('--- Agregar novelas ---');
        writeln;
        write ('¿Cuántos novelas desea agregar? : '); readln (cant);
        writeln;
        reset (a);
        for i:= 1 to cant do begin
            leer (n);
            while (Existe (a, n.cod)) do begin
                writeln ('El código de novela ya existe. Ingrese otro.');
                writeln;
                leer (n);
            end;
            seek (a, filesize(a));
            write (a, n);
        end;
        writeln ('--- Agregar finalizado ---');
        writeln;
        close (a);
    end;

    procedure modificarNovela (var a: archivo);
    var
        n: novela;
        cod: integer;
        encontre: boolean;
    begin
        writeln ('--- Modificación de stock ---');
        writeln;
        write ('Ingrese el código de la novela a modificar: '); readln (cod);
        writeln;
        encontre:= false;
        reset (a);
        while not EOF (a) and not (encontre) do begin
            read (a, n);
            if (n.cod = cod) then begin
                encontre:= true;
                writeln ('Ingrese los nuevos datos (Datos actuales = nombre: ',n.nom,', género: ',n.gen,', precio: ',n.precio,').'); 
                writeln('Ingrese el nuevo nombre: '); readln(n.nom);
                writeln('Ingrese el nuevo género: '); readln(n.gen);
                writeln('Ingrese el nuevo precio: '); readln(n.precio);
                seek (a, filePos(a)-1);
                write (a, n);
                writeln;
                writeln ('Novela actualizada con éxito.');
            end;
        end;
        if not (encontre) then writeln ('Novela no encontrada.');
        writeln;
        writeln ('--- Fin de la modificación ---');
        writeln;
        close (a);
    end;
    
var
    novelas: archivo;
    valor: byte;
    nombre: string;
begin
    writeln;
    writeln ('--- Programa "Práctica 1, Ejercicio 7" ---');
    writeln;
    write ('Ingrese el nombre del archivo para empezar: '); readln (nombre);
    writeln;
    assign (novelas, nombre);
    repeat
        writeln ('1. Crear archivo binario desde novelas.txt.');
        writeln ('2. Agregar una novela');
        writeln ('3. Modificar una novela');
        writeln ('0. Salir');
        writeln;
        write ('Ingresar opción: '); readln (valor);
        writeln;
        case valor of
            1: crearArchivo (novelas);
            2: agregarNovela (novelas);
            3: modificarNovela (novelas);
        end;
    until (valor = 0);
    writeln ('--- Fin del Programa ---');
end.