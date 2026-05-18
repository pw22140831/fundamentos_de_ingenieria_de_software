import { useState } from "react";
import { useNavigate } from "react-router-dom";

import Input from "../components/Input";
import Button from "../components/Button";
import Header from "../components/Header";
import Footer from "../components/Footer";
import Message from "../components/Message";

import "./Login.css";

export default function Login() {

    const navigate = useNavigate();

    const [inputs, setInputs] = useState({
        user: "",
        password: ""
    });

    const [message, setMessage] = useState("");
    const [messageType, setMessageType] = useState("");

    // =====================
    // INPUT
    // =====================
    const handleChange = (e) => {
        setInputs({
            ...inputs,
            [e.target.name]: e.target.value
        });
    };

    // =====================
    // MENSAJE
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
    // LOGIN
    // =====================
    const handleSubmit = (e) => {
        e.preventDefault();

        if (inputs.user === "admin" && inputs.password === "123") {

            localStorage.setItem("user", JSON.stringify({
                id: 1,
                username: "admin",
                rol: 1
            }));

            navigate("/dashboard/projects");

        } else if (inputs.user === "operador" && inputs.password === "123") {

            localStorage.setItem("user", JSON.stringify({
                id: 2,
                username: "operador",
                rol: 2
            }));

            navigate("/dashboard/projects");

        } else if (inputs.user === "usuario" && inputs.password === "123") {

            localStorage.setItem("user", JSON.stringify({
                id: 3,
                username: "usuario",
                rol: 3
            }));

            navigate("/dashboard/projects");

        } else {
            showMessage("Credenciales incorrectas", "error");
        }
    };

    return (
        <>
            <Header />

            <main className="App-main">

                <h2>Login</h2>

                {/* MENSAJE */}
                {message && <Message text={message} type={messageType} />}

                <form className="login-form" onSubmit={handleSubmit}>

                    <Input
                        label="User"
                        type="text"
                        name="user"
                        value={inputs.user}
                        onChange={handleChange}
                    />

                    <Input
                        label="Password"
                        type="password"
                        name="password"
                        value={inputs.password}
                        onChange={handleChange}
                    />

                    <Button
                        text="Login"
                        type="submit"
                        className="btn-login"
                    />

                </form>

            </main>

            <Footer />
        </>
    );
}