-- Insérer des données de test pour la table Adherent
INSERT INTO Adherent (nom, prenom, email, telephone, adresse, date_naissance) VALUES
('Doe', 'John', 'john.doe@example.com', '1234567890', '123 Main St', '1990-01-01'),
('Smith', 'Jane', 'jane.smith@example.com', '0987654321', '456 Elm St', '1985-05-15'),
('Brown', 'Charlie', 'charlie.brown@example.com', '1122334455', '789 Oak St', '1970-07-07');

-- Insérer des données de test pour la table Structure
INSERT INTO Structure (nom, adresse, coordonnees_bancaires, SIRET) VALUES
('Structure A', '123 Main St', 'FR7630006000011234567890189', '12345678901234'),
('Structure B', '456 Elm St', 'FR7630006000011234567890189', '23456789012345');

-- Insérer des données de test pour la table Panier
INSERT INTO Panier (ID_Structure, nom, description, unite, photo, image) VALUES
(1, 'Panier A', 'Description A', 'kg', 'photoA.jpg', 'imageA.jpg'),
(2, 'Panier B', 'Description B', 'kg', 'photoB.jpg', 'imageB.jpg');

-- Insérer des données de test pour la table Frequence
INSERT INTO Frequence (type_frequence) VALUES
('Hebdomadaire'),
('Mensuelle');

-- Insérer des données de test pour la table Panier_Frequence
INSERT INTO Panier_Frequence (ID_Panier, ID_Frequence) VALUES
(1, 1),
(1, 2),
(2, 1);

-- Insérer des données de test pour la table PointDeDepot
INSERT INTO PointDeDepot (nom, adresse, latitude, longitude, ID_Structure) VALUES
('Depot A', '789 Oak St', 48.8566, 2.3522, 1),
('Depot B', '101 Pine St', 48.8566, 2.3522, 2);

-- Insérer des données de test pour la table Tournee
INSERT INTO Tournee (jour_preparation, jour_livraison, statut_tournee) VALUES
('2025-01-01', '2025-01-02', 'préparée'),
('2025-02-01', '2025-02-02', 'préparée');

-- Insérer des données de test pour la table Tournee_PointDeDepot
INSERT INTO Tournee_PointDeDepot (ID_Tournee, ID_PointDeDepot, numero_ordre, statut_etape) VALUES
(1, 1, 1, 'planifiée'),
(1, 2, 2, 'planifiée'),
(2, 1, 1, 'planifiée');

-- Insérer des données de test pour la table Abonnement
INSERT INTO Abonnement (ID_Adherent, ID_Panier, ID_Frequence, date_debut, date_fin, statut) VALUES
(1, 1, 1, '2025-01-01', NULL, 'actif'),
(2, 1, 2, '2025-01-01', NULL, 'actif');

-- Insérer des données de test pour la table Commande
INSERT INTO Commande (ID_Abonnement, ID_PointDeDepot, quantite, date_commande, statut) VALUES
(1, 1, 5, '2025-01-01 10:00:00', 'en attente'),
(2, 2, 3, '2025-01-01 11:00:00', 'en attente');

-- Insérer des données de test pour la table Commande_Tournee
INSERT INTO Commande_Tournee (ID_Commande, ID_Tournee, statut_livraison) VALUES
(1, 1, 'non livrée'),
(2, 2, 'non livrée');

-- Insérer des données de test pour la table Facturation
INSERT INTO Facturation (ID_Adherent, montant, date_facture) VALUES
(1, 100.00, '2025-01-01 12:00:00'),
(2, 150.00, '2025-01-01 13:00:00');

-- Insérer des données de test pour la table Facture_Abonnement
INSERT INTO Facture_Abonnement (ID_Facture, ID_Abonnement) VALUES
(1, 1),
(2, 2);

-- Insérer des données de test pour la table Adhesion
INSERT INTO Adhesion (ID_Adherent, type, date_debut, date_fin, statut) VALUES
(1, 'association', '2025-01-01', NULL, 'actif'),
(2, 'panier', '2025-01-01', NULL, 'actif');