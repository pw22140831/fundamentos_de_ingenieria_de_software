import { useState, useEffect } from "react";
import axios from "axios";
import { API_BASE } from '../config/config';
import "./Projects.css";

export default function Projects() {

  const [projects, setProjects] = useState([]);
  const [form, setForm] = useState({
    id_proyecto: "",
    nombre: "",
    responsable: "",
    fecha_inicio: "",
    fecha_fin: "",
    presupuesto: ""
  });

  const [editing, setEditing] = useState(false);

  //  CAMBIA AQUÍ
  const USE_BACKEND = false;

  // =========================
  //  VIEW (GET)
  // =========================
  useEffect(() => {
    if (USE_BACKEND) {
      axios.get(`${API_BASE}/proyectos/index.php`)
        .then(res => setProjects(res.data))
        .catch(err => console.error(err));
    } else {
      //  DATOS FAKE
      setProjects([
        {
          id_proyecto: 1,
          nombre: "Sistema ERP",
          responsable: "Andrea",
          fecha_inicio: "2026-01-01",
          fecha_fin: "2026-06-01",
          presupuesto: 50000
        }
      ]);
    }
  }, []);

  // =========================
  //  HANDLE INPUT
  // =========================
  const handleChange = (e) => {
    setForm({ ...form, [e.target.name]: e.target.value });
  };

  // =========================
  //  CREATE
  // =========================
  const handleCreate = async () => {

    if (USE_BACKEND) {
      await axios.post(`${API_BASE}/proyectos/save.php`, form);
    } else {
      setProjects([...projects, { ...form, id_proyecto: Date.now() }]);
    }

    resetForm();
  };

  // =========================
  //  UPDATE
  // =========================
  const handleUpdate = async () => {

    if (USE_BACKEND) {
      await axios.post(`${API_BASE}/proyectos/update.php`, form);
    } else {
      setProjects(projects.map(p =>
        p.id_proyecto === form.id_proyecto ? form : p
      ));
    }

    resetForm();
  };

  // =========================
  //  DELETE
  // =========================
  const handleDelete = async (id) => {

    if (USE_BACKEND) {
      await axios.post(`${API_BASE}/proyectos/delete.php`, {
        id_proyecto: id
      });
    } else {
      setProjects(projects.filter(p => p.id_proyecto !== id));
    }
  };

  // =========================
  // EDIT LOAD
  // =========================
  const handleEdit = (project) => {
    setForm(project);
    setEditing(true);
  };

  // =========================
  //  RESET
  // =========================
  const resetForm = () => {
    setForm({
      id_proyecto: "",
      nombre: "",
      responsable: "",
      fecha_inicio: "",
      fecha_fin: "",
      presupuesto: ""
    });
    setEditing(false);
  };

  return (
    <div className="projects-container">

      <h2>Projects</h2>

      {/* FORM */}
      <div className="form">
        <input name="nombre" placeholder="Name" onChange={handleChange} value={form.nombre} />
        <input name="responsable" placeholder="Responsible" onChange={handleChange} value={form.responsable} />
        <input type="date" name="fecha_inicio" onChange={handleChange} value={form.fecha_inicio} />
        <input type="date" name="fecha_fin" onChange={handleChange} value={form.fecha_fin} />
        <input name="presupuesto" placeholder="Budget" onChange={handleChange} value={form.presupuesto} />

        {editing ? (
          <button onClick={handleUpdate}>Update</button>
        ) : (
          <button onClick={handleCreate}>Create</button>
        )}
      </div>

      {/* TABLE */}
      <table>
        <thead>
          <tr>
            <th>Name</th>
            <th>Responsible</th>
            <th>Start</th>
            <th>End</th>
            <th>Budget</th>
            <th>Actions</th>
          </tr>
        </thead>

        <tbody>
          {projects.map(p => (
            <tr key={p.id_proyecto}>
              <td>{p.nombre}</td>
              <td>{p.responsable}</td>
              <td>{p.fecha_inicio}</td>
              <td>{p.fecha_fin}</td>
              <td>{p.presupuesto}</td>
              <td>
                <button onClick={() => handleEdit(p)}>Edit</button>
                <button onClick={() => handleDelete(p.id_proyecto)}>Delete</button>
              </td>
            </tr>
          ))}
        </tbody>
      </table>

    </div>
  );
}