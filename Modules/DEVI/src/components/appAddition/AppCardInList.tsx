import { useState } from "react";
import { MdOutlineAdd } from "react-icons/md";
import { IAppOption } from "../../interfaces";

const AppCardInList = ({ app, addAppToInstance }: { app: IAppOption, addAppToInstance: (app: IAppOption) => void }) => {

    const [showAdd, setShowAdd] = useState(false);

    return (
        <li className="flex items-center gap-4 p-4 py-3 relative"
            onMouseEnter={e => setShowAdd(true)} onMouseLeave={e => setShowAdd(false)}
        >
            <img src={app.iconUrl}
                className="w-10 h-10 box-border inline border-dotted border border-purple-600 rounded-full p-0.5"
                alt={app.name} />
            <div className="flex flex-col">
                <p>
                    <span className="font-medium text-blue-900">{app.name}</span> {app.version && <> - <span className="text-gray-600 text-sm">{app.version}</span></>}
                </p>
                {app.suite &&
                    <span className="text-gray-600 text-sm -mt-1">{app.suite} - {app.suiteVersion}</span>
                }
            </div>
            {showAdd && <MdOutlineAdd className="text-blue-700 font-semibold text-2xl border border-blue-600 border-dotted 
                absolute right-2 top-5 cursor-pointer hover:text-white hover:bg-blue-700" onClick={e => addAppToInstance(app)} />}
        </li>
    )
}

export default AppCardInList;