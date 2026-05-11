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

import "./Inventory.css";

export default function Inventory() {

    const token =
        localStorage.getItem("token");

    const axiosConfig = {
        headers: {
            Authorization:
                `Bearer ${token}`
        }
    };

    const [inventory, setInventory] =
        useState([]);

    const [projects, setProjects] =
        useState([]);

    const [form, setForm] = useState({
        id_inventario: "",
        id_proyecto: "",
        nombre_recurso: "",
        cantidad: "",
        estado: ""
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
    // VALIDACIÓN
    // =====================
    const isEmpty = (v) =>
        !v || v.toString().trim() === "";

    const validateForm = () => {

        if (
            !form.id_proyecto ||
            !form.nombre_recurso ||
            !form.cantidad ||
            !form.estado
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
    // LOAD
    // =====================
    useEffect(() => {

        setLoading(true);

        if (USE_BACKEND) {

            Promise.all([

                axios.get(
                    `${API_BASE}/inventario/index.php`,
                    axiosConfig
                ),

                axios.get(
                    `${API_BASE}/proyectos/index.php`,
                    axiosConfig
                )

            ])
                .then(([inventoryRes, projectsRes]) => {

                    setInventory(
                        inventoryRes.data
                    );

                    setProjects(
                        projectsRes.data
                    );

                })
                .catch(error => {

                    console.error(error);

                    showMessage(
                        "Error cargando inventario",
                        "error"
                    );
                })
                .finally(() => {
                    setLoading(false);
                });

        } else {

            setInventory([
                {
                    id_inventario: 1,
                    proyecto: "Sistema Web",
                    nombre_recurso: "Laptop",
                    cantidad: 5,
                    estado: "Disponible",
                    fecha_actualizacion: "2026-05-10"
                }
            ]);

            setProjects([
                {
                    id_proyecto: 1,
                    nombre: "Sistema Web"
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

        let value =
            e.target.value;

        if (
            e.target.name ===
            "id_proyecto"
        ) {

            value =
                Number(value);
        }

        setForm({
            ...form,
            [e.target.name]:
                value
        });
    };

    // =====================
    // SAVE CLICK
    // =====================
    const handleSaveClick = () => {

        setSubmitted(true);

        if (!validateForm()) return;

        setActionType(
            editing
                ? "update"
                : "create"
        );

        setActionData(form);

        setShowConfirm(true);
    };

    // =====================
    // DELETE CLICK
    // =====================
    const handleDeleteClick = (item) => {

        setActionType("delete");

        setActionData(item);

        setShowConfirm(true);
    };

    // =====================
    // EDIT
    // =====================
    const handleEdit = (item) => {

        setForm({
            ...item
        });

        setEditing(true);
    };

    // =====================
    // CONFIRM
    // =====================
    const handleConfirm = async () => {

        setLoading(true);

        try {

            // CREATE
            if (actionType === "create") {

                if (USE_BACKEND) {

                    await axios.post(
                        `${API_BASE}/inventario/save.php`,
                        actionData,
                        axiosConfig
                    );

                    const res =
                        await axios.get(
                            `${API_BASE}/inventario/index.php`,
                            axiosConfig
                        );

                    setInventory(res.data);

                } else {

                    const project =
                        projects.find(
                            p =>
                                p.id_proyecto ==
                                actionData.id_proyecto
                        );

                    setInventory([
                        ...inventory,
                        {
                            ...actionData,
                            id_inventario:
                                Date.now(),
                            proyecto:
                                project?.nombre
                        }
                    ]);
                }

                showMessage(
                    buildMessage(
                        "Inventario",
                        actionData.nombre_recurso,
                        "creado"
                    ),
                    "success"
                );

                resetForm();
            }

            // UPDATE
            if (actionType === "update") {

                if (USE_BACKEND) {

                    await axios.post(
                        `${API_BASE}/inventario/update.php`,
                        actionData,
                        axiosConfig
                    );

                    const res =
                        await axios.get(
                            `${API_BASE}/inventario/index.php`,
                            axiosConfig
                        );

                    setInventory(res.data);

                } else {

                    const project =
                        projects.find(
                            p =>
                                p.id_proyecto ==
                                actionData.id_proyecto
                        );

                    setInventory(

                        inventory.map(i =>

                            i.id_inventario ===
                                actionData.id_inventario

                                ? {

                                    ...actionData,
                                    proyecto:
                                        project?.nombre,

                                    fecha_actualizacion:
                                        new Date()
                                            .toLocaleString()
                                }
                                

                                : i
                        )
                    );
}

showMessage(
    buildMessage(
        "Inventario",
        actionData.nombre_recurso,
        "actualizado"
    ),
    "success"
);

resetForm();
            }

// DELETE
if (actionType === "delete") {

    if (USE_BACKEND) {

        await axios.post(
            `${API_BASE}/inventario/delete.php`,
            {
                id_inventario:
                    actionData.id_inventario
            },
            axiosConfig
        );

        const res =
            await axios.get(
                `${API_BASE}/inventario/index.php`,
                axiosConfig
            );

        setInventory(res.data);

    } else {

        setInventory(

            inventory.filter(
                i =>
                    i.id_inventario !==
                    actionData.id_inventario
            )
        );
    }

    showMessage(
        buildMessage(
            "Inventario",
            actionData.nombre_recurso,
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
        id_inventario: "",
        id_proyecto: "",
        nombre_recurso: "",
        cantidad: "",
        estado: ""
    });

    setEditing(false);

    setSubmitted(false);
};

return (

    <div className="inventory-container">

        <h2>
            {
                editing
                    ? "Editing Inventory"
                    : "Inventory"
            }
        </h2>

        {loading && <Loading />}

        {message && (
            <Message
                text={message}
                type={messageType}
            />
        )}

        <div className="inventory-form">

            <select
                label="Project"
                name="id_proyecto"
                value={form.id_proyecto}
                onChange={handleChange}
            >

                <option value="">
                    Select Project
                </option>

                {projects.map(p => (

                    <option
                        key={p.id_proyecto}
                        value={p.id_proyecto}
                    >
                        {p.nombre}
                    </option>

                ))}

            </select>

            <Input
                label="Resource"
                name="nombre_recurso"
                value={form.nombre_recurso}
                onChange={handleChange}
                error={
                    submitted &&
                    isEmpty(
                        form.nombre_recurso
                    )
                }
            />

            <Input
                label="Quantity"
                type="number"
                name="cantidad"
                value={form.cantidad}
                onChange={handleChange}
                error={
                    submitted &&
                    isEmpty(form.cantidad)
                }
            />

            <Input
                label="Status"
                name="estado"
                value={form.estado}
                onChange={handleChange}
                error={
                    submitted &&
                    isEmpty(form.estado)
                }
            />

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

        <table className="inventory-table">

            <thead>

                <tr>

                    <th>Project</th>
                    <th>Resource</th>
                    <th>Quantity</th>
                    <th>Status</th>
                    <th>Updated</th>
                    <th>Actions</th>

                </tr>

            </thead>

            <tbody>

                {inventory.map(i => (

                    <tr
                        key={i.id_inventario}
                    >

                        <td>
                            {i.proyecto}
                        </td>

                        <td>
                            {i.nombre_recurso}
                        </td>

                        <td>
                            {i.cantidad}
                        </td>

                        <td>
                            {i.estado}
                        </td>

                        <td>
                            {
                                i.fecha_actualizacion
                            }
                        </td>

                        <td>

                            <Button
                                text="Edit"
                                onClick={() =>
                                    handleEdit(i)
                                }
                                className="btn-edit"
                            />

                            <Button
                                text="Delete"
                                onClick={() =>
                                    handleDeleteClick(i)
                                }
                                className="btn-delete"
                            />

                        </td>

                    </tr>

                ))}

            </tbody>

        </table>

        {showConfirm && (

            <ConfirmModal

                text={`¿Seguro que deseas ${actionType === "create"
                        ? "crear"
                        : actionType === "update"
                            ? "actualizar"
                            : "eliminar"
                    } el recurso "${actionData?.nombre_recurso
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