{
Considere que se tiene un archivo que contiene informacion de prestamos
otorgados por una empresa financiera que cuenta con varias sucursales.

Por cada prestamo se tiene la siguiente informacion:
numero de sucursal donde se otorgo, DNI del empleado que lo otorgo,
numero de prestamo, fecha de otorgacion, monto otorgado.

Cada prestamo otorgado por la empresa se considera como una venta. Ademas
se sabe que el archivo esta ordenado por los siguientes criterios: codigo
de sucursal, DNI del empleado, fecha de otorgacion (en ese orden).
 
Se le solicita definir las estructuras de datos necesarias y escribir
el modulo que reciba el archivo de datos y genere un informe en un archivo
de texto con el siguiente formato:
 
    Informe de ventas de la empresa
        Sucursal <Numero de sucursal>
                Empleado: DNI <DNI del empleado>
                año            cantidad de ventas            monto de ventas
                ----        ------------------            --------------
                ----        ------------------            --------------
                totales        <total ventas empleado>        <monto total empleado>

                Empleado: DNI <DNI del empleado>
                ...
            cantidad total de ventas sucursal: .......
            monto total vendido por sucursal: .......
        Sucursal <Numero de sucursal>
        ...
    cantidad de ventas de la empresa: .......
    monto total vendido por la empresa: .......
    
Notas: 
    
El archivo se debe recorrer 1 vez
Para determinar el año de otorgacion de un prestamo, puede asumir que
existe una funcion extraerAño(fecha) que a partir de una fecha dada devuelve
el año de la misma.
    
En la generacion del archivo de texto solo interesa que aparezca la
informacion requerida, NO es necesario que se incluyan espacios en blanco
o tabulaciones que se incluyen en el informe dado como ejemplo.
}

program Parcial1;
const
    valorAlto = 999
type
    prestamo = record
        sucursal : integer;
        dni: integer;
        num: integer
        fecha: string;
        monto: real;
    end;
    prestamos = file of prestamo;
    
    procedure cargarArchivo (var a: prestamos); // se dispone
    
    procedure leer (var a: prestamos; p: prestamo);
    begin
        if not eof (a) then
            read (a, p)
        else
            p.sucursal := valorAlto;
    end;
    
    procedure exportar(var a: prestamos);
    var
        txt: text;
        p: prestamo;
        montoTotal, montoSucursal, montoEmpleado, montoAnio: real;
        totalVentas, ventasSucursal, ventasEmpleado, ventasAnio: integer;
        actSucursal, actDni: integer;
        actAnio: string;
    begin
        assign(txt, 'informe.txt');
        rewrite(txt);
        reset(a);
        writeln(txt, 'Informe de ventas de la empresa');
        montoTotal := 0;
        totalVentas := 0;
        leer(a, p);
        while p.sucursal <> valorAlto do begin
            actSucursal := p.sucursal;
            writeln(txt, 'Sucursal ', actSucursal);
            montoSucursal := 0;
            ventasSucursal := 0;
            while (p.sucursal = actSucursal) do begin
                actDni := p.dni;
                writeln(txt, 'Empleado: DNI ', actDni);
                writeln(txt, 'anio    cantidad de ventas    monto de ventas');
                montoEmpleado := 0;
                ventasEmpleado := 0;
                while (p.sucursal = actSucursal) and (p.dni = actDni) do begin
                    actAnio := extraerAnio(p.fecha);
                    montoAnio := 0;
                    ventasAnio := 0;
                    while (p.sucursal = actSucursal) and (p.dni = actDni) and (extraerAnio(p.fecha) = actAnio) do begin
                        montoAnio := montoAnio + p.monto;
                        ventasAnio := ventasAnio + 1;
                        leer(a, p);
                    end;
                    writeln(txt, actAnio, '    ', ventasAnio, '    ', montoAnio:0:2);
                    montoEmpleado := montoEmpleado + montoAnio;
                    ventasEmpleado := ventasEmpleado + ventasAnio;
                end;
                writeln(txt, 'totales    ', ventasEmpleado, '    ', montoEmpleado:0:2);
                montoSucursal := montoSucursal + montoEmpleado;
                ventasSucursal := ventasSucursal + ventasEmpleado;
            end;
            writeln(txt, 'cantidad total de ventas sucursal: ', ventasSucursal);
            writeln(txt, 'monto total vendido por sucursal: ', montoSucursal:0:2);
            montoTotal := montoTotal + montoSucursal;
            totalVentas := totalVentas + ventasSucursal;
        end;
        writeln(txt, 'cantidad de ventas de la empresa: ', totalVentas);
        writeln(txt, 'monto total vendido por la empresa: ', montoTotal:0:2);
        close(a);
        close(txt);
    end;
 
var
    a : prestamos;
begin
  assign(a, 'prestamos.dat');
  exportar(a);
end.
