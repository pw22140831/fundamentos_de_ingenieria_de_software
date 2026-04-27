import { BrowserRouter, Routes, Route } from "react-router-dom";
import Login from "../pages/Login";
import ListUser from "../pages/ListUser";
import Layout from "../pages/Layout";
import Projects from "../pages/Projects";

export default function AppRoutes() {
    return (
        <BrowserRouter>
            <Routes>

                {/* Login */}
                <Route path="/" element={<Login />} />

                {/* App con layout */}
                <Route path="/dashboard" element={<Layout />}>
                    <Route path="users" element={<ListUser />} />
                    <Route path="projects" element={<Projects />} />
                </Route>

            </Routes>
        </BrowserRouter>
    );
}