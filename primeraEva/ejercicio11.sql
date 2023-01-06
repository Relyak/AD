set serveroutput on
drop table Tabla_clientes;
drop table Tabla_productos;
drop table Tabla_ventas;
drop table LINEASVENTAS;
drop table VENTAS;
drop table CLIENTE;
drop table PRODUCTOS;

drop type tip_venta force;
drop type tip_lineas_venta force;
drop type tip_linea_venta force;
drop type tip_producto force;
drop type tip_cliente force;
drop type tip_direccion force;
drop type tip_telefonos force;





create table CLIENTE (
	idecliente number primary key,
	nombre varchar(50),
	direccion varchar(50),
	poblacion varchar(50),
	cdopostal number,
	provincia varchar(50),
	nif varchar(9),
	tel1 varchar(15),
	tel2 varchar(15),
	tel3 varchar(15)
);

create table PRODUCTOS(
	idproducto number primary key,
	descripcion varchar(80),
	pvp number,
	stockactual number
);

create table VENTAS(
	ideventas number PRIMARY KEY,
	idcliente number,
	fechaventa date,
	CONSTRAINT FK_VENTAS_idcliente FOREIGN KEY (idcliente) REFERENCES CLIENTE(idecliente)
);

create table LINEASVENTAS(
	idventa number ,
	numerolinea number , 
	idproducto number,
	cantidad number,
	CONSTRAINT FK_LINEASVENTAS_idventa FOREIGN KEY(idventa) REFERENCES VENTAS(ideventas),
	CONSTRAINT FK_LINEASVENTAS_idproducto FOREIGN KEY (idproducto) REFERENCES PRODUCTOS(idproducto),
	CONSTRAINT PK_idcenta_numlinea PRIMARY KEY (idventa,numerolinea)
	);
/* 2. Diseña el modelo objeto-relacional*/
create type tip_telefonos is varray(3) of varchar(15);
/

create or replace type tip_direccion as object (
	calle varchar(50),
	poblacion varchar(50),
	codpos varchar(20),
	provincia varchar(40)
);
/

create or replace type tip_cliente as object(
	idcliente number,
	nombre varchar(50),
	direc tip_direccion,
	nif varchar(9),
	telef tip_telefonos
);
/

create or replace type tip_producto as object(
	idproducto number,
	descripcion varchar(80),
	pvp number,
	stockactual number
);
/

create or replace type tip_linea_venta as object(
	numerolinea number,
	idproducto REF tip_producto,
	cantidad number
);
/

create  type tip_lineas_venta as table of tip_linea_venta; 
/
create or replace type tip_venta as object(
	Idventa number,
	Idcliente REF tip_cliente,
	Fechaventa date,
	Lineas tip_lineas_venta,
	member function total_venta return number
);
/
/* 3. Crea el cuerpo para la función total_venta*/
create or  replace  type body tip_venta as 
	 MEMBER FUNCTION total_venta RETURN number IS 
 	 total number:=0;
 	 linea tip_linea_venta;
   	 product tip_producto;
 	 BEGIN
 	 FOR i in 1..lineas.count loop
		 linea:=lineas(i);
 		 select deref(linea.idproducto) into product from dual;
 		 total:= total + linea.cantidad*product.pvp;
  	 end loop;
  return total;
 	end;
end;
   /
/* 4. Persiste los objetos*/
create table Tabla_clientes of tip_cliente(idcliente primary key);
create table Tabla_productos of tip_producto(idproducto primary key);
create table Tabla_ventas of tip_venta(Idventa primary key)nested table Lineas store as tabla_lineas_N;

/* 5. Inserta datos en las tablas*/
insert into Tabla_clientes values(1,'Luis Garcia', tip_direccion('calle Las 
Flores,23','Guadalajara','19003','Guadalajara'),'34343434L',tip_telefonos('949876655','949876655'));

insert into Tabla_clientes values(2,'ana Serrano', tip_direccion('calle 
Galiana,6','Guadalajara','19004','Guadalajara'),'76767667F',tip_telefonos('94980009'));

insert into Tabla_productos values(1, 'caja de cristal de murano',100,5);
insert into Tabla_productos values(2, 'bicicleta city',120,15);
insert into Tabla_productos values(3, '100 lapices de colores',20,5);
insert into Tabla_productos values(4, 'ipad',600,5);
insert into Tabla_productos values(5, 'ordenador portatil',400,10);

INSERT INTO TABLA_VENTAS SELECT 1, REF(C),SYSDATE, TIP_LINEAS_VENTA() FROM TABLA_CLIENTES C WHERE C.IDCLIENTE=1;
--Líneas para la venta 1 **********************************
--Linea1--
INSERT INTO TABLE (SELECT V.LINEAS FROM TABLA_VENTAS V WHERE 
V.IDVENTA=1)(SELECT 1,REF(P),1 FROM TABLA_PRODUCTOS P WHERE IDPRODUCTO=1);
--Línea 2 --
INSERT INTO TABLE (SELECT V.LINEAS FROM TABLA_VENTAS V WHERE 
V.IDVENTA=1)(SELECT 2,REF(P),2 FROM TABLA_PRODUCTOS P WHERE IDPRODUCTO=2);

INSERT INTO TABLA_VENTAS SELECT 2, REF(C),SYSDATE, TIP_LINEAS_VENTA() FROM 
TABLA_CLIENTES C WHERE C.IDCLIENTE=1;
--Líneas para la venta 2 *********************************
--Linea1
INSERT INTO TABLE (SELECT V.LINEAS FROM TABLA_VENTAS V WHERE 
V.IDVENTA=2)(SELECT 1,REF(P),2 FROM TABLA_PRODUCTOS P WHERE IDPRODUCTO=4);
--Línea 2
INSERT INTO TABLE (SELECT V.LINEAS FROM TABLA_VENTAS V WHERE 
V.IDVENTA=2)(SELECT 2,REF(P),1 FROM TABLA_PRODUCTOS P WHERE IDPRODUCTO=1);
--Línea 3
INSERT INTO TABLE (SELECT V.LINEAS FROM TABLA_VENTAS V WHERE 
V.IDVENTA=2)(SELECT 3,REF(P),4 FROM TABLA_PRODUCTOS P WHERE IDPRODUCTO=5);


--6.1--
select v.Lineas from tabla_ventas v where v.idventa=2;

select lin.* from tabla_ventas v,table(v.Lineas) lin where v.idventa=2;




--6.2--
select deref(lin.idproducto)  from tabla_ventas v,table(v.Lineas) lin where v.idventa=2;
--6.3--
select lin.* from tabla_ventas v,table(v.Lineas) lin;

--6.4--
SELECT nombre FROM TABLA_CLIENTES WHERE IDCLIENTE=2;
--6.5--
UPDATE TABLA_CLIENTES SET nombre='ROSA SERRANO' WHERE idcliente= 2;
SELECT nombre FROM TABLA_CLIENTES WHERE IDCLIENTE=2;
--6.6--
SELECT direc FROM TABLA_CLIENTES WHERE idcliente = 2;
UPDATE TABLA_CLIENTES SET 
direc=tip_direccion('calle Estopa,34','Guadalajara','19003','Guadalajara') 
WHERE idcliente = 2;

--6.7--
SELECT * FROM TABLA_CLIENTES WHERE IDCLIENTE=1;

UPDATE TABLA_CLIENTES SET
telef=tip_telefonos('949876655','9498
76655','0000000') WHERE
IDCLIENTE=1;
SELECT VALUE(C) FROM TABLA_CLIENTES C WHERE C.IDCLIENTE=1;
--6.8--
SELECT V.IDCLIENTE.NOMBRE FROM TABLA_VENTAS V WHERE V.IDVENTA=2;
SELECT DEREF(IDCLIENTE).NOMBRE,IDVENTA FROM TABLA_VENTAS WHERE IDVENTA=2;

--6.9--
SELECT DEREF(IDCLIENTE),IDVENTA FROM TABLA_VENTAS WHERE IDVENTA=2;
--6.10--
SELECT v.IDVENTA,v.TOTAL_VENTA() FROM TABLA_VENTAS v WHERE v.IDCLIENTE.IDCLIENTE=1;
--6.11--
SELECT V.IDVENTA,V.TOTAL_VENTA() FROM TABLA_VENTAS V;
--6.12--


create or replace PROCEDURE ejercicio12(p_idventa tabla_ventas.idventa%type) 
is
var_idventa number;
var_fecha date;
var_nombre varchar2(50);
var_calle varchar2(50);

var_lineas number;
var_desc varchar2(50);
var_pvp number;
var_cant number;
var_total_comp number;
var_total_venta number;
var_cliente number;		
cursor c1 is 
	select lin.numerolinea, deref(idproducto).descripcion,deref(idproducto).pvp, lin.cantidad from tabla_ventas v, table(v.Lineas) lin where v.idventa=p_idventa;
	
begin
SELECT v.TOTAL_VENTA() into var_total_venta from TABLA_VENTAS v WHERE v.IDVENTA=p_idventa;

select v.idventa,v.fechaventa,deref(v.idcliente).nombre,
deref(v.idcliente).direc.calle into var_idventa,var_fecha,var_nombre,var_calle from tabla_ventas v where v.idventa=p_idventa;


DBMS_OUTPUT.PUT_LINE('NUMERO DE VENTA: '||var_idventa);
DBMS_OUTPUT.PUT_LINE('FECHA DE VENTA: '||var_fecha);
DBMS_OUTPUT.PUT_LINE('CLIENTE: '||var_nombre);
DBMS_OUTPUT.PUT_LINE('DIRECCION: '||var_calle);
DBMS_OUTPUT.PUT_LINE('*******************************');
	open c1;
	fetch c1 into var_lineas,var_desc,var_pvp,var_cant;
	
	while c1%found loop
	var_total_comp:=var_pvp*var_cant;
	DBMS_OUTPUT.PUT_LINE(var_lineas||'*'||var_desc||'*'||var_pvp||'*'||var_cant||'*'||var_total_comp);
	fetch c1 into var_lineas,var_desc,var_pvp,var_cant;
	end loop;
	DBMS_OUTPUT.PUT_LINE('tOTAL_VENTA: '||var_total_venta);
	close c1;
end;
/

 execute ejercicio12(2);
