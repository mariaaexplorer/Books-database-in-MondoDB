-- Tabelul pentru autori
CREATE TABLE Autori (
    id_Autor INTEGER PRIMARY KEY,
    nume VARCHAR(100) NOT NULL,
    tara VARCHAR(100) NOT NULL
);

-- Tabelul pentru limbi
CREATE TABLE Limbi (
    id_Limba INTEGER PRIMARY KEY,
    nume_limba VARCHAR(50) NOT NULL
);

-- Tabelul pentru edituri
CREATE TABLE Edituri (
    id_Editura INTEGER,
    nume_editura VARCHAR(100) NOT NULL
);

-- Tabelul pentru carti
CREATE TABLE Carti (
    id_Carte INTEGER PRIMARY KEY,
    titlu VARCHAR(100) NOT NULL,
    an_aparitie NUMERIC(4) NOT NULL,
    genul VARCHAR(100) NOT NULL,
    id_Editura INTEGER,
    id_Limba INTEGER,
    CONSTRAINT fk_carti_limbi FOREIGN KEY (id_Limba) REFERENCES Limbi(id_Limba)
);

-- Tabelul pentru stocul cartilor
CREATE TABLE Stoc_Carti (
    id_Carte INTEGER PRIMARY KEY,
    stoc_disponibil NUMERIC(4) NOT NULL,
    stoc_total NUMERIC(4) NOT NULL,
    CONSTRAINT fk_stoc_carti_carti FOREIGN KEY (id_Carte) REFERENCES Carti(id_Carte)
);


-- Tabelul de asociere pentru autori si carti
CREATE TABLE Carte_Autori (
    id_Carte INTEGER,
    id_Autor INTEGER,
    PRIMARY KEY (id_Carte, id_Autor),
    FOREIGN KEY (id_Carte) REFERENCES Carti(id_Carte),
    FOREIGN KEY (id_Autor) REFERENCES Autori(id_Autor)
);

-- Tabelul pentru adrese
CREATE TABLE Adrese (
    id_Adresa INTEGER PRIMARY KEY,
    strada VARCHAR(100) NOT NULL,
    numar INT NOT NULL,
    oras VARCHAR(100) NOT NULL,
    cod_postal VARCHAR(10) NOT NULL
);

-- Tabelul pentru clienti
CREATE TABLE Clienti (
    id_Client INTEGER PRIMARY KEY,
    nume VARCHAR(100) NOT NULL,
    prenume VARCHAR(100) NOT NULL,
    nr_telefon NUMERIC(10) NOT NULL,
    email VARCHAR(100) NOT NULL,
    gen VARCHAR(100) NOT NULL
);

-- Tabelul pentru imprumuturi
CREATE TABLE Imprumuturi (
    id_Imprumut INTEGER PRIMARY KEY,
    id_Client INTEGER,
    data_inceput DATE NOT NULL,
    data_returnare_planificata DATE NOT NULL,
    data_returnare_efectiva DATE,
    id_Status Varchar(50),
    CONSTRAINT fk_imprumuturi_clienti FOREIGN KEY (id_Client) REFERENCES Clienti(id_Client)
);

-- Tabelul pentru continutul imprumutului
CREATE TABLE Continut_Imprumut (
    id_Imprumut INTEGER,
    id_Carte INTEGER,
    PRIMARY KEY (id_Imprumut, id_Carte),
    CONSTRAINT fk_continut_imprumut_imprumut FOREIGN KEY (id_Imprumut) REFERENCES Imprumuturi(id_Imprumut),
    CONSTRAINT fk_continut_imprumut_carte FOREIGN KEY (id_Carte) REFERENCES Carti(id_Carte)
);
-- Actualizarea coloanei cu numarul total de carti imprumutate pentru fiecare client

ALTER TABLE Clienti
ADD COLUMN total_carti_imprumutate INTEGER;

UPDATE Clienti
SET total_carti_imprumutate = (
    SELECT COUNT(*)
    FROM Imprumuturi i
    JOIN Continut_Imprumut ci ON i.id_Imprumut = ci.id_Imprumut
    WHERE i.id_Client = Clienti.id_Client
);
-- Tabelul de asociere pentru clienti si adrese
CREATE TABLE Clienti_Adrese (
    id_Client INTEGER,
    id_Adresa INTEGER,
    PRIMARY KEY (id_Client, id_Adresa),
    CONSTRAINT fk_clienti_adrese_clienti FOREIGN KEY (id_Client) REFERENCES Clienti(id_Client),
    CONSTRAINT fk_clienti_adrese_adrese FOREIGN KEY (id_Adresa) REFERENCES Adrese(id_Adresa)
);




-- Tabelul pentru istoricul imprumuturilor
CREATE TABLE Istoric_Imprumuturi (
    id_Istoric INTEGER PRIMARY KEY,
    id_Imprumut INTEGER,
    data_inceput DATE NOT NULL,
    data_sfarsit DATE,
    CONSTRAINT fk_istoric_imprumuturi_imprumut FOREIGN KEY (id_Imprumut) REFERENCES Imprumuturi(id_Imprumut)
);





-- Tabelul pentru penalizare_zi
CREATE TABLE Penalizare_Zi (
    id_Penalizare INTEGER PRIMARY KEY,
    id_Carte INTEGER,
    data DATE,
    pret_pe_zi INTEGER,
    CONSTRAINT fk_penalizare_carte FOREIGN KEY (id_Carte) REFERENCES Carti(id_Carte)
);


-- Tabelul pentru facturi
CREATE TABLE Facturi (
    id_Factura INTEGER PRIMARY KEY,
    id_Imprumut INTEGER,
    data_emiterii DATE,
    total_factura DECIMAL(10,2),
    CONSTRAINT fk_facturi_imprumuturi FOREIGN KEY (id_Imprumut) REFERENCES Imprumuturi(id_Imprumut)
);