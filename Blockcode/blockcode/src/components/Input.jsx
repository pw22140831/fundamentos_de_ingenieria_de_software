export default function Input({ label, type, name, onChange, value, className }) {
    return (
        <div className="form-group">
            {label && <label htmlFor={name}>{label}</label>}
            <input
                id={name}
                type={type}
                name={name}
                placeholder={label}
                value={value}
                onChange={onChange}
                className={className}
            />
        </div>
    );
}