const Footer = () => {
    return (
        <div className="bottom-0 left-0 right-0 min-h-6 backdrop-blur lg:border-b lg:border-slate-900/10 border-slate-50/[0.06] supports-backdrop-blur:bg-white/95 bg-slate-900/90 flex items-center z-10 text-slate-200">
            <div className="mx-4 flex items-center justify-between w-full font-inter">
                <span className="tracking-widest text-xs">v1 - {new Date().getFullYear()} </span>
                <span className="tracking-widest">&copy; </span>
                <a className="cursor-pointer text-xs">More Info</a>
            </div>
        </div>
    );
};

export default Footer;