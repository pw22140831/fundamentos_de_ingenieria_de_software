import { BrowserRouter, Routes, Route } from "react-router-dom";
import Login1 from "../pages/Login1";
import Users from "../pages/Users";
import Layout from "../pages/Layout";
import Projects from "../pages/Projects";
import Inventory from "../pages/Inventory";
import Transacciones from "../pages/Transaccion";

export default function AppRoutes() {
    return (
        <BrowserRouter>
            <Routes>

                {/* Login */}
                <Route path="/" element={<Login1 />} />

                {/* App con layout */}
                <Route path="/dashboard" element={<Layout />}>
                    <Route path="users" element={<Users />} />
                    <Route path="projects" element={<Projects />} />
                    <Route path="inventory" element={<Inventory />}/>
                    <Route path="transactions/:id" element={<Transacciones />} />
                </Route>

            </Routes>
        </BrowserRouter>
    );
}