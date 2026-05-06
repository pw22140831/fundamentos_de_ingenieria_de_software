import { useEffect, useState } from "react";
import axios from "axios";
import { API_BASE } from "../config/config";

import Header from "../components/Header";
import Footer from "../components/Footer";
import Navbar from "../components/Navbar";

import Input from "../components/Input";
import Button from "../components/Button";
import Message from "../components/Message";
import Loading from "../components/Loading";
import ConfirmModal from "../components/ConfirmModal";

import { buildMessage } from "../utils/messageBuilder";

import "./ListUser.css";

export default function Users() {

    const [users, setUsers] = useState([]);
    const [roles, setRoles] = useState([]);

    const [form, setForm] = useState({
        id_usuario: "",
        nombre: "",
        apellido_paterno: "",
        apellido_materno: "",
        correo: "",
        password: "",
        id_rol: ""
    });

    const [editing, setEditing] = useState(false);
    const [submitted, setSubmitted] = useState(false);

    const [message, setMessage] = useState("");
    const [messageType, setMessageType] = useState("");
    const [loading, setLoading] = useState(false);

    const [showConfirm, setShowConfirm] = useState(false);
    const [actionType, setActionType] = useState("");
    const [actionData, setActionData] = useState(null);

    const USE_BACKEND = false;

    const currentUser = JSON.parse(localStorage.getItem("user")) || { rol: 1 };
    const isAdmin = currentUser.rol === 1;
    const isOperador = currentUser.rol === 2;

    const isEmpty = (v) => !v || v.trim() === "";

    // ===================== MENSAJES
    const showMessage = (text, type) => {
        setMessage(text);
        setMessageType(type);

        setTimeout(() => {
            setMessage("");
            setMessageType("");
        }, 3000);
    };

    // ===================== VALIDACIÓN
    const validateForm = () => {
        if (
            !form.nombre ||
            !form.apellido_paterno ||
            !form.apellido_materno ||
            !form.correo ||
            !form.password ||
            !form.id_rol
        ) {
            showMessage("Faltan datos obligatorios", "error");
            return false;
        }
        return true;
    };

    // ===================== LOAD
    useEffect(() => {
        setLoading(true);

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

        setTimeout(() => setLoading(false), 500);
    }, []);

    // ===================== INPUT
    const handleChange = (e) => {
        setForm({ ...form, [e.target.name]: e.target.value });
    };

    // ===================== CREATE CLICK
    const handleCreateClick = () => {
        setSubmitted(true);
        if (!validateForm()) return;

        setActionType("create");
        setActionData(form);
        setShowConfirm(true);
    };

    // ===================== DELETE CLICK
    const handleDeleteClick = (user) => {
        setActionType("delete");
        setActionData(user);
        setShowConfirm(true);
    };

    // ===================== CONFIRM ACTION
    const handleConfirm = async () => {
        setLoading(true);

        if (actionType === "create") {

            if (isOperador && actionData.id_rol != 3) {
                showMessage("Solo puedes crear usuarios básicos", "error");
                setLoading(false);
                return;
            }

            if (USE_BACKEND) {
                await axios.post(`${API_BASE}/users/save.php`, actionData);
            } else {
                const role = roles.find(r => r.id_rol == actionData.id_rol);

                setUsers([
                    ...users,
                    {
                        ...actionData,
                        id_usuario: Date.now(),
                        rol_nombre: role?.nombre
                    }
                ]);
            }

            showMessage(buildMessage("Usuario", actionData.nombre, "creado"), "success");
            resetForm();
        }

        if (actionType === "delete") {

            if (isOperador && actionData.id_rol != 3) {
                showMessage("Solo puedes eliminar usuarios básicos", "error");
                setLoading(false);
                return;
            }

            if (USE_BACKEND) {
                await axios.post(`${API_BASE}/users/delete.php`, {
                    id_usuario: actionData.id_usuario
                });
            } else {
                setUsers(users.filter(u => u.id_usuario !== actionData.id_usuario));
            }

            showMessage(buildMessage("Usuario", actionData.nombre, "eliminado"), "success");
        }

        setShowConfirm(false);
        setLoading(false);
    };

    // ===================== EDIT
    const handleEdit = (user) => {
        if (!isAdmin) return;
        setForm(user);
        setEditing(true);
    };

    // ===================== RESET
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
        <>
            <div className="users-container">

                <h2>Users</h2>

                {loading && <Loading />}
                {message && <Message text={message} type={messageType} />}

                {(isAdmin || isOperador) && (
                    <div className="users-form">

                        <Input label="Name" name="nombre"
                            value={form.nombre}
                            onChange={handleChange}
                            error={submitted && isEmpty(form.nombre)}
                        />

                        <Input label="Last Name" name="apellido_paterno"
                            value={form.apellido_paterno}
                            onChange={handleChange}
                            error={submitted && isEmpty(form.apellido_paterno)}
                        />

                        <Input label="Second Last Name" name="apellido_materno"
                            value={form.apellido_materno}
                            onChange={handleChange}
                            error={submitted && isEmpty(form.apellido_materno)}
                        />

                        <Input label="Email" name="correo"
                            value={form.correo}
                            onChange={handleChange}
                            error={submitted && isEmpty(form.correo)}
                        />

                        <Input label="Password" type="password" name="password"
                            value={form.password}
                            onChange={handleChange}
                            error={submitted && isEmpty(form.password)}
                        />

                        <select name="id_rol" value={form.id_rol} onChange={handleChange}>
                            <option value="">Select Role</option>
                            {roles
                                .filter(r => isAdmin || r.id_rol == 3)
                                .map(r => (
                                    <option key={r.id_rol} value={r.id_rol}>
                                        {r.nombre}
                                    </option>
                                ))}
                        </select>

                        <Button
                            text={editing ? "Update" : "Create"}
                            onClick={handleCreateClick}
                            className={editing ? "btn-edit" : "btn-create"}
                        />

                    </div>
                )}

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
                                            <Button
                                                text="Edit"
                                                onClick={() => handleEdit(u)}
                                                className="btn-edit"
                                            />
                                        )}

                                        <Button
                                            text="Delete"
                                            onClick={() => handleDeleteClick(u)}
                                            className="btn-delete"
                                        />
                                    </td>
                                )}
                            </tr>
                        ))}
                    </tbody>
                </table>

                {showConfirm && (
                    <ConfirmModal
                        text={`¿Seguro que deseas ${actionType === "create" ? "crear" : "eliminar"} ${actionData?.nombre}?`}
                        onConfirm={handleConfirm}
                        onCancel={() => setShowConfirm(false)}
                    />
                )}

            </div>

        </>
    );
}