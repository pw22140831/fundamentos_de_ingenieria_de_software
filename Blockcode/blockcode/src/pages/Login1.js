import { useState } from "react";
import { useNavigate } from "react-router-dom";

import Input from "../components/Input";
import Button from "../components/Button";
import Header from "../components/Header";
import Footer from "../components/Footer";

import "./Login.css";

export default function Login() {
    const navigate = useNavigate();

    const [inputs, setInputs] = useState({
        user: "",
        password: ""
    });

    const handleChange = (event) => {
        const name = event.target.name;
        const value = event.target.value;
        setInputs(values => ({ ...values, [name]: value }));
    };

    const handleSubmit = (event) => {
    event.preventDefault();

    if (inputs.user === "admin" && inputs.password === "123") {

        localStorage.setItem("user", JSON.stringify({
            id: 1,
            username: "admin",
            rol: 1
        }));

        navigate("/dashboard/users");

    } else if (inputs.user === "operador" && inputs.password === "123") {

        localStorage.setItem("user", JSON.stringify({
            id: 2,
            username: "operador",
            rol: 2
        }));

        navigate("/dashboard/users");

    } else if (inputs.user === "usuario" && inputs.password === "123") {

        localStorage.setItem("user", JSON.stringify({
            id: 3,
            username: "usuario",
            rol: 3
        }));

        navigate("/dashboard/projects");

    } else {
        alert("Credenciales incorrectas");
    }
};
    /*const handleSubmit = async (event) => {
        event.preventDefault();

        try {
            const response = await axios.post(
                `${API_BASE}/users/login.php`,
                inputs
            );

            if (response.data.success) {

                //  GUARDAS EL USUARIO AQUÍ
                localStorage.setItem("user", JSON.stringify(response.data.user));

                //  LUEGO NAVEGAS
                navigate("/dashboard/users");

            } else {
                alert("Credenciales incorrectas");
            }

        } catch (error) {
            console.error(error);
        }
    };*/
    return (
        <>
            <Header />

            <div>
                <main className="App-main">

                    <h2>Login</h2>
                    <form className="login-form" onSubmit={handleSubmit}>

                        <Input
                            label="User"
                            type="text"
                            name="user"
                            onChange={handleChange}
                        />

                        <Input
                            label="Password"
                            type="password"
                            name="password"
                            onChange={handleChange}
                        />

                        <Button text="Login" />

                    </form>
                </main>
            </div >

            <Footer />
        </>
    );
}