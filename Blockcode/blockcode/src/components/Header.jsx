import "./Header.css";
import logo from "../assets/images/logo.jpeg";
export default function Header() {
    return (
        <header className="App-header">
            <div className="header-brand">
                <div className="logo-space">
                    <img src={logo} alt="Blockcode logo" />
                </div>
                <div className="brand-text">
                    <h1>Blockcode</h1>
                    <p>Digital solutions</p>
                </div>
            </div>
        </header>
    );
}