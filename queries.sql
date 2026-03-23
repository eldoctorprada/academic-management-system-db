-- =========================================
-- INSERT DATA
-- =========================================

-- Add a new user
INSERT INTO usuario (tipo_usuario, nombre, apellido, email)
VALUES ('Estudiante', 'Pedro', 'Lopez', 'pedro@example.com');

-- Add a new student
INSERT INTO estudiante (id_usuario, documento, fecha_nacimiento)
VALUES (5, '1003', '2012-03-10');

-- =========================================
-- SELECT QUERIES
-- =========================================

-- Get all students with their grades
SELECT u.nombre, m.nombre AS materia, c.nota
FROM estudiante e
JOIN usuario u ON e.id_usuario = u.id_usuario
JOIN calificacion c ON e.id_estudiante = c.id_estudiante
JOIN materia m ON c.id_materia = m.id_materia;

-- Get students without subjects
SELECT u.nombre
FROM estudiante e
JOIN usuario u ON e.id_usuario = u.id_usuario
LEFT JOIN inscripcion_materia i ON e.id_estudiante = i.id_estudiante
WHERE i.id_materia IS NULL;

-- Get average grade per student
SELECT u.nombre, AVG(c.nota) AS promedio
FROM estudiante e
JOIN usuario u ON e.id_usuario = u.id_usuario
JOIN calificacion c ON e.id_estudiante = c.id_estudiante
GROUP BY e.id_estudiante;

-- =========================================
-- UPDATE
-- =========================================

-- Update a student's grade
UPDATE calificacion
SET nota = 4.8
WHERE id_calificacion = 1;

-- =========================================
-- DELETE
-- =========================================

-- Delete a student (will cascade)
DELETE FROM estudiante
WHERE id_estudiante = 2;
