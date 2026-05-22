import {useForm} from "react-hook-form";
import {zodResolver} from "@hookform/resolvers/zod";
import * as z from "zod";
import { useAuthStore } from "@/stores/authStore";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { Label } from "@/components/ui/label";

const loginSchema = z.object({
    email: z.email("Invalid email address"),
    password: z.string().min(8, "Password must be at least 8 characters."),
});

type LoginForm = z.infer<typeof loginSchema>

export default function LoginPage() {
    const {login} = useAuthStore();
    const {register, handleSubmit, formState: {errors, isSubmitting}} = useForm<LoginForm>({
        resolver:zodResolver(loginSchema),
    });

    const onSubmit = async (data: LoginForm) =>{
        try {
            await login(data.email, data.password);
        }catch(error){
            console.error("Login failed:", error);
        }
    }; 

    return (
        <div className="flex min-h-screen items-center justify-center bg-gray-50 px-4">
            <form onSubmit={handleSubmit(onSubmit)} className="w-full max-w-md space-y-6 rounded-lg bg-white p-8 shadow-sm">
                <div className="text-center">
                    <h1 className="text-2xl font-bold tracking-tight">Storefronts</h1>
                    <p className="text-sm text-gray-500 mt-1"> Sign in to your dashboard</p>
                </div>
                <div className=" space-y-2">
                    <Label htmlFor="email">Email</Label>
                    <Input id="email" type="email" {...register("email")} disabled={isSubmitting} />
                    {errors.email && <p className="text-sm text-red-500">{errors.email.message}</p> }
                </div>
                <div className=" space-y-2">
                    <label htmlFor="password">Password</label>
                    <Input type="password" id="password" {...register("password")} disabled={isSubmitting} />
                    {errors.password && <p className="text-sm text-red-500">{errors.password.message}</p> }
                </div>

                <Button type="submit" className="w-full" disabled={isSubmitting}>
                    {isSubmitting?"Signing In":"Sign In"}
                </Button>
            </form>

        </div>
    )
}