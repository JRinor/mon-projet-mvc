import React, { useEffect, useState } from 'react';
import { MapContainer, TileLayer, Marker, Polyline } from 'react-leaflet';
import 'leaflet/dist/leaflet.css';
import axios from 'axios';
import './App.css';

function App() {
  const [tournees, setTournees] = useState([]);
  const [pointsDepot, setPointsDepot] = useState([]);
  const [selectedTournee, setSelectedTournee] = useState(null);
  const [itineraire, setItineraire] = useState([]);
  const [filterDate, setFilterDate] = useState('');
  const [newPointDepot, setNewPointDepot] = useState('');
  const [newNumeroOrdre, setNewNumeroOrdre] = useState('');

  useEffect(() => {
    // Récupérer les tournées
    axios.get('/tournees').then((response) => {
      setTournees(response.data);
    });

    // Récupérer les points de dépôt
    axios.get('/points-depot').then((response) => {
      setPointsDepot(response.data);
    });
  }, []);

  const handleTourneeSelect = (tournee) => {
    setSelectedTournee(tournee);
    // Récupérer l'itinéraire de la tournée
    axios.get(`/tournees/${tournee.id_tournee}/points-depot`).then((response) => {
      setItineraire(response.data);
    });
  };

  const handleFilterChange = (e) => {
    setFilterDate(e.target.value);
  };

  const handleAddPointDepot = () => {
    if (selectedTournee && newPointDepot && newNumeroOrdre) {
      axios
        .post(`/tournees/${selectedTournee.id_tournee}/points-depot`, {
          id_point_depot: newPointDepot,
          numero_ordre: newNumeroOrdre,
          statut_etape: 'planifiée',
        })
        .then((response) => {
          setItineraire([...itineraire, response.data]);
          setNewPointDepot('');
          setNewNumeroOrdre('');
        });
    }
  };

  const filteredTournees = tournees.filter((tournee) =>
    tournee.jour_livraison.includes(filterDate)
  );

  return (
    <div className="App">
      <header className="bg-primary text-white p-3">
        <h1>Gestion des Tournées</h1>
      </header>
      <main className="container mt-5">
        <div className="row">
          <div className="col-md-4">
            <h2>Tournées</h2>
            <input
              type="date"
              className="form-control mb-3"
              value={filterDate}
              onChange={handleFilterChange}
            />
            <ul className="list-group">
              {filteredTournees.map((tournee) => (
                <li
                  key={tournee.id_tournee}
                  className="list-group-item"
                  onClick={() => handleTourneeSelect(tournee)}
                >
                  {tournee.jour_livraison}
                </li>
              ))}
            </ul>
            {selectedTournee && (
              <div className="mt-3">
                <h3>Ajouter un Point de Dépôt</h3>
                <select
                  className="form-control mb-2"
                  value={newPointDepot}
                  onChange={(e) => setNewPointDepot(e.target.value)}
                >
                  <option value="">Sélectionner un point de dépôt</option>
                  {pointsDepot.map((point) => (
                    <option key={point.id_pointdedepot} value={point.id_pointdedepot}>
                      {point.nom}
                    </option>
                  ))}
                </select>
                <input
                  type="number"
                  className="form-control mb-2"
                  placeholder="Numéro d'ordre"
                  value={newNumeroOrdre}
                  onChange={(e) => setNewNumeroOrdre(e.target.value)}
                />
                <button className="btn btn-primary" onClick={handleAddPointDepot}>
                  Ajouter
                </button>
              </div>
            )}
          </div>
          <div className="col-md-8">
            <h2>Carte</h2>
            <MapContainer center={[48.8566, 2.3522]} zoom={12} style={{ height: '500px' }}>
              <TileLayer
                url="https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png"
                attribution='&copy; <a href="https://www.openstreetmap.org/copyright">OpenStreetMap</a> contributors'
              />
              {pointsDepot.map((point) => (
                <Marker key={point.id_pointdedepot} position={[point.latitude, point.longitude]} />
              ))}
              {itineraire.length > 0 && (
                <Polyline
                  positions={itineraire.map((point) => [point.latitude, point.longitude])}
                  color="blue"
                />
              )}
            </MapContainer>
          </div>
        </div>
      </main>
    </div>
  );
}

export default App;
