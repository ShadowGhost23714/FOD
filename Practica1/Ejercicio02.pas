// Realizar un algoritmo, que utilizando el archivo de números enteros no ordenados
//creado en el ejercicio 1, informe por pantalla cantidad de números menores a 1500 y el
//promedio de los números ingresados. El nombre del archivo a procesar debe ser
//proporcionado por el usuario una única vez. Además, el algoritmo deberá listar el
//contenido del archivo en pantalla.

program Ejercicio02;
type
    archivo = file of integer;
    
    procedure CantMenores (var enteros: archivo);
    var
        cant, num: integer;
    begin
        cant:= 0;
        while not (EOF (enteros)) do begin
            read (enteros, num);
            if (num < 1500) then
                cant:= cant + 1;
        end;
        writeln ('La cantidad de números menores a 1500 es de ', cant);
    end;
    
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
        writeln ('Se ingreso el número ', num);
        writeln ('Ingrese un número');
        readln (num);
    end;
    seek (enteros, 0); // reset (enteros);
    CantMenores (enteros);
    close (enteros);
end.