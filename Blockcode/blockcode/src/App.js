import {BrowserRouter, Routes, Route, Link} from 'react-router-dom';
import './App.css';
import ListUser from './components/ListUser';
import CreateUser from './components/CreateUser';
import EditUser from './components/EditUser';

function App() {
  return (
  <div className="App">
      {/* Encabezado */}
      <header className="App-header">
        <h1>Blockcode</h1>
        <div className="logo-space">
          <img src="logo.jpeg" alt="Logo Blockcode" />
        </div>
      </header>

      {/* Login */}
      <main className="App-main">
        <h2>Login</h2>
        <form className="login-form">
          <label>
            Username:
            <input type="text" name="username" />
          </label>
          <label>
            Password:
            <input type="password" name="password" />
          </label>
          <button type="submit">Ingresar</button>
        </form>
      </main>

      {/* Footer */}
      <footer className="App-footer">
        <p>© 2026 Blockcode - Todos los derechos reservados</p>
      </footer>
    </div>
  );
}

export default App;
