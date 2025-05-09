{5. Realizar un programa para una tienda de celulares, que presente un menú con
opciones para:

a. Crear un archivo de registros no ordenados de celulares y cargarlo con datos
ingresados desde un archivo de texto denominado “celulares.txt”. Los registros
correspondientes a los celulares, deben contener: código de celular, el nombre,
descripcion, marca, precio, stock mínimo y el stock disponible.

b. Listar en pantalla los datos de aquellos celulares que tengan un stock menor al
stock mínimo.

c. Listar en pantalla los celulares del archivo cuya descripción contenga una
cadena de caracteres proporcionada por el usuario.

d. Exportar el archivo creado en el inciso a) a un archivo de texto denominado
“celulares.txt” con todos los celulares del mismo.}

program Ejercicio05;
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
        writeln ('0. Finalizar.');
        writeln;
        write ('Ingresar opción: '); readln (menu);
        writeln;
    end;
    
    procedure crearArchivo (var a: archivo);
    var
        c: celular;
        nom: string;
    begin
        writeln ('--- Creación de archivo ---');
        writeln;
        write ('Ingrese un nombre para el archivo: '); readln (nom);
        assign (a, nom);
        rewrite (a);
        leer (c);
        while (c.cod <> 0) do begin
            write (a, c);
            leer (c);
        end;
        close (a);
        writeln ('--- Fin de la creación de archivo ---');
        writeln;
    end;
    
    procedure listarStokMenorAlMin (var a: archivo);
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
    
    procedure exportarArchivoTexto (var a: archivo; var t: text);
    var
        c: celular;
    begin
        assign (t, 'celulares.txt');
        rewrite (t);
        reset (a);
        while not EOF(a) do begin
            read (a, c);
            writeln (t, c.marca,' / ',c.nom,' / ',c.precio,' / ', c.cod,' / ',c.desc,' / ',c.stockMin,' / ',c.stockDisp);
        end;
        close (a); close (t);
        writeln ('--- Archivo exportado a formato ".txt" ---');
        writeln;
    end;
    
var
    celulares: archivo;
    texto: text;
    valor: byte;
begin
    repeat
        valor:= menu;
        case valor of
            1: crearArchivo (celulares);
            2: listarStokMenorAlMin (celulares);
            3: listarPorDescripcion (celulares);
            4: exportarArchivoTexto (celulares, texto);
        end;
    until (valor = 0);
end.