export default function ConfirmModal({ text, onConfirm, onCancel }) {
    return (
        <div className="modal-overlay">
            <div className="modal-box">
                <p>{text}</p>

                <div className="modal-actions">
                    <button className="btn-confirm" onClick={onConfirm}>
                        Sí
                    </button>
                    <button className="btn-cancel" onClick={onCancel}>
                        Cancelar
                    </button>
                </div>
            </div>
        </div>
    );
}