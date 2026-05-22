import { create } from "zustand";
import api from "@/api/client";

interface AuthState {
    storeId: string |null;
    role: "admin" | "customer" | null;
    isAuthenticated: boolean;
    isLoading: boolean;
    initialize: () => Promise<void>;
    login: (email: string, password: string) =>Promise<void>;
    logout: () => Promise<void>;
}

export const useAuthStore = create<AuthState>((set) =>({
    storeId: null,
    role: null,
    isAuthenticated: false,
    isLoading: true,
    initialize: async() =>{
        try{
            const {data} = await api.get('/api/v1/auth/me');
            set({storeId: data.store_id, role: data.role, isAuthenticated:true});
        }catch{
            set({storeId: null, role: null, isAuthenticated:false});
        }finally{
            set({isLoading: false})
        }
    },
    login: async  (email, password) =>{
        await api.post('/api/v1/auth/login',  {email, password});
        await useAuthStore.getState().initialize();
    },
    logout: async () =>{
        await api.post("/api/v1/auth/logout");
        set({storeId: null, role: null, isAuthenticated: false});
    },
}));