import { useRouteError } from "react-router-dom";

export default function ErrorPage() {
    const error = useRouteError();
    console.error(error);
  
    return (
      <div className="w-full h-full flex items-center justify-center flex-col font-inter">
        <h1 className="text-4xl font-semibold">Oops!</h1>
        <p className="text-xl text-gray-600 mt-2">Sorry, an unexpected error has occurred.</p>
        <p className="text-red-600 mt-4">
          <i>{error.statusText || error.message}</i>
        </p>
      </div>
    );
}