import WorkspaceArea from "./WorkspaceArea";

const VisionView = () => {
    return (
        <div className="flex-grow overflow-y-auto">
            {/* <Navbar isNavbarOpen={isNavbarOpen} toggleNavbar={toggleNavbar} /> */}
            {/* <WorkspaceArea isNavbarOpen={isNavbarOpen} /> */}
            <WorkspaceArea />
            {/* <Properties /> */}
        </div>
    )
}

export default VisionView;