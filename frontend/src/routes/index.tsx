import { createBrowserRouter } from "react-router-dom";
import { ProtectedRoute } from "./ProtectedRoutes";
import LoginPage from "@/pages/auth/LoginPage";
import AdminDashboard from "@/pages/admin/Dashboard";
import ExplorePage from "@/pages/explore/Index";
import NotFound from "@/pages/NotFound";

export const router = createBrowserRouter([
    {path: "/login", element:<LoginPage /> },
    {
        path: "/admin",
        element:<ProtectedRoute requiredRole="admin" />,
        children:[{index: true, element:<AdminDashboard />}]
    },
    {
        path:'/explore',
        element:<ProtectedRoute requiredRole="customer" />,
        children: [{index: true, element: <ExplorePage />}],
    },
    {path:"*", element: <NotFound/>},
]);