{4. Se cuenta con un archivo de productos de una cadena de venta de alimentos congelados.
De cada producto se almacena: código del producto, nombre, descripción, stock disponible,
stock mínimo y precio del producto.

Se recibe diariamente un archivo detalle de cada una de las 30 sucursales de la cadena. Se
debe realizar el procedimiento que recibe los 30 detalles y actualiza el stock del archivo
maestro. La información que se recibe en los detalles es: código de producto y cantidad
vendida. Además, se deberá informar en un archivo de texto: nombre de producto,
descripción, stock disponible y precio de aquellos productos que tengan stock disponible por
debajo del stock mínimo. Pensar alternativas sobre realizar el informe en el mismo
procedimiento de actualización, o realizarlo en un procedimiento separado (analizar
ventajas/desventajas en cada caso).

Nota: todos los archivos se encuentran ordenados por código de productos. En cada detalle
puede venir 0 o N registros de un determinado producto.}


program Ejercicio04;
const
    valorAlto = 999;
    df = 3;
type
    rango = 1..df;
    
    producto = record
        cod: integer;
        nom: string;
        desc: string;
        stockDisp: integer;
        stockMin: integer;
    end;
    
    master = file of producto;
    
    venta = record
        cod: integer;
        cant: integer;
    end;
    
    detalle = file of venta;
    
    detalles = array [rango] of detalle;
    ventas = array [rango] of venta;
    
    procedure CrearMaestro (var m: master);
    var
        p: producto;
        txt: text;
        nom: string;
    begin
        assign (txt, 'Productos.txt');
        reset (txt);
        write ('Ingrese un nombre para el archivo maestro: '); readln (nom);
        assign (m, nom);
        rewrite (m);
        while not EOF (txt) do begin
            readln(txt, p.cod, p.nom, p.desc, p.stockDisp, p.stockMin);
            write (m, p);
        end;
        close (m); close (txt);
    end;
    
    procedure CrearUnDetalle (var d: detalle);
    var
        v: venta;
        txt: text;
        nom: string;
    begin
        assign (txt, 'Ventas.txt');
        reset (txt);
        write ('Ingrese un nombre para el archivo detalle'); readln (nom);
        assign (d, nom);
        rewrite (d);
        while not EOF (txt) do begin
            readln (txt, v.cod, v.cant);
            write (d, v);
        end;
        close (d); close (txt);
    end;
    
    procedure CrearDetalles (var vector: detalles);
    var
        i: rango;
    begin
        for i:= 1 to df do
            CrearUnDetalle (vector[i]);
    end;
    
    procedure Leer (var d: detalle; var v: venta);
    begin
        if not EOF (d) then
            read (d, v)
        else
            v.cod := valorAlto;
    end;
    
    procedure Minimo (var vecDet: detalles; var vecVent: ventas; var min: venta);
    var
        i, pos: rango;
    begin
        min.cod:= valorAlto;
        for i:= 1 to DF do
            if (vecVent[i].cod < min.cod) then begin
                min:= vecVent[i];
                pos:= i;
            end;
        if (min.cod <> valorAlto) then
            leer (vecDet[pos], vecVent[pos]);
    end;
    
    procedure ActualizarMaestro (var m: master; var vecDet: detalles);
    var
        p: producto;
        min: venta;
        vecVent: ventas;
        i: rango;
        cant, aux: integer;
    begin
        reset (m); 
        for i:= 1 to df do begin
            reset (vecDet[i]);
            Leer (vecDet[i], vecVent[i]);
        end;
        Minimo (vecDet, vecVent, min);
        while (min.cod <> valorAlto) do begin
            aux:= min.cod;
            cant:= 0;
            while (min.cod <> valorAlto) and (min.cod = aux) do begin
                cant:= cant + min.cant;
                Minimo (vecDet, vecVent, min);
            end;
            read (m, p);
            while (p.cod <> aux) do
                read (m, p);
            seek (m, filepos(m)-1);
            p.stockDisp := p.stockDisp - cant;
            write (m, p);
        end;
        for i:= 1 to df do
            close (vecDet[i]);
        close (m);
    end;
    
    procedure ImprimirMaestro (var m: master);
    var
        p: producto;
    begin
        reset (m);
        while not EOF (m) do begin
            read (m, p);
            writeln (p.cod,' ',p.nom,' ',p.desc,' ',p.stockDisp,' ',p.stockMin);
        end;
        close (m);
    end;
    
    procedure ExportarStokMenorAlMin (var m: master);
    var
        p: producto;
        txt: text;
    begin
        assign (txt, 'StokMenorAlMin.txt');
        rewrite (txt);
        reset (m);
        while not EOF (m) do begin
            read (m, p);
            if (p.stockDisp < p.stockMin) then
                writeln (txt, p.cod,' ',p.nom,' ',p.desc,' ',p.stockDisp,' ',p.stockMin);
        end;
        writeln ('Archivo maestro exportado.');
        writeln;
        close (m); close (txt);
    end;
    
var
    maestro: master;
    vecDet: detalles;
begin
    writeln;
    writeln ('--- Programa "Práctica 2, Ejercicio 3" ---');
    writeln;
    CrearMaestro (maestro);
    CrearDetalles (vecDet);
    writeln('Archivo maestro original: ');
    writeln;
    ImprimirMaestro (maestro);
    ActualizarMaestro (maestro, vecDet);
    writeln('Archivo maestro actualizado: ');
    writeln;
    ImprimirMaestro (maestro);
    ExportarStokMenorAlMin (maestro);
    writeln ('--- Fin del Programa ---');
end.