import axios from "axios";
import { API_BASE } from "../config/config";

export const login = (data) => {
  return axios.post(`${API_BASE}/users/login.php`, data);
};

export const getUsers = () => {
  return axios.get(`${API_BASE}/users`);
};