{2. Se necesita contabilizar los votos de las diferentes mesas electorales registradas por
localidad en la provincia de Buenos Aires. Para ello, se posee un archivo con la
siguiente información: código de localidad, número de mesa y cantidad de votos en
dicha mesa. Presentar en pantalla un listado como se muestra a continuación:

Código de Localidad              Total de Votos
................................ ......................
................................ ......................
Total General de Votos: ………………

NOTAS:
● La información en el archivo no está ordenada por ningún criterio.
● Trate de resolver el problema sin modificar el contenido del archivo dado.
● Puede utilizar una estructura auxiliar, como por ejemplo otro archivo, para
llevar el control de las localidades que han sido procesadas.}

program Ejercicio2;
const
    valorAlto = 999;
type
    mesa = record
        cod: integer;
        num: integer;
        cant: integer;
    end;
    
    archivo = file of mesa;

    procedure leerMesa (var m: mesa);
    begin
        write ('Ingrese el código: '); readln (m.cod);
        if (m.cod <> valorAlto) then begin
            write ('Ingrese el número: '); readln (m.num);
            write ('Ingrese la cantidad de votos: '); readln (m.cant);
        end;
        writeln;
    end;
    
    procedure crearMaestro (var arc: archivo);
    var
        m: mesa;
    begin
        writeln ('Cargar archivo maestro');
        writeln;
        assign (arc, 'Maestro');
        rewrite (arc);
        leerMesa (m);
        while (m.cod <> valorAlto) do begin
            write (arc, m);
            leerMesa (m);
        end;
        close (arc);
    end;
    
    procedure crearAuxiliar (var arc: archivo; var arcAux: archivo; var total: integer);
    var
        m, aux: mesa;
        existe: boolean;
    begin
        assign (arcAux, 'Auxiliar');
        rewrite (arcAux);
        reset (arc);
        total:= 0;
        while not eof (arc) do begin
            read (arc, m);
            existe:= false;
            while not eof (arcAux) and not existe do begin
                read (arcAux, aux);
                if (m.cod = aux.cod) then begin
                    existe:= true;
                    aux.cant := aux.cant + m.cant;
                    seek (arcAux, filepos(arcAux)-1);
                    write (arcAux, aux);
                end;
            end;
            if not existe then begin
                seek (arcAux, filesize(arcAux));
                write (arcAux, m);
            end;
            seek (arcAux, 0);
            total := total + m.cant;
        end;
        close (arc); close (arcAux);
    end;
    
    procedure imprimirMaestro (var arc: archivo; total: integer);
    var
        m: mesa;
    begin
        reset (arc);
        writeln ('Código de Localidad           Total de Votos');
        while not eof (arc) do begin
            read (arc, m);
            writeln (m.cod,'                             ',m.cant);
        end;
        writeln;
        writeln ('Total General de Votos: ', total);
        writeln;
        close (arc);
    end;
    
var
    mae, maeAux: archivo;
    totalGeneral: integer;
begin
    writeln;
    writeln ('--- Programa "Práctica 3, Parte 2, Ejercicio 2" ---');
    writeln;
    crearMaestro (mae);
    crearAuxiliar (mae, maeAux, totalGeneral);
    imprimirMaestro (maeAux, totalGeneral);
    writeln ('Fin del programa.');
end.