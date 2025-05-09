{7. Se cuenta con un archivo que almacena información sobre especies de aves en vía
de extinción, para ello se almacena: código, nombre de la especie, familia de ave,
descripción y zona geográfica. El archivo no está ordenado por ningún criterio. Realice
un programa que permita borrar especies de aves extintas. Este programa debe
disponer de dos procedimientos:

a. Un procedimiento que dada una especie de ave (su código) marque la misma
como borrada (en caso de querer borrar múltiples especies de aves, se podría
invocar este procedimiento repetidamente).

b. Un procedimiento que compacte el archivo, quitando definitivamente las
especies de aves marcadas como borradas. Para quitar los registros se deberá
copiar el último registro del archivo en la posición del registro a borrar y luego
eliminar del archivo el último registro de forma tal de evitar registros duplicados.

c. Implemente una variante de este procedimiento de compactación del
archivo (baja física) donde el archivo se trunque una sola vez.}

program Ejercicio7;
const
    valor = -1;
type
    ave = record
        cod: integer;
        nom: string;
        flia: string;
        desc: string;
        zona: string;
    end;
    
    archivo = file of ave;
    
    procedure Imprimir (a: ave);
    begin
        writeln ('Código: ',a.cod);
        writeln ('Nombre: ',a.nom);
        writeln ('Familia: ',a.flia);
        writeln ('Descripción: ',a.desc);
        writeln ('Zona: ',a.zona);
        writeln;
    end;
    
    procedure LeerAve (var a: ave);
    begin
        write ('Ingrese el código: '); readln (a.cod);
        if (a.cod <> valor) then begin
            write ('Ingrese el nombre: '); readln (a.nom);
            write ('Ingrese la familia: '); readln (a.flia);
            write ('Ingrese la descripción: '); readln (a.desc);
            write ('Ingrese la zona: '); readln (a.zona);
        end;
        writeln;
    end;
    
    procedure CrearArchivo (var arc: archivo);
    var
        a: ave;
        nombre: string;
    begin
        writeln ('---------- Cargar el archivo ----------');
        write ('Ingrese un nuevo nombre para el archivo: '); readln (nombre);
        writeln;
        assign (arc, nombre);
        rewrite (arc);
        LeerAve (a);
        while (a.cod <> valor) do begin
            write (arc, a);
            LeerAve (a);
        end;
        close (arc);
        writeln ('----- Fin de Carga -----');
        writeln;
    end;
    
    procedure Eliminar (var arc: archivo); // Punto A
    var
        cod: integer;
        a: ave;
        ok: boolean;
    begin
        reset(arc);
        write ('Ingrese el código de la ave a eliminar: '); readln (cod);
        writeln;
        while cod <> valor do begin
            ok:= false;
            seek (arc, 0);
            while not eof(arc) and not ok do begin
                read(arc, a);
                if a.cod = cod then begin
                    a.cod := a.cod * -1;
                    seek (arc, filepos(arc)-1);
                    write (arc, a);
                    ok:= true;
                end;
            end;
            if ok then 
                writeln ('Ave con código ',cod,' eliminada')
            else
                writeln ('No se escontró el ave con el código ',cod);
            writeln;
            write ('Ingrese otro código o finalice con "-1": '); readln (cod);
            writeln;
        end;
        close(arc);
    end;

    {procedure Leer (var arc: archivo; var a: ave);
    begin
        if not eof(arc) then
            read (arc, a)
        else
            a.cod:= valor;
    end;

    procedure Compactar (var arc: archivo); // Punto B
    var
        a: ave;
        pos: integer;
    begin
        reset (arc);
        Leer (arc, a);
        while a.cod <> valor do begin
            if a.cod < 0 then begin
                pos:= filepos(arc) - 1;
                seek (arc, filesize(arc)-1);
                read (arc, a);
                if (filepos(arc)-1 <> 0) then begin
                    while a.cod < 0 do begin
                        seek (arc, filesize(arc)-1);
                        truncate (arc);
                        seek (arc, filesize(arc)-1);
                        read (arc, a);
                    end;
                end;
                seek(arc, pos);
                write(arc, a);
                seek(arc, filesize(arc)-1);
                truncate(arc);
                seek(arc, pos);
                end;
            leer(arc, a);
            end;
        close(arc);
    end;}
    
    procedure Compactar (var arc: archivo); // Punto C
    var
        a: ave;
        i, j: integer;
    begin
        reset(arc);
        i := 0;
        j := 0;
        while i < filesize(arc) do begin
            seek(arc, i);
            read(arc, a);
            if a.cod > 0 then begin
                if i <> j then begin
                    seek(arc, j);
                    write(arc, a);
                end;
                j := j + 1;
            end;
            i := i + 1;
        end;
        seek(arc, j);
        truncate(arc);
        close(arc);
        writeln ('Archivo compactado');
        writeln;
    end;
    
    procedure ImprimirArchivo (var arc: archivo);
    var
        a: ave;
    begin
        reset (arc);
        while not eof(arc) do begin
            read (arc, a);
            Imprimir (a);
        end;
        close (arc);
    end;
    
var
    aves: archivo;
begin
    writeln;
    writeln ('--- Programa "Práctica 3, Ejercicio 7" ---');
    writeln;
    CrearArchivo (aves);
    Eliminar (aves);
    ImprimirArchivo (aves);
    writeln;
    Compactar (aves);
    ImprimirArchivo (aves);
    writeln;
    write ('Fin del programa.');
end.
