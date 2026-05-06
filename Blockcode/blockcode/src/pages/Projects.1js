import { useState, useEffect } from "react";
import axios from "axios";
import { API_BASE } from '../config/config';
import "./Projects.css";

export default function Projects() {
  const [message, setMessage] = useState("");
  const [messageType, setMessageType] = useState("");
  const [projects, setProjects] = useState([]);
  const isEmpty = (value) => !value || value.trim() === "";
  const [submitted, setSubmitted] = useState(false);

  const fetchProjects = async () => {
    const res = await axios.get(`${API_BASE}/proyectos/index.php`);
    setProjects(res.data);
  };

  const [form, setForm] = useState({
    id_proyecto: "",
    nombre: "",
    responsable: "",
    fecha_inicio: "",
    fecha_fin: "",
    presupuesto: ""
  });

  const [editing, setEditing] = useState(false);

  const validateForm = () => {
    if (
      !form.nombre ||
      !form.responsable ||
      !form.fecha_inicio ||
      !form.fecha_fin ||
      !form.presupuesto
    ) {
      setMessage("Faltan datos obligatorios");
      setTimeout(() => {
        setMessage("");
      }, 3000);
      return false;
    }

    return true;
  };
  //  BACKEDN
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
    setSubmitted(true);
    if (!validateForm()) return;
    if (USE_BACKEND) {
      await axios.post(`${API_BASE}/proyectos/save.php`, form);
      fetchProjects();
    } else {
      setProjects([...projects, { ...form, id_proyecto: Date.now() }]);
    }
    setMessage(`Proyecto ${form.nombre} creado correctamente `);
    setMessageType("success");
    resetForm();

  };

  // =========================
  //  UPDATE
  // =========================
  const handleUpdate = async () => {
    setSubmitted(true);
    if (!validateForm()) return;
    if (USE_BACKEND) {
      await axios.post(`${API_BASE}/proyectos/update.php`, form);
      fetchProjects();
    } else {
      setProjects(projects.map(p =>
        p.id_proyecto === form.id_proyecto ? form : p
      ));
    }
    setMessage(`Proyecto ${form.nombre} actualizado correctamente `);
    setMessageType("success");
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
      fetchProjects();
    } else {
      setProjects(projects.filter(p => p.id_proyecto !== id));
    }
    setMessage(`Proyecto ${form.nombre} eliminado correctamente `);
    setMessageType("success");
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
    setSubmitted(false);
  };

  return (
    <div className="projects-container">

      <h2>Projects</h2>

      {/* FORM */}
      <div className="form">
        <input name="nombre" placeholder="Name" onChange={handleChange} value={form.nombre} className={submitted && isEmpty(form.nombre) ? "error-input" : ""} />
        <input name="responsable" placeholder="Responsible" onChange={handleChange} value={form.responsable} className={submitted && isEmpty(form.responsable) ? "error-input" : ""} />
        <input type="date" name="fecha_inicio" onChange={handleChange} value={form.fecha_inicio} className={submitted && isEmpty(form.fecha_inicio) ? "error-input" : ""} />
        <input type="date" name="fecha_fin" onChange={handleChange} value={form.fecha_fin} className={submitted && isEmpty(form.fecha_fin) ? "error-input" : ""} />
        <input name="presupuesto" placeholder="Budget" onChange={handleChange} value={form.presupuesto} className={submitted && isEmpty(form.presupuesto) ? "error-input" : ""} />

        {editing ? (
          <button onClick={handleUpdate}>Update</button>
        ) : (
          <button onClick={handleCreate}>Create</button>
        )}
      </div>
      {message && (
        <div className={`message-box ${messageType}`}>
          {message}
        </div>
      )}
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