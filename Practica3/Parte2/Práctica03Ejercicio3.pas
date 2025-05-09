{3. Suponga que trabaja en una oficina donde está montada una LAN (red local). La
misma fue construida sobre una topología de red que conecta 5 máquinas entre sí y
todas las máquinas se conectan con un servidor central. Semanalmente cada
máquina genera un archivo de logs informando las sesiones abiertas por cada usuario
en cada terminal y por cuánto tiempo estuvo abierta. Cada archivo detalle contiene
los siguientes campos: cod_usuario, fecha, tiempo_sesion. Debe realizar un
procedimiento que reciba los archivos detalle y genere un archivo maestro con los
siguientes datos: cod_usuario, fecha, tiempo_total_de_sesiones_abiertas.

Notas:
● Los archivos detalle no están ordenados por ningún criterio.
● Un usuario puede iniciar más de una sesión el mismo día en la misma máquina, inclusive, en diferentes máquinas.}

program Ejercicio3;
const
    valorAlto = 999;
    df = 3; // df = 5
type
    rango = 1..df;

    info = record
        cod: integer;
        fecha: string;
        tiempo: integer;
    end;
    
    archivo = file of info;

    vecDet = array [rango] of archivo;

    procedure leerInfo (var inf: info);
    begin
        write ('Ingrese el código de usuario: '); readln (inf.cod);
        if (inf.cod <> valorAlto) then begin
            write ('Ingrese la fecha de la sesión: '); readln (inf.fecha);
            write ('Ingrese la cantidad de horas: '); readln (inf.tiempo);
        end;
        writeln;
    end;
    
    procedure crearUnDetalle (var d: archivo);
    var
        inf: info;
        nombre: string;
    begin
        write ('Ingrese un nombre para el archivo detalle: '); readln (nombre);
        writeln;
        assign (d, nombre);
        rewrite (d);
        leerInfo (inf);
        while (inf.cod <> valorAlto) do begin
            write (d, inf);
            leerInfo (inf);
        end;
        writeln ('Archivo detalle ',nombre,' creado');
        writeln;
        close (d);
    end;
    
    procedure crearDetalles (var detalles: vecDet);
    var
        i: rango;
    begin
        writeln ('----- Creación de archivos detalle -----');
        writeln;
        for i:= 1 to df do
            crearUnDetalle (detalles[i]);
    end;
    
    
    procedure crearMaestro (var m: archivo; var v: vecDet);
    var
        infoMae, infoDet: info;
        i: rango;
        ok: boolean;
    begin
        assign (m, 'Maestro');
        rewrite (m);
        for i:= 1 to df do begin
            reset (v[i]);
            while not eof (v[i]) do begin
                read (v[i], infoDet);
                ok:= false;
                while not eof (m) and not ok do begin
                    read (m, infoMae);
                    if (infoDet.cod = infoMae.cod) then begin
                        ok:= true;
                        infoMae.tiempo := infoMae.tiempo + infoDet.tiempo;
                        seek (m, filepos(m)-1);
                        write (m, infoMae);
                    end;
                end;
                if not ok then begin
                    seek (m, filesize(m));
                    write (m, infoDet);
                end;
                seek (m, 0);
            end;
            close (v[i]);
        end;
        close (m);
    end;
    
    procedure imprimirInfo (inf: info);
    begin
        writeln ('Código de usuario: ',inf.cod);
        writeln ('Última sesión: ',inf.fecha);
        writeln ('Tiempo total de sesiones abiertas: ',inf.tiempo);
        writeln;
    end;
    
    procedure imprimirMaestro (var m: archivo);
    var
        inf: info;
    begin
        reset (m);
        writeln ('----- Contenido del archivo maestro -----');
        writeln;
        while not eof (m) do begin
            read (m, inf);
            imprimirInfo (inf);
        end;
        close (m);
    end;
    
var
    mae: archivo;
    detalles: vecDet;
begin
    writeln;
    writeln ('--- Programa "Práctica 3, Parte 2, Ejercicio 3" ---');
    writeln;
    crearDetalles (detalles);
    crearMaestro (mae, detalles);
    imprimirMaestro (mae);
    writeln ('Fin del programa.');
end.