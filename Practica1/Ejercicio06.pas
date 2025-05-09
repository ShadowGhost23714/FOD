{6. Agregar al menú del programa del ejercicio 5, opciones para:

a. Añadir uno o más celulares al final del archivo con sus datos ingresados por
teclado.

b. Modificar el stock de un celular dado.

c. Exportar el contenido del archivo binario a un archivo de texto denominado:
”SinStock.txt”, con aquellos celulares que tengan stock 0.

NOTA: Las búsquedas deben realizarse por nombre de celular.}

program Ejercicio06;
type
    celular = record
        cod: integer;
        nom: string;
        desc: string;
        marca: string;
        precio: real;
        stockMin: integer;
        stockDisp: integer;
    end;
    
    archivo = file of celular;
    
    procedure leer (var c: celular);
    begin
        write ('Ingrese el código: '); readln (c.cod);
        if (c.cod <> 0) then begin
            write ('Ingrese el nombre: '); readln (c.nom);
            write ('Ingrese la descripción: '); readln (c.desc);
            write ('Ingrese la marca: '); readln (c.marca);
            write ('Ingrese el precio: '); readln (c.precio);
            write ('Ingrese el stock mínimo: '); readln (c.stockMin);
            write ('Ingrese el stock disponible: '); readln (c.stockDisp);
        end;
        writeln ('----------');
        writeln;
    end;
    
    procedure imprimir (c: celular);
    begin
        writeln ('Código = ',c.cod);
        writeln ('Nombre : ',c.nom,' - Marca : ',c.marca,' - Precio : ',c.precio);
        writeln ('Descripción : ',c.desc);
        writeln ('stock disponible : ', c.stockDisp);
        writeln ('stock mínimo : ',c.stockMin);
        writeln ('----------');
        writeln;
    end;
    
    function menu (): byte;
    begin
        writeln;
        writeln ('1. Crear archivo.');
        writeln ('2. Listar celulares con stock menor al stock mínimo');
        writeln ('3. Listar celulares cuya descripción contenga una cadena de caracteres proporcionada por el usuario.');
        writeln ('4. Exportar el archivo.');
        writeln ('5. Añadir uno o más celulares.');
        writeln ('6. Modificar el stock de un celular dado.');
        writeln ('7. Exportar el archivo con aquellos celulares que tengan stock 0.');
        writeln ('0. Finalizar.');
        writeln;
        write ('Ingresar opción: '); readln (menu);
        writeln;
    end;
    
    procedure crearArchivo (var a: archivo);
    var
        c: celular;
    begin
        writeln ('--- Creación de archivo ---');
        writeln;
        rewrite (a);
        leer (c);
        while (c.cod <> 0) do begin
            write (a, c);
            leer (c);
        end;
        close (a);
        writeln ('--- Archivo guardado ---');
        writeln;
    end;
    
    procedure listarStockMenorAlMin (var a: archivo);
    var
        c: celular;
    begin
        writeln ('--- Búsqueda de stock menor al stock mínimo ---');
        writeln;
        reset (a);
        while not (EOF(a)) do begin
            read (a, c);
            if (c.stockDisp < c.stockMin) then
                imprimir (c);
        end;
        close (a);
        writeln ('--- Fin de la búsqueda ---');
        writeln;
    end;
    
    procedure listarPorDescripcion(var a: archivo);
    var
        buscado: string;
        c: celular;
    begin
        writeln ('--- Búsqueda de cadena de caracteres --- ');
        writeln;
        write('Ingrese la palabra o frase a buscar en la descripción: '); readln(buscado);
        writeln;
        writeln('Celulares con "', buscado, '" en la descripción:');
        writeln;
        reset(a);
        while not EOF(a) do begin
            read (a, c);
            if ((pos(buscado, c.desc)) <> 0) then  // Si la palabra está en la descripción
                imprimir (c);
        end;
        close(a);
        writeln ('--- Fin de la búsqueda ---');
    end;
    
    procedure exportarArchivoTexto (var a: archivo);
    var
        c: celular;
        t: text;
    begin
        assign (t, 'celulares.txt');
        rewrite (t);
        reset (a);
        while not EOF(a) do begin
            read (a, c);
            writeln (t, c.marca,' / ',c.nom,' / ',c.precio:0:2,' / ', c.cod,' / ',c.desc,' / ',c.stockMin,' / ',c.stockDisp);
            writeln (t);
        end;
        close (a); close (t);
        writeln ('--- Archivo exportado a formato ".txt" ---');
        writeln;
    end;
    
    function Existe (var a: archivo; cod: integer): boolean;
    var
        c: celular;
    begin
        Existe:= false;
        seek (a, 0);
        while not EOF(a) do begin
            read (a, c);
            if (c.cod = cod) then begin
                Existe:= true;
                exit;
            end;
        end;
        seek (a, 0);
    end;
    
    procedure agregarCelulares (var a: archivo);
    var
        cant, i: integer;
        c: celular;
    begin
        writeln ('--- Agregar celulares ---');
        writeln;
        write ('¿Cuántos celulares desea agregar? : '); readln (cant);
        writeln;
        reset (a);
        for i:= 1 to cant do begin
            leer (c);
            while (Existe (a, c.cod)) do begin
                writeln ('El código de celular ya existe. Ingrese otro.');
                writeln;
                leer (c);
            end;
            seek (a, filesize(a));
            write (a, c);
        end;
        writeln ('--- Agregar finalizado ---');
        writeln;
        close (a);
    end;

    procedure modificarStock (var a: archivo);
    var
        c: celular;
        nombre: string;
        stock: integer;
        encontre: boolean;
    begin
        writeln ('--- Modificación de stock ---');
        writeln;
        write ('Ingrese el nombre del celular a modificar: '); readln (nombre);
        writeln;
        encontre:= false;
        reset (a);
        while not EOF (a) and not (encontre) do begin
            read (a, c);
            if (c.nom = nombre) then begin
                encontre:= true;
                write ('Ingrese el nuevo stock (stock actual: ',c.stockDisp,'): '); readln (stock);
                c.stockDisp:= stock;
                seek (a, filePos(a)-1);
                write (a, c);
                writeln;
                writeln ('Stock actualizado con éxito.');
            end;
        end;
        if not (encontre) then writeln ('Celular no encontrado.');
        writeln;
        writeln ('--- Fin de la modificación ---');
        writeln;
        close (a);
    end;
    
    procedure exportarStockCero (var a: archivo);
    var
        c: celular;
        t: text;
    begin
        assign (t, 'SinStock.txt');
        rewrite (t);
        reset (a);
        while not EOF(a) do begin
            read (a, c);
            if (c.stockDisp = 0) then begin
                writeln (t, c.marca,' / ',c.nom,' / ',c.precio:0:2,' / ', c.cod,' / ',c.desc,' / ',c.stockMin,' / ',c.stockDisp);
                writeln (t);
            end;
        end;
        close (a); close (t);
        writeln ('--- Archivo exportado a formato ".txt" ---');
        writeln;
    end;
    
var
    celulares: archivo;
    valor: byte;
    nombre: string;
begin
    writeln;
    writeln ('--- Programa "Práctica 1, Ejercicio 6" ---');
    writeln;
    write ('Ingrese el nombre del archivo para empezar: '); readln (nombre);
    writeln;
    assign (celulares, nombre);
    repeat
        valor:= menu;
        case valor of
            1: crearArchivo (celulares);
            2: listarStockMenorAlMin (celulares);
            3: listarPorDescripcion (celulares);
            4: exportarArchivoTexto (celulares);
            5: agregarCelulares (celulares);
            6: modificarStock (celulares);
            7: exportarStockCero (celulares);
        end;
    until (valor = 0);
    writeln ('--- Fin del Programa ---');
end.