{5. Suponga que trabaja en una oficina donde está montada una LAN (red local). La misma fue
construida sobre una topología de red que conecta 5 máquinas entre sí y todas las
máquinas se conectan con un servidor central. Semanalmente cada máquina genera un
archivo de logs informando las sesiones abiertas por cada usuario en cada terminal y por
cuánto tiempo estuvo abierta. Cada archivo detalle contiene los siguientes campos:
cod_usuario, fecha, tiempo_sesion. Debe realizar un procedimiento que reciba los archivos
detalle y genere un archivo maestro con los siguientes datos: cod_usuario, fecha,
tiempo_total_de_sesiones_abiertas.

Notas:

● Cada archivo detalle está ordenado por cod_usuario y fecha.

● Un usuario puede iniciar más de una sesión el mismo día en la misma máquina, o
inclusive, en diferentes máquinas.

● El archivo maestro debe crearse en la siguiente ubicación física: /var/log.}


program Ejercicio05;
const
    valorAlto = 999;
    df = 5;
type
    rango = 1..df;
    
    sesion = record
        cod: integer;
        fecha: string;
        tiempo: real;
    end;
    
    master = file of sesion;
    detalle = file of sesion;
    
    vecDet = array [rango] of detalle;
    vecSes = array [rango] of sesion;
    
    procedure LeerDetalle (var m: sesion);
    begin
        write ('Ingrese el código de usuario: '); readln (m.cod);
        if (m.cod <> valorAlto) then begin
            write ('Ingrese la fecha : '); readln (m.fecha);
            write ('Ingrese el tiempo de la sesion: '); readln (m.tiempo);
        end;
    end;
    
    procedure CrearUnDetalle (var d: detalle);
    var
        s: sesion;
        nom: string;
    begin
        write ('Ingrese un nombre para el archivo detalle: '); readln (nom);
        assign (d, nom);
        rewrite (d);
        LeerDetalle (s);
        while (s.cod <> valorAlto) do begin
            write (d, s);
            LeerDetalle (s);
        end;
        close (d);
    end;
    
    procedure CrearDetalles (var detalles: vecDet);
    var
        i: rango;
    begin
        for i:= 1 to df do
            CrearUnDetalle (detalles[i]);
    end;
    
    procedure Leer (var d: detalle; var m: sesion);
    begin
        if not EOF (d) then
            read (d, m)
        else
            m.cod := valorAlto;
    end;
    
    procedure Minimo (var detalles: vecDet; var sesiones: vecSes; var min: sesion);
    var
        i, pos: rango;
    begin
        pos:= 1;
        min.cod:= valorAlto;
        min.fecha:= 'zzz';
        for i:= 1 to DF do
            if (sesiones[i].cod <= min.cod) and (sesiones[i].fecha < min.fecha) then begin
                min:= sesiones[i];
                pos:= i;
            end;
        if (min.cod <> valorAlto) then
            leer (detalles[pos], sesiones[pos]);
    end;
    
    procedure CrearMaestro (var m: master; var detalles: vecDet);
    var
        min, s: sesion;
        sesiones: vecSes;
        i: rango;
    begin
        assign (m, '/var/log');
        rewrite (m);
        for i:= 1 to df do begin
            reset (detalles[i]);
            Leer (detalles[i], sesiones[i]);
        end;
        Minimo (detalles, sesiones, min);
        while (min.cod <> valorAlto) do begin
            s.cod:= min.cod;
            while (s.cod = min.cod) do begin
                s.fecha:= min.fecha;
                s.tiempo:= 0;
                while (s.cod = min.cod) and (s.fecha = min.fecha) do begin
                    s.tiempo:= s.tiempo + min.tiempo;
                    Minimo (detalles, sesiones, min);
                end;
                write (m, s);
            end;
        end;
        for i:= 1 to df do
            close (detalles[i]);
        close (m);
    end;
    
    procedure ImprimirMaestro (var m: master);
    var
        s: sesion;
    begin
        reset (m);
        while not EOF (m) do begin
            read (m, s);
            writeln (s.cod,' ',s.fecha,' ',s.tiempo);
        end;
        close (m);
    end;
    
var
    maestro: master;
    detalles: vecDet;
begin
    writeln;
    writeln ('--- Programa "Práctica 2, Ejercicio 5" ---');
    writeln;
    CrearDetalles (detalles);
    CrearMaestro (maestro, detalles);
    ImprimirMaestro (maestro);
    writeln ('--- Fin del Programa ---');
end.