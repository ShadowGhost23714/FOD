program Ejercicio01;
type
    archivo = file of integer;
var
    enteros: archivo;
    num: integer;
    nom: string;
begin
    writeln ('Ingrese el nombre del archivo');
    readln (nom);
    assign (enteros, nom);
    rewrite (enteros);
    writeln ('Ingrese un número');
    readln (num);
    while (num <> 3000) do begin
        write (enteros, num);
        writeln ('Ingrese un número');
        readln (num);
    end;
    close (enteros);
end.