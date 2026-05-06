export default function Input({ label, type, name, onChange, value, className }) {
    return (
        <input
            type={type}
            name={name}
            placeholder={label}
            value={value}
            onChange={onChange}
            className={className}
        />
    );
}