import useAppContext from "../contexts/AppContext";
import CancelButton from "./baseComponents/CancelButton";
import PrimaryButton from "./baseComponents/PrimaryButton";
import AppsOptionTable from "./tables/AppsOptionTable";

const SettingsView = () => {
    // const { visionId } = useParams();
    const { appsList } = useAppContext();

    function saveChanges() {

    }

    function goBack() {

    }

    return (
        <div className="p-4 flex-grow overflow-y-scroll scrollbar-hide">
            <div className="border-b border-gray-300 p-2 flex items-center justify-between">
                <h2 className="text-xl text-blue-900">Vision & Global Settings</h2>
                <div className="actionBtns">
                    <CancelButton callToAction={goBack} label="Cancel" className="mr-4" />
                    <PrimaryButton callToAction={saveChanges} label="Save" className="" />
                </div>
            </div>
            <div className="settingsSection px-4 py-2">
                <AppsOptionTable appsList={appsList} />
            </div>
        </div>
    )
}

export default SettingsView;