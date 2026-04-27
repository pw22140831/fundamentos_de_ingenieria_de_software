export default function Input({ label, type, name, onChange }) {
  return (
    <div className="form-group">
      <label>{label}</label>
      <input 
        type={type}
        name={name}
        onChange={onChange}
      />
    </div>
  );
}