import { NavLink } from "react-router-dom";
import "./Navbar.css";

export default function Navbar() {

  const user = JSON.parse(localStorage.getItem("user"));

  const isAdmin = user?.rol === 1;
  const isOperador = user?.rol === 2;

  return (
    <nav className="navbar">

      <NavLink to="/dashboard/projects" className="nav-link">
        Proyectos
      </NavLink>

      {(isAdmin || isOperador) && (
        <NavLink to="/dashboard/users" className="nav-link">
          Usuarios
        </NavLink>
      )}

    </nav>
  );
}