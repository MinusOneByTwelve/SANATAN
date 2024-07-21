import { Outlet } from "react-router-dom";
import Footer from "../components/Footer";
import Header from "../components/Header";

export default function Root() {
  return (
    <div className="h-dvh flex flex-col overflow-hidden">
      <Header />
      <Outlet />
      <Footer />
    </div>
  );
}