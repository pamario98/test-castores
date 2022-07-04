USE sys;
DROP DATABASE IF EXISTS examen_castores_noticias;
CREATE DATABASE examen_castores_noticias;
USE examen_castores_noticias;


CREATE TABLE usuarios(
	idusuario INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL,
    tipo ENUM('interno', 'externo') NOT NULL,
    correo VARCHAR(50) NOT NULL,
    password VARCHAR(50) NOT NULL
);

CREATE TABLE personal(
	idpersonal INT AUTO_INCREMENT PRIMARY KEY,
    apepaterno VARCHAR(50) NOT NULL,
    apematerno VARCHAR(50) NOT NULL,
    direccion VARCHAR(100) NOT NULL,
    fechadeingreso DATETIME DEFAULT CURRENT_TIMESTAMP,
    idusuario INT,
    CONSTRAINT fk_usuarios_personal FOREIGN KEY (idusuario) REFERENCES usuarios (idusuario)
);


CREATE TABLE notas(
	idnota INT AUTO_INCREMENT PRIMARY KEY,
    idusuario INT NOT NULL,
    descripcion VARCHAR(300),
    titulo VARCHAR(100),
    fecha DATETIME DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_usuarios_notas FOREIGN KEY (idusuario) REFERENCES usuarios (idusuario)
);

CREATE TABLE comentarios(
	idcomentario INT AUTO_INCREMENT PRIMARY KEY,
    comentario VARCHAR(300),
    idnota INT NOT NULL,
    idusuario INT NOT NULL,
    fecha DATETIME DEFAULT CURRENT_TIMESTAMP,
    idcomentariorespuesta INT DEFAULT NULL,
	CONSTRAINT fk_usuarios_comentarios FOREIGN KEY (idusuario) REFERENCES usuarios (idusuario),
    CONSTRAINT fk_nota_comentarios FOREIGN KEY (idnota) REFERENCES notas (idnota)
);

DROP procedure IF EXISTS `sp_comentar_nota`;
DELIMITER $$
CREATE PROCEDURE `sp_comentar_nota` (
	IN _idnota INT,
    IN _idusuario INT,
    IN _comentario VARCHAR(3000))
BEGIN
	INSERT INTO comentarios(comentario, idnota, idusuario) VALUE
	(_comentario, _idnota, _idusuario);
END$$
DELIMITER ;

DROP procedure IF EXISTS `sp_responder_comentario`;
DELIMITER $$
CREATE PROCEDURE `sp_responder_comentario` (
	IN _idcomentario INT,
    IN _idusuario INT,
    IN _comentario VARCHAR(3000))
BEGIN
	SET @idnota = (SELECT idnota FROM comentarios WHERE idcomentario = _idcomentario);

	INSERT INTO comentarios(comentario, idnota, idusuario, idcomentariorespuesta) VALUE
	(_comentario, @idnota, _idusuario, _idcomentario);
END$$
DELIMITER ;

DROP procedure IF EXISTS `sp_comentarios_notas`;
DELIMITER $$
CREATE PROCEDURE `sp_comentarios_notas` (
	IN _idnota INT)
BEGIN
	SELECT comentarios.*, usuarios.nombre as 'usuario' FROM comentarios 
    INNER JOIN usuarios ON usuarios.idusuario = comentarios.idusuario
    WHERE idnota = _idnota AND idcomentariorespuesta IS NULL;
END$$
DELIMITER ;

DROP procedure IF EXISTS `sp_respuestas_comentarios_notas`;
DELIMITER $$
CREATE PROCEDURE `sp_respuestas_comentarios_notas` (
	IN _idcomentario INT)
BEGIN
	SELECT comentarios.*, usuarios.nombre as 'usuario' FROM comentarios 
    INNER JOIN usuarios ON usuarios.idusuario = comentarios.idusuario
    WHERE idcomentariorespuesta = _idcomentario;
END$$
DELIMITER ;

DROP procedure IF EXISTS `sp_crear_notas`;
DELIMITER $$
CREATE PROCEDURE `sp_crear_notas` (
	IN _idusuario INT,
    IN _descripcion VARCHAR(300),
    IN _titulo VARCHAR(100))
BEGIN
	SET @tipo = (SELECT tipo FROM usuarios WHERE idusuario = _idusuario);

	IF @tipo = 'interno' THEN
      INSERT INTO notas(idusuario, descripcion, titulo) VALUE(_idusuario, _descripcion, _titulo);
	END IF;
END$$
DELIMITER ;

DROP procedure IF EXISTS `sp_crear_usuario`;
DELIMITER $$
CREATE PROCEDURE `sp_crear_usuario` (
    IN _nombre VARCHAR(50),
    IN _tipo ENUM('interno', 'externo'),
    IN _correo VARCHAR(50),
    IN _password VARCHAR(50),
    
    IN _apepaterno VARCHAR(50),
    IN _apematerno VARCHAR(50),
    IN _direccion VARCHAR(100)
    )
BEGIN
	INSERT INTO usuarios(nombre, tipo, correo, password) VALUE(_nombre, _tipo, _correo, _password);
	SET @idusuario = (SELECT last_insert_id());
    
    IF _tipo = 'interno' THEN
      INSERT INTO personal(apepaterno, apematerno, direccion, idusuario) VALUE(_apepaterno, _apematerno, _direccion, @idusuario);
	END IF;
END$$
DELIMITER ;


USE `examen_castores_noticias`;
DROP procedure IF EXISTS `get_notas`;

DELIMITER $$
USE `examen_castores_noticias`$$
CREATE PROCEDURE `get_notas` ()
BEGIN
SELECT * FROM examen_castores_noticias.notas;
END$$

DELIMITER ;

USE `examen_castores_noticias`;
DROP procedure IF EXISTS `get_comentarios`;

DELIMITER $$
USE `examen_castores_noticias`$$
CREATE PROCEDURE `get_comentarios` ()
BEGIN
SELECT * FROM examen_castores_noticias.comentarios;
END$$

DELIMITER ;

USE `examen_castores_noticias`;
DROP procedure IF EXISTS `get_personal_interno`;

DELIMITER $$
USE `examen_castores_noticias`$$
CREATE PROCEDURE `get_personal_interno` ()
BEGIN
SELECT * FROM examen_castores_noticias.personal;
END$$

DELIMITER ;

USE `examen_castores_noticias`;
DROP procedure IF EXISTS `get_usuarios`;

DELIMITER $$
USE `examen_castores_noticias`$$
CREATE PROCEDURE `get_usuarios` ()
BEGIN
SELECT * FROM examen_castores_noticias.usuarios;
END$$

DELIMITER ;


call examen_castores_noticias.sp_crear_usuario('MARIO', 'interno', 'mario@mail.com', '12345', 'Garcia', 'Gonzalez', 'direccion1');
call examen_castores_noticias.sp_crear_usuario('DANIEL', 'externo', 'daniel@mail.com', '12345', '', '', '');


call examen_castores_noticias.sp_crear_notas(1, 'Este examen esta muy padre', 'Examen Castores');
call examen_castores_noticias.sp_crear_notas(1, 'Esta es la Segunda Nota', 'Nota 2');

call examen_castores_noticias.sp_comentar_nota(1, 2, 'No me gusto el examen');
call examen_castores_noticias.sp_comentar_nota(2, 2, 'Que padre la segunda nota');

call examen_castores_noticias.sp_responder_comentario(1, 1, 'Pues a mi si me gusto :(');
