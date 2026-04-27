import { useEffect, useState } from "react";
import axios from "axios";
import { API_BASE } from "../config/config";
import "./ListUser.css";

export default function Users() {
    const [message, setMessage] = useState("");
    const [messageType, setMessageType] = useState("");
    const [users, setUsers] = useState([]);
    const [roles, setRoles] = useState([]);
    const isEmpty = (value) => !value || value.trim() === "";
    const [submitted, setSubmitted] = useState(false);

    const [form, setForm] = useState({
        id_usuario: "",
        nombre: "",
        apellido_paterno: "",
        apellido_materno: "",
        correo: "",
        password: "",
        id_rol: ""
    });

    const validateForm = () => {
        if (
            !form.nombre ||
            !form.apellido_paterno ||
            !form.apellido_materno ||
            !form.correo ||
            !form.password ||
            !form.id_rol
        ) {
            setMessage("Faltan datos obligatorios");
            setMessageType("error");
            setTimeout(() => {
                setMessage("");
                setMessageType("");
            }, 3000);
            return false;
        }

        return true;
    };
    const [editing, setEditing] = useState(false);

    const USE_BACKEND = false;

    //  usuario logueado (fake por ahora)
    const currentUser = JSON.parse(localStorage.getItem("user")) || { rol: 1 };

    const isAdmin = currentUser.rol === 1;
    const isOperador = currentUser.rol === 2;

    // =====================
    // LOAD DATA
    // =====================
    useEffect(() => {

        if (USE_BACKEND) {
            axios.get(`${API_BASE}/users/index.php`)
                .then(res => setUsers(res.data));

            axios.get(`${API_BASE}/roles/index.php`)
                .then(res => setRoles(res.data));

        } else {
            setUsers([
                {
                    id_usuario: 1,
                    nombre: "Andrea",
                    apellido_paterno: "Macedo",
                    apellido_materno: "Lopez",
                    correo: "admin@test.com",
                    id_rol: 1,
                    rol_nombre: "Admin"
                }
            ]);

            setRoles([
                { id_rol: 1, nombre: "Admin" },
                { id_rol: 2, nombre: "Operador" },
                { id_rol: 3, nombre: "Usuario" }
            ]);
        }

    }, []);

    // =====================
    // INPUT
    // =====================
    const handleChange = (e) => {
        setForm({ ...form, [e.target.name]: e.target.value });
    };

    // =====================
    // CREATE
    // =====================
    const handleCreate = async () => {

        //  operador solo puede crear usuarios básicos
        setSubmitted(true);
        if (!validateForm()) return;

        if (isOperador && form.id_rol != 3) {
            alert("Solo puedes crear usuarios básicos");
            return;
        }

        if (USE_BACKEND) {
            await axios.post(`${API_BASE}/users/save.php`, form);
        } else {
            const role = roles.find(r => r.id_rol == form.id_rol);

            setUsers([
                ...users,
                {
                    ...form,
                    id_usuario: Date.now(),
                    rol_nombre: role?.nombre
                }
            ]);
        }
        setMessage(`Usuario ${form.nombre} creado correctamente `);
        setMessageType("success");
        resetForm();
    };

    // =====================
    // UPDATE (solo admin)
    // =====================
    const handleUpdate = async () => {


        if (!isAdmin) {
            alert("No tienes permisos");
            return;
        }
        setSubmitted(true);
        if (!validateForm()) return;

        if (USE_BACKEND) {
            await axios.post(`${API_BASE}/users/update.php`, form);
        } else {
            const role = roles.find(r => r.id_rol == form.id_rol);

            setUsers(users.map(u =>
                u.id_usuario === form.id_usuario
                    ? { ...form, rol_nombre: role?.nombre }
                    : u
            ));
        }
        setMessage(`Usuario ${form.nombre} actualizado correctamente `);
        setMessageType("success");
        resetForm();
    };

    // =====================
    // DELETE
    // =====================
    const handleDelete = async (user) => {

        //  operador solo elimina básicos
        if (isOperador && user.id_rol != 3) {
            alert("Solo puedes eliminar usuarios básicos");
            return;
        }

        if (USE_BACKEND) {
            await axios.post(`${API_BASE}/users/delete.php`, {
                id_usuario: user.id_usuario
            });
        } else {
            setUsers(users.filter(u => u.id_usuario !== user.id_usuario));
        }
        setMessage(`Usuario ${user.nombre} eliminado correctamente `);
        setMessageType("success");
    };

    // =====================
    // EDIT
    // =====================
    const handleEdit = (user) => {
        if (!isAdmin) return;

        setForm(user);
        setEditing(true);
    };

    // =====================
    // RESET
    // =====================
    const resetForm = () => {
        setForm({
            id_usuario: "",
            nombre: "",
            apellido_paterno: "",
            apellido_materno: "",
            correo: "",
            password: "",
            id_rol: ""
        });
        setEditing(false);
        setSubmitted(false);
    };

    return (
        <div className="users-container">
            <h2>Users</h2>

            {/* FORM */}
            {(isAdmin || isOperador) && (
                <div className="users-form">
                    <input name="nombre" placeholder="Name"  value={form.nombre} onChange={handleChange} className={submitted && isEmpty(form.nombre) ? "error-input" : ""} />
                    <input name="apellido_paterno" placeholder="Last Name"  value={form.apellido_paterno} onChange={handleChange} className={submitted && isEmpty(form.apellido_paterno) ? "error-input" : ""} />
                    <input name="apellido_materno" placeholder="Second Last Name"  value={form.apellido_materno} onChange={handleChange} className={submitted && isEmpty(form.apellido_materno) ? "error-input" : ""} />
                    <input name="correo" placeholder="Email"  value={form.correo} onChange={handleChange} className={submitted && isEmpty(form.correo) ? "error-input" : ""} />
                    <input type="password" name="password" placeholder="Password"  value={form.password} onChange={handleChange} className={submitted && isEmpty(form.password) ? "error-input" : ""} />

                    <select name="id_rol" onChange={handleChange}>
                        <option value="">Select Role</option>

                        {roles
                            .filter(r => isAdmin || r.id_rol == 3) // operador solo ve usuario
                            .map(r => (
                                <option key={r.id_rol} value={r.id_rol}>
                                    {r.nombre}
                                </option>
                            ))}
                    </select>

                    {editing ? (
                        <button className="btn-edit" onClick={handleUpdate}>
                            Update
                        </button>
                    ) : (
                        <button className="btn-create" onClick={handleCreate}>
                            Create
                        </button>
                    )}
                </div>
            )}
            {message && (
                <div className={`message-box ${messageType}`}>
                    {message}
                </div>
            )}
            {/* TABLE */}
            <table className="users-table">
                <thead>
                    <tr>
                        <th>Name</th>
                        <th>Email</th>
                        <th>Role</th>
                        {(isAdmin || isOperador) && <th>Actions</th>}
                    </tr>
                </thead>

                <tbody>
                    {users.map(u => (
                        <tr key={u.id_usuario}>
                            <td>{u.nombre}</td>
                            <td>{u.correo}</td>
                            <td>{u.rol_nombre}</td>

                            {(isAdmin || isOperador) && (
                                <td>
                                    {isAdmin && (
                                        <button onClick={() => handleEdit(u)}>Edit</button>
                                    )}

                                    <button onClick={() => handleDelete(u)}>Delete</button>
                                </td>
                            )}
                        </tr>
                    ))}
                </tbody>
            </table>

        </div>
    );
}