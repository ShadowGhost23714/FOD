{
Una empresa dedicada a la venta de golosinas posee un archivo que contiene información sobre los 
productos que tiene a la venta. De cada producto se registran los siguientes datos: código de producto, 
nombre comercial, precio de venta, stock actual y stock mínimo.

La empresa cuenta con 20 sucursales. Diariamente, se recibe un archivo detalle de cada una de las 
20 sucursales de la empresa que indica las ventas diarias efectuadas por cada sucursal. De cada venta se 
registra código de producto y cantidad vendida. Se debe realizar un procedimiento que actualice el stock 
en el archivo maestro con la información disponible en los archivos detalles y que además informe en un 
archivo de texto aquellos productos cuyo monto total vendido en el día supere los $10.000. En el archivo 
de texto a exportar, por cada producto incluido, se deben informar todos sus datos. Los datos de un 
producto se deben organizar en el archivo de texto para facilitar el uso eventual del mismo como un 
archivo de carga.

El objetivo del ejercicio es escribir el procedimiento solicitado, junto con las estructuras de datos y 
módulos usados en el mismo.

Notas:

    Todos los archivos se encuentran ordenados por código de producto.

    En un archivo detalles pueden haber 0, 1 o N registros de un producto determinado.

    Cada archivo detalle solo contiene registros sobre productos que existen en el archivo maestro.

    Los archivos se deben recorrer una sola vez. En el mismo recorrido, se debe realizar la actualización del archivo maestro con los archivos detalles, así como la generación del archivo de texto solicitado.
}
program Parcial04;
const 
    df = 20;
    valorAlto = 9999;
type
    rango = 1..df;
    
    producto = record
        cod: integer;
        nom: string[20];
        precio: real;
        stockActual: integer;
        stockMinimo: integer;
    end;
    
    venta = record
        cod: integer;
        cant: integer;
    end;
    
    maestro = file of producto;
    
    detalle = file of venta;
    
    vecDetalles = array [rango] of detalle;
    
    vecRegistros = array [rango] of venta;
    
    procedure crearMaestro (var m: maestro);
    var
        p: producto;
        txt: text;
    begin
        assign (txt, 'productos.txt');
        reset (txt);
        assign (m, 'ArchivoMaestro');
        rewrite (m);
        while not eof (txt) do begin
            readln (txt, p.cod, p.nom, p.precio, p.stockActual, p.stockMinimo);
            write (m, p);
        end;
        close (m);
        close (txt);
    end;
    
    procedure crearUnDetalle (var d: detalle);
    var
        v: venta;
        nom: string;
        txt: text;
    begin
        write ('Ingrese ruta del detalle '); readln (nom);
        assign (txt, nom);
        reset (txt);
        write ('Ingrese un nombre para el detalle'); readln (nom);
        assign (d, nom);
        rewrite (d);
        while not eof (txt) do begin
            readln (txt, v.cod, v.cant);
            write (d, v);
        end;
        close (d);
        close (txt);
    end;
    
    procedure crearDetalles (var vector: vecDetalles);
    var
        i: rango;
    begin
        for i:= 1 to df do
            crearUnDetalle(v[i]);
    end;
    
    procedure leer (var d: detalle; var v: venta);
    begin
        if not eof (d) then
            read (d, v)
        else
            v.cod := valorAlto;
    end;
    
    procedure minimo (var detalles: vecDetalles; var ventas: vecRegistros; var min: venta);
    var
        i, pos: rango;
    begin
        min.cod := valorAlto;
        for 1:= 1 to df do begin
            if ventas[i].cod < min.cod then begin
                min := ventas[i];
                pos := i;
            end;
        end;
        if min.cod <> valorAlto then
            leer (detalles[pos], min);
    end;
    
    procedure actualizarMaestroExportar (var m: maestro; var detalles: vecDetalles; var txt: text);
    var
        p: producto;
        ventas: vecRegistros;
        i: rango;
        min: venta;
        stockActual, productosVendidos: integer;
        precioActual: integer;
    begin
        assign (txt, 'Informe.txt');
        rewrite (txt);
        for i:= 1 to df do begin
            reset (detalles[i]);
            leer (detalles[i], ventas[i]);
        end;
        reset (m);
        minimo (detalles, ventas, min); 
        while min.cod <> valorAlto do begin
            read (m, p);
            while p.cod <> min.cod do // busco hasta encontrar el producto
                read (m, p);
            productosVendidos := 0;
            precioActual := p.precio;
            stockActual := p.stockActual
            while p.cod = min.cod do begin
                if stockActual > min.cant then begin
                    productosVendidos := productosVendidos + min.cant;
                    stockActual := stockActual - min.cant;
                end
                else begin
                    productosVendidos := productosVendidos + stockActual; // si las ventas son mayores que el stockActual sumo solo lo que tengo
                    stockActual := 0;
                end;
                minimo (detalles, ventas, min);
            end;
            p.stockActual := stockActual;
            if (productosVendidos * precioActual > 10000) then // meto todo despues de actualizar el producto
                writeln (txt, p.cod, ' ', p.nom, ' ', p.precio:0:2, ' ', p.stockActual, ' ', p.stockMinimo);
            seek (m, filepos(m)-1);
            write (m, p);
        end;
        close (m);
        for i:= 1 to df do
            close (detalles[i]);
        close (txt);
    end;
    
var
    archivo: maestro;
    vector: vecDetalles;
    texto: text;
begin
    crearMaestro (archivo);
    crearDetalles (vector);
    actualizarMaestroExportar (archivo, vector, texto);
end.