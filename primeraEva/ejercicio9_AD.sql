drop type listin force ;
drop type telefono force;
drop table clientes_9;

create or replace type telefono as object(
Tipo varchar(30),
Numero number
);
/

create or replace type listin is table of telefono;
/

create table clientes_9(
id_cli number,
nombre varchar(30),
apellido varchar(30),
direccion varchar(30),
poblacion varchar(30),
provincia varchar(30),
telefonos listin
) nested table telefonos store as tel_tabl;

insert into clientes_9 values(1,'ROBERTO','DE LA FUENTE','C/ DE LAS ROSAS','MADRID','MADRID',listin(telefono(
'Fijo',965431232),telefono('Movil',712221543),telefono('Movil',615123452)));
insert into clientes_9 values(2,'RICK','SANCHEZ','C/ DE GRAN VIA','MADRID','MADRID',listin(telefono(
'Fijo',965555222),telefono('Movil',666123444),telefono('Movil',699123566)));
insert into clientes_9 values(3,'AMANDA','TORRES','AVENIDA DE LAS SOLEDADES','MURCIA','MURCIA',listin(telefono(
'Fijo',912345622),telefono('Fijo',999111222),telefono('Movil',650005123)));


select * from clientes_9;

select c.id_cli,concat(c.nombre,(concat(' ',c.apellido))) nombre_completo,c.direccion,
concat(c.provincia,(concat(' ',c.poblacion))) prov_pobl,
 t.* from clientes_9 c, table (c.Telefonos) t;

SELECT * FROM USER_OBJECTS;
SELECT * FROM all_objects where OWNER= 'ROCAS';
SELECT * FROM all_objects where OWNER= 'ROCAS' and OBJECT_TYPE='TYPE';

SELECT * FROM ALL_OBJECTS;

SELECT * FROM USER_NESTED_TABLES WHERE TABLE_TYPE_OWNER='ROCAS';
SELECT * FROM ALL_NESTED_TABLES WHERE TABLE_TYPE_OWNER='ROCAS';

select c.id_cli, t.* from clientes_9 c, table (c.Telefonos) t WHERE c.id_cli=3;

select c.id_cli, t.* from clientes_9 c, table (c.Telefonos) t WHERE c.id_cli=1;
update clientes_9
set telefonos=listin(telefono('fijo',934444444),
telefono('movil personal',65555555),
telefono('movilempresa',644444444)
)
where id_cli=1;
select c.id_cli, t.* from clientes_9 c, table (c.Telefonos) t WHERE c.id_cli=1;
select c.id_cli, t.* from clientes_9 c, table (c.Telefonos) t ;
select c.id_cli,c.nombre, t.tipo,t.numero from clientes_9 c, table (c.Telefonos) t ;






