-- Supprimer les tables existantes si elles existent
DROP TABLE IF EXISTS Facture_Abonnement;
DROP TABLE IF EXISTS Commande_Tournee;
DROP TABLE IF EXISTS Commande;
DROP TABLE IF EXISTS Adhesion;
DROP TABLE IF EXISTS Facturation;
DROP TABLE IF EXISTS Abonnement;
DROP TABLE IF EXISTS Tournee_PointDeDepot;
DROP TABLE IF EXISTS Tournee;
DROP TABLE IF EXISTS PointDeDepot;
DROP TABLE IF EXISTS Panier_Frequence;
DROP TABLE IF EXISTS Frequence;
DROP TABLE IF EXISTS Panier;
DROP TABLE IF EXISTS Adherent;
DROP TABLE IF EXISTS Structure;

-- Table pour la structure
CREATE TABLE Structure (
    ID_Structure SERIAL PRIMARY KEY,
    nom VARCHAR(100) NOT NULL,
    adresse VARCHAR(255) NOT NULL,
    coordonnees_bancaires VARCHAR(255),
    SIRET VARCHAR(14) NOT NULL UNIQUE
);

-- Table pour les adhérents
CREATE TABLE Adherent (
    ID_Adherent SERIAL PRIMARY KEY,
    nom VARCHAR(100) NOT NULL,
    prenom VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    telephone VARCHAR(20),
    adresse VARCHAR(255),
    date_naissance DATE
);

-- Table pour les paniers (produits)
CREATE TABLE Panier (
    ID_Panier SERIAL PRIMARY KEY,
    ID_Structure INT NOT NULL,
    nom VARCHAR(100) NOT NULL,
    description TEXT,
    unite VARCHAR(50) NOT NULL,
    photo VARCHAR(255),
    image VARCHAR(255),
    FOREIGN KEY (ID_Structure) REFERENCES Structure(ID_Structure) ON DELETE CASCADE
);

-- Table pour les fréquences
CREATE TABLE Frequence (
    ID_Frequence SERIAL PRIMARY KEY,
    type_frequence VARCHAR(50) NOT NULL
);

-- Table pour l'association entre paniers et fréquences
CREATE TABLE Panier_Frequence (
    ID_Panier INT,
    ID_Frequence INT,
    PRIMARY KEY (ID_Panier, ID_Frequence),
    FOREIGN KEY (ID_Panier) REFERENCES Panier(ID_Panier) ON DELETE CASCADE,
    FOREIGN KEY (ID_Frequence) REFERENCES Frequence(ID_Frequence) ON DELETE CASCADE
);

-- Table pour les points de dépôt
CREATE TABLE PointDeDepot (
    ID_PointDeDepot SERIAL PRIMARY KEY,
    nom VARCHAR(100) NOT NULL,
    adresse VARCHAR(255) NOT NULL,
    latitude DECIMAL(10, 8),
    longitude DECIMAL(11, 8),
    ID_Structure INT NOT NULL,
    FOREIGN KEY (ID_Structure) REFERENCES Structure(ID_Structure) ON DELETE CASCADE
);

-- Table pour les tournées
CREATE TABLE Tournee (
    ID_Tournee SERIAL PRIMARY KEY,
    jour_preparation DATE NOT NULL,
    jour_livraison DATE NOT NULL,
    statut_tournee VARCHAR(20) DEFAULT 'préparée'
);

-- Table pour l'association entre tournées et points de dépôt
CREATE TABLE Tournee_PointDeDepot (
    ID_Tournee INT,
    ID_PointDeDepot INT,
    numero_ordre INT NOT NULL,
    statut_etape VARCHAR(20) DEFAULT 'planifiée',
    PRIMARY KEY (ID_Tournee, ID_PointDeDepot),
    FOREIGN KEY (ID_Tournee) REFERENCES Tournee(ID_Tournee) ON DELETE CASCADE,
    FOREIGN KEY (ID_PointDeDepot) REFERENCES PointDeDepot(ID_PointDeDepot) ON DELETE CASCADE
);

-- Table pour les abonnements
CREATE TABLE Abonnement (
    ID_Abonnement SERIAL PRIMARY KEY,
    ID_Adherent INT NOT NULL,
    ID_Panier INT NOT NULL,
    ID_Frequence INT NOT NULL,
    date_debut DATE NOT NULL,
    date_fin DATE DEFAULT NULL,
    statut VARCHAR(20) DEFAULT 'actif',
    FOREIGN KEY (ID_Adherent) REFERENCES Adherent(ID_Adherent) ON DELETE CASCADE,
    FOREIGN KEY (ID_Panier) REFERENCES Panier(ID_Panier) ON DELETE CASCADE,
    FOREIGN KEY (ID_Frequence) REFERENCES Frequence(ID_Frequence) ON DELETE CASCADE
);

-- Table pour les commandes
CREATE TABLE Commande (
    ID_Commande SERIAL PRIMARY KEY,
    ID_Abonnement INT NOT NULL,
    ID_PointDeDepot INT NOT NULL,
    quantite INT NOT NULL CHECK (quantite > 0),
    date_commande TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    statut VARCHAR(20) DEFAULT 'en attente',
    FOREIGN KEY (ID_Abonnement) REFERENCES Abonnement(ID_Abonnement) ON DELETE CASCADE,
    FOREIGN KEY (ID_PointDeDepot) REFERENCES PointDeDepot(ID_PointDeDepot) ON DELETE CASCADE
);

-- Table pour l'association entre commandes et tournées
CREATE TABLE Commande_Tournee (
    ID_Commande INT,
    ID_Tournee INT,
    statut_livraison VARCHAR(20) DEFAULT 'non livrée',
    PRIMARY KEY (ID_Commande, ID_Tournee),
    FOREIGN KEY (ID_Commande) REFERENCES Commande(ID_Commande) ON DELETE CASCADE,
    FOREIGN KEY (ID_Tournee) REFERENCES Tournee(ID_Tournee) ON DELETE CASCADE
);

-- Table pour la facturation
CREATE TABLE Facturation (
    ID_Facture SERIAL PRIMARY KEY,
    ID_Adherent INT NOT NULL,
    montant DECIMAL(10, 2) NOT NULL CHECK (montant >= 0),
    date_facture TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (ID_Adherent) REFERENCES Adherent(ID_Adherent) ON DELETE CASCADE
);

-- Table pour le lien entre factures et abonnements
CREATE TABLE Facture_Abonnement (
    ID_Facture INT,
    ID_Abonnement INT,
    PRIMARY KEY (ID_Facture, ID_Abonnement),
    FOREIGN KEY (ID_Facture) REFERENCES Facturation(ID_Facture) ON DELETE CASCADE,
    FOREIGN KEY (ID_Abonnement) REFERENCES Abonnement(ID_Abonnement) ON DELETE CASCADE
);

-- Table pour les adhésions
CREATE TABLE Adhesion (
    ID_Adhesion SERIAL PRIMARY KEY,
    ID_Adherent INT NOT NULL,
    type VARCHAR(20) NOT NULL,
    date_debut DATE NOT NULL,
    date_fin DATE DEFAULT NULL,
    statut VARCHAR(20) DEFAULT 'actif',
    UNIQUE (ID_Adherent, type, statut),
    FOREIGN KEY (ID_Adherent) REFERENCES Adherent(ID_Adherent) ON DELETE CASCADE
);

-- Triggers
CREATE OR REPLACE FUNCTION check_frequence_abonnement_insert() RETURNS TRIGGER AS $$
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM Panier_Frequence
        WHERE ID_Panier = NEW.ID_Panier AND ID_Frequence = NEW.ID_Frequence
    ) THEN
        RAISE EXCEPTION 'La fréquence choisie n''est pas disponible pour ce panier';
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER check_frequence_abonnement_insert
BEFORE INSERT ON Abonnement
FOR EACH ROW
EXECUTE FUNCTION check_frequence_abonnement_insert();

CREATE OR REPLACE FUNCTION check_frequence_abonnement_update() RETURNS TRIGGER AS $$
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM Panier_Frequence
        WHERE ID_Panier = NEW.ID_Panier AND ID_Frequence = NEW.ID_Frequence
    ) THEN
        RAISE EXCEPTION 'La fréquence choisie n''est pas disponible pour ce panier';
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER check_frequence_abonnement_update
BEFORE UPDATE ON Abonnement
FOR EACH ROW
EXECUTE FUNCTION check_frequence_abonnement_update();