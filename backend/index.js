const express = require('express');
const { Pool } = require('pg');
const app = express();
const port = 5001;

const pool = new Pool({
  connectionString: process.env.DATABASE_URL,
});

app.get('/', async (req, res) => {
  const { rows } = await pool.query('SELECT NOW()');
  res.send(rows[0]);
});

app.listen(port, () => {
  console.log(`Backend running on port ${port}`);
});
