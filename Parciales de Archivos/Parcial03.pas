{
Suponga que tiene un archivo con información referente a los productos que se 
comercializan en un supermercado. De cada producto se conoce código de producto (único), 
nombre del producto, descripción, precio de compra, precio de venta y ubicación en depósito.

Se solicita hacer el mantenimiento de este archivo utilizando la técnica de reutilización de 
espacio llamada lista invertida.

Declare las estructuras de datos necesarias e implemente los siguientes módulos:

Agregar producto: Recibe el archivo sin abrir y solicita al usuario que ingrese los datos del 
producto y lo agrega al archivo sólo si el código ingresado no existe. Suponga que existe una 
función llamada existeProducto que recibe un código de producto y un archivo y devuelve 
verdadero si el código existe en el archivo o falso en caso contrario. La función 
existeProducto no debe implementarla. Si el producto ya existe debe informarlo en pantalla.

Quitar producto: Recibe el archivo sin abrir y solicita al usuario que ingrese un código y lo 
elimina del archivo solo si ese código existe. Puede utilizar la función existeProducto. En 
caso de que el producto no exista debe informarse en pantalla.

Nota: Los módulos que debe implementar deberán guardar en memoria secundaria todo 
cambio que se produzca en el archivo.
}

program Parcial03;
type
    producto = record
        cod: integer;
        nom: string[20];
        desc: string[50];
        precioCompra: real;
        precioVenta: real;
        ubicacion: string[20];
    end;
    
    productos = file of producto
    
    procedure leerProducto (var p: producto);
    begin
        write ('Ingrese el codigo: '); readln (p.cod);
        write ('Ingrese el nombre: '); readln (p.nom);
        write ('Ingrese la descripción: '); readln (p.desc);
        write ('Ingrese el precio de compra: '); readln (p.precioCompra);
        write ('Ingrese el precio de venta: '); readln (p.precioVenta);
        write ('Ingrese la ubicación: '); readln (p.ubicacion);
    end;
    
    function buscarProducto (var a: productos; cod: integer): integer;
    var
        p: producto;
        ok: boolean; 
    begin
        ok := false;
        reset (a);
        while not eof (a) and not ok do begin
            read (a, p);
            if p.cod = cod then
                ok := true;
        end;
        if ok then
            buscarProducto := filepos(a)-1
        else
            buscarProducto := -1;
        close (a);
    end;
    
    procedure agregarProducto (var a: productos);
    var
        p, encabezado: producto;
    begin
        leerProducto (p);
        if buscarProducto(a, p.cod) = -1 then begin
            reset (a);
            read (a, encabezado);
            if encabezado.cod = 0 then begin
                seek (a, filesize(a));
                write (a, p);
            end
            else begin
                seek (a, encabezado.cod*-1);
                read (a, encabezado);
                seek (a, filepos(a)-1);
                write (a, p);
                seek (a, 0);
                write (a, encabezado);
            end;
            close (a);
            writeln ('Se agrego ', p.cod);
        end
        else
            writeln ('No se pudo agregar ', p.cod,' porque ya existe');
    end;
    
    procedure quitarProducto (var a: productos);
    var
        p, encabezado: producto;
        pos, cod: integer;
    begin
        write ('Ingrese el codigo del producto: '); readln(cod);
        pos := buscarProducto(a, cod);
        if pos <> -1 then begin 
            reset (a);
            read (a, encabezado);
            seek (a, pos);
            read (a, p);
            p.cod := encabezado.cod;
            seek (a, pos);
            write (a, p);
            encabezado.cod := -pos;
            seek (a, 0);
            write (a, encabezado);
            close (a);
            writeln ('Se elimino ', cod);
        end
        else
            writeln ('No se pudo eliminar ', cod,' porque no existe');
    end;
    
var
    archivo: productos
begin
    assign (archivo, 'productos'); // suponiendo que se dispone
    agregarProducto (archivo);
    quitarProducto (archivo);
end.