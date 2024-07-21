import { TbLayoutSidebarLeftCollapse, TbLayoutSidebarRightCollapse } from "react-icons/tb";

const texts = ["S", "T", "A", "C", "K"];

const Navbar = ({ isNavbarOpen, toggleNavbar }: {isNavbarOpen: boolean, toggleNavbar: () => void}) => {
  return (
    <div className={`relative ${isNavbarOpen ? 'w-72' : 'w-0'} bg-gray-300 scrollbar-hide
        transition-width duration-300`}>
        <div 
            className={`text-purple-200 text-2xl flex flex-col items-center bg-purple-900 p-2 rounded-r-md
                absolute top-0 right-0 mt-3 -mr-10 z-10 py-3 cursor-pointer
            `}
            onClick={toggleNavbar}
        >
            {isNavbarOpen ? <TbLayoutSidebarLeftCollapse /> : <TbLayoutSidebarRightCollapse className="mb-2"/>}
            {!isNavbarOpen && texts.map(text => {
                return (
                    <span className="font-inter font-medium text-xs" key={text}>{text}</span>
                )
            })}
        </div>
        
    </div>
  );
};

export default Navbar;