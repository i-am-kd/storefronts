import { useEffect } from "react";
import { useBusinessStore } from "@/stores/businessStore";
import { Skeleton } from "@/components/ui/skeleton";
import { toast } from "sonner";

export default function AdminDashboard() {
    const {products, isLoading, fetchInventory} = useBusinessStore();

    useEffect(() =>{
        fetchInventory().catch(() => toast.error("failed to load inventory"));
    }, [fetchInventory]);

    if(isLoading) {
        return (
            <div className="p-6 grid grid-cols-1 md:grid-cols-3 gap-4">
                {[...Array(6)].map((_, i) => <Skeleton key={i} className="h-32 rounded"/>)}
            </div>
        );
    }

    return(
        <div className="p-6 space-y-6">
            <div className="flex items-center justify-between">
                <h1 className="text-2xl font-bold">Inventory Dashboard</h1>
                <span className="text-sm text-gray-500">{products.length} active products</span>
            </div>
            <div className="grid grid-cols-1 md:grid-cols-3 gap-4">
                {products.map((p) =>(
                    <div key={p.product_id} className="rounded border bg-white p-4 shadow-sm">
                        <h3 className="font-semibold">{p.name}</h3>
                        <p className="text-sm text-gray-500">SKU: {p.sku}</p>
                        <p className="mt-2 font-medium">${p.price.toFixed(2)}</p>
                        <p className={`text-sm ${p.stock_count <5? "text-red-500":"text-green-600"}`}>
                            Sotck: {p.stock_count}
                        </p>
                    </div>
                ))}
            </div>
        </div>
    );
}