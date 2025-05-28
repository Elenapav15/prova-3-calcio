import React, { useState, useEffect } from 'react';
import { Play, Users, User, BarChart3, History, Plus, Save, Edit3, Camera } from 'lucide-react';

const SoccerApp = () => {
  const [currentView, setCurrentView] = useState('home');
  const [teams, setTeams] = useState([]);
  const [players, setPlayers] = useState([]);
  const [matches, setMatches] = useState([]);
  const [currentMatch, setCurrentMatch] = useState(null);
  const [gameTime, setGameTime] = useState(0);
  const [isGameRunning, setIsGameRunning] = useState(false);

  // Timer del gioco
  useEffect(() => {
    let interval;
    if (isGameRunning) {
      interval = setInterval(() => {
        setGameTime(time => time + 1);
      }, 1000);
    }
    return () => clearInterval(interval);
  }, [isGameRunning]);

  const formatTime = (seconds) => {
    const mins = Math.floor(seconds / 60);
    const secs = seconds % 60;
    return `${mins.toString().padStart(2, '0')}:${secs.toString().padStart(2, '0')}`;
  };

  const colors = [
    '#FF0000', '#00FF00', '#0000FF', '#FFFF00', '#FF00FF', '#00FFFF',
    '#FFA500', '#800080', '#FFC0CB', '#000000', '#FFFFFF', '#808080',
    '#800000', '#008000', '#000080', '#808000', '#800080', '#008080'
  ];

  // Componente Home
  const HomeView = () => (
    <div className="min-h-screen bg-gradient-to-br from-green-400 to-blue-600 flex flex-col items-center justify-center p-4">
      <h1 className="text-4xl font-bold text-white mb-8 text-center">⚽ Soccer Manager</h1>
      
      <button
        onClick={() => setCurrentView('newMatch')}
        className="bg-white text-green-600 px-8 py-4 rounded-full text-xl font-bold shadow-lg hover:shadow-xl transform hover:scale-105 transition-all mb-8"
      >
        <Play className="inline mr-2" size={24} />
        INIZIA PARTITA
      </button>

      <div className="grid grid-cols-2 md:grid-cols-4 gap-4 w-full max-w-md">
        {[
          { icon: Users, label: 'Squadre', view: 'teams' },
          { icon: User, label: 'Giocatori', view: 'players' },
          { icon: BarChart3, label: 'Statistiche', view: 'stats' },
          { icon: History, label: 'Partite', view: 'matches' }
        ].map(({ icon: Icon, label, view }) => (
          <button
            key={view}
            onClick={() => setCurrentView(view)}
            className="bg-white/20 backdrop-blur-sm text-white p-4 rounded-lg flex flex-col items-center hover:bg-white/30 transition-all"
          >
            <Icon size={32} className="mb-2" />
            <span className="text-sm font-medium">{label}</span>
          </button>
        ))}
      </div>
    </div>
  );

  // Componente Squadre
  const TeamsView = () => {
    const [newTeam, setNewTeam] = useState({ name: '', color: '#FF0000' });
    const [editingTeam, setEditingTeam] = useState(null);

    const addTeam = () => {
      if (newTeam.name.trim()) {
        const team = {
          id: Date.now(),
          name: newTeam.name,
          color: newTeam.color,
          formation: [],
          players: []
        };
        setTeams([...teams, team]);
        setNewTeam({ name: '', color: '#FF0000' });
      }
    };

    return (
      <div className="p-4">
        <div className="flex items-center justify-between mb-6">
          <h2 className="text-2xl font-bold">Squadre</h2>
          <button onClick={() => setCurrentView('home')} className="text-blue-600">← Home</button>
        </div>

        <div className="bg-white p-4 rounded-lg shadow mb-6">
          <h3 className="font-bold mb-4">Crea Nuova Squadra</h3>
          <div className="flex gap-4 items-end">
            <div className="flex-1">
              <label className="block text-sm font-medium mb-1">Nome Squadra</label>
              <input
                type="text"
                value={newTeam.name}
                onChange={(e) => setNewTeam({...newTeam, name: e.target.value})}
                className="w-full p-2 border rounded"
                placeholder="Nome squadra..."
              />
            </div>
            <div>
              <label className="block text-sm font-medium mb-1">Colore</label>
              <input
                type="color"
                value={newTeam.color}
                onChange={(e) => setNewTeam({...newTeam, color: e.target.value})}
                className="w-12 h-10 border rounded cursor-pointer"
              />
            </div>
            <button onClick={addTeam} className="bg-green-600 text-white px-4 py-2 rounded hover:bg-green-700">
              <Plus size={20} />
            </button>
          </div>
        </div>

        <div className="grid gap-4">
          {teams.map(team => (
            <div key={team.id} className="bg-white p-4 rounded-lg shadow border-l-4" style={{borderLeftColor: team.color}}>
              <div className="flex items-center justify-between">
                <div className="flex items-center gap-3">
                  <div className="w-6 h-6 rounded-full" style={{backgroundColor: team.color}}></div>
                  <span className="font-bold text-lg">{team.name}</span>
                </div>
                <div className="flex gap-2">
                  <button className="text-blue-600 hover:bg-blue-50 p-2 rounded">
                    <Edit3 size={16} />
                  </button>
                </div>
              </div>
              <div className="mt-2 text-sm text-gray-600">
                Giocatori: {team.players?.length || 0}
              </div>
            </div>
          ))}
        </div>
      </div>
    );
  };

  // Componente Giocatori
  const PlayersView = () => {
    const [newPlayer, setNewPlayer] = useState({ name: '', team: '', photo: null });

    const addPlayer = () => {
      if (newPlayer.name.trim()) {
        const player = {
          id: Date.now(),
          name: newPlayer.name,
          team: newPlayer.team,
          photo: newPlayer.photo,
          stats: { goals: 0, matches: 0 }
        };
        setPlayers([...players, player]);
        setNewPlayer({ name: '', team: '', photo: null });
      }
    };

    return (
      <div className="p-4">
        <div className="flex items-center justify-between mb-6">
          <h2 className="text-2xl font-bold">Giocatori</h2>
          <button onClick={() => setCurrentView('home')} className="text-blue-600">← Home</button>
        </div>

        <div className="bg-white p-4 rounded-lg shadow mb-6">
          <h3 className="font-bold mb-4">Aggiungi Giocatore</h3>
          <div className="grid gap-4">
            <div>
              <label className="block text-sm font-medium mb-1">Nome Giocatore</label>
              <input
                type="text"
                value={newPlayer.name}
                onChange={(e) => setNewPlayer({...newPlayer, name: e.target.value})}
                className="w-full p-2 border rounded"
                placeholder="Nome giocatore..."
              />
            </div>
            <div>
              <label className="block text-sm font-medium mb-1">Squadra</label>
              <select
                value={newPlayer.team}
                onChange={(e) => setNewPlayer({...newPlayer, team: e.target.value})}
                className="w-full p-2 border rounded"
              >
                <option value="">Seleziona squadra</option>
                {teams.map(team => (
                  <option key={team.id} value={team.id}>{team.name}</option>
                ))}
              </select>
            </div>
            <div className="flex gap-2">
              <button className="bg-gray-200 text-gray-700 px-3 py-2 rounded flex items-center gap-2">
                <Camera size={16} />
                Aggiungi Foto
              </button>
              <button onClick={addPlayer} className="bg-green-600 text-white px-4 py-2 rounded hover:bg-green-700">
                Aggiungi
              </button>
            </div>
          </div>
        </div>

        <div className="grid gap-4">
          {players.map(player => (
            <div key={player.id} className="bg-white p-4 rounded-lg shadow flex items-center gap-4">
              <div className="w-12 h-12 bg-gray-200 rounded-full flex items-center justify-center">
                <User size={24} className="text-gray-500" />
              </div>
              <div className="flex-1">
                <h4 className="font-bold">{player.name}</h4>
                <p className="text-sm text-gray-600">
                  Squadra: {teams.find(t => t.id == player.team)?.name || 'Nessuna'}
                </p>
                <p className="text-sm text-gray-600">
                  Goal: {player.stats.goals} | Partite: {player.stats.matches}
                </p>
              </div>
            </div>
          ))}
        </div>
      </div>
    );
  };

  // Componente Nuova Partita
  const NewMatchView = () => {
    const [selectedTeams, setSelectedTeams] = useState({ team1: '', team2: '' });

    const startMatch = () => {
      if (selectedTeams.team1 && selectedTeams.team2) {
        const team1 = teams.find(t => t.id == selectedTeams.team1);
        const team2 = teams.find(t => t.id == selectedTeams.team2);
        
        setCurrentMatch({
          id: Date.now(),
          team1: { ...team1, score: 0, goals: [] },
          team2: { ...team2, score: 0, goals: [] },
          startTime: new Date(),
          status: 'playing'
        });
        setGameTime(0);
        setCurrentView('match');
      }
    };

    return (
      <div className="p-4">
        <div className="flex items-center justify-between mb-6">
          <h2 className="text-2xl font-bold">Nuova Partita</h2>
          <button onClick={() => setCurrentView('home')} className="text-blue-600">← Home</button>
        </div>

        <div className="bg-white p-6 rounded-lg shadow">
          <h3 className="font-bold mb-4">Seleziona Squadre</h3>
          
          <div className="grid gap-6">
            <div>
              <label className="block text-sm font-medium mb-2">Squadra Casa</label>
              <select
                value={selectedTeams.team1}
                onChange={(e) => setSelectedTeams({...selectedTeams, team1: e.target.value})}
                className="w-full p-3 border rounded-lg"
              >
                <option value="">Seleziona squadra casa</option>
                {teams.map(team => (
                  <option key={team.id} value={team.id}>{team.name}</option>
                ))}
              </select>
            </div>

            <div className="text-center text-2xl font-bold text-gray-400">VS</div>

            <div>
              <label className="block text-sm font-medium mb-2">Squadra Ospite</label>
              <select
                value={selectedTeams.team2}
                onChange={(e) => setSelectedTeams({...selectedTeams, team2: e.target.value})}
                className="w-full p-3 border rounded-lg"
              >
                <option value="">Seleziona squadra ospite</option>
                {teams.filter(t => t.id != selectedTeams.team1).map(team => (
                  <option key={team.id} value={team.id}>{team.name}</option>
                ))}
              </select>
            </div>

            <button
              onClick={startMatch}
              disabled={!selectedTeams.team1 || !selectedTeams.team2}
              className="w-full bg-green-600 text-white py-3 rounded-lg font-bold disabled:bg-gray-300 disabled:cursor-not-allowed hover:bg-green-700 transition-colors"
            >
              INIZIA PARTITA
            </button>
          </div>
        </div>
      </div>
    );
  };

  // Componente Partita Live
  const MatchView = () => {
    const scoreGoal = (teamKey, playerId = null) => {
      setCurrentMatch(prev => ({
        ...prev,
        [teamKey]: {
          ...prev[teamKey],
          score: prev[teamKey].score + 1,
          goals: [
            ...prev[teamKey].goals,
            {
              minute: Math.floor(gameTime / 60),
              second: gameTime % 60,
              player: playerId,
              time: gameTime
            }
          ]
        }
      }));
    };

    const removeGoal = (teamKey) => {
      setCurrentMatch(prev => ({
        ...prev,
        [teamKey]: {
          ...prev[teamKey],
          score: Math.max(0, prev[teamKey].score - 1),
          goals: prev[teamKey].goals.slice(0, -1)
        }
      }));
    };

    const endMatch = () => {
      const finalMatch = {
        ...currentMatch,
        endTime: new Date(),
        duration: gameTime,
        status: 'finished'
      };
      setMatches([...matches, finalMatch]);
      setCurrentMatch(null);
      setGameTime(0);
      setIsGameRunning(false);
      setCurrentView('home');
    };

    if (!currentMatch) return <div>Nessuna partita in corso</div>;

    const team1Players = players.filter(p => p.team == currentMatch.team1.id);
    const team2Players = players.filter(p => p.team == currentMatch.team2.id);

    return (
      <div className="min-h-screen bg-gray-100">
        {/* Header con timer */}
        <div className="bg-white shadow-sm p-4">
          <div className="flex justify-between items-center">
            <button onClick={endMatch} className="text-red-600 font-medium">
              Termina Partita
            </button>
            <div className="text-center">
              <div className="text-3xl font-bold">{formatTime(gameTime)}</div>
              <button
                onClick={() => setIsGameRunning(!isGameRunning)}
                className={`mt-2 px-4 py-1 rounded text-sm ${
                  isGameRunning ? 'bg-red-500 text-white' : 'bg-green-500 text-white'
                }`}
              >
                {isGameRunning ? 'PAUSA' : 'PLAY'}
              </button>
            </div>
            <button onClick={() => setCurrentView('home')} className="text-blue-600">
              Home
            </button>
          </div>
        </div>

        {/* Campo di gioco diviso */}
        <div className="flex flex-col h-[calc(100vh-120px)]">
          {/* Squadra 1 */}
          <div 
            className="flex-1 p-4 text-white relative"
            style={{ backgroundColor: currentMatch.team1.color }}
          >
            <div className="flex justify-between items-start h-full">
              <div>
                <h2 className="text-2xl font-bold mb-2">{currentMatch.team1.name}</h2>
                <div className="text-6xl font-bold">{currentMatch.team1.score}</div>
                <div className="flex gap-2 mt-4">
                  <button
                    onClick={() => scoreGoal('team1')}
                    className="bg-white/20 hover:bg-white/30 px-4 py-2 rounded font-bold"
                  >
                    +1
                  </button>
                  <button
                    onClick={() => removeGoal('team1')}
                    className="bg-white/20 hover:bg-white/30 px-4 py-2 rounded font-bold"
                  >
                    -1
                  </button>
                </div>
              </div>
              
              <div className="text-right">
                <h3 className="font-bold mb-2">Giocatori</h3>
                <div className="grid gap-1">
                  {team1Players.map(player => (
                    <button
                      key={player.id}
                      onClick={() => scoreGoal('team1', player.id)}
                      className="bg-white/20 hover:bg-white/40 px-3 py-1 rounded text-sm transition-colors"
                    >
                      {player.name}
                    </button>
                  ))}
                </div>
              </div>
            </div>
          </div>

          {/* Linea di metà campo */}
          <div className="h-1 bg-white"></div>

          {/* Squadra 2 */}
          <div 
            className="flex-1 p-4 text-white relative"
            style={{ backgroundColor: currentMatch.team2.color }}
          >
            <div className="flex justify-between items-end h-full">
              <div>
                <div className="text-6xl font-bold">{currentMatch.team2.score}</div>
                <h2 className="text-2xl font-bold mt-2">{currentMatch.team2.name}</h2>
                <div className="flex gap-2 mt-4">
                  <button
                    onClick={() => scoreGoal('team2')}
                    className="bg-white/20 hover:bg-white/30 px-4 py-2 rounded font-bold"
                  >
                    +1
                  </button>
                  <button
                    onClick={() => removeGoal('team2')}
                    className="bg-white/20 hover:bg-white/30 px-4 py-2 rounded font-bold"
                  >
                    -1
                  </button>
                </div>
              </div>
              
              <div className="text-right">
                <div className="grid gap-1 mb-2">
                  {team2Players.map(player => (
                    <button
                      key={player.id}
                      onClick={() => scoreGoal('team2', player.id)}
                      className="bg-white/20 hover:bg-white/40 px-3 py-1 rounded text-sm transition-colors"
                    >
                      {player.name}
                    </button>
                  ))}
                </div>
                <h3 className="font-bold">Giocatori</h3>
              </div>
            </div>
          </div>
        </div>
      </div>
    );
  };

  // Componente Statistiche
  const StatsView = () => {
    const playerStats = players.map(player => ({
      ...player,
      totalGoals: matches.reduce((total, match) => {
        const team1Goals = match.team1?.goals?.filter(g => g.player === player.id).length || 0;
        const team2Goals = match.team2?.goals?.filter(g => g.player === player.id).length || 0;
        return total + team1Goals + team2Goals;
      }, 0)
    }));

    const teamStats = teams.map(team => {
      const teamMatches = matches.filter(m => 
        m.team1?.id === team.id || m.team2?.id === team.id
      );
      
      let wins = 0, draws = 0, losses = 0, goalsFor = 0, goalsAgainst = 0;
      
      teamMatches.forEach(match => {
        const isTeam1 = match.team1?.id === team.id;
        const ourScore = isTeam1 ? match.team1.score : match.team2.score;
        const theirScore = isTeam1 ? match.team2.score : match.team1.score;
        
        goalsFor += ourScore;
        goalsAgainst += theirScore;
        
        if (ourScore > theirScore) wins++;
        else if (ourScore === theirScore) draws++;
        else losses++;
      });
      
      return {
        ...team,
        matches: teamMatches.length,
        wins,
        draws,
        losses,
        goalsFor,
        goalsAgainst
      };
    });

    return (
      <div className="p-4">
        <div className="flex items-center justify-between mb-6">
          <h2 className="text-2xl font-bold">Statistiche</h2>
          <button onClick={() => setCurrentView('home')} className="text-blue-600">← Home</button>
        </div>

        <div className="grid gap-6">
          {/* Statistiche Squadre */}
          <div className="bg-white p-4 rounded-lg shadow">
            <h3 className="font-bold text-lg mb-4">Classifica Squadre</h3>
            <div className="overflow-x-auto">
              <table className="w-full text-sm">
                <thead>
                  <tr className="border-b">
                    <th className="text-left p-2">Squadra</th>
                    <th className="text-center p-2">P</th>
                    <th className="text-center p-2">V</th>
                    <th className="text-center p-2">N</th>
                    <th className="text-center p-2">S</th>
                    <th className="text-center p-2">GF</th>
                    <th className="text-center p-2">GS</th>
                  </tr>
                </thead>
                <tbody>
                  {teamStats
                    .sort((a, b) => (b.wins * 3 + b.draws) - (a.wins * 3 + a.draws))
                    .map(team => (
                    <tr key={team.id} className="border-b">
                      <td className="p-2 flex items-center gap-2">
                        <div className="w-4 h-4 rounded" style={{backgroundColor: team.color}}></div>
                        {team.name}
                      </td>
                      <td className="text-center p-2">{team.wins * 3 + team.draws}</td>
                      <td className="text-center p-2">{team.wins}</td>
                      <td className="text-center p-2">{team.draws}</td>
                      <td className="text-center p-2">{team.losses}</td>
                      <td className="text-center p-2">{team.goalsFor}</td>
                      <td className="text-center p-2">{team.goalsAgainst}</td>
                    </tr>
                  ))}
                </tbody>
              </table>
            </div>
          </div>

          {/* Statistiche Giocatori */}
          <div className="bg-white p-4 rounded-lg shadow">
            <h3 className="font-bold text-lg mb-4">Marcatori</h3>
            <div className="grid gap-2">
              {playerStats
                .sort((a, b) => b.totalGoals - a.totalGoals)
                .slice(0, 10)
                .map(player => (
                <div key={player.id} className="flex justify-between items-center p-2 hover:bg-gray-50 rounded">
                  <span className="font-medium">{player.name}</span>
                  <span className="font-bold text-green-600">{player.totalGoals} gol</span>
                </div>
              ))}
            </div>
          </div>
        </div>
      </div>
    );
  };

  // Componente Partite
  const MatchesView = () => (
    <div className="p-4">
      <div className="flex items-center justify-between mb-6">
        <h2 className="text-2xl font-bold">Storico Partite</h2>
        <button onClick={() => setCurrentView('home')} className="text-blue-600">← Home</button>
      </div>

      <div className="grid gap-4">
        {matches.length === 0 ? (
          <div className="text-center text-gray-500 py-8">
            Nessuna partita giocata ancora
          </div>
        ) : (
          matches.map(match => (
            <div key={match.id} className="bg-white p-4 rounded-lg shadow">
              <div className="flex justify-between items-center mb-2">
                <div className="flex items-center gap-4">
                  <div className="flex items-center gap-2">
                    <div className="w-4 h-4 rounded" style={{backgroundColor: match.team1?.color}}></div>
                    <span className="font-medium">{match.team1?.name}</span>
                  </div>
                  <span className="font-bold text-lg">
                    {match.team1?.score} - {match.team2?.score}
                  </span>
                  <div className="flex items-center gap-2">
                    <span className="font-medium">{match.team2?.name}</span>
                    <div className="w-4 h-4 rounded" style={{backgroundColor: match.team2?.color}}></div>
                  </div>
                </div>
                <div className="text-sm text-gray-500">
                  {formatTime(match.duration || 0)}
                </div>
              </div>
              <div className="text-sm text-gray-600">
                {new Date(match.startTime).toLocaleDateString('it-IT')} - {new Date(match.startTime).toLocaleTimeString('it-IT')}
              </div>
            </div>
          ))
        )}
      </div>
    </div>
  );

  // Render principale
  const renderView = () => {
    switch(currentView) {
      case 'home': return <HomeView />;
      case 'teams': return <TeamsView />;
      case 'players': return <PlayersView />;
      case 'stats': return <StatsView />;
      case 'matches': return <MatchesView />;
      case 'newMatch': return <NewMatchView />;
      case 'match': return <MatchView />;
      default: return <HomeView />;
    }
  };

  return <div className="min-h-screen bg-gray-50">{renderView()}</div>;
};
