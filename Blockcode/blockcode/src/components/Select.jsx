export default function Select({ label, name, onChange, value, className, children }) {
    return (
        <div className="form-group">
            {label && <label htmlFor={name}>{label}</label>}
            <select
                id={name}
                name={name}
                value={value}
                onChange={onChange}
                className={className}
            >
                {children}
            </select>
        </div>
    );
}