import { Link } from "react-router-dom";

const Header = () => {
  return (
    <div className="min-h-12 backdrop-blur lg:border-b lg:border-slate-900/10 border-slate-50/[0.06] supports-backdrop-blur:bg-white/95 bg-slate-900/90 flex items-center text-sm font-inter text-slate-200">
      <div className="mx-4 flex items-center justify-between w-full">
        <Link to="/dashboard">
          <h1 className="tracking-widest text-gray-100 font-medium">D.E.V.I.</h1>
        </Link>
        <a>Login</a>
      </div>
    </div>
  );
};

export default Header;
