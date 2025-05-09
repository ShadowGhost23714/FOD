{3. Realizar un programa que genere un archivo de novelas filmadas durante el presente
año. De cada novela se registra: código, género, nombre, duración, director y precio.
El programa debe presentar un menú con las siguientes opciones:

a. Crear el archivo y cargarlo a partir de datos ingresados por teclado. Se
utiliza la técnica de lista invertida para recuperar espacio libre en el
archivo. Para ello, durante la creación del archivo, en el primer registro del
mismo se debe almacenar la cabecera de la lista. Es decir un registro
ficticio, inicializando con el valor cero (0) el campo correspondiente al
código de novela, el cual indica que no hay espacio libre dentro del
archivo.

b. Abrir el archivo existente y permitir su mantenimiento teniendo en cuenta el
inciso a), se utiliza lista invertida para recuperación de espacio. En
particular, para el campo de “enlace” de la lista (utilice el código de
novela como enlace), se debe especificar los números de registro
referenciados con signo negativo, . Una vez abierto el archivo, brindar
operaciones para:

i. Dar de alta una novela leyendo la información desde teclado. Para
esta operación, en caso de ser posible, deberá recuperarse el
espacio libre. Es decir, si en el campo correspondiente al código de
novela del registro cabecera hay un valor negativo, por ejemplo -5,
se debe leer el registro en la posición 5, copiarlo en la posición 0
(actualizar la lista de espacio libre) y grabar el nuevo registro en la
posición 5. Con el valor 0 (cero) en el registro cabecera se indica
que no hay espacio libre.

ii. Modificar los datos de una novela leyendo la información desde
teclado. El código de novela no puede ser modificado.

iii. Eliminar una novela cuyo código es ingresado por teclado. Por
ejemplo, si se da de baja un registro en la posición 8, en el campo
código de novela del registro cabecera deberá figurar -8, y en el
registro en la posición 8 debe copiarse el antiguo registro cabecera.

c. Listar en un archivo de texto todas las novelas, incluyendo las borradas, que
representan la lista de espacio libre. El archivo debe llamarse “novelas.txt”.
NOTA: Tanto en la creación como en la apertura el nombre del archivo debe ser
proporcionado por el usuario.}

program Ejercicio3;
type
    novela = record
        cod: integer;
        nom: string[30];
        gen: string[20];
        dur: integer;
        dire: string[20];
        precio: real;
    end;
    
    archivo = file of novela;
    
    procedure Imprimir (n: novela);
    begin
        writeln ('Código: ',n.cod);
        writeln ('Nombre: ',n.nom);
        writeln ('Género: ',n.gen);
        writeln ('Duración: ',n.dur,' episodios');
        writeln ('Director: ',n.dire);
        writeln ('Precio: ',n.precio:0:2);
        writeln;
    end;
    
    procedure Leer (var n: novela);
    begin
        write ('Ingrese el código: '); readln (n.cod);
        if (n.cod <> -1) then begin
            write ('Ingrese el nombre: '); readln (n.nom);
            write ('Ingrese el género: '); readln (n.gen);
            write ('Ingrese la duración: '); readln (n.dur);
            write ('Ingrese el director: '); readln (n.dire);
            write ('Ingrese el precio: '); readln (n.precio);
        end;
        writeln;
    end;
    
    procedure CargarArchivo (var arc: archivo);
    var
        n: novela;
        nombre: string;
    begin
        writeln ('---------- Cargar el archivo ----------');
        write ('Ingrese un nuevo nombre para el archivo: '); readln (nombre);
        assign (arc, nombre);
        rewrite (arc);
        n.cod:= 0;
        n.gen:= '';
        n.nom:= '';
        n.dur:= 0;
        n.dire:= '';
        n.precio:= 0;
        write(arc, n);
        Leer (n);
        while (n.cod <> -1) do begin
            write (arc, n);
            Leer (n);
        end;
        close (arc);
        writeln ('----- Fin de Carga -----');
        writeln;
    end;
    
    procedure Alta (var arc: archivo);
    var
        cab, n: novela;
    begin
        reset (arc);
        read (arc, cab);
        Leer (n);
        if (cab.cod = 0) then begin
            seek (arc, filesize(arc));
            write (arc, n);
        end
        else begin
            seek (arc, cab.cod * -1);
            read (arc, cab);
            seek (arc, filepos(arc)-1);
            write (arc, n);
            seek (arc, 0);
            write (arc, cab);
        end;
        close (arc);
    end;
    
    procedure Modificar (var n: novela);
    var
        valor: byte;
    begin
        writeln ('----- Menú de novela -----');
        writeln;
        repeat
            writeln ('1. Modificar la novela entera (el código no puede ser modificado)');
            writeln ('2. Modificar el nombre');
            writeln ('3. Modificar el género');
            writeln ('4. Modificar la duración');
            writeln ('5. Modificar el director');
            writeln ('6. Modificar el precio');
            writeln ('0. Salir');
            writeln;
            write ('Elegir opción '); readln (valor);
            writeln;
            case valor of 
                1: begin
                    write ('Ingrese el nombre: '); readln (n.nom);
                    write ('Ingrese el género: '); readln (n.gen);
                    write ('Ingrese la duración: '); readln (n.dur);
                    write ('Ingrese el director: '); readln (n.dire);
                    write ('Ingrese el precio: '); readln (n.precio);
                end;
                2: begin write ('Ingrese el nombre: '); readln (n.nom); end;
                3: begin write ('Ingrese el género: '); readln (n.gen); end;
                4: begin write ('Ingrese la duración: '); readln (n.dur); end;
                5: begin write ('Ingrese el director: '); readln (n.dire); end;
                6: begin write ('Ingrese el precio: '); readln (n.precio); end;
            end;
            writeln;
        until (valor = 0);
    end;
    
    procedure ModificarNovela (var arc: archivo);
    var
        n: novela;
        cod: integer;
        ok: boolean;
    begin
        ok:= false;
        reset (arc);
        write ('Ingrese el código del la novela a modificar: '); readln (cod);
        writeln;
        while not eof(arc) and not ok do begin
            read (arc, n);
            if (n.cod = cod) then begin
                ok:= true;
                Modificar (n);
                seek (arc, filepos(arc)-1);
                write (arc, n);
            end;
        end;
        if ok then
            writeln ('Se modifico la novela con el código ',cod)
        else
            writeln ('No se encontro la novela con el código ',cod);
        writeln;
        close (arc);
    end;
    
    procedure Baja (var arc: archivo);
    var
        cab, n: novela;
        cod: integer;
        ok: boolean;
    begin
        ok:= false;
        reset (arc);
        write ('Ingrese el código de la novela a eliminar: '); readln (cod); 
        writeln;
        read (arc, cab);
        while not eof(arc) and not ok do begin
            read (arc, n);
            if (n.cod = cod) then begin
                ok:= true;
                seek (arc, filepos(arc)-1);
                write (arc, cab);
                cab.cod:= (filepos(arc)-1)*-1;
                seek (arc, 0);
                write (arc, cab);
            end;
        end;
        if ok then
            writeln ('Se elimino la novela con el código ',cod)
        else
            writeln ('No se encontro la novela con el código ',cod);
        writeln;
        close (arc);
    end;
    
    procedure CrearArchivoTxt (var arc: archivo);
    var
        n: novela;
        txt: text;
    begin
        assign (txt, 'novelas.txt');
        rewrite (txt);
        reset (arc);
        seek (arc, 1);
        while not eof(arc) do begin
            read (arc, n);
            if (n.cod < 1) then
                writeln (txt, 'Novela eliminada');
            writeln (txt, 'Código: ', n.cod, ', Género: ', n.gen, ', Nombre: ', n.nom, ', Duración: ', n.dur,' episodios, Director: ', n.dire, ', Precio: ', n.precio:0:2);
            writeln (txt);
        end;
        writeln ('Archivo de texto creado');
        writeln;
        close (arc); close (txt);
    end;
    
    procedure ImprimirNovelas (var arc: archivo);
    var
        n: novela;
    begin
        writeln ('A continuación todos las novelas: ');
        writeln;
        reset (arc);
        while not (EOF (arc)) do begin
            read (arc, n);
            Imprimir (n);
        end;
        close (arc);
    end;
    
var
    novelas: archivo;
    valor: byte;
    nombre: string;
begin
    writeln;
    writeln ('--- Programa "Práctica 3, Ejercicio 3" ---');
    writeln;
    write('Ingrese el nombre del archivo a abrir: '); readln(nombre);
    writeln;
    assign (novelas, nombre);
    repeat
        writeln('----- Menú de opciones -----');
        writeln ('1. Crear nuevo archivo');
        writeln ('2. Agregar novela');
        writeln ('3. Modificar novela');
        writeln ('4. Eliminar novela');
        writeln ('5. Crear archivo de texto "novelas.txt"');
        writeln ('6. Imprimir novelas');
        writeln ('0. Salir');
        writeln;
        write ('Ingresar opción '); readln(valor);
        writeln;
        case valor of
            1: CargarArchivo (novelas);
            2: Alta (novelas);
            3: ModificarNovela (novelas);
            4: Baja (novelas);
            5: CrearArchivoTxt (novelas);
            6: ImprimirNovelas (novelas);
        end;
    until (valor = 0 );
    write ('Fin del programa.');
end.
