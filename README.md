# Projet Cocagne

Hostname/address : db
Port : 5432
Maintenance database : bd_cocagne
Username : postgres
Password : password

docker volume rm projet_cocagne_pgdata


docker-compose exec db psql -U postgres -d bd_cocagne

\dt

INSERT INTO Adherent (nom, prenom, email, telephone, adresse, date_naissance) VALUES ('Doe', 'John', 'john.doe@example.com', '1234567890', '123 Main St', '1990-01-01');