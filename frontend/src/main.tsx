import React from "react";
import ReactDOM from "react-dom/client";
import { RouterProvider } from "react-router-dom";
import { router } from "@/routes/index";
import { ErrorBoundary } from "./components/ErrorBoundary";
import { Toaster } from "sonner";
import { useAuthStore } from "./stores/authStore";
import "./index.css";

// initialize auth state before rendering routes
useAuthStore.getState().initialize().then(() =>{
  console.log("About to render React app");
  ReactDOM.createRoot(document.getElementById("root")!).render(
    <React.StrictMode>
      <ErrorBoundary>
        <RouterProvider router={router} />
        <Toaster position="top-right" richColors />
      </ErrorBoundary>
    </React.StrictMode>
  );
});
