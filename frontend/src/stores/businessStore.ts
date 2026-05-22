import { create } from "zustand";
import api from "@/api/client";
import { Product } from "@/types/api";

export interface Products {
    product_id: string;
    store_id: string;
    sku: string;
    name: string;
    price: number;
    stock_count: number;
    status: 'active' | 'discontinuted' | "out_of_stock";
}
interface BusinessState {
    products: Product[];
    isLoading: boolean;
    fetchInventory: () =>Promise<void>
}

export const useBusinessStore = create<BusinessState>((set) =>({
    products: [],
    isLoading:false,
    fetchInventory: async () =>{
        set({isLoading: true});
        try{
            const {data} = await api.get('/api/v1/admin/inventory');
            set({products: data.products || []});
        }catch(error){
            console.error("failed to fetch inventory:", error)
        }finally{
            set({isLoading: false});
        }
    },
}));