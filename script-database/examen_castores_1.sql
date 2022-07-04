USE sys;
DROP DATABASE IF EXISTS examen_castores;
CREATE DATABASE examen_castores;
USE examen_castores;

CREATE TABLE miembros(
	id_miembro INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(50),
    edad INT
);

CREATE TABLE comidamiembros(
	id_comidamiembros INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(50),
    id_miembro INT,
	CONSTRAINT fk_miembros_comidamiembros FOREIGN KEY (id_miembro) REFERENCES miembros (id_miembro)
);


INSERT INTO miembros(nombre, edad) VALUE
('Papá', 42),
('Mamá', 45),
('Hija', 19),
('Hijo', 16),
('Perro', 2);

INSERT INTO comidamiembros(nombre, id_miembro) VALUE
('Sopa', 4),
('Enchiladas', 1),
('Ensalada', 2);

SELECT m.nombre FROM comidamiembros c
INNER JOIN miembros m ON m.id_miembro = c.id_miembro;

SELECT m.nombre, c.nombre FROM comidamiembros c
RIGHT JOIN miembros m ON m.id_miembro = c.id_miembro;

