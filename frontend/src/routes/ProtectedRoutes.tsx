import { Navigate, Outlet } from "react-router-dom";
import { useAuthStore } from "@/stores/authStore";
import {Skeleton} from "@/components/ui/skeleton"

interface Props {requiredRole?: "admin"| "customer"}

export const ProtectedRoute = ({requiredRole}: Props) =>{
    const {isAuthenticated, role, isLoading} = useAuthStore();
    if (isLoading) return <Skeleton className="h-screen w-full" />;
    if(!isAuthenticated) return <Navigate to="/login" replace />;
    if(requiredRole && role !== requiredRole) return <Navigate to="/login" replace />;


    return <Outlet />;
};