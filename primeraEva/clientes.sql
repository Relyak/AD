drop table detalle;
drop table pedidos;
drop table clientes;
drop table articulos;
alter session set NLS_DATE_FORMAT='DD/MM/YY';
create table clientes (codcli  number(6) not null,
		       	nombre char(45),
			direccion char(40),
			ciudad char(30),
			cpostal char(9),
			telefono char(9),
			empno number(4) not null,
			creditlimit number(9,2),
			comentario long,
	constraint idcli_primary_key primary key(codcli),
	constraint fk_empno foreign key (empno) references emp);


INSERT INTO CLIENTES VALUES(000001, 'JOSE LOPEZ' , 'SOL, 23', 'MADRID','28012','912345674', 7839,100000,'BUEN CLIENTE');
INSERT INTO CLIENTES VALUES(000002, 'JUAN GOMEZ' , 'SOL, 43', 'MADRID','28012','912444444',7566,100000,'BUEN CLIENTE');
INSERT INTO CLIENTES VALUES(000003, 'MARIA PEREZ' , 'GRAN VIA , 22', 'MADRID','28012','915555554',7839,200000,'FAMILIA JEFE');
INSERT INTO CLIENTES VALUES(000004, 'ELENA MARTIN' , 'PALO DE FLOR, 55', 'MADRID','28012','916666664',7839,300000,'ENCHUFADO');
INSERT INTO CLIENTES VALUES(000005, 'CARLOS MOTOS' , 'CAMILLA, 88', 'SEVILLA','38012','972787878',7654,500000,'BUEN CLIENTE');
INSERT INTO CLIENTES VALUES(000006, 'ANGEL RUIZ' , 'TRIANA, 77', 'SEVILLA','38012','972345674',7902,10000,'BUEN CLIENTE');
INSERT INTO CLIENTES VALUES(000007, 'INES PETRA' , 'BOLOS , 11', 'TOLEDO','44012','962355674',7369,0,'MOROSO');



create table pedidos (  idped number(4) not null,
			codcli number(6) not null,
			fechaped  date,
			fechafact date,
	constraint ipded_primary_key primary key (idped),
	constraint FK_CODCLI foreign key (codcli) references clientes);
	
INSERT INTO PEDIDOS VALUES (0001,000007, '17/11/99', '19/11/99');
INSERT INTO PEDIDOS VALUES (0002,000006, '18/12/99', '19/12/99');
INSERT INTO PEDIDOS VALUES (0003,000004, '27/12/99', '30/12/99');
INSERT INTO PEDIDOS VALUES (0004,000003, '04/01/00', '19/11/00');
INSERT INTO PEDIDOS VALUES (0005,000002, '07/01/00', '19/11/00');
INSERT INTO PEDIDOS VALUES (0006,000003, '08/08/00', '20/08/00');

create table articulos (idart   number(4) not null primary key,
			descrip     varchar2(20),
			stock      number(4),
			precio     number(6));
	
INSERT INTO ARTICULOS VALUES (4000, 'PIZZA',7,2000);
INSERT INTO ARTICULOS VALUES (4001, 'HAMBURGUESA',8,800);
INSERT INTO ARTICULOS VALUES (4002, 'PAELLA',1,1000);
INSERT INTO ARTICULOS VALUES (4003, 'CORDERO',5,3000);
INSERT INTO ARTICULOS VALUES (4004, 'COMIDA CHINA',9,500);


create table detalle (idped number(4) not null,
		      idart number(4) not null,
		      cantidad number(8),
	 constraint idpart_primary_key primary key (idped, idart),
	 constraint fk_idped foreign key (idped) references pedidos,
	 constraint fk_idart foreign key (idart) references articulos);

INSERT INTO detalle VALUES(0001, 4002 , 2);
INSERT INTO detalle VALUES(0002, 4003,  1);
INSERT INTO detalle VALUES(0003, 4004,  1);
INSERT INTO detalle VALUES(0004, 4002,  3);
INSERT INTO detalle VALUES(0005, 4002,  1);
INSERT INTO detalle VALUES(0005, 4003, 10000);
INSERT INTO detalle VALUES(0005, 4004, 5000);
INSERT INTO detalle VALUES(0006, 4004,   3);

