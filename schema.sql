DROP SCHEMA IF EXISTS sistema_academico;
-- =====================================================
-- SISTEMA ACADÉMICO - ESQUEMA COMPLETO MEJORADO
-- =====================================================

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;

-- =========================
-- CREATE DATABASE
-- =========================
CREATE SCHEMA IF NOT EXISTS `sistema_academico` DEFAULT CHARACTER SET utf8mb4;
USE `sistema_academico`;

-- =========================
-- USUARIO
-- =========================
CREATE TABLE `usuario` (
  `id_usuario` INT AUTO_INCREMENT PRIMARY KEY,
  `tipo_usuario` VARCHAR(20) NOT NULL,
  `nombre` VARCHAR(100) NOT NULL,
  `apellido` VARCHAR(100) NOT NULL,
  `email` VARCHAR(150) NOT NULL UNIQUE,
  `telefono` VARCHAR(20),
  `fecha_registro` DATETIME DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB;

-- =========================
-- GRADO
-- =========================
CREATE TABLE `grado` (
  `id_grado` INT AUTO_INCREMENT PRIMARY KEY,
  `nombre` VARCHAR(50) NOT NULL,
  `nivel` TINYINT NOT NULL
) ENGINE=InnoDB;

-- =========================
-- PERIODO
-- =========================
CREATE TABLE `periodo` (
  `id_periodo` INT AUTO_INCREMENT PRIMARY KEY,
  `nombre` VARCHAR(20) NOT NULL
) ENGINE=InnoDB;

-- =========================
-- ESTUDIANTE
-- =========================
CREATE TABLE `estudiante` (
  `id_estudiante` INT AUTO_INCREMENT PRIMARY KEY,
  `id_usuario` INT,
  `documento` VARCHAR(20) NOT NULL UNIQUE,
  `fecha_nacimiento` DATE NOT NULL,
  `estado` VARCHAR(20) DEFAULT 'Activo',
  FOREIGN KEY (`id_usuario`)
    REFERENCES `usuario`(`id_usuario`)
    ON DELETE CASCADE
) ENGINE=InnoDB;

-- =========================
-- DOCENTE
-- =========================
CREATE TABLE `docente` (
  `id_docente` INT AUTO_INCREMENT PRIMARY KEY,
  `id_usuario` INT,
  `especialidad` VARCHAR(100),
  `codigo_empleado` VARCHAR(20) UNIQUE,
  `departamento` VARCHAR(50),
  FOREIGN KEY (`id_usuario`)
    REFERENCES `usuario`(`id_usuario`)
    ON DELETE CASCADE
) ENGINE=InnoDB;

-- =========================
-- ADMINISTRATIVO
-- =========================
CREATE TABLE `administrativo` (
  `id_administrativo` INT AUTO_INCREMENT PRIMARY KEY,
  `id_usuario` INT,
  `rol_administrativo` VARCHAR(50) NOT NULL,
  `area` VARCHAR(50),
  FOREIGN KEY (`id_usuario`)
    REFERENCES `usuario`(`id_usuario`)
    ON DELETE CASCADE
) ENGINE=InnoDB;

-- =========================
-- MATRICULA
-- =========================
CREATE TABLE `matricula` (
  `id_matricula` INT AUTO_INCREMENT PRIMARY KEY,
  `id_estudiante` INT NOT NULL,
  `id_grado` INT NOT NULL,
  `anio` INT NOT NULL,
  `estado` VARCHAR(20) DEFAULT 'Activo',
  INDEX `idx_matricula_estudiante` (`id_estudiante`),
  INDEX `idx_matricula_grado` (`id_grado`),
  FOREIGN KEY (`id_estudiante`)
    REFERENCES `estudiante`(`id_estudiante`)
    ON DELETE CASCADE,
  FOREIGN KEY (`id_grado`)
    REFERENCES `grado`(`id_grado`)
    ON DELETE CASCADE
) ENGINE=InnoDB;

-- =========================
-- MATERIA
-- =========================
CREATE TABLE `materia` (
  `id_materia` INT AUTO_INCREMENT PRIMARY KEY,
  `nombre` VARCHAR(100) NOT NULL,
  `codigo` VARCHAR(10) UNIQUE,
  `horas_semana` INT NOT NULL
) ENGINE=InnoDB;

-- =========================
-- INSCRIPCION MATERIA
-- =========================
CREATE TABLE `inscripcion_materia` (
  `id_inscripcion` INT AUTO_INCREMENT PRIMARY KEY,
  `id_estudiante` INT NOT NULL,
  `id_materia` INT NOT NULL,
  `anio` INT NOT NULL,
  INDEX `idx_inscripcion_estudiante` (`id_estudiante`),
  INDEX `idx_inscripcion_materia` (`id_materia`),
  FOREIGN KEY (`id_estudiante`)
    REFERENCES `estudiante`(`id_estudiante`)
    ON DELETE CASCADE,
  FOREIGN KEY (`id_materia`)
    REFERENCES `materia`(`id_materia`)
    ON DELETE CASCADE
) ENGINE=InnoDB;

-- =========================
-- DOCENTE_MATERIA
-- =========================
CREATE TABLE `docente_materia` (
  `id_docente_materia` INT AUTO_INCREMENT PRIMARY KEY,
  `id_docente` INT,
  `id_materia` INT,
  `anio_academico` INT NOT NULL,
  UNIQUE (`id_docente`, `id_materia`, `anio_academico`),
  FOREIGN KEY (`id_docente`)
    REFERENCES `docente`(`id_docente`)
    ON DELETE CASCADE,
  FOREIGN KEY (`id_materia`)
    REFERENCES `materia`(`id_materia`)
    ON DELETE CASCADE
) ENGINE=InnoDB;

-- =========================
-- HORARIO
-- =========================
CREATE TABLE `horario` (
  `id_horario` INT AUTO_INCREMENT PRIMARY KEY,
  `dia_semana` ENUM('Lunes','Martes','Miércoles','Jueves','Viernes') NOT NULL,
  `hora_inicio` TIME NOT NULL,
  `hora_fin` TIME NOT NULL,
  `id_grado` INT,
  `id_materia` INT,
  `id_docente` INT,
  FOREIGN KEY (`id_grado`)
    REFERENCES `grado`(`id_grado`)
    ON DELETE SET NULL,
  FOREIGN KEY (`id_materia`)
    REFERENCES `materia`(`id_materia`)
    ON DELETE SET NULL,
  FOREIGN KEY (`id_docente`)
    REFERENCES `docente`(`id_docente`)
    ON DELETE SET NULL
) ENGINE=InnoDB;

-- =========================
-- ASISTENCIA
-- =========================
CREATE TABLE `asistencia` (
  `id_asistencia` INT AUTO_INCREMENT PRIMARY KEY,
  `id_estudiante` INT,
  `fecha` DATE NOT NULL,
  `presente` TINYINT(1) NOT NULL,
  FOREIGN KEY (`id_estudiante`)
    REFERENCES `estudiante`(`id_estudiante`)
    ON DELETE CASCADE
) ENGINE=InnoDB;

-- =========================
-- CALIFICACION
-- =========================
CREATE TABLE `calificacion` (
  `id_calificacion` INT AUTO_INCREMENT PRIMARY KEY,
  `id_estudiante` INT,
  `id_materia` INT,
  `id_periodo` INT NOT NULL,
  `nota` DECIMAL(3,1),
  `fecha_registro` DATETIME DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (`id_estudiante`)
    REFERENCES `estudiante`(`id_estudiante`)
    ON DELETE CASCADE,
  FOREIGN KEY (`id_materia`)
    REFERENCES `materia`(`id_materia`)
    ON DELETE CASCADE,
  FOREIGN KEY (`id_periodo`)
    REFERENCES `periodo`(`id_periodo`)
    ON DELETE CASCADE
) ENGINE=InnoDB;

-- =========================
-- RESTORE SETTINGS
-- =========================
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
