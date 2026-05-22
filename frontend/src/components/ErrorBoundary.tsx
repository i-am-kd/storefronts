import { Component, ErrorInfo, type ReactNode } from "react";
import {toast } from "sonner"

interface Props {children: ReactNode}
interface State {hasError: boolean}

export class ErrorBoundary extends Component<Props, State>{
    state = {hasError: false};

    static getDerivedStateFromError(){
        return {hasError: true};
    }

    componentDidCatch (error: Error, errorInfo: ErrorInfo){
        toast.error("Application error", {description:error.message || "an unexpected error occured"});
        console.error("[UI Error]", error, errorInfo);
    }

    render() {
        if(this.state.hasError){
            return(
                <div className="flex h-screen items-center justify-center bg-gray-50">
                    <div className="text-center">
                        <h2 className="text-xl font-semibold text-red-600"> Something went wrong</h2>
                        <button onClick={() => globalThis.location.reload()} className="mt-4 rounded bh-gray-900 px-4 py-2 text-white " >
                            Reload Application
                        </button>
                    </div>
                </div>
            );
        }
        return this.props.children;
    }
}