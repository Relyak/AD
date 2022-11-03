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
DROP TABLE TABLA_CLIENTES;
DROP TABLE TABLA_PRODUCTOS;
DROP TABLE TABLA_VENTAS;

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

create or replace type tip_telefonos is varray(3) of varchar(15);
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
create or replace type tip_lineas_venta as table of tip_linea_venta; 
/

create or replace type tip_venta as object(
	Idventa number,
	Idcliente REF tip_cliente,
	Fechaventa date,
	Lineas tip_lineas_venta,
	member function total_venta return number
);
/

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

CREATE TABLE TABLA_CLIENTES OF TIP_CLIENTE(IDCLIENTE PRIMARY KEY);
CREATE TABLE TABLA_PRODUCTOS OF TIP_PRODUCTO(IDPRODUCTO PRIMARY KEY);
CREATE TABLE TABLA_VENTAS OF TIP_VENTA(IDVENTA PRIMARY KEY) nested table LINEAS store as TABLA_LINEASSS;

INSERT INTO TABLA_CLIENTES VALUES(1,'Luis Garcia', tip_direccion('calle Las Flores,23','Guadalajara','19003','Guadalajara'),'34343434L',tip_telefonos('949876655','9498
76655'));
INSERT INTO TABLA_CLIENTES VALUES(2,'ana Serrano', tip_direccion('calle Galiana,6','Guadalajara','19004','Guadalajara'),'76767667F',tip_telefonos('94980009'));


INSERT INTO TABLA_PRODUCTOS VALUES(1, 'caja de cristal de murano',100,5);
INSERT INTO TABLA_PRODUCTOS VALUES(2, 'bicicleta city',120,15);
INSERT INTO TABLA_PRODUCTOS VALUES(3, '100 lapices de colores',20,5);
INSERT INTO TABLA_PRODUCTOS VALUES(4, 'ipad',600,5);
INSERT INTO TABLA_PRODUCTOS VALUES(5, 'ordenador portatil',400,10);


INSERT INTO TABLA_VENTAS SELECT 1, REF(C),SYSDATE, TIP_LINEAS_VENTA() FROM
TABLA_CLIENTES C WHERE C.IDCLIENTE=1;

INSERT INTO TABLE (SELECT V.LINEAS FROM TABLA_VENTAS V WHERE
V.IDVENTA=1)(SELECT 1,REF(P),1 FROM TABLA_PRODUCTOS P WHERE IDPRODUCTO=1);

INSERT INTO TABLE (SELECT V.LINEAS FROM TABLA_VENTAS V WHERE
V.IDVENTA=1)(SELECT 2,REF(P),2 FROM TABLA_PRODUCTOS P WHERE IDPRODUCTO=2);

INSERT INTO TABLA_VENTAS VALUES(5, (SELECT REF(C) FROM TABLA_CLIENTES C WHERE
C.IDCLIENTE=1)
,SYSDATE,
TIP_LINEAS_VENTA(
TIP_LINEA_VENTA(1,(SELECT REF(P) FROM TABLA_PRODUCTOS P 
WHERE IDPRODUCTO=1),1),
TIP_LINEA_VENTA(2,(SELECT REF(P) FROM TABLA_PRODUCTOS P 
WHERE IDPRODUCTO=2),2)
));



INSERT INTO TABLA_VENTAS SELECT 2, REF(C),SYSDATE, TIP_LINEAS_VENTA() FROM
TABLA_CLIENTES C WHERE C.IDCLIENTE=1;
INSERT INTO TABLE (SELECT V.LINEAS FROM TABLA_VENTAS V WHERE
V.IDVENTA=2)(SELECT 1,REF(P),2 FROM TABLA_PRODUCTOS P WHERE IDPRODUCTO=4);
INSERT INTO TABLE (SELECT V.LINEAS FROM TABLA_VENTAS V WHERE
V.IDVENTA=2)(SELECT 2,REF(P),1 FROM TABLA_PRODUCTOS P WHERE IDPRODUCTO=1);
INSERT INTO TABLE (SELECT V.LINEAS FROM TABLA_VENTAS V WHERE
V.IDVENTA=2)(SELECT 3,REF(P),4 FROM TABLA_PRODUCTOS P WHERE IDPRODUCTO=5);

INSERT INTO TABLA_VENTAS VALUES(4,(SELECT REF(C) FROM TABLA_CLIENTES C WHERE
C.IDCLIENTE=1)
,SYSDATE,
	TIP_LINEAS_VENTA(TIP_LINEA_VENTA(1,(SELECT REF(P) FROM TABLA_PRODUCTOS P
	WHERE IDPRODUCTO=1),2),
	TIP_LINEA_VENTA(2,(SELECT REF(P) FROM TABLA_PRODUCTOS P WHERE IDPRODUCTO=2),3),
	TIP_LINEA_VENTA(3,(SELECT REF(P) FROM TABLA_PRODUCTOS P WHERE IDPRODUCTO=3),4)));
	
