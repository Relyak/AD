create or replace function anual(v_sal emp.sal%type,
v_comm emp.comm%type)
return number as
v_anual number;
v_salario number;
v_commis number;
begin
select sal,nvl(comm,0) into v_salario,v_commis from emp where v_sal=sal and v_comm=comm;
v_anual:=v_salario+v_commis;
v_anual:=v_anual*12;
return v_anual;
end anual;
/




Crear una función "Anual" para devolver el salario anual 
cuando se pasa el
salario mensual y la comisión de un empleado. Hay 
que asegurarse de que controla nulos. 
Utilizar una variable de acoplamiento 
para ver lo que devuelve y/o devolverlo por pantalla.

declare



begin


end;

/

