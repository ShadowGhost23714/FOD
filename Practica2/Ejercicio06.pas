{6. Se desea modelar la información necesaria para un sistema de recuentos de casos de covid
para el ministerio de salud de la provincia de buenos aires.

Diariamente se reciben archivos provenientes de los distintos municipios, la información
contenida en los mismos es la siguiente: código de localidad, código cepa, cantidad de
casos activos, cantidad de casos nuevos, cantidad de casos recuperados, cantidad de casos
fallecidos.

El ministerio cuenta con un archivo maestro con la siguiente información: código localidad,
nombre localidad, código cepa, nombre cepa, cantidad de casos activos, cantidad de casos
nuevos, cantidad de recuperados y cantidad de fallecidos.
Se debe realizar el procedimiento que permita actualizar el maestro con los detalles
recibidos, se reciben 10 detalles. Todos los archivos están ordenados por código de
localidad y código de cepa.

Para la actualización se debe proceder de la siguiente manera:
1. Al número de fallecidos se le suman el valor de fallecidos recibido del detalle.
2. Idem anterior para los recuperados.
3. Los casos activos se actualizan con el valor recibido en el detalle.
4. Idem anterior para los casos nuevos hallados.

Realice las declaraciones necesarias, el programa principal y los procedimientos que
requiera para la actualización solicitada e informe cantidad de localidades con más de 50
casos activos (las localidades pueden o no haber sido actualizadas).}


program Ejercicio06;
const
    valorAlto = 9999;
    df = 3;
type
    rango = 1..df;
    
    infoMae = record
        codLocalidad: integer;
        nomLocalidad: string;
        nomCepa: string;
        codCepa: integer;
        activos: integer;
        nuevos: integer;
        recuperados: integer;
        fallecidos: integer;
    end;
    
    master = file of infoMae;
    
    infoDet = record
        codLocalidad: integer;
        codCepa: integer;
        activos: integer;
        nuevos: integer;
        recuperados: integer;
        fallecidos: integer;
    end;
    detalle = file of infoDet;
    
    vecDet = array [rango] of detalle;
    regDet = array [rango] of infoDet;
    
    procedure CrearNuevoMaestro (var m: master);
    var
        info: infoMae;
        nom: string;
        txt: text;
    begin
        assign (txt, 'Casos.txt');
        reset (txt);
        write ('Ingrese un nombre para el nuevo archivo maestro: '); readln (nom);
        writeln;
        assign (m, nom);
        rewrite (m);
        while not EOF (txt) do begin
            readln (txt, info.codLocalidad, info.codCepa, info.activos, info.nuevos, info.recuperados, info.fallecidos, info.nomCepa, info.nomLocalidad);
            write (m, info);
        end;
        close (m);
    end;
    
    procedure CrearUnArchivoDetalle (var d: detalle);
    var
        info: infoDet;
        nom: string;
        txt: text;
    begin
        write ('Ingrese la ruta del archivo detalle: '); readln (nom);
        writeln;
        assign (txt, nom);
        reset (txt);
        write ('Ingrese un nombre para el nuevo archivo detalle: '); readln (nom);
        writeln;
        assign (d, nom);
        rewrite (d);
        while not EOF (txt) do begin
            readln (txt, info.codLocalidad, info.codCepa, info.activos, info.nuevos, info.recuperados, info.fallecidos);
            write (d, info);
        end;
        close (d);
    end;
    
    procedure CrearArchivosDetalle (var detalles: vecDet);
    var
        i: rango;
    begin
        for i:= 1 to df do
            CrearUnArchivoDetalle (detalles[i]);
    end;
    
    procedure Leer (var d: detalle; var infoD: infoDet);
    begin
        if not EOF (d) then
            read (d, infoD)
        else
            infoD.codLocalidad := valorAlto;
    end;
    
    procedure Minimo (var detalles: vecDet; var registros: regDet; var min: infoDet);
    var
        i, pos : rango;
    begin
        min.codLocalidad := valorAlto;
        for i:= 1 to df do begin
            if (registros[i].codLocalidad < min.codLocalidad) or ((registros[i].codLocalidad = min.codLocalidad) and (registros[i].codCepa < min.codCepa)) then begin
                min:= registros[i];
                pos:= i;
            end;
        end;
        if (min.codLocalidad <> valorAlto) then
            leer(detalles[pos], registros[pos]);
    end;
    
    procedure ActualizarMaestro (var m: master; var detalles: vecDet);
    var
        infoM: infoMae;
        registros: regDet;
        min: infoDet;
        i, cantCasosLocalidad, cantLocalidades: integer;
    begin
        cantLocalidades := 0;
        for i:= 1 to df do begin
            reset (detalles[i]);
            Leer (detalles[i], registros[i]);
        end;
        reset (m);
        Minimo (detalles, registros, min);
        read (m, infoM);
        while (min.codLocalidad <> valorAlto) do begin
            cantCasosLocalidad := 0;
            while (infoM.codLocalidad <> min.codLocalidad) do
                read (m, infoM);
            while (infoM.codLocalidad = min.codLocalidad) do begin
                while (infoM.codCepa <> min.codCepa) do
                    read (m, infoM);
                while (infoM.codLocalidad = min.codLocalidad) and (infoM.codCepa = min.codCepa) do begin
                    infoM.fallecidos := infoM.fallecidos + min.fallecidos;
                    infoM.recuperados := infoM.recuperados + min.recuperados;
                    cantCasosLocalidad := cantCasosLocalidad + min.activos;
                    infoM.activos := min.activos;
                    infoM.nuevos := min.nuevos;
                    Minimo (detalles, registros, min);
                end;
                seek (m, filepos(m)-1);
                write (m, infoM);
            end;
            if cantCasosLocalidad > 50 then
                cantLocalidades := cantLocalidades + 1;
        end;
        close (m);
        for i:= 1 to df do 
            close (detalles[i]);
        writeln ('La cantidad de localidades con más de 50 casos activos es de ',cantLocalidades);
        writeln;
    end;
    
    procedure ImprimirMaestro (var m: master);
    var
        info: infoMae;
    begin
        reset (m);
        while not EOF (m) do begin
            read (m, info);
            writeln ('Localidad=', info.codLocalidad, ' Cepa=', info.codCepa, ' CA=', info.activos, ' CN=', info.nuevos, ' CR=', info.recuperados, ' CF=', info.fallecidos, ' NombreCepa=', info.nomCepa, ' NombreLocalidad=', info.nomLocalidad);
        end;
        close (m);
    end;
var
    maestro: master;
    detalles: vecDet;
begin
    writeln;
    writeln ('--- Programa "Práctica 2, Ejercicio 6" ---');
    writeln;
    CrearNuevoMaestro (maestro);
    CrearArchivosDetalle (detalles);
    ActualizarMaestro (maestro, detalles);
    ImprimirMaestro (maestro);
    writeln ('--- Fin del Programa ---');
end.