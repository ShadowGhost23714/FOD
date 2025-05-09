{3. Se cuenta con un archivo de productos de una cadena de venta de alimentos congelados.
De cada producto se almacena: código del producto, nombre, descripción, stock disponible,
stock mínimo y precio del producto.

Se recibe diariamente un archivo detalle de cada una de las 30 sucursales de la cadena. Se
debe realizar el procedimiento que recibe los 30 detalles y actualiza el stock del archivo
maestro. La información que se recibe en los detalles es: código de producto y cantidad
vendida. Además, se deberá informar en un archivo de texto: nombre de producto,
descripción, stock disponible y precio de aquellos productos que tengan stock disponible por
debajo del stock mínimo.

Nota: todos los archivos se encuentran ordenados por código de productos. En cada detalle
puede venir 0 o N registros de un determinado producto.}

program Ejercicio03;
type
    producto = record
        cod: integer;
        nom: string;
        desc: string;
        stockDisp: integer;
        stockMin: integer;
        precio: real;
    end;
    master = file of producto;
    venta = record
        cod: integer;
        cantVend: integer;
    end;
    detalle = file of venta;
    
    procedure leer (var a: detalle; var v: venta);
    begin
        if not EOF (a) then
            read(a, v)
        else
            v.cod := -1;
    end;
    
    procedure ActualizarMaestro (var m: master; var d: detalle);
    var
        regm: producto;
        regd: venta;
    begin
        reset (m); reset (d);
        leer (d, regd);
        while (regd.cod <> -1) do begin
            read (m, regm);
            while (regm.cod <> regd.cod) and not EOF (m) do
                read(m, regm);
            while (regm.cod = regd.cod) do begin
                regm.stockDisp := regm.stockDisp - regd.cantVend;
                leer (d, regd);
            end;
            if regm.stockDisp < 0 then
                regm.stockDisp := 0;
            seek (m, filepos(m)-1);
            write (m, regm);
        end;
        close (m); close (d);
    end;
    
    procedure ExportarArchivo (var a: master);
    var
        p: producto;
        texto: text;
    begin
        assign (texto, 'stockDebajoDelMinimo.txt');
        rewrite (texto);
        reset (a);
        while not EOF (a) do begin
            read (a, p);
            if (p.stockDisp < p.stockMin) then
                writeln (texto, p.nom,' ', p.desc,' ', p.stockDisp,' ', p.stockMin,' ', p.precio);
        end;
        close (a); close (texto);
    end;
    
var
    maestro: master;
    det: detalle;
    opcion: byte;
begin
    writeln;
    writeln ('--- Programa "Práctica 2, Ejercicio 3" ---');
    writeln;
    repeat
        writeln ('1. Actualizar el archivo maestro.');
        writeln ('2. Exportar archivo maestro con productos con stock debajo del mínimo.');
        writeln ('0. Finalizar.');
        writeln;
        write ('Elegir opción '); readln (opcion);
        writeln;
        case opcion of
            1: ActualizarMaestro (maestro, det);
            2: ExportarArchivo (maestro);
        end;
    until (opcion = 0);
    writeln ('--- Fin del Programa ---');
end.