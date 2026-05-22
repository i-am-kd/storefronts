import axios from "axios";
import {toast} from 'sonner';
// import { useAuthStore } from "../stores/authStore";


const api = axios.create({
    baseURL: import.meta.env.VITE_API_BASE_URL,
    timeout: 10_000,
    withCredentials: true, // enables httponly cookie transmission
    headers: {"Content-Type":"application/json"}
});

// request interceptor : add tracing id
api.interceptors.request.use((config) =>{
    config.headers['X-request-ID'] = crypto.randomUUID();
    return config;
});

//response interceptor: standarize error and handle 401
api.interceptors.response.use(
    (res) => res,
    (err) => {
        const status = err.response?.status;
        const message = err.response?.data?.error || err.message|| "Request failed";

        if (status ===401 || status ===403){
            globalThis.location.href = "/login";
        }else if (status === 500){
            toast.error("Server error", {description: "pealse try again later."});
        }else if(status!==401){
            toast.error("Request failed", {description: message});
        }
        return Promise.reject(err);
    }
);

export default api;