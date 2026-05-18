export default function Message({ text, type }) {
    return (
        <div className={`message-box ${type}`}>
            {text}
        </div>
    );
}