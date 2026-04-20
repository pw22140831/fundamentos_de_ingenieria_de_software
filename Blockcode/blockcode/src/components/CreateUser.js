import { useState } from "react";
import axios from "axios";
import { useNavigate } from "react-router-dom";
import { API_BASE } from '../config';

export default function ListUsers() {
    const navigate = useNavigate();
 
    const [inputs, setInputs] = useState({})

    const HandleChange = (event) => {
        const name = event.target.name;
        const value = event.target.value;
        setInputs(values => ({...values, [name]: value}));
    }

    const handleSubmit = (event) => {
        event.preventDefault();

        axios.post(`${API_BASE}/users/save.php`, inputs).then(function(response){
            console.log(response.data);
            navigate('/');
        });

    }
    return (
        <div>
        <h1>List Users</h1>
        <form onSubmit={handleSubmit}>
            <table cellPadding="10">
                <tbody>
                    <tr>
                        <th> 
                            <label>Name:</label>
                        </th>
                        <td>
                            <input type="text" name="name" onChange={HandleChange} />
                        </td>
                    </tr>
                    <tr>
                        <th>
                            <label>Email:</label>
                        </th>
                        <td>
                            <input type="text" name="email" onChange={HandleChange}/>
                        </td>
                    </tr>
                    <tr>
                        <th>
                            <label>Mobile:</label>
                        </th>
                        <td>
                            <input type="text" name="mobile" onChange={HandleChange} />
                        </td>
                    </tr>
                    <tr>
                        <td colSpan="2" align ="right">
                            <button>Save</button>
                        </td>
                    </tr>
                </tbody>
            </table>
        </form>
        </div>
    );
} 
