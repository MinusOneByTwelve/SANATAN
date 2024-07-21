import { useState } from "react";
import { FaExclamation } from "react-icons/fa";
import { IoBagCheckOutline } from "react-icons/io5";
import { MdOutlineContentCopy, MdOutlineDelete } from "react-icons/md";
import { IUIAppDisplay } from "../../interfaces";

const AppCard: React.FC<{
    app: IUIAppDisplay,
    appDeleted: (e: MouseEvent, app: IUIAppDisplay) => void,
    appEdited: (app: IUIAppDisplay) => void,
    handleAppCopy: (e: MouseEvent, appUiId: string) => void,
    handleAppSelection: (appUiId: string) => void,
    isSelected: boolean
}> = ({ app, appDeleted, appEdited, handleAppSelection, handleAppCopy, isSelected = false }) => {

    const [appInfo, setAppInfo] = useState(app);
    const [showDelete, setShowDelete] = useState(false);

    // useEffect(() => {
    //     console.log("reredndering", app.uiId);
    // }, [app]);

    function changeAppDetail(fieldName: string, value: string) {
        const updateAppInfo = { ...appInfo, [fieldName]: +value };
        setAppInfo(updateAppInfo);
        appEdited(updateAppInfo);
    }

    return (
        <div className={`flex flex-col gap-3 p-3 relative border 
            ${isSelected ? 'border-green-500 shadow-md shadow-green-300' : 'border-gray-300 shadow-md'} 
             h-auto rounded-sm col-span-1 cursor-pointer`}
            key={appInfo.id}
            onMouseEnter={e => setShowDelete(true)} onMouseLeave={e => setShowDelete(false)}
            onClick={e => { e.stopPropagation(); handleAppSelection(appInfo.uiId ?? "") }}
        >
            <div className="flex items-center gap-3">
                <div>
                    <img src={appInfo.iconUrl}
                        className="w-10 h-10 box-border inline border-dotted border border-purple-600 rounded-full p-0.5"
                        alt={appInfo.name} />
                </div>
                <div>
                    < div className="flex flex-col" >
                        <p>
                            <span className="font-medium text-blue-900">{appInfo.name}</span> {appInfo.version && <> - <span className="text-gray-600 text-sm">{appInfo.version}</span></>}
                        </p>
                        {
                            appInfo.suite &&
                            <span className="text-gray-600 text-sm -mt-1">{appInfo.suite} - {appInfo.suiteVersion}</span>
                        }
                    </div>
                </div>
            </div>
            <div className="grid grid-cols-2 gap-2">
                <div className="col-span-1 flex flex-col w-16">
                    <input type="number" step={1}
                        className={`px-2 py-1 text-gray-500 relative bg-white text-sm border-b border-gray-300 focus:border-gray-400 shadow-md outline-none focus:outline-none w-full}`}
                        value={appInfo.memory ?? appInfo.defaultMemory ?? 0}
                        onChange={(event) => changeAppDetail('memory', event.target.value)} />
                    <p className="text-gray-600 mt-1 text-left text-[64%] break-words">
                        GB RAM
                    </p>
                </div>
                <div className="col-span-1 flex flex-col w-16">
                    <input type="number" step={1}
                        className={`px-2 py-1 text-gray-500 relative bg-white text-sm border-b border-gray-300 focus:border-gray-400 shadow-md outline-none focus:outline-none w-full}`}
                        value={appInfo.cores ?? appInfo.defaultCores ?? 0}
                        onChange={(event) => changeAppDetail('cores', event.target.value)} />
                    <p className="text-gray-600 mt-1 text-left text-[64%] break-words">CORES</p>
                </div>
            </div>

            {showDelete && <div className="absolute right-1 bottom-1 text-right flex flex-col gap-y-3">
                <MdOutlineContentCopy className="w-5 h-5 cursor-pointer text-purple-500 inline-block" title="Copy"
                    onClick={e => handleAppCopy(e, appInfo.uiId)} />
                <MdOutlineDelete className="w-5 h-5 cursor-pointer text-red-500 inline-block" title="Remove"
                    onClick={e => appDeleted(e, appInfo)} />
            </div>}

            {/* {isSelected && <div className="absolute -right-2 -top-4 text-right bg-green-200 p-1 rounded-full">
                <FiCheckCircle className="w-5 h-5 text-green-600 inline-block" title="Selected" />
            </div>} */}

            {appInfo.isUnfulfilled && <div className="absolute -left-2 -top-2 bg-red-200 p-1 rounded-full">
                <FaExclamation className="w-3 h-3 text-red-800" title="Not Deployed" />
            </div>}

            {appInfo.isNewlyAdded && <div className="absolute -left-3 -top-3 bg-blue-200 p-1 rounded-full">
                <IoBagCheckOutline className="w-4 h-4 text-blue-800" />
            </div>}

            {/* <div className="grid grid-cols-3 gap-2 mt-2">
                <div className="col-span-2">
                    <p className="text-sm cursor-pointer"><MdOutlineEdit className="w-4 h-4 text-blue-600 rounded-md inline-block"
                        title="Edit Properties" /></p>
                </div>
                <div className="col-span-1 text-right">
                    <MdOutlineDelete className="w-6 h-6 cursor-pointer text-red-500 rounded-md inline-block" title="Remove" />
                </div>
            </div> */}
        </div>
    )
}


export default AppCard;