import { useEffect, useState } from "react";
import axios from "axios";

import {
    API_BASE,
    USE_BACKEND
} from "../config/config";

import Input from "../components/Input";
import Button from "../components/Button";
import Message from "../components/Message";
import Loading from "../components/Loading";
import ConfirmModal from "../components/ConfirmModal";

import { buildMessage } from "../utils/messageBuilder";

import "./ListUser.css";

export default function Users() {

    // =====================
    // USER LOGIN
    // =====================
    const loggedUser = JSON.parse(
        localStorage.getItem("user")
    );

    const token =
        localStorage.getItem("token");

    const rol = loggedUser?.rol || "";

    const isAdmin =
        rol.toLowerCase() === "admin";

    const isOperador =
        rol.toLowerCase() === "operador";

    // =====================
    // STATES
    // =====================
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

    const [editing, setEditing] =
        useState(false);

    const [submitted, setSubmitted] =
        useState(false);

    const [message, setMessage] =
        useState("");

    const [messageType, setMessageType] =
        useState("");

    const [loading, setLoading] =
        useState(false);

    const [showConfirm, setShowConfirm] =
        useState(false);

    const [actionType, setActionType] =
        useState("");

    const [actionData, setActionData] =
        useState(null);

    // =====================
    // AXIOS CONFIG
    // =====================
    const axiosConfig = {
        headers: {
            Authorization:
                `Bearer ${token}`
        }
    };

    // =====================
    // VALIDACIÓN
    // =====================
    const isEmpty = (v) =>
        !v || v.trim() === "";

    const validateForm = () => {

        if (
            !form.nombre ||
            !form.apellido_paterno ||
            !form.apellido_materno ||
            !form.correo ||
            (!editing && !form.password) ||
            !form.id_rol
        ) {

            showMessage(
                "Faltan datos obligatorios",
                "error"
            );

            return false;
        }

        return true;
    };

    // =====================
    // MENSAJES
    // =====================
    const showMessage = (text, type) => {

        setMessage(text);
        setMessageType(type);

        setTimeout(() => {

            setMessage("");
            setMessageType("");

        }, 3000);
    };

    // =====================
    // LOAD DATA
    // =====================
    useEffect(() => {

        setLoading(true);

        // =====================
        // BACKEND
        // =====================
        if (USE_BACKEND) {

            Promise.all([

                axios.get(
                    `${API_BASE}/users/index.php`,
                    axiosConfig
                ),

                axios.get(
                    `${API_BASE}/roles/index.php`,
                    axiosConfig
                )

            ])
                .then(([usersRes, rolesRes]) => {

                    setUsers(usersRes.data);
                    setRoles(rolesRes.data);

                })
                .catch((error) => {

                    console.error(error);

                    showMessage(
                        "Error cargando datos",
                        "error"
                    );
                })
                .finally(() => {
                    setLoading(false);
                });

        }

        // =====================
        // LOCAL TEST
        // =====================
        else {

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
                {
                    id_rol: 1,
                    nombre: "Admin"
                },
                {
                    id_rol: 2,
                    nombre: "Operador"
                },
                {
                    id_rol: 3,
                    nombre: "Trabajador"
                }
            ]);

            setTimeout(() => {
                setLoading(false);
            }, 500);
        }

    }, []);

    // =====================
    // INPUTS
    // =====================
    const handleChange = (e) => {

        setForm({
            ...form,
            [e.target.name]:
                e.target.value
        });
    };

    // =====================
    // SAVE CLICK
    // =====================
    const handleSaveClick = () => {

        setSubmitted(true);

        if (!validateForm()) return;

        setActionType(
            editing ? "update" : "create"
        );

        setActionData(form);

        setShowConfirm(true);
    };

    // =====================
    // DELETE CLICK
    // =====================
    const handleDeleteClick = (user) => {

        setActionType("delete");

        setActionData(user);

        setShowConfirm(true);
    };

    // =====================
    // EDIT
    // =====================
    const handleEdit = (user) => {

        const roleName = (
            user.rol_nombre ||
            user.rol ||
            ""
        ).toLowerCase();

        // =====================
        // ADMIN
        // =====================
        if (isAdmin) {

            setForm({
                ...user,
                password: ""
            });

            setEditing(true);

            return;
        }

        // =====================
        // OPERADOR
        // =====================
        if (
            isOperador &&
            roleName === "trabajador"
        ) {

            setForm({
                ...user,
                password: ""
            });

            setEditing(true);

            return;
        }

        // =====================
        // SIN PERMISOS
        // =====================
        showMessage(
            "No tienes permisos",
            "error"
        );
    };

    // =====================
    // CONFIRM ACTION
    // =====================
    const handleConfirm = async () => {

        setLoading(true);

        try {

            // =====================
            // CREATE
            // =====================
            if (actionType === "create") {

                const role =
                    roles.find(
                        r =>
                            r.id_rol ==
                            actionData.id_rol
                    );

                // OPERADOR SOLO TRABAJADORES
                if (
                    isOperador &&
                    role?.nombre
                        .toLowerCase() !==
                    "trabajador"
                ) {

                    showMessage(
                        "Solo puedes crear trabajadores",
                        "error"
                    );

                    setLoading(false);

                    return;
                }

                // BACKEND
                if (USE_BACKEND) {

                    await axios.post(
                        `${API_BASE}/users/save.php`,
                        actionData,
                        axiosConfig
                    );

                    const usersRes =
                        await axios.get(
                            `${API_BASE}/users/index.php`,
                            axiosConfig
                        );

                    setUsers(usersRes.data);

                }

                // LOCAL
                else {

                    setUsers([
                        ...users,
                        {
                            ...actionData,
                            id_usuario:
                                Date.now(),
                            rol_nombre:
                                role?.nombre
                        }
                    ]);
                }

                showMessage(
                    buildMessage(
                        "Usuario",
                        actionData.nombre,
                        "creado"
                    ),
                    "success"
                );

                resetForm();
            }

            // =====================
            // UPDATE
            // =====================
            if (actionType === "update") {

                const role = roles.find(
                    r => r.id_rol == actionData.id_rol
                );

                const roleName =
                    role?.nombre?.toLowerCase() || "";

                // =====================
                // ADMIN
                // =====================
                if (!isAdmin) {

                    // =====================
                    // OPERADOR SOLO TRABAJADORES
                    // =====================
                    if (
                        !(
                            isOperador &&
                            roleName === "trabajador"
                        )
                    ) {

                        showMessage(
                            "No tienes permisos",
                            "error"
                        );

                        setLoading(false);

                        return;
                    }
                }

                // =====================
                // BACKEND
                // =====================
                if (USE_BACKEND) {

                    await axios.post(
                        `${API_BASE}/users/update.php`,
                        actionData,
                        axiosConfig
                    );

                    const usersRes =
                        await axios.get(
                            `${API_BASE}/users/index.php`,
                            axiosConfig
                        );

                    setUsers(usersRes.data);

                }

                // =====================
                // LOCAL
                // =====================
                else {

                    setUsers(
                        users.map(u =>
                            u.id_usuario ===
                                actionData.id_usuario

                                ? {
                                    ...actionData,
                                    rol_nombre:
                                        role?.nombre
                                }

                                : u
                        )
                    );
                }

                showMessage(
                    buildMessage(
                        "Usuario",
                        actionData.nombre,
                        "actualizado"
                    ),
                    "success"
                );

                resetForm();
            }

            // =====================
            // DELETE
            // =====================
            if (actionType === "delete") {

                const role =
                    roles.find(
                        r =>
                            r.id_rol ==
                            actionData.id_rol
                    );

                if (
                    isOperador &&
                    role?.nombre
                        .toLowerCase() !==
                    "trabajador"
                ) {

                    showMessage(
                        "Solo puedes eliminar trabajadores",
                        "error"
                    );

                    setLoading(false);

                    return;
                }

                if (USE_BACKEND) {

                    await axios.post(
                        `${API_BASE}/users/delete.php`,
                        {
                            id_usuario:
                                actionData.id_usuario
                        },
                        axiosConfig
                    );

                    const usersRes =
                        await axios.get(
                            `${API_BASE}/users/index.php`,
                            axiosConfig
                        );

                    setUsers(usersRes.data);

                } else {

                    setUsers(
                        users.filter(
                            u =>
                                u.id_usuario !==
                                actionData.id_usuario
                        )
                    );
                }

                showMessage(
                    buildMessage(
                        "Usuario",
                        actionData.nombre,
                        "eliminado"
                    ),
                    "success"
                );
            }

        } catch (error) {

            console.error(error);

            showMessage(
                "Error en la operación",
                "error"
            );

        } finally {

            setLoading(false);

            setShowConfirm(false);
        }
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

            <h2>
                {
                    editing
                        ? "Editando usuario"
                        : "Users"
                }
            </h2>

            {loading && <Loading />}

            {message && (
                <Message
                    text={message}
                    type={messageType}
                />
            )}

            {/* FORM */}
            {(isAdmin || isOperador) && (

                <div className="users-form">

                    <Input
                        label="Name"
                        name="nombre"
                        value={form.nombre}
                        onChange={handleChange}
                        error={
                            submitted &&
                            isEmpty(form.nombre)
                        }
                    />

                    <Input
                        label="Last Name"
                        name="apellido_paterno"
                        value={form.apellido_paterno}
                        onChange={handleChange}
                        error={
                            submitted &&
                            isEmpty(
                                form.apellido_paterno
                            )
                        }
                    />

                    <Input
                        label="Second Last Name"
                        name="apellido_materno"
                        value={form.apellido_materno}
                        onChange={handleChange}
                        error={
                            submitted &&
                            isEmpty(
                                form.apellido_materno
                            )
                        }
                    />

                    <Input
                        label="Email"
                        name="correo"
                        value={form.correo}
                        onChange={handleChange}
                        error={
                            submitted &&
                            isEmpty(form.correo)
                        }
                    />

                    <Input
                        label="Password"
                        type="password"
                        name="password"
                        value={form.password}
                        onChange={handleChange}
                        error={
                            submitted &&
                            isEmpty(form.password)
                        }
                    />

                    <select
                        name="id_rol"
                        value={form.id_rol}
                        onChange={handleChange}
                    >

                        <option value="">
                            Select Role
                        </option>

                        {roles
                            .filter(r =>
                                isAdmin ||
                                r.nombre
                                    .toLowerCase() ===
                                "trabajador"
                            )
                            .map(r => (

                                <option
                                    key={r.id_rol}
                                    value={r.id_rol}
                                >
                                    {r.nombre}
                                </option>
                            ))
                        }

                    </select>

                    <Button
                        text={
                            editing
                                ? "Update"
                                : "Create"
                        }
                        onClick={handleSaveClick}
                        className={
                            editing
                                ? "btn-edit"
                                : "btn-create"
                        }
                    />

                </div>
            )}

            {/* TABLE */}
            <table className="users-table">

                <thead>

                    <tr>

                        <th>Name</th>
                        <th>Email</th>
                        <th>Role</th>

                        {(isAdmin || isOperador) && (
                            <th>Actions</th>
                        )}

                    </tr>

                </thead>

                <tbody>

                    {users

                        // =====================
                        // FILTRO POR ROL
                        // =====================
                        .filter(u => {

                            // ADMIN VE TODO
                            if (isAdmin) {
                                return true;
                            }

                            // OPERADOR SOLO VE TRABAJADORES
                            if (isOperador) {

                                return (
                                    (
                                        u.rol_nombre ||
                                        u.rol ||
                                        ""
                                    )
                                        .toLowerCase() ===
                                    "trabajador"
                                );
                            }

                            // OTROS NO VEN USERS
                            return false;
                        })

                        // =====================
                        // MAP
                        // =====================
                        .map(u => (

                            <tr key={u.id_usuario}>

                                <td>{u.nombre}</td>

                                <td>{u.correo}</td>

                                <td>
                                    {u.rol_nombre || u.rol}
                                </td>

                                {(isAdmin || isOperador) && (

                                    <td>

                                        {/* =====================
                                EDIT
                            ===================== */}

                                        {(

                                            // ADMIN EDITA TODO
                                            isAdmin ||

                                            // OPERADOR SOLO TRABAJADORES
                                            (
                                                isOperador &&

                                                (
                                                    u.rol_nombre ||
                                                    u.rol ||
                                                    ""
                                                )
                                                    .toLowerCase() ===
                                                "trabajador"
                                            )

                                        ) && (

                                                <Button
                                                    text="Edit"
                                                    onClick={() =>
                                                        handleEdit(u)
                                                    }
                                                    className="btn-edit"
                                                />

                                            )}

                                        {/* =====================
                                DELETE
                            ===================== */}

                                        <Button
                                            text="Delete"
                                            onClick={() =>
                                                handleDeleteClick(u)
                                            }
                                            className="btn-delete"
                                        />

                                    </td>

                                )}

                            </tr>

                        ))

                    }

                </tbody>

            </table>

            {/* MODAL */}
            {showConfirm && (

                <ConfirmModal

                    text={`¿Seguro que deseas ${actionType === "create"
                        ? "crear"
                        : actionType === "update"
                            ? "actualizar"
                            : "eliminar"
                        } el usuario "${actionData?.nombre
                        }"?`}

                    onConfirm={handleConfirm}

                    onCancel={() =>
                        setShowConfirm(false)
                    }
                />
            )}

        </div>
    );
}