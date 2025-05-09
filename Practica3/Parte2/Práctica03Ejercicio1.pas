{1. El encargado de ventas de un negocio de productos de limpieza desea administrar el
stock de los productos que vende. Para ello, genera un archivo maestro donde figuran
todos los productos que comercializa. De cada producto se maneja la siguiente
información: código de producto, nombre comercial, precio de venta, stock actual y
stock mínimo. Diariamente se genera un archivo detalle donde se registran todas las
ventas de productos realizadas. De cada venta se registran: código de producto y
cantidad de unidades vendidas. Resuelve los siguientes puntos:

a. Se pide realizar un procedimiento que actualice el archivo maestro con el
archivo detalle, teniendo en cuenta que:

i. Los archivos no están ordenados por ningún criterio.

ii. Cada registro del maestro puede ser actualizado por 0, 1 ó más registros
del archivo detalle.

b. ¿Qué cambios realizaría en el procedimiento del punto anterior si se sabe que
cada registro del archivo maestro puede ser actualizado por 0 o 1 registro del
archivo detalle?}

program Ejercicio1;
const
    valorAlto = 999;
type
    producto = record
        cod: integer;
        nom: string;
        precio: real;
        stockDisp: integer;
        stockMin: integer;
    end;
    
    maestro = file of producto;
    
    venta = record
        cod: integer;
        cant: integer;
    end;
    
    detalle = file of venta;
    
    procedure leerProducto (var p: producto);
    begin
        write ('Ingrese el código: '); readln (p.cod);
        if (p.cod <> valorAlto) then begin
            write ('Ingrese el nombre: '); readln (p.nom);
            write ('Ingrese el precio: '); readln (p.precio);
            write ('Ingrese el stock actual: '); readln (p.stockDisp);
            write ('Ingrese el stock mínimo: '); readln (p.stockMin);
        end;
        writeln;
    end;
    
    procedure leerVenta (var v: venta);
    begin
        write ('Ingrese el código: '); readln (v.cod);
        write ('Ingrese la cantidad vendida: '); readln (v.cant);
        writeln;
    end;
    
    procedure crearMaestro (var m: maestro);
    var
        p: producto;
    begin
        writeln ('Cargar archivo maestro');
        writeln;
        assign (m, 'Maestro');
        rewrite (m);
        leerProducto (p);
        while (p.cod <> valorAlto) do begin
            write (m, p);
            leerProducto (p);
        end;
        close (m);
    end;
    
    procedure crearDetalle (var d: detalle);
    var
        v: venta;
    begin
        writeln ('Cargar archivo detalle');
        writeln;
        assign (d, 'Detalle');
        rewrite (d);
        leerVenta (v);
        while (v.cod <> valorAlto) do begin
            write (d, v);
            leerVenta (v);
        end;
        close (d);
    end;
    
    procedure actualizarMaestro (var m: maestro; var d: detalle); // Punto A
    var
        p: producto;
        v: venta;
    begin
        reset (m); reset (d);
        while not eof (d) do begin
            read (d, v);
            read (m, p);
            while (v.cod <> p.cod) do
                read (m, p);
            if (v.cant > 0) then begin
                p.stockDisp:= p.stockDisp - v.cant;
                seek (m, filepos(m)-1);
                write (m, p);
            end;
            seek (m, 0);
        end;
        writeln ('Archivo maestro actualizado');
        writeln;
        close (m); close (d);
    end;
    
    procedure imprimirProducto (p: producto);
    begin
        writeln ('Código: ',p.cod);
        writeln ('Nombre: ',p.nom);
        writeln ('Precio: ',p.precio:0:2);
        writeln ('Stock actual: ',p.stockDisp);
        writeln ('Stock mínimo: ',p.stockMin);
        writeln;
    end;
    
    procedure imprimirMaestro (var m: maestro);
    var
        p: producto;
    begin
        reset (m);
        while not eof (m) do begin
            read (m, p);
            imprimirProducto (p);
        end;
        close (m);
    end;
    
var
    mae: maestro;
    det: detalle;
begin
    writeln;
    writeln ('--- Programa "Práctica 3, Parte 2, Ejercicio 1" ---');
    writeln;
    crearMaestro (mae);
    crearDetalle (det);
    imprimirMaestro (mae);
    actualizarMaestro (mae, det);
    imprimirMaestro (mae);
    writeln ('Fin del programa.');
end.

