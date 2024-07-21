import ReactDOM from 'react-dom/client';
import {
  createBrowserRouter,
  Navigate,
  RouterProvider,
} from "react-router-dom";
import Landing from './components/Landing.tsx';
import SettingsView from './components/SettingsView.tsx';
import VisionView from './components/VisionView.tsx';
import { AppProvider } from './contexts/AppContext.tsx';
import ErrorPage from './errorPage.tsx';
import './index.css';
import Root from './routes/Root.tsx';

const router = createBrowserRouter([
  {
    path: "/",
    element: <Root />,
    errorElement: <ErrorPage />,
    children: [
      { index: true, element: <Navigate to="/dashboard" replace /> },
      {
        path: "/dashboard",
        element: <Landing />,
      },
      {
        path: "/visions/:visionId",
        element: <VisionView />,
      },
      {
        path: "/settings/:visionId",
        element: <SettingsView />,
      }
    ]
  },
]);

ReactDOM.createRoot(document.getElementById('root')!).render(
  <AppProvider>
    <div className="h-dvh overflow-hidden">
      <RouterProvider router={router} />
    </div>
  </AppProvider>

)
