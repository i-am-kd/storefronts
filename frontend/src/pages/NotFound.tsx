import { Link } from "react-router-dom";

export default function NotFound() {
  return (
    <div className="flex h-screen items-center justify-center">
      <div className="text-center">
        <h1 className="text-4xl font-bold">404</h1>
        <p className="mt-2">Page not found</p>
        <Link
          to="/login"
          className="mt-4 inline-block text-blue-600 hover:underline"
        >
          Go to Login
        </Link>
      </div>
    </div>
  );
}
