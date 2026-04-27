import Header from "../components/Header";
import Footer from "../components/Footer";
import Navbar from "../components/Navbar";
import { Outlet } from "react-router-dom";

export default function Layout() {
  return (
    <>
      <Header />
      <Navbar />

      <main style={{ padding: "20px" }}>
        <Outlet /> {/* aquí cambian las páginas */}
      </main>

      <Footer />
    </>
  );
}