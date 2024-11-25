--CREACION DE BASE DE DATOS

IF EXISTS (SELECT name FROM sys.databases WHERE name = 'PatitasPerdidas')
BEGIN
    USE master;
    ALTER DATABASE PatitasPerdidas SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE PatitasPerdidas;
END
-----------------------------------------------------------------------------------------------------------------------------

create database PatitasPerdidas
ON PRIMARY
(
    NAME = PatitasPerdidas_Primary,
    FILENAME = 'C:\SQLData\PatitasPerdidas.mdf',
    SIZE = 100MB,
    MAXSIZE = UNLIMITED,
    FILEGROWTH = 10%
)
LOG ON
(
    NAME = PatitasPerdidas_Log,
    FILENAME = 'C:\SQLData\PatitasPerdidas_Log.ldf',
    SIZE = 50MB,
    MAXSIZE = 2048GB,
    FILEGROWTH = 10%
);
GO
-----------------------------------------------------------------------------------------------------------------------------
use PatitasPerdidas
go
-- First, create the filegroups
ALTER DATABASE PatitasPerdidas
ADD FILEGROUP refugio_group;

ALTER DATABASE PatitasPerdidas
ADD FILEGROUP perrito_group;

ALTER DATABASE PatitasPerdidas 
ADD FILEGROUP adoptante_group;

ALTER DATABASE PatitasPerdidas 
ADD FILEGROUP adopcion_group;

ALTER DATABASE PatitasPerdidas 
ADD FILEGROUP veterinario_group;

ALTER DATABASE PatitasPerdidas 
ADD FILEGROUP vacuna_group;

ALTER DATABASE PatitasPerdidas 
ADD FILEGROUP visita_group;

ALTER DATABASE PatitasPerdidas 
ADD FILEGROUP donacion_group;

-----------------------------------------------------------------------------------------------------------------------------
-- Then add files to the filegroups
ALTER DATABASE PatitasPerdidas
ADD FILE
(
    NAME = refugio_file,
    FILENAME = 'C:\SQLData\refugio_file.ndf',
    SIZE = 100MB,
    MAXSIZE = UNLIMITED,
    FILEGROWTH = 10%
)
TO FILEGROUP refugio_group;

ALTER DATABASE PatitasPerdidas
ADD FILE
(
    NAME = adopciones_file,
    FILENAME = 'C:\SQLData\adopciones_file.ndf',
    SIZE = 100MB,
    MAXSIZE = UNLIMITED,
    FILEGROWTH = 10%
)
TO FILEGROUP adopcion_group;

ALTER DATABASE PatitasPerdidas
ADD FILE
(
    NAME = adoptantes_file,
    FILENAME = 'C:\SQLData\adoptantes_file.ndf',
    SIZE = 100MB,
    MAXSIZE = UNLIMITED,
    FILEGROWTH = 10%
)
TO FILEGROUP adoptante_group;

ALTER DATABASE PatitasPerdidas
ADD FILE
(
    NAME = donaciones_file,
    FILENAME = 'C:\SQLData\donaciones_file.ndf',
    SIZE = 100MB,
    MAXSIZE = UNLIMITED,
    FILEGROWTH = 10%
)
TO FILEGROUP donacion_group;

ALTER DATABASE PatitasPerdidas
ADD FILE
(
    NAME = perritos_file,
    FILENAME = 'C:\SQLData\perritos_file.ndf',
    SIZE = 100MB,
    MAXSIZE = UNLIMITED,
    FILEGROWTH = 10%
)
TO FILEGROUP perrito_group;


ALTER DATABASE PatitasPerdidas
ADD FILE
(
    NAME = vacunas_file,
    FILENAME = 'C:\SQLData\vacunas_file.ndf',
    SIZE = 100MB,
    MAXSIZE = UNLIMITED,
    FILEGROWTH = 10%
)
TO FILEGROUP vacuna_group;

ALTER DATABASE PatitasPerdidas
ADD FILE
(
    NAME = veterinarios_file,
    FILENAME = 'C:\SQLData\veterinarios_file.ndf',
    SIZE = 100MB,
    MAXSIZE = UNLIMITED,
    FILEGROWTH = 10%
)
TO FILEGROUP veterinario_group;

ALTER DATABASE PatitasPerdidas
ADD FILE
(
    NAME = visitas_veterinarias_file,
    FILENAME = 'C:\SQLData\visitas_veterinarias_file.ndf',
    SIZE = 100MB,
    MAXSIZE = UNLIMITED,
    FILEGROWTH = 10%
)
TO FILEGROUP visita_group;

-----------------------------------------------------------------------------------------------------------------------------

-- Part 2: Creating Tables with Filegroups
CREATE TABLE Refugio (
    ID_Refugio INT IDENTITY(1,1) PRIMARY KEY,
    Nombre VARCHAR(100) NOT NULL,
    Direccion VARCHAR(255) NOT NULL,
    Telefono VARCHAR(20),
    Email VARCHAR(100)
) ON refugio_group;

CREATE TABLE Perritos (
    ID_Perrito INT IDENTITY(1,1) PRIMARY KEY,
    Nombre VARCHAR(100) NOT NULL,
    Raza VARCHAR(100),
    Edad INT,
    Color VARCHAR(50),
    Sexo VARCHAR(10),
    Estado_Adopcion VARCHAR(20),
    ID_Refugio INT,
    FOREIGN KEY (ID_Refugio) REFERENCES Refugio(ID_Refugio) ON DELETE CASCADE
) ON perrito_group;

CREATE TABLE Adoptantes (
    Nombre VARCHAR(100) NOT NULL,
    Apellido VARCHAR(100) NOT NULL,
    DNI_ADOPTANTE VARCHAR(20) UNIQUE NOT NULL,
    Telefono VARCHAR(20),
    Email VARCHAR(100),
    Direccion VARCHAR(255)
) ON adoptante_group;

CREATE TABLE Adopciones (
    ID INT IDENTITY(1,1) PRIMARY KEY,
    ID_Perrito INT,
    DNI_ADOPTANTE VARCHAR(20) UNIQUE NOT NULL,
    Fecha_Adopcion DATE NOT NULL,
    FOREIGN KEY (ID_Perrito) REFERENCES Perritos(ID_Perrito) ON DELETE CASCADE,
    FOREIGN KEY (DNI_ADOPTANTE) REFERENCES Adoptantes(DNI_ADOPTANTE) ON DELETE CASCADE
) ON adopcion_group;

CREATE TABLE Veterinarios (
    DNI_VETERINARIOS VARCHAR(20) UNIQUE NOT NULL,
    Nombre VARCHAR(100) NOT NULL,
    Apellido VARCHAR(100) NOT NULL,
    Telefono VARCHAR(20),
    Email VARCHAR(100),
    Direccion VARCHAR(255)
) ON veterinario_group;

CREATE TABLE Vacunas (
    ID VARCHAR (100) PRIMARY KEY,
    Nombre VARCHAR(100) NOT NULL,
    Descripcion NVARCHAR(MAX),
	Fecha_Vacunacion DATE NOT NULL,
	ID_Perrito INT,
	DNI_VETERINARIOS VARCHAR(20) UNIQUE NOT NULL
	FOREIGN KEY (ID_Perrito) REFERENCES Perritos(ID_Perrito) ON DELETE CASCADE,
	FOREIGN KEY (DNI_VETERINARIOS) REFERENCES Veterinarios(DNI_VETERINARIOS)
) ON vacuna_group;

CREATE TABLE VisitasVeterinarias (
    ID_Perrito INT,
    DNI_VETERINARIOS VARCHAR(20) UNIQUE NOT NULL,
    Fecha_Visita DATE NOT NULL,
    Descripcion NVARCHAR(MAX),
    FOREIGN KEY (ID_Perrito) REFERENCES Perritos(ID_Perrito) ON DELETE CASCADE,
    FOREIGN KEY (DNI_VETERINARIOS) REFERENCES Veterinarios(DNI_VETERINARIOS)
) ON visita_group;

CREATE TABLE Donaciones (
    Monto DECIMAL(10, 2) NOT NULL,
    Fecha DATE NOT NULL,
    DNI_ADOPTANTE VARCHAR(20) UNIQUE NOT NULL,
    ID_Refugio INT,
    FOREIGN KEY (DNI_ADOPTANTE) REFERENCES Adoptantes(DNI_ADOPTANTE),
    FOREIGN KEY (ID_Refugio) REFERENCES Refugio(ID_Refugio)
) ON donacion_group;



--------------------------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------------------------

--CARGA MASIVA

USE PatitasPerdidas;
--------------------------------------------------------------------------------------------------------------------------------------------------
--REFUGIO
DECLARE @NumRegistros INT = 150;

SET IDENTITY_INSERT Refugio ON;

INSERT INTO Refugio (ID_Refugio, Nombre, Direccion, Telefono, Email)
SELECT
    ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) AS ID,
    'Refugio ' + CAST(ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) AS VARCHAR(10)) AS Nombre,
    'Calle ' + CAST(ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) AS VARCHAR(10)) AS Direccion,
    '555-' + RIGHT('0000' + CAST(ABS(CHECKSUM(NEWID())) % 10000 AS VARCHAR(4)), 4) AS Telefono,
    'refugio' + CAST(ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) AS VARCHAR(10)) + '@example.com' AS Email
FROM (SELECT TOP (@NumRegistros) ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) AS RowNum FROM sys.objects) AS t;
SET IDENTITY_INSERT Refugio OFF;
--ingresa esto en el cmd: bcp "SELECT ID_Refugio, Nombre, Direccion, Telefono, Email FROM PatitasPerdidas.dbo.Refugio" queryout "C:\SQLData\refugio.csv" -c -t, -T -S DESKTOP-7C3P22D\MSSQLSERVER01

-- REFUGIO TEMPORAL
CREATE TABLE #TempRefugio (
    ID_Refugio INT,
    Nombre NVARCHAR(100),
    Direccion NVARCHAR(255),
    Telefono NVARCHAR(20),
    Email NVARCHAR(100)
);
drop table if exists #TempRefugio

-- BULK INSERT para Refugio
BULK INSERT #TempRefugio
FROM 'C:\SQLData\refugio.csv'
WITH (
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n',
    FIRSTROW = 2,
    CODEPAGE = '65001'  -- UTF-8
);

select * from #TempRefugio;

--------------------------------------------------------------------------------------------------------------------------------------------------
-- PERRITOS

DECLARE @NumRegistros INT = 150;
DECLARE @MaxRefugioID INT = (SELECT MAX(ID_Refugio) FROM Refugio);

SET IDENTITY_INSERT Perritos ON;

INSERT INTO Perritos (ID_Perrito, Nombre, Raza, Edad, Color, Sexo, Estado_Adopcion, ID_Refugio)
SELECT 
    ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) AS ID_Perrito,
    'Perrito ' + CAST(ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) AS VARCHAR(10)) AS Nombre,
    CASE 
        WHEN ABS(CHECKSUM(NEWID()) % 3) = 0 THEN 'Labrador'
        WHEN ABS(CHECKSUM(NEWID()) % 3) = 1 THEN 'Bulldog'
        ELSE 'Poodle'
    END AS Raza,
    ABS(CHECKSUM(NEWID()) % 15) + 1 AS Edad,
    CASE 
        WHEN ABS(CHECKSUM(NEWID()) % 3) = 0 THEN 'Negro'
        WHEN ABS(CHECKSUM(NEWID()) % 3) = 1 THEN 'Marrón'
        ELSE 'Blanco'
    END AS Color,
    CASE WHEN ABS(CHECKSUM(NEWID()) % 2) = 0 THEN 'Macho' ELSE 'Hembra' END AS Sexo,
    CASE WHEN ABS(CHECKSUM(NEWID()) % 2) = 0 THEN 'Disponible' ELSE 'Adoptado' END AS Estado_Adopcion,
    ABS(CHECKSUM(NEWID()) % @MaxRefugioID) + 1 AS ID_Refugio
FROM 
    (SELECT TOP (@NumRegistros) 
        ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) AS RowNum 
    FROM sys.objects) AS t;

SET IDENTITY_INSERT Perritos OFF;

--ingresa esto en el cmd: bcp "SELECT ID_Perrito, Nombre, Raza, Edad, Color, Sexo, Estado_Adopcion, ID_Refugio FROM PatitasPerdidas.dbo.Perritos" queryout "C:\SQLData\Perritos.csv" -c -t, -T -S DESKTOP-7C3P22D\MSSQLSERVER01 

-- PERRITOS TEMPORAL
CREATE TABLE #TempPerritos (
    ID_Perrito INT,
    Nombre NVARCHAR(100),
    Raza NVARCHAR(100),
    Edad INT,
    Color NVARCHAR(50),
    Sexo NVARCHAR(10),
    Estado_Adopcion NVARCHAR(20),
    ID_Refugio INT
);
drop table if exists #TempPerritos

-- BULK INSERT con manejo de errores
BULK INSERT #TempPerritos
FROM 'C:\SQLData\Perritos.csv'
WITH (
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n',
    FIRSTROW = 2,
    CODEPAGE = '65001'
);

select * from #tempPerritos;

--------------------------------------------------------------------------------------------------------------------------------------------------
-- ADOPTANTES

DECLARE @NumRegistros INT = 140;

INSERT INTO Adoptantes (Nombre, Apellido, DNI_ADOPTANTE, Telefono, Email, Direccion)
SELECT
    'Nombre' + CAST(ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) AS VARCHAR(10)) AS Nombre,
    'Apellido' + CAST(ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) AS VARCHAR(10)) AS Apellido,
    'DNI' + CAST(ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) AS VARCHAR(10)) AS DNI_ADOPTANTE,
    '555-' + RIGHT('0000' + CAST(ABS(CHECKSUM(NEWID())) % 10000 AS VARCHAR(4)), 4) AS Telefono,
    'adoptante' + CAST(ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) AS VARCHAR(10)) + '@example.com' AS Email,
    'Calle ' + CAST(ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) AS VARCHAR(10)) + ', Ciudad' AS Direccion
FROM (SELECT TOP (@NumRegistros) ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) AS RowNum FROM sys.objects) AS t;

--bcp "SELECT Nombre, Apellido, DNI_ADOPTANTE, Telefono, Email, Direccion FROM PatitasPerdidas.dbo.Adoptantes" queryout "C:\SQLData\adoptantes.csv" -c -t, -T -S DESKTOP-7C3P22D\MSSQLSERVER01

-- ADOPTANTES TEMPORAL
CREATE TABLE #TempAdoptantes (
    Nombre NVARCHAR(100),
    Apellido NVARCHAR(100),
    DNI_ADOPTANTE NVARCHAR(20),
    Telefono NVARCHAR(20),
    Email NVARCHAR(100),
    Direccion NVARCHAR(255)
);
drop table #TempAdoptantes

-- BULK INSERT para Adoptantes
BULK INSERT #TempAdoptantes
FROM 'C:\SQLData\adoptantes.csv'
WITH (
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n',
    FIRSTROW = 2,
    CODEPAGE = '65001'
);

select * from #TempAdoptantes
--------------------------------------------------------------------------------------------------------------------------------------------------
-- ADOPCIONES
DECLARE @NumRegistros INT = 140;
DECLARE @MaxPerritoID INT = (SELECT MAX(ID_Perrito) FROM Perritos);

INSERT INTO Adopciones (ID_Perrito, DNI_ADOPTANTE, Fecha_Adopcion)
SELECT
    ABS(CHECKSUM(NEWID()) % @MaxPerritoID) + 1 AS ID_Perrito,
    'DNI' + CAST(ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) AS VARCHAR(10)) AS DNI_ADOPTANTE,
    DATEADD(DAY, -ABS(CHECKSUM(NEWID()) % 365), GETDATE()) AS Fecha_Adopcion
FROM (SELECT TOP (@NumRegistros) ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) AS RowNum FROM sys.objects) AS t;
--no correr esto: 
TRUNCATE TABLE Adopciones;

--bcp "SELECT ID_Perrito, DNI_ADOPTANTE, Fecha_Adopcion FROM PatitasPerdidas.dbo.Adopciones" queryout "C:\SQLData\adopciones.csv" -c -t, -T -S DESKTOP-7C3P22D\MSSQLSERVER01

-- ADOPCIONES TEMPORAL
CREATE TABLE #TempAdopciones (
    ID_Perrito INT,
    DNI_ADOPTANTE NVARCHAR(20),
    Fecha_Adopcion DATE
);
drop table #TempAdopciones
BULK INSERT #TempAdopciones
FROM 'C:\SQLData\adopciones.csv'
WITH (
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n',
    FIRSTROW = 2,
    CODEPAGE = '65001'
);


select *from #TempAdopciones
--------------------------------------------------------------------------------------------------------------------------------------------------
-- VETERINARIOS
DECLARE @NumRegistros INT = 140;
INSERT INTO Veterinarios (DNI_VETERINARIOS, Nombre, Apellido, Telefono, Email, Direccion)
SELECT
    'DNI_V' + CAST(ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) AS VARCHAR(10)) AS DNI_VETERINARIOS,
    'VetNombre' + CAST(ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) AS VARCHAR(10)) AS Nombre,
    'VetApellido' + CAST(ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) AS VARCHAR(10)) AS Apellido,
    '555-' + RIGHT('0000' + CAST(ABS(CHECKSUM(NEWID())) % 10000 AS VARCHAR(4)), 4) AS Telefono,
    'veterinario' + CAST(ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) AS VARCHAR(10)) + '@example.com' AS Email,
    'Calle ' + CAST(ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) AS VARCHAR(10)) + ', Ciudad' AS Direccion
FROM (SELECT TOP (@NumRegistros) ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) AS RowNum FROM sys.objects) AS t;

--bcp "SELECT DNI_VETERINARIOS, Nombre, Apellido, Telefono, Email, Direccion FROM PatitasPerdidas.dbo.Veterinarios" queryout "C:\SQLData\veterinarios.csv" -c -t, -T -S DESKTOP-7C3P22D\MSSQLSERVER01

-- VETERINARIOS TEMPORAL
CREATE TABLE #TempVeterinarios (
    DNI_VETERINARIOS NVARCHAR(20),
    Nombre NVARCHAR(100),
    Apellido NVARCHAR(100),
    Telefono NVARCHAR(20),
    Email NVARCHAR(100),
    Direccion NVARCHAR(255)
);

-- BULK INSERT para Veterinarios
BULK INSERT #TempVeterinarios
FROM 'C:\SQLData\veterinarios.csv'
WITH (
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n',
    FIRSTROW = 2,
    CODEPAGE = '65001'
);

select * from #TempVeterinarios
--------------------------------------------------------------------------------------------------------------------------------------------------
-- VACUNAS
DECLARE @NumRegistros INT = 140;
DECLARE @MaxPerritoID INT = (SELECT MAX(ID_Perrito) FROM Perritos);

INSERT INTO Vacunas (ID, Nombre, Descripcion, Fecha_Vacunacion, ID_Perrito, DNI_VETERINARIOS)
SELECT
    'VAC' + CAST(ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) AS VARCHAR(10)) AS ID,
    'Vacuna ' + CAST(ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) AS VARCHAR(10)) AS Nombre,
    'Descripción de la vacuna ' + CAST(ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) AS VARCHAR(10)) AS Descripcion,
    DATEADD(DAY, -ABS(CHECKSUM(NEWID()) % 365), GETDATE()) AS Fecha_Vacunacion,
    ABS(CHECKSUM(NEWID()) % @MaxPerritoID) + 1 AS ID_Perrito,
    'DNI_V' + CAST(ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) AS VARCHAR(10)) AS DNI_VETERINARIOS
FROM (SELECT TOP (@NumRegistros) ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) AS RowNum FROM sys.objects) AS t;

--bcp "SELECT ID, Nombre, Descripcion, Fecha_Vacunacion, ID_Perrito, DNI_VETERINARIOS FROM PatitasPerdidas.dbo.Vacunas" queryout "C:\SQLData\vacunas.csv" -c -t, -T -S DESKTOP-7C3P22D\MSSQLSERVER01

-- VACUNAS TEMPORAL
CREATE TABLE #TempVacunas (
    ID NVARCHAR(100),
    Nombre NVARCHAR(100),
    Descripcion NVARCHAR(MAX),
    Fecha_Vacunacion DATE,
    ID_Perrito INT,
    DNI_VETERINARIOS NVARCHAR(20)
);

-- BULK INSERT para Vacunas
BULK INSERT #TempVacunas
FROM 'C:\SQLData\vacunas.csv'
WITH (
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n',
    FIRSTROW = 2,
    CODEPAGE = '65001'
);

select * from #TempVacunas
--------------------------------------------------------------------------------------------------------------------------------------------------

-- VISITAS VETERINARIAS
DECLARE @NumRegistros INT = 140;
DECLARE @MaxPerritoID INT = (SELECT MAX(ID_Perrito) FROM Perritos);
DECLARE @VeterinarioIDs TABLE (DNI_VETERINARIOS VARCHAR(20), RowNum INT);

-- Insertar los DNI_VETERINARIOS únicos en la tabla temporal y asignarles un número de fila
WITH VeterinarioRowNum AS (
    SELECT DNI_VETERINARIOS, ROW_NUMBER() OVER (ORDER BY DNI_VETERINARIOS) AS RowNum
    FROM Veterinarios
)
INSERT INTO @VeterinarioIDs (DNI_VETERINARIOS, RowNum)
SELECT DNI_VETERINARIOS, RowNum FROM VeterinarioRowNum;

-- Insertar las visitas veterinarias, utilizando la tabla temporal para obtener DNI_VETERINARIOS únicos
DECLARE @i INT = 1;
WHILE @i <= @NumRegistros
BEGIN
    INSERT INTO VisitasVeterinarias (ID_Perrito, DNI_VETERINARIOS, Fecha_Visita, Descripcion)
    SELECT
        CAST(ABS(CHECKSUM(NEWID())) % @MaxPerritoID + 1 AS INT) AS ID_Perrito,
        v.DNI_VETERINARIOS,
        DATEADD(DAY, -ABS(CHECKSUM(NEWID()) % 365), GETDATE()) AS Fecha_Visita,
        'Descripción de visita veterinaria ' + CAST(@i AS VARCHAR(10)) AS Descripcion
    FROM @VeterinarioIDs v
    WHERE v.RowNum = @i
    SET @i = @i + 1;
END
	TRUNCATE TABLE VisitasVeterinarias 
--bcp "SELECT ID, Fecha_Visita, ID_Perrito, DNI_VETERINARIOS, Motivo, Tratamiento FROM PatitasPerdidas.dbo.Visitas_Veterinarias" queryout "C:\SQLData\visitas_veterinarias.csv" -c -t, -T -S DESKTOP-7C3P22D\MSSQLSERVER01

-- VISITAS VETERINARIAS TEMPORAL
CREATE TABLE #TempVisitasVeterinarias (
    ID_Perrito INT,
    DNI_VETERINARIOS NVARCHAR(20),
    Fecha_Visita DATE,
    Descripcion NVARCHAR(MAX)
);
drop table #TempVisitasVeterinarias
-- BULK INSERT para Visitas Veterinarias
BULK INSERT #TempVisitasVeterinarias
FROM 'C:\SQLData\visitasveterinarias.csv'
WITH (
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n',
    FIRSTROW = 2,
    CODEPAGE = '65001'
);

select * from #TempVisitasVeterinarias
--------------------------------------------------------------------------------------------------------------------------------------------------
-- DONACIONES
DECLARE @NumRegistros INT = 140;
DECLARE @MaxRefugioID INT = (SELECT MAX(ID_Refugio) FROM Refugio);

INSERT INTO Donaciones (Monto, Fecha, DNI_ADOPTANTE, ID_Refugio)
SELECT
    CAST(ABS(CHECKSUM(NEWID()) % 500) AS DECIMAL(10, 2)) AS Monto,
    DATEADD(DAY, -ABS(CHECKSUM(NEWID()) % 365), GETDATE()) AS Fecha,
    'DNI' + CAST(ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) AS VARCHAR(10)) AS DNI_ADOPTANTE,
    ABS(CHECKSUM(NEWID()) % @MaxRefugioID) + 1 AS ID_Refugio
FROM (SELECT TOP (@NumRegistros) ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) AS RowNum FROM sys.objects) AS t;

--bcp "SELECT Monto, Fecha, DNI_ADOPTANTE, ID_Refugio FROM PatitasPerdidas.dbo.Donaciones" queryout "C:\SQLData\donaciones.csv" -c -t, -T -S DESKTOP-7C3P22D\MSSQLSERVER01

-- DONACIONES TEMPORAL
CREATE TABLE #TempDonaciones (
    Monto DECIMAL(10, 2),
    Fecha DATE,
    DNI_ADOPTANTE NVARCHAR(20),
    ID_Refugio INT
);

-- BULK INSERT para Donaciones
BULK INSERT #TempDonaciones
FROM 'C:\SQLData\donaciones.csv'
WITH (
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n',
    FIRSTROW = 2,
    CODEPAGE = '65001'
);

select * from #TempDonaciones


-- Verificación de datos importados (opcional)
SELECT 'Refugio' as Tabla, COUNT(*) as Registros FROM #TempRefugio
UNION ALL
SELECT 'Perritos', COUNT(*) FROM #TempPerritos
UNION ALL
SELECT 'Adoptantes', COUNT(*) FROM #TempAdoptantes
UNION ALL
SELECT 'Adopciones', COUNT(*) FROM #TempAdopciones
UNION ALL
SELECT 'Veterinarios', COUNT(*) FROM #TempVeterinarios
UNION ALL
SELECT 'Vacunas', COUNT(*) FROM #TempVacunas
UNION ALL
SELECT 'Visitas Veterinarias', COUNT(*) FROM #TempVisitasVeterinarias
UNION ALL
SELECT 'Donaciones', COUNT(*) FROM #TempDonaciones;

---------------------------------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------------------------------
--INDICES
CREATE NONCLUSTERED INDEX IX_Perritos_IDRefugio ON Perritos(ID_Refugio);
CREATE NONCLUSTERED INDEX IX_Adopciones_IDPerrito ON Adopciones(ID_Perrito);
CREATE NONCLUSTERED INDEX IX_Adopciones_DNIAdoptante ON Adopciones(DNI_Adoptante);
CREATE NONCLUSTERED INDEX IX_VisitasVeterinarias_IDPerrito ON VisitasVeterinarias(ID_Perrito);
---------------------------------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------------------------------
--DICCIONARIO DE DATOS (CONSULTAS DE METADATA)
-- List all filegroups
SELECT name AS "Nombre del Filegroup", 
       size/128.0 AS "Tamaño (MB)"
FROM sys.database_files;

-- Get table information
SELECT 
    t.name AS "Nombre de la Tabla",
    c.name AS "Nombre de la Columna",
    TYPE_NAME(c.system_type_id) AS "Tipo de Dato",
    c.max_length AS "Longitud Máxima",
    c.is_nullable AS "¿Nulo?"
FROM sys.tables t
INNER JOIN sys.columns c ON t.object_id = c.object_id
WHERE t.type = 'U'
ORDER BY t.name, c.column_id;

-- Get primary keys
SELECT 
    t.name AS "Nombre de la Tabla",
    c.name AS "Columna Clave Primaria"
FROM sys.tables t
INNER JOIN sys.indexes i ON t.object_id = i.object_id
INNER JOIN sys.index_columns ic ON i.object_id = ic.object_id AND i.index_id = ic.index_id
INNER JOIN sys.columns c ON ic.object_id = c.object_id AND ic.column_id = c.column_id
WHERE i.is_primary_key = 1;
---------------------------------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------------------------------
--VIEWS
-- Vista 2: Perritos sin vacunas
CREATE VIEW PerritosSinVacunas AS
SELECT 
    P.Nombre AS Perrito_Nombre,
    P.Raza,
    P.Color,
    P.Sexo,
    R.Nombre AS Refugio_Nombre,
    R.Telefono AS Refugio_Telefono,
    (SELECT TOP 1 Nombre FROM Adoptantes AD WHERE AD.Direccion LIKE '%Calle%') AS Posible_Adoptante
FROM Perritos P
JOIN Refugio R ON P.ID_Refugio = R.ID_Refugio
WHERE NOT EXISTS (SELECT 1 FROM Vacunas V WHERE V.ID_Perrito = P.ID_Perrito);

-- Vista 6: Información de perritos adoptados con su último chequeo
CREATE VIEW PerritosAdoptadosUltimoChequeo AS
SELECT 
    P.Nombre AS Perrito_Nombre,
    P.Raza,
    P.Edad,
    V.Nombre AS Veterinario_Nombre,
    V.Apellido AS Veterinario_Apellido,
    VV.Fecha_Visita AS Ultima_Visita,
    R.Nombre AS Refugio_Nombre
FROM Perritos P
LEFT JOIN VisitasVeterinarias VV ON P.ID_Perrito = VV.ID_Perrito
LEFT JOIN Veterinarios V ON VV.DNI_VETERINARIOS = V.DNI_VETERINARIOS
JOIN Refugio R ON P.ID_Refugio = R.ID_Refugio
WHERE P.Estado_Adopcion = 'Adoptado'
AND (VV.Fecha_Visita IS NULL OR VV.Fecha_Visita = (
    SELECT MAX(Fecha_Visita) 
    FROM VisitasVeterinarias 
    WHERE ID_Perrito = P.ID_Perrito
));

-- Vista 8: Perritos vacunados por múltiples veterinarios
CREATE VIEW PerritosMultiplesVeterinarios AS
SELECT 
    P.Nombre AS Perrito_Nombre,
    P.Raza,
    COUNT(DISTINCT V.DNI_VETERINARIOS) AS Cantidad_Veterinarios,
    R.Nombre AS Refugio_Nombre,
    V.Nombre AS Veterinario_Nombre
FROM Perritos P
JOIN Vacunas VA ON P.ID_Perrito = VA.ID_Perrito
JOIN Veterinarios V ON VA.DNI_VETERINARIOS = V.DNI_VETERINARIOS
JOIN Refugio R ON P.ID_Refugio = R.ID_Refugio
GROUP BY P.ID_Perrito, P.Nombre, P.Raza, R.Nombre, V.Nombre
HAVING COUNT(DISTINCT V.DNI_VETERINARIOS) >= 1;

-- Vista 9: Donaciones anuales por refugio y mes
CREATE VIEW DonacionesAnualesPorRefugio AS
SELECT R.Nombre AS Refugio, MONTH(D.Fecha) AS Mes, SUM(D.Monto) AS Total_Donado
FROM Refugio R
JOIN Donaciones D ON R.ID_Refugio = D.ID_Refugio
WHERE D.Fecha > DATEADD(year, -1, GETDATE())
GROUP BY R.Nombre, MONTH(D.Fecha);

-- Vista 10: Perritos sin visitas veterinarias recientes
CREATE VIEW PerritosSinVisitasRecientes AS
SELECT P.Nombre AS Nombre_Perrito, R.Nombre AS Refugio, R.Direccion
FROM Perritos P
JOIN Refugio R ON P.ID_Refugio = R.ID_Refugio
LEFT JOIN VisitasVeterinarias VV ON P.ID_Perrito = VV.ID_Perrito
WHERE (VV.Fecha_Visita IS NULL OR VV.Fecha_Visita < DATEADD(year, -1, GETDATE()))
  AND P.Estado_Adopcion = 'Disponible';

-- Vista 11: Promedio de edad de perritos adoptados
CREATE VIEW PromedioEdadAdoptados AS
SELECT R.Nombre AS Nombre_Refugio, AVG(P.Edad) AS Edad_Promedio_Adoptados
FROM Refugio R
JOIN Perritos P ON R.ID_Refugio = P.ID_Refugio
JOIN Adopciones AD ON P.ID_Perrito = AD.ID_Perrito
GROUP BY R.Nombre;

-- Vista 12: Promedio de visitas veterinarias anuales
CREATE VIEW PromedioVisitasVeterinarias AS
SELECT P.Nombre AS Perrito, COUNT(VV.Fecha_Visita) AS Total_Visitas,
       (SELECT AVG(VisitasAnuales) 
        FROM (SELECT COUNT(Fecha_Visita) AS VisitasAnuales 
              FROM VisitasVeterinarias 
              WHERE Fecha_Visita > DATEADD(year, -1, GETDATE()) 
              GROUP BY ID_Perrito) AS PromedioVisitas) AS Promedio_Visitas_Anual
FROM Perritos P
LEFT JOIN VisitasVeterinarias VV ON P.ID_Perrito = VV.ID_Perrito
WHERE VV.Fecha_Visita > DATEADD(year, -1, GETDATE())
GROUP BY P.Nombre;

-- Vista 13: Historial de visitas veterinarias
CREATE VIEW HistorialVisitasVeterinarias AS
SELECT P.Nombre AS Nombre_Perrito, V.Nombre AS Nombre_Veterinario, VV.Fecha_Visita
FROM Perritos P
JOIN VisitasVeterinarias VV ON P.ID_Perrito = VV.ID_Perrito
JOIN Veterinarios V ON VV.DNI_VETERINARIOS = V.DNI_VETERINARIOS;

-- Vista 14: Resumen de donaciones por adoptante
CREATE VIEW ResumenDonacionesAdoptantes AS
SELECT A.Nombre AS Nombre_Adoptante, A.Apellido, SUM(D.Monto) AS Total_Donado,
       MAX(D.Fecha) AS Ultima_Donacion
FROM Adoptantes A
JOIN Donaciones D ON A.DNI_ADOPTANTE = D.DNI_ADOPTANTE
GROUP BY A.Nombre, A.Apellido;

-- Vista 18: Adopciones mensuales con promedio
CREATE VIEW AdopcionesMensualesPromedio AS
SELECT MONTH(Fecha_Adopcion) AS Mes, COUNT(*) AS Total_Adopciones,
       (SELECT AVG(AdopcionesMensuales) 
        FROM (SELECT COUNT(*) AS AdopcionesMensuales
              FROM Adopciones
              WHERE Fecha_Adopcion > DATEADD(year, -1, GETDATE())
              GROUP BY MONTH(Fecha_Adopcion)) AS PromedioMensual) AS Promedio_Adopciones_Mensual
FROM Adopciones
WHERE Fecha_Adopcion > DATEADD(year, -1, GETDATE())
GROUP BY MONTH(Fecha_Adopcion);

-- Vista 19: Adopciones por refugio
CREATE VIEW AdopcionesPorRefugio AS
SELECT R.Nombre AS Nombre_Refugio, R.Direccion, COUNT(A.ID) AS Total_Adopciones
FROM Refugio R
JOIN Perritos P ON R.ID_Refugio = P.ID_Refugio
JOIN Adopciones A ON P.ID_Perrito = A.ID_Perrito
GROUP BY R.Nombre, R.Direccion;
--CONSULTAS Y SUBCONSULTAS


-- Consulta 2: Detalle de todos los perritos que NO han recibido ninguna vacuna, junto con su refugio y posibles adoptantes
SELECT 
    P.Nombre AS Perrito_Nombre,
    P.Raza,
    P.Color,
    P.Sexo,
    R.Nombre AS Refugio_Nombre,
    R.Telefono AS Refugio_Telefono,
    (SELECT TOP 1 Nombre FROM Adoptantes AD WHERE AD.Direccion LIKE '%Calle%') AS Posible_Adoptante
FROM Perritos P
JOIN Refugio R ON P.ID_Refugio = R.ID_Refugio
WHERE NOT EXISTS (SELECT 1 FROM Vacunas V WHERE V.ID_Perrito = P.ID_Perrito)
ORDER BY R.Nombre;

-- Consulta 6: Información detallada de todos los perritos que están en adopción junto con su último chequeo veterinario (si existe)
SELECT 
    P.Nombre AS Perrito_Nombre,
    P.Raza,
    P.Edad,
    V.Nombre AS Veterinario_Nombre,
    V.Apellido AS Veterinario_Apellido,
    VV.Fecha_Visita AS Ultima_Visita,
    R.Nombre AS Refugio_Nombre
FROM Perritos P
LEFT JOIN VisitasVeterinarias VV ON P.ID_Perrito = VV.ID_Perrito
LEFT JOIN Veterinarios V ON VV.DNI_VETERINARIOS = V.DNI_VETERINARIOS
JOIN Refugio R ON P.ID_Refugio = R.ID_Refugio
WHERE P.Estado_Adopcion = 'Adoptado'
AND (VV.Fecha_Visita IS NULL OR VV.Fecha_Visita = (
    SELECT MAX(Fecha_Visita) 
    FROM VisitasVeterinarias 
    WHERE ID_Perrito = P.ID_Perrito
))
ORDER BY P.Nombre;



-- Consulta 8: Perritos vacunados por más de un veterinario con los detalles de vacunación y refugio
SELECT 
    P.Nombre AS Perrito_Nombre,
    P.Raza,
    COUNT(DISTINCT V.DNI_VETERINARIOS) AS Cantidad_Veterinarios,
    R.Nombre AS Refugio_Nombre,
    V.Nombre AS Veterinario_Nombre
FROM Perritos P
JOIN Vacunas VA ON P.ID_Perrito = VA.ID_Perrito
JOIN Veterinarios V ON VA.DNI_VETERINARIOS = V.DNI_VETERINARIOS
JOIN Refugio R ON P.ID_Refugio = R.ID_Refugio
GROUP BY P.ID_Perrito, P.Nombre, P.Raza, R.Nombre, V.Nombre
HAVING COUNT(DISTINCT V.DNI_VETERINARIOS) >= 1;



--Consulta 9: Donaciones en el último año agrupadas por refugio y por mes
SELECT R.Nombre AS Refugio, MONTH(D.Fecha) AS Mes, SUM(D.Monto) AS Total_Donado
FROM Refugio R
JOIN Donaciones D ON R.ID_Refugio = D.ID_Refugio
WHERE D.Fecha > DATEADD(year, -1, GETDATE())
GROUP BY R.Nombre, MONTH(D.Fecha)
ORDER BY R.Nombre, Mes;

-- Consulta 10: Perritos que no han recibido visitas veterinarias en el último año, con detalle de su refugio
SELECT P.Nombre AS Nombre_Perrito, R.Nombre AS Refugio, R.Direccion
FROM Perritos P
JOIN Refugio R ON P.ID_Refugio = R.ID_Refugio
LEFT JOIN VisitasVeterinarias VV ON P.ID_Perrito = VV.ID_Perrito
WHERE (VV.Fecha_Visita IS NULL OR VV.Fecha_Visita < DATEADD(year, -1, GETDATE()))
  AND P.Estado_Adopcion = 'Disponible'
ORDER BY P.Nombre;

-- Consulta 11: Promedio de edad de perritos adoptados por refugio
SELECT R.Nombre AS Nombre_Refugio, AVG(P.Edad) AS Edad_Promedio_Adoptados
FROM Refugio R
JOIN Perritos P ON R.ID_Refugio = P.ID_Refugio
JOIN Adopciones AD ON P.ID_Perrito = AD.ID_Perrito
GROUP BY R.Nombre
ORDER BY Edad_Promedio_Adoptados DESC;

-- Consulta 12: Promedio de visitas veterinarias por perrito en el último año
SELECT P.Nombre AS Perrito, COUNT(VV.Fecha_Visita) AS Total_Visitas,
       (SELECT AVG(VisitasAnuales) 
        FROM (SELECT COUNT(Fecha_Visita) AS VisitasAnuales 
              FROM VisitasVeterinarias 
              WHERE Fecha_Visita > DATEADD(year, -1, GETDATE()) 
              GROUP BY ID_Perrito) AS PromedioVisitas) AS Promedio_Visitas_Anual
FROM Perritos P
LEFT JOIN VisitasVeterinarias VV ON P.ID_Perrito = VV.ID_Perrito
WHERE VV.Fecha_Visita > DATEADD(year, -1, GETDATE())
GROUP BY P.Nombre
ORDER BY Total_Visitas DESC;

-- Consulta 13: Lista de perritos y sus visitas veterinarias, ordenado por fecha de la última visita
SELECT P.Nombre AS Nombre_Perrito, V.Nombre AS Nombre_Veterinario, VV.Fecha_Visita
FROM Perritos P
JOIN VisitasVeterinarias VV ON P.ID_Perrito = VV.ID_Perrito
JOIN Veterinarios V ON VV.DNI_VETERINARIOS = V.DNI_VETERINARIOS
ORDER BY VV.Fecha_Visita DESC;


-- Consulta 14: Detalles de donaciones por adoptante, incluyendo la cantidad total donada y la fecha de la última donación
SELECT A.Nombre AS Nombre_Adoptante, A.Apellido, SUM(D.Monto) AS Total_Donado,
       MAX(D.Fecha) AS Ultima_Donacion
FROM Adoptantes A
JOIN Donaciones D ON A.DNI_ADOPTANTE = D.DNI_ADOPTANTE
GROUP BY A.Nombre, A.Apellido
ORDER BY Total_Donado DESC;

-- Consulta 18: Total de adopciones por mes en el último año, con subconsulta para calcular el promedio mensual
SELECT MONTH(Fecha_Adopcion) AS Mes, COUNT(*) AS Total_Adopciones,
       (SELECT AVG(AdopcionesMensuales) 
        FROM (SELECT COUNT(*) AS AdopcionesMensuales
              FROM Adopciones
              WHERE Fecha_Adopcion > DATEADD(year, -1, GETDATE())
              GROUP BY MONTH(Fecha_Adopcion)) AS PromedioMensual) AS Promedio_Adopciones_Mensual
FROM Adopciones
WHERE Fecha_Adopcion > DATEADD(year, -1, GETDATE())
GROUP BY MONTH(Fecha_Adopcion)
ORDER BY Mes;

-- Consulta 19: Cantidad de adopciones por refugio, incluyendo el nombre y la dirección del refugio
SELECT R.Nombre AS Nombre_Refugio, R.Direccion, COUNT(A.ID) AS Total_Adopciones
FROM Refugio R
JOIN Perritos P ON R.ID_Refugio = P.ID_Refugio
JOIN Adopciones A ON P.ID_Perrito = A.ID_Perrito
GROUP BY R.Nombre, R.Direccion
ORDER BY Total_Adopciones DESC;
---------------------------------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------------------------------
--CURSORES

--1
DECLARE @ID_Perrito INT
DECLARE @Nombre VARCHAR(100) 
DECLARE @DNI_VETERINARIOS VARCHAR(20)
DECLARE @Fecha_Visita DATE

DECLARE cursor_visitas CURSOR FOR
SELECT p.ID_Perrito, p.Nombre, v.DNI_VETERINARIOS, v.Fecha_Visita
FROM Perritos p
JOIN VisitasVeterinarias v ON p.ID_Perrito = v.ID_Perrito
WHERE p.ID_Perrito = @ID_Perrito

OPEN cursor_visitas

FETCH NEXT FROM cursor_visitas 
INTO @ID_Perrito, @Nombre, @DNI_VETERINARIOS, @Fecha_Visita

WHILE @@FETCH_STATUS = 0
BEGIN
    PRINT 'Perrito: ' + @Nombre
    PRINT 'Veterinario: ' + @DNI_VETERINARIOS
    PRINT 'Fecha de Visita: ' + CAST(@Fecha_Visita AS VARCHAR(10))

    FETCH NEXT FROM cursor_visitas
    INTO @ID_Perrito, @Nombre, @DNI_VETERINARIOS, @Fecha_Visita
END

CLOSE cursor_visitas
DEALLOCATE cursor_visitas


------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------------------------------
--DETONADORES
-- Detonador (Trigger)
CREATE TRIGGER TR_Adopciones_Insert
ON Adopciones
AFTER INSERT
AS
BEGIN
    DECLARE @IDPerrito INT, @DNIAdoptante VARCHAR(20), @FechaAdopcion DATE
    SELECT @IDPerrito = ID_Perrito, @DNIAdoptante = DNI_ADOPTANTE, @FechaAdopcion = Fecha_Adopcion FROM inserted

    UPDATE Perritos
    SET Estado_Adopcion = 'Adoptado'
    WHERE ID_Perrito = @IDPerrito

    INSERT INTO Donaciones (Monto, Fecha, DNI_ADOPTANTE, ID_Refugio)
    VALUES (100.00, @FechaAdopcion, @DNIAdoptante, (SELECT ID_Refugio FROM Perritos WHERE ID_Perrito = @IDPerrito))
END
GO


-- Trigger to prevent duplicate veterinarian entries
CREATE TRIGGER TR_Veterinarios_UniqueCheck
ON Veterinarios
INSTEAD OF INSERT
AS
BEGIN
    INSERT INTO Veterinarios 
    SELECT Nombre, Apellido, DNI_VETERINARIOS, Telefono, Email, Direccion
    FROM inserted i
    WHERE NOT EXISTS (
        SELECT 1 FROM Veterinarios v 
        WHERE v.DNI_VETERINARIOS = i.DNI_VETERINARIOS
    )
END
GO


---------------------------------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------------------------------
--SEGURIDAD

-- Seguridad, Usuarios, Privilegios y Roles
CREATE LOGIN ADOP WITH PASSWORD = '12345'
CREATE USER ADOP FOR LOGIN adoptante_user

CREATE LOGIN VET WITH PASSWORD = '12345'
CREATE USER VET FOR LOGIN veterinario_user

GRANT SELECT, INSERT, UPDATE ON Adopciones TO ADOP
GRANT SELECT, INSERT, UPDATE ON VisitasVeterinarias TO VET

CREATE ROLE refugio_admin
GRANT ALL PRIVILEGES ON Refugio TO refugio_admin
GRANT ALL PRIVILEGES ON Perritos TO refugio_admin
GRANT ALL PRIVILEGES ON Inventario TO refugio_admin

EXEC sp_addrolemember 'refugio_admin', 'admin_user'
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--BACKUP
BACKUP DATABASE PatitasPerdidas
TO DISK = 'C:\SQLData\BACKUP\PatitasPerdidas.bak'
WITH INIT, 
     NAME = 'Full Backup of PatitasPerdidas';

--BACKUP DIARIO
-- Create a backup stored procedure
CREATE PROCEDURE DailyDatabaseBackup
AS
BEGIN
    DECLARE @BackupPath NVARCHAR(255)
    DECLARE @BackupFileName NVARCHAR(255)
    DECLARE @BackupFullPath NVARCHAR(255)

    -- Set backup directory path
    SET @BackupPath = 'C:\SQLData\PatitasPerdidas\'

    -- Create backup filename with current date
    SET @BackupFileName = 'PatitasPerdidas_Backup_' + 
        REPLACE(CONVERT(NVARCHAR(10), GETDATE(), 120), '-', '_') + 
        '.bak'

    SET @BackupFullPath = @BackupPath + @BackupFileName

    -- Ensure backup directory exists (requires xp_cmdshell enabled)
    EXEC xp_cmdshell 'mkdir "C:\SQLData\PatitasPerdidas"'

    -- Perform full backup with compression
    BACKUP DATABASE PatitasPerdidas
    TO DISK = @BackupFullPath
    WITH 
        COMPRESSION, 
        STATS = 10,
        NAME = 'Daily Full Backup',
        DESCRIPTION = 'Automated daily full database backup'

    -- Optional: Delete backups older than 30 days
    EXEC xp_cmdshell 'forfiles /p "C:\SQLData\PatitasPerdidas" /s /m *.bak /d -30 /c "cmd /c del @path"'
END
GO

-- Create SQL Server Agent job for daily backup
USE msdb;
GO

EXEC msdb.dbo.sp_add_job
    @job_name = N'Daily PatitasPerdidas Backup';

EXEC msdb.dbo.sp_add_jobstep
    @job_name = N'Daily PatitasPerdidas Backup',
    @step_name = N'Run Backup Procedure',
    @subsystem = N'TSQL',
    @command = N'EXEC DailyDatabaseBackup';

EXEC msdb.dbo.sp_add_schedule
    @schedule_name = N'Daily at 2 AM',
    @freq_type = 4,  -- Daily
    @freq_interval = 1,  -- Every day
    @active_start_time = 020000;  -- 2:00 AM

EXEC msdb.dbo.sp_attach_job
    @job_name = N'Daily PatitasPerdidas Backup',
    @schedule_name = N'Daily at 2 AM';