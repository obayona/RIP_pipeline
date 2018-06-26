Create DataBase BaseRIP_prueba;
use BaseRIP_prueba;


CREATE TABLE Planta(
idPlanta integer,
tipo varchar(20) default "enferma",
PRIMARY KEY (idPlanta)
);


CREATE TABLE Hoja(
idPlanta integer,
numHoja integer,
tipo varchar(20) default "enferma",
PRIMARY KEY (idPlanta, numHoja),
FOREIGN KEY (idPlanta) REFERENCES Planta(idPlanta) ON DELETE CASCADE ON UPDATE CASCADE
);



CREATE TABLE Experimento(
idPlanta integer,
numHoja integer,
fechaHora datetime,
rutaExperimento varchar(50) NOT NUll,
PRIMARY KEY (rutaExperimento),
FOREIGN KEY (idPlanta, numHoja) REFERENCES Hoja(idPLanta, numHoja ) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE Region(
	idRegion varchar(70),
	x integer,
	y integer,
	w integer,
	h integer,
	estadio varchar(10),
	experimento varchar(50),
	plana char default 's',
	PRIMARY KEY (idRegion),
	FOREIGN KEY (experimento) REFERENCES Experimento(rutaExperimento) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE Enlace(
	idEnlace integer AUTO_INCREMENT,
	origen varchar(70),
	destino varchar(70),
	color varchar(7),

	PRIMARY KEY (idEnlace),
	FOREIGN KEY (origen) REFERENCES Region(idRegion) ON DELETE CASCADE ON UPDATE CASCADE,
	FOREIGN KEY (destino) REFERENCES Region(idRegion) ON DELETE CASCADE ON UPDATE CASCADE 
);

CREATE TABLE Usuario(
usuario varchar(20),
clave varchar(20),

PRIMARY KEY (usuario)
);

CREATE TABLE SesionInfo(
	usuario varchar(20),
	experimento varchar(50),
	PRIMARY KEY (usuario,experimento)
);


CREATE TABLE transformedRegion(
	idTransformedRegion varchar(70),
	x1 integer,
	y1 integer,
	x2 integer,
	y2 integer,
	x3 integer,
	y3 integer,
	x4 integer,
	y4 integer,
	PRIMARY KEY (IdTransformedRegion)
);


# PROCEDIMIENTOS
# (Hay 22 procedimientos) 

#----------------------------------------#
# Procedimientos para mapear las tablas


# Inserta una planta en la tabla Planta
# si la planta ya existe no hace nada
DELIMITER //
CREATE PROCEDURE insertarPlanta(in id_Planta integer)
BEGIN
	INSERT IGNORE Planta(idPlanta) VALUES (id_Planta);
END //
DELIMITER ;

# Inserta una hoja en la tabla Hoja
# si la hoja ya existe no hace nada
DELIMITER //
CREATE PROCEDURE insertarHoja(in id_Planta integer, in num_Hoja integer  )
BEGIN
	INSERT IGNORE Hoja (idPlanta, numHoja) VALUES (id_Planta, num_Hoja);	
END //
DELIMITER ;


# inserta un experimento
DELIMITER //
CREATE PROCEDURE insertarExperimento(in id_Planta integer, in num_Hoja integer, in fecha_hora datetime, in ruta varchar(50) )
BEGIN
	INSERT INTO Experimento(idPlanta, numHoja, fechaHora, rutaExperimento ) 
	VALUES (id_Planta, num_Hoja, fecha_hora, ruta);	
END //
DELIMITER ;



#------------------------------------------------------------#
# Procedimientos para obtener Plantas, Hojas y Experimentos

# obtiene las plantas
DELIMITER //
CREATE PROCEDURE obtenerPlantas()
BEGIN
	SELECT idPlanta FROM Planta;

END //
DELIMITER ;


# Obitne las hojas que pertenezcan a una planta 
DELIMITER //
CREATE PROCEDURE obtenerHojas(In id_Planta integer)
BEGIN
	SELECT idPlanta	, numHoja FROM Hoja AS hj
	WHERE hj.idPlanta = id_Planta;

END //
DELIMITER ;


# obtiene los experimentos pertenecientes a una hoja
DELIMITER //
CREATE PROCEDURE obtenerExperimentos(id_Planta integer, num_Hoja integer)
BEGIN
	SELECT TRIM(rutaExperimento) as rutaExperimento FROM Experimento as ex
	WHERE ex.idPlanta = id_Planta and ex.numHoja = num_Hoja;
END //
DELIMITER ;



#--------------------------------------------------#
# PROCEDIMIENTOS PARA VALIDAR HOJAS, PLANTAS Y EXPERIMENTOS

# valida si una planta existe
DELIMITER //
CREATE PROCEDURE validarPlanta(in id_Planta integer)
BEGIN
	SELECT idPlanta FROM Planta Where idPlanta = id_Planta;
END //
DELIMITER ;

# valida si una hoja existe
DELIMITER //
CREATE PROCEDURE validarHoja(in id_Planta integer, in num_Hoja integer)
BEGIN
	SELECT * FROM Hoja Where idPlanta = id_Planta and numHoja = num_Hoja;
END //
DELIMITER ;

# valida si existe un experimento cuyo idPlanta, numHoja y rutaExperimento
# sea igual a id_Planta, num_Hoja, y ruta_Experimento espectivamente
DELIMITER //
CREATE PROCEDURE validarExperimento(in id_Planta integer, in num_Hoja integer, in ruta_Experimento varchar(50))
BEGIN
	SELECT rutaExperimento FROM Experimento Where idPlanta = id_Planta and numHoja = num_Hoja and rutaExperimento=ruta_Experimento;
END //
DELIMITER ;

# valida si dos experimentos pertenecen a la misma planta
DELIMITER //
CREATE PROCEDURE validarExperimentos(in id_Planta integer, in num_Hoja integer,
 in ruta_Experimento1 varchar(50), in ruta_Experimento2 varchar(50))
BEGIN
	SELECT rutaExperimento FROM Experimento Where idPlanta = id_Planta and numHoja = num_Hoja and rutaExperimento=ruta_Experimento1 UNION
	SELECT rutaExperimento FROM Experimento Where idPlanta = id_Planta and numHoja = num_Hoja and rutaExperimento=ruta_Experimento2;
END //
DELIMITER ;

# 

#--------------------------------------------------#
# PROCEDIMIENTOS DE LA REGIONES

# recupera las regiones de un experimento
DELIMITER //
CREATE PROCEDURE obtenerRegiones(in experimento varchar(50) )
BEGIN
	SELECT idRegion, x,y,w,h,estadio,plana,lado,experimento, false as "select" FROM Region
	WHERE Region.experimento = experimento;		
END //
DELIMITER ;


# inserta una region
DELIMITER //
CREATE PROCEDURE insertarRegion(in id_region varchar(70), in x integer, in y integer,in w integer,in h integer, in estadio varchar(10), in experimento varchar(50) )
BEGIN
	INSERT INTO Region(idRegion, x, y, w, h, estadio, experimento) VALUES (id_region, x, y, w, h, estadio,experimento);	
END //
DELIMITER ;

#edita una region
DELIMITER //
CREATE PROCEDURE editarRegion(in id_region varchar(70), in x integer, in y integer,in w integer,in h integer, in estadio varchar(10),in plana char,in lado varchar(10),in experimento varchar(50) )
BEGIN
	UPDATE Region SET Region.x = x, Region.y = y, Region.w = w, Region.h = h, Region.estadio = estadio, Region.plana = plana, Region.lado = lado
	WHERE Region.idRegion = id_region;	
END //
DELIMITER ;

#elimina una region
DELIMITER //
CREATE PROCEDURE eliminarRegion(in id_region varchar(70))
BEGIN
	DELETE FROM Region
	WHERE Region.idRegion = id_region;	
END //
DELIMITER ;


#--------------------------------------------------#
# PROCEDIMIENTOS DE LOS ENLACES

# obtiene el enlace de dos regiones
DELIMITER //
CREATE PROCEDURE obtenerEnlaces(in origen varchar(70), in destino varchar(70) )
BEGIN
	SELECT * FROM Enlace
	WHERE Enlace.origen like CONCAT(origen,'%') and Enlace.destino like CONCAT(destino,'%');		
END //
DELIMITER ;


# inserta un enlace
DELIMITER //
CREATE PROCEDURE insertarEnlace(in origen varchar(70), in destino varchar(70), in color varchar(7))
BEGIN
	INSERT INTO Enlace(origen, destino,color) 
	VALUES (origen, destino, color);	
END //
DELIMITER ;

# elimina un enlace
DELIMITER //
CREATE PROCEDURE eliminarEnlace(in origen varchar(70), in destino varchar(70))
BEGIN
	DELETE FROM Enlace
	WHERE Enlace.origen = origen and Enlace.destino = destino;	
END //
DELIMITER ;

#--------------------------------------------------#
# PROCEDIMIENTOS DE LOS USUARIOS Y SESION

# obtiene un usuario
DELIMITER //
CREATE PROCEDURE obtenerUsuario(in usuario varchar(20), in clave varchar(20) )
BEGIN
	SELECT * FROM Usuario as u WHERE u.usuario = usuario and u.clave = clave;
END //
DELIMITER ;

# inserta un registro en la tabla SesionInfo
# si ese registro ya existe no hace nada
DELIMITER //
CREATE PROCEDURE insertarSesion(IN usuario varchar(20), IN experimento varchar(50))
BEGIN
	INSERT IGNORE SesionInfo(usuario,experimento) VALUES(usuario, experimento);
END //
DELIMITER ;

# elimina registros de la tabla SesionInfo por experimento
DELIMITER //
CREATE PROCEDURE liberarExperimento(IN experimento varchar(50))
BEGIN
	DELETE FROM SesionInfo WHERE SesionInfo.experimento = experimento;
END//
DELIMITER ;

# elimina todos los registros de la Tabla SesionInfo por usuario
DELIMITER //
CREATE PROCEDURE eliminarSesion(IN usuario varchar(20))
BEGIN
	DELETE FROM SesionInfo WHERE SesionInfo.usuario = usuario;
END//
DELIMITER ;

# comrpueba si una registro de la tabla SesionInfo existe
DELIMITER //
CREATE PROCEDURE validarExperimentoSesion(IN user varchar(20), IN exp varchar(50))
BEGIN
	SELECT experimento From SesionInfo WHERE experimento = exp and not(usuario=user);
END//
DELIMITER ;

