-- Creaci�n de la base de datos
Create database SistemaBusqueda;
go

-- Usar base de datos
use SistemaBusqueda;
go


-- Creaci�n de las tablas, llaves primarias y llaves for�neas

CREATE TABLE Documentos
(
    Id INT IDENTITY(1,1) PRIMARY KEY,

    TipoDocumento NVARCHAR(30) NOT NULL,

    Nombre NVARCHAR(300) NOT NULL,

    MesDocumento TINYINT NOT NULL,

    AnioDocumento SMALLINT NOT NULL,

    RutaDocumento NVARCHAR(500) NOT NULL,

    FechaRegistro DATETIME2 NOT NULL
        DEFAULT SYSDATETIME(),

    CONSTRAINT CK_Documentos_Mes
        CHECK (MesDocumento BETWEEN 1 AND 12),

    CONSTRAINT CK_Documentos_Tipo
        CHECK (
            TipoDocumento IN
            (
                'Proyecto',
                'LineaInvestigacion',
                'Informe'
            )
        )
);
GO

CREATE TABLE Proyectos
(
    Id INT IDENTITY(1,1) PRIMARY KEY,

    DocumentoId INT NOT NULL,

    Lider NVARCHAR(200) NOT NULL,

    Categoria NVARCHAR(150) NOT NULL,

    HorasInvestigacion INT NOT NULL,

    CONSTRAINT FK_Proyectos_Documentos
        FOREIGN KEY (DocumentoId)
        REFERENCES Documentos(Id)
);
GO

CREATE TABLE ProyectoIntegrantes
(
    Id INT IDENTITY(1,1) PRIMARY KEY,

    ProyectoId INT NOT NULL,

    NombreIntegrante NVARCHAR(200) NOT NULL,

    CONSTRAINT FK_ProyectoIntegrantes_Proyectos
        FOREIGN KEY (ProyectoId)
        REFERENCES Proyectos(Id)
        ON DELETE CASCADE
);
GO

CREATE TABLE LineasInvestigacion
(
    Id INT IDENTITY(1,1) PRIMARY KEY,

    DocumentoId INT NOT NULL,

    AreaConocimiento NVARCHAR(150) NOT NULL,

    Lider NVARCHAR(200) NOT NULL,

    CuerpoAcademico NVARCHAR(250) NOT NULL,

    CONSTRAINT FK_LineasInvestigacion_Documentos
        FOREIGN KEY (DocumentoId)
        REFERENCES Documentos(Id)
);
GO

CREATE TABLE LineaIntegrantes
(
    Id INT IDENTITY(1,1) PRIMARY KEY,

    LineaInvestigacionId INT NOT NULL,

    NombreIntegrante NVARCHAR(200) NOT NULL,

    CONSTRAINT FK_LineaIntegrantes_Lineas
        FOREIGN KEY (LineaInvestigacionId)
        REFERENCES LineasInvestigacion(Id)
        ON DELETE CASCADE
);
GO

CREATE TABLE Informes
(
    Id INT IDENTITY(1,1) PRIMARY KEY,

    DocumentoId INT NOT NULL,

    CodigoFolio NVARCHAR(100) NOT NULL,

    AutorResponsable NVARCHAR(200) NOT NULL,

    Destinatario NVARCHAR(150) NOT NULL,

    CONSTRAINT FK_Informes_Documentos
        FOREIGN KEY (DocumentoId)
        REFERENCES Documentos(Id)
);
GO

-- Comprobar que existen las seis tablas

SELECT TABLE_NAME
FROM INFORMATION_SCHEMA.TABLES
WHERE TABLE_TYPE = 'BASE TABLE'
ORDER BY TABLE_NAME;

-- Comprobar las 5 columnas

SELECT
    TABLE_NAME,
    COLUMN_NAME,
    DATA_TYPE,
    IS_NULLABLE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_SCHEMA = 'dbo'
ORDER BY TABLE_NAME, ORDINAL_POSITION;

-- Comprobar las llaves primarias (PK)

SELECT
    TABLE_NAME,
    COLUMN_NAME
FROM INFORMATION_SCHEMA.KEY_COLUMN_USAGE
WHERE CONSTRAINT_NAME LIKE 'PK_%'
ORDER BY TABLE_NAME;

-- Comprobar las relaciones (Llaves for�neas) FK

SELECT
    fk.name AS ForeignKey,
    OBJECT_NAME(fk.parent_object_id) AS TablaHija,
    COL_NAME(fkc.parent_object_id, fkc.parent_column_id) AS Campo,
    OBJECT_NAME(fk.referenced_object_id) AS TablaPadre,
    COL_NAME(fkc.referenced_object_id, fkc.referenced_column_id) AS Campo
FROM sys.foreign_keys fk
INNER JOIN sys.foreign_key_columns fkc
    ON fk.object_id = fkc.constraint_object_id
ORDER BY TablaHija;