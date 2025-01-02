const express = require('express');
const { Pool } = require('pg');
const app = express();
const port = 5001;

const pool = new Pool({
  connectionString: process.env.DATABASE_URL,
});

app.use(express.json());

app.get('/', async (req, res) => {
  const { rows } = await pool.query('SELECT NOW()');
  res.send(rows[0]);
});

// Route pour obtenir toutes les tournées
app.get('/tournees', async (req, res) => {
  const { rows } = await pool.query('SELECT * FROM Tournee');
  res.json(rows);
});

// Route pour créer une nouvelle tournée
app.post('/tournees', async (req, res) => {
  const { jour_preparation, jour_livraison, statut_tournee } = req.body;
  const { rows } = await pool.query(
    'INSERT INTO Tournee (jour_preparation, jour_livraison, statut_tournee) VALUES ($1, $2, $3) RETURNING *',
    [jour_preparation, jour_livraison, statut_tournee]
  );
  res.status(201).json(rows[0]);
});

// Route pour obtenir tous les points de dépôt
app.get('/points-depot', async (req, res) => {
  const { rows } = await pool.query('SELECT * FROM PointDeDepot');
  res.json(rows);
});

// Route pour ajouter un point de dépôt à une tournée
app.post('/tournees/:id/points-depot', async (req, res) => {
  const { id } = req.params;
  const { id_point_depot, numero_ordre, statut_etape } = req.body;
  const { rows } = await pool.query(
    'INSERT INTO Tournee_PointDeDepot (ID_Tournee, ID_PointDeDepot, numero_ordre, statut_etape) VALUES ($1, $2, $3, $4) RETURNING *',
    [id, id_point_depot, numero_ordre, statut_etape]
  );
  res.status(201).json(rows[0]);
});

app.listen(port, () => {
  console.log(`Backend running on port ${port}`);
});
