import axios from 'axios';
import { useEffect, useState } from 'react';
import { API_BASE } from '../config';

export default function ListUser() {
    
    const [users, setUsers] = useState([]);

    useEffect(() => {
        getUsers();
    }, []);

    function getUsers() {
        axios.get(`${API_BASE}/users.php`)
            .then(function(response){
                console.log(response.data); // 👈 CLAVE
                setUsers(response.data);
            });
    }

    return (
        <div>
            <h1>List User</h1>
            <table border="1">
                <thead>
                    <tr>
                        <th>ID</th>
                        <th>Name</th>
                        <th>Email</th>
                        <th>Mobile</th>
                    </tr>
                </thead>
                <tbody>
                    {users.map((user, key) => (
                        <tr key={key}>
                            <td>{user.id}</td>
                            <td>{user.name}</td>
                            <td>{user.email}</td>
                            <td>{user.movil}</td>
                        </tr>
                    ))}
                </tbody>
            </table>
        </div>
    );
}