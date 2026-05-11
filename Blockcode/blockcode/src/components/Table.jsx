import "./Table.css";

export default function Table({ data, columns, actions }) {
    const getActionsForRow = (item) => {
        if (typeof actions === 'function') {
            return actions(item);
        }
        return actions || [];
    };

    return (
        <div className="table-container">
            <table className="data-table">
                <thead>
                    <tr>
                        {columns.map((col, index) => (
                            <th key={index}>{col.label}</th>
                        ))}
                        {(actions && (typeof actions === 'function' || actions.length > 0)) && <th>Actions</th>}
                    </tr>
                </thead>
                <tbody>
                    {data.map((item, rowIndex) => {
                        const rowActions = getActionsForRow(item);
                        return (
                            <tr key={rowIndex}>
                                {columns.map((col, colIndex) => (
                                    <td key={colIndex}>
                                        {col.render ? col.render(item) : item[col.key]}
                                    </td>
                                ))}
                                {rowActions && rowActions.length > 0 && (
                                    <td className="actions-cell">
                                        {rowActions.map((action, actionIndex) => (
                                            <button
                                                key={actionIndex}
                                                className={action.className}
                                                onClick={() => action.onClick(item)}
                                            >
                                                {action.label}
                                            </button>
                                        ))}
                                    </td>
                                )}
                            </tr>
                        );
                    })}
                </tbody>
            </table>
        </div>
    );
}