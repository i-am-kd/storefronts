import { create } from "zustand";

export interface nearbyStore{
    store_id: string;
    name: string;
    distance_m: number;
}
interface CustomerState{
    location: {lat: number, lng: number}    | null;
    nearbyStores: nearbyStore[];
    isLocating: boolean;
    requestLocation: () => Promise<void>;
    setNearbyStores: (stores: nearbyStore[]) => void;
}

export const useCustomerStore = create< CustomerState>((set) =>({
    location: null,
    nearbyStores: [],
    isLocating: false,
    requestLocation: async () =>{
        if(!navigator.geolocation) return;
        set({isLocating: true});
        navigator.geolocation.getCurrentPosition(
            (pos) => set({location: {lat: pos.coords.latitude, lng: pos.coords.longitude}, isLocating: false}),
            () => set({isLocating: false})
        );
    },
    setNearbyStores: (stores) =>set({nearbyStores: stores}),
}))