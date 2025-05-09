{8. Se cuenta con un archivo con información de las diferentes distribuciones de linux
existentes. De cada distribución se conoce: nombre, año de lanzamiento, número de
versión del kernel, cantidad de desarrolladores y descripción. El nombre de las
distribuciones no puede repetirse. Este archivo debe ser mantenido realizando bajas
lógicas y utilizando la técnica de reutilización de espacio libre llamada lista invertida.
Escriba la definición de las estructuras de datos necesarias y los siguientes
procedimientos:

a. BuscarDistribucion: módulo que recibe por parámetro el archivo, un
nombre de distribución y devuelve la posición dentro del archivo donde se
encuentra el registro correspondiente a la distribución dada (si existe) o
devuelve -1 en caso de que no exista..

b. AltaDistribucion: módulo que recibe como parámetro el archivo y el registro
que contiene los datos de una nueva distribución, y se encarga de agregar
la distribución al archivo reutilizando espacio disponible en caso de que
exista. (El control de unicidad lo debe realizar utilizando el módulo anterior).
En caso de que la distribución que se quiere agregar ya exista se debe
informar “ya existe la distribución”.

c. BajaDistribucion: módulo que recibe como parámetro el archivo y el
nombre de una distribución, y se encarga de dar de baja lógicamente la
distribución dada. Para marcar una distribución como borrada se debe
utilizar el campo cantidad de desarrolladores para mantener actualizada
la lista invertida. Para verificar que la distribución a borrar exista debe utilizar
el módulo BuscarDistribucion. En caso de no existir se debe informar
“Distribución no existente”.}

program Ejercicio8;
const
    valor = 'fin';
type
    distribucion = record
        nom: string;
        fecha: string;
        num: integer;
        cant: integer;
        desc: string;
    end;
    
    archivo = file of distribucion;
    
    procedure ImprimirDistr (d: distribucion);
    begin
        writeln ('Nombre: ',d.nom);
        writeln ('Fecha: ',d.fecha);
        writeln ('Número: ',d.num);
        writeln ('Desarrolladores: ',d.cant);
        writeln ('Descripción: ',d.desc);
        writeln;
    end;
    
    procedure LeerDistr (var d: distribucion);
    begin
        write ('Ingrese el nombre: '); readln (d.nom);
        if (d.nom <> valor) then begin
            write ('Ingrese el año de lanzamiento: '); readln (d.fecha);
            write ('Ingrese el número: '); readln (d.num);
            write ('Ingrese la cantidad de desarrolladores: '); readln (d.cant);
            write ('Ingrese la descripción: '); readln (d.desc);
        end;
        writeln;
    end;
    
    procedure CrearArchivo (var arc: archivo);
    var
        d: distribucion;
    begin
        writeln ('---------- Cargar el archivo ----------');
        writeln;
        assign (arc, 'Maestro');
        rewrite (arc);
        d.nom:= '';
        d.fecha:= '';
        d.num:= 0;
        d.cant:= 0;
        d.desc:= '';
        write (arc, d);
        LeerDistr (d);
        while (d.nom <> valor) do begin
            write (arc, d);
            LeerDistr (d);
        end;
        close (arc);
        writeln ('----- Fin de Carga -----');
        writeln;
    end;
    
    function BuscarDistribucion (var arc: archivo; nom: string): integer; // Punto A
    var
        d: distribucion;
        ok: boolean;
    begin
        ok:= false;
        reset (arc);
        while not eof (arc) and not ok do begin
            read (arc, d);
            if d.nom = nom then
                ok:= true;
        end;
        if ok then begin
            BuscarDistribucion := filepos(arc)-1;
        end
        else
            BuscarDistribucion := -1;
        close (arc);
    end;
    
    procedure AltaDistribucion (var arc: archivo; d: distribucion); // Punto B
    var
        cab: distribucion;
    begin
        if (BuscarDistribucion(arc, d.nom)) = -1 then begin
            reset (arc);
            read (arc, cab);
            if cab.cant = 0 then begin
                seek (arc, filesize(arc));
                write (arc, d);
            end
            else begin
                seek (arc, cab.cant * -1);
                read (arc, cab);
                seek (arc, filepos(arc)-1);
                write (arc, d);
                seek (arc, 0);
                write (arc, cab);
            end;
            writeln('Se realizo el alta de la distribucion ', d.nom);
            close (arc);
        end
        else
            writeln ('La distribución ',d.nom,' ya existe');
        writeln;
    end;
    
    procedure BajaDistribucion (var arc: archivo; nom: string); // Punto C
    var
        cab, d: distribucion;
    begin
        if (BuscarDistribucion(arc, nom)) <> -1 then begin
            reset(arc);
            read (arc, cab);
            read (arc, d);
            while d.nom <> nom do
                read (arc, d);
            seek (arc, filepos(arc)-1);
            write (arc, cab);
            cab.cant:= (filepos(arc)-1)*-1;
            seek (arc, 0);
            write (arc, cab);
            close(arc);
            writeln('Se eliminó la distribucion ', nom);
        end
        else
            writeln ('La distribución ',nom,' no existente');
        writeln;
    end;

    procedure ImprimirArchivo (var arc: archivo);
    var
        d: distribucion;
    begin
        reset (arc);
        seek (arc, 1);
        while not eof(arc) do begin
            read (arc, d);
            ImprimirDistr (d);
        end;
        close (arc);
    end;
    
var
    distribuciones: archivo;
    d: distribucion;
begin
    writeln;
    writeln ('--- Programa "Práctica 3, Ejercicio 8" ---');
    writeln;
    CrearArchivo (distribuciones);
    ImprimirArchivo (distribuciones);
    writeln;
    LeerDistr (d);
    AltaDistribucion (distribuciones, d);
    LeerDistr (d);
    AltaDistribucion (distribuciones, d);
    ImprimirArchivo (distribuciones);
    writeln;
    BajaDistribucion (distribuciones, 'aaa');
    BajaDistribucion (distribuciones, 'bbb');
    BajaDistribucion (distribuciones, 'zzz');
    ImprimirArchivo (distribuciones);
    write ('Fin del programa.');
end.
