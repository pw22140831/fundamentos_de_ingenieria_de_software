import "./Header.css";
import logo from "../assets/images/logo.jpeg";
export default function Header() {
    return (
        <header className="App-header">
            <h1>Blockcode</h1>
            <div className="logo-space">
                <img src={logo} alt="Logo" />
            </div>
        </header>
    );
}