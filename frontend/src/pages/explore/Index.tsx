import { useEffect } from "react";
import { useCustomerStore } from "@/stores/customerStore";
import { Button } from "@/components/ui/button";
import { Skeleton } from "@/components/ui/skeleton";

export default function ExplorePage(){
    const {location, isLocating, requestLocation} = useCustomerStore();

    useEffect (() =>{requestLocation();}, []);

    return(
        <div className="p-6 space-y-6">
            <h1 className="text-2xl font-bold">Explore Nearby Stores</h1>
            {isLocating ? (
                <Skeleton className="h-10 w-48" />
            ): location? (
                <div className="rounded border bg-white p-4">
                    <p className="text-sm text-gray-600" >Location acquired</p>
                    <code className="mt-1 block text-sx">Lat:{location.lat.toFixed(4)}, Lng: {location.lng.toFixed(4)}</code>
                    <Button className="mt-3">Refresh Nearby Stores</Button>
                </div>
            ):(
                <p className="text-red-500">Location access denied. Please enable browser permissions.</p>
            )}
        </div>
    )


}