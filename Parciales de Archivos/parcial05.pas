program parcial5;
const 
    valorAlto = 9999;
type
    sesion = record
        codArtista = integer;
        nomArtista = string[20];
        anio = integer;
        codEvento = integer;
        nomEvento = string[20];
        likes = integer;
        dislikes = integer;
        puntaje = integer;
    end;
    
    sesiones = file of sesion;
    
    procedure leer (var a: sesiones; var s: sesion);
    begin
        if not eof (a) then
            read (a, s)
        else
            s.anio := valorAlto;
    end;
    
    procedure informar (var a: sesiones);
    var
        likesArtista, dislikesArtista, puntajeArtista: integer;
        actualAnio, actualEvento, actualArtista: integer;
        minPuntaje, minDislikes: integer;
        nomEvento, nomArtista, minArtista: string;
        anios, presentacionesPorAnio, presentacionesTotales: integer;
        prom : real;
        s: sesion;
    begin
        reset(a);
        leer (a);
        anios := 0;
        presentacionesTotales := 0;
        writeln ('Resumen de menor influencia por evento');
        while s.anio <> valorAlto do begin
            actualAnio := s.anio;
            presentacionesPorAnio := 0;
            writeln ('Año: ', actualAnio);
            while s.anio = actualAnio do begin
                actualEvento := s.codEvento;
                nomEvento := s.nomEvento;
                writeln ('Evento: ', nomEvento, '(Codigo: ',actualEvento,')');
                while s.anio = actualAnio and s.codEvento = actualEvento do begin
                    minPuntaje := valorAlto;
                    maxDislikes := -1;
                    actualArtista := s.codArtista;
                    nomArtista := s.nomArtista;
                    writeln ('Artista: ', nomArtista, ' (Codigo: ', actualArtista,')');
                    while s.anio = actualAnio and s.codEvento = actualEvento and s.codArtista = actualArtista do begin
                        likesArtista := likesArtista + s.likes;
                        dislikesArtista := dislikesArtista + s.dislikes;
                        puntajeArtista := puntajeArtista + s.puntaje;
                        presentaciones := presentaciones + 1;
                        leer (a, s);
                    end;
                    writeln ('Likes totales: ', likesArtista);
                    writeln ('Dislikes totales: ', dislikesArtista);
                    writeln ('Diferencia: ', likesArtista - dislikesArtista);
                    writeln ('Puntaje total: ', puntajeArtista);
                    if puntajeArtista < minPuntaje then begin
                        minPuntaje := puntajeArtista;
                        maxDislikes := dislikesArtista;
                        minArtista := nomArtista;
                    end
                    else if puntajeArtista = minPuntaje and dislikesArtista > maxDislikes then begin
                        maxDislikes := dislikesArtista;
                        minArtista := nomArtista;
                    end
                    else if puntajeArtista = minPuntaje and dislikesArtista = maxDislikes then
                        minArtista := nomArtista;
                end;
                writeln ('El artista ', minArtista, ' fue el menos influyente de ', nomEvento, ' del año ', actualAnio);
            end;
            writeln ('Durante el año ', actualAnio, ' se registraron ', presentacionesPorAnio, ' de presentaciones de artistas');
            anios := anios + 1;
            presentacionesTotales := presentacionesTotales + presentacionesPorAnio;
        end;
        prom := presentacionesTotales / anios;
        writeln ('El promedio total de presentaciones por año es de: ', prom, ' presentaciones');
        close (a);
    end;
    
var
    archivo: presentaciones;
begin
    assign (archivo, 'Presentaciones');
    informar (archivo);
end.