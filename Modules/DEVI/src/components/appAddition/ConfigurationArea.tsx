import { customAlphabet } from 'nanoid';
import { useEffect, useState } from "react";
import { LuTableProperties } from "react-icons/lu";
import { MdOutlineDelete } from "react-icons/md";
import { IInterfaceTabOptions, IProperty, IUIAppDisplay } from "../../interfaces";

const nanoid = customAlphabet('ABCDEF1234567890', 6);

const ConfigurationArea = ({ selectedApp, handleAppPropertiesModified, propertiesMap }:
    {
        selectedApp: IUIAppDisplay | undefined,
        handleAppPropertiesModified: (appProperties: IProperty[]) => void,
        propertiesMap: { [id: string]: IProperty[] }
    }) => {

    const [selectedTab, setSelectedTab] = useState<IInterfaceTabOptions>(IInterfaceTabOptions.PROPERTIES);
    const [appProperties, setAppProperties] = useState<IProperty[]>([]);

    //console.log(selectedApp);

    const changeTab = (tab: IInterfaceTabOptions) => {
        setSelectedTab(tab);
    }

    useEffect(() => {
        if (selectedApp?.uiId) {
            setAppProperties(propertiesMap[selectedApp?.uiId])
        }
    }, [selectedApp?.uiId])


    const addProperty = () => {
        setAppProperties([...appProperties, { name: "", value: "", type: 'public', isNewlyAdded: true, propertyId: nanoid() }]);
    }

    const removeProperty = (propertyId: string | undefined) => {
        setAppProperties(appProperties.filter((property: IProperty) => property.propertyId !== propertyId));
    }

    const editProperty = (propertyId: string | undefined, fieldName: string, value: string) => {
        setAppProperties(appProperties.map(appProperty => {
            if (appProperty.propertyId === propertyId) {
                return { ...appProperty, [fieldName]: value }
            }
            return appProperty;
        }))
    }

    useEffect(() => {
        // console.log(appProperties);
        handleAppPropertiesModified(appProperties);
    }, [appProperties]);

    return (
        <div className="border-b border-gray-200 dark:border-gray-700">
            <ul className="flex flex-wrap -mb-px text-sm font-medium text-center text-gray-500 dark:text-gray-400">
                <li className="me-2">
                    <a href="#" className={`inline-flex items-center justify-center p-4 border-b-2 rounded-t-lg group ${selectedTab === IInterfaceTabOptions.PROPERTIES ? 'text-blue-600 border-blue-600 dark:text-blue-500 dark:border-blue-500 active' : 'border-transparent hover:text-gray-600 hover:border-gray-300 dark:hover:text-gray-300'}`}
                        onClick={e => changeTab(IInterfaceTabOptions.PROPERTIES)}>
                        <LuTableProperties className="mr-1 text-xl" /> Properties
                    </a>
                </li>
                {/* <li className="me-2">
                    <a href="#" className={`inline-flex items-center justify-center p-4 border-b-2 rounded-t-lg group ${selectedTab === IInterfaceTabOptions.REPLICATE ? 'text-blue-600 border-blue-600 dark:text-blue-500 dark:border-blue-500 active' : 'border-transparent hover:text-gray-600 hover:border-gray-300 dark:hover:text-gray-300'}`}
                        onClick={e => changeTab(IInterfaceTabOptions.REPLICATE)}>
                        <MdOutlineContentCopy className="mr-1 text-xl" /> Replicate
                    </a>
                </li> */}
            </ul>
            {selectedTab === IInterfaceTabOptions.PROPERTIES &&
                <div className="py-6 text-medium text-gray-500 dark:text-gray-400 dark:bg-gray-800 rounded-lg w-full">
                    {/* <h3 className="text-lg font-bold text-gray-900 dark:text-white mb-2">Properties</h3> */}
                    {
                        selectedApp?.uiId &&
                        <>
                            <p className="">Edit values for <b>{selectedApp.name}</b> - {selectedApp.uiId}</p>

                            <div className="grid grid-cols-12 gap-6 mb-2 mt-4 underline">
                                <div className="col-span-5">
                                    <p className="text-gray-800 text-left text-[84%]">
                                        NAME
                                    </p>
                                </div>
                                <div className="col-span-5">
                                    <p className="text-gray-800 text-left text-[84%]">
                                        VALUE
                                    </p>
                                </div>
                                <div className="col-span-2">

                                </div>

                            </div>
                            {appProperties.map(appProperty => {
                                return (
                                    <div className="grid grid-cols-12 gap-6 mb-2 items-start" key={appProperty.propertyId}>
                                        <div className="col-span-5 flex flex-col">
                                            <input type="text"
                                                className={`px-2 py-1 text-gray-500 relative text-sm border-b bg-transparent border-gray-300 focus:border-gray-400 outline-none focus:outline-none w-full}`}
                                                value={appProperty.name}
                                                onChange={(event) => editProperty(appProperty.propertyId, 'name', event.target.value)} />
                                        </div>
                                        <div className="col-span-5 flex flex-col">
                                            <textarea rows={1}
                                                className={`px-2 py-1 text-gray-500 relative text-sm border-b bg-transparent border-gray-300 focus:border-gray-400 outline-none focus:outline-none w-full}`}
                                                value={appProperty.value}
                                                onChange={(event) => editProperty(appProperty.propertyId, 'value', event.target.value)} />
                                        </div>
                                        <div className="col-span-2">
                                            <MdOutlineDelete className="w-5 h-5 cursor-pointer text-red-500 rounded-md inline-block" title="Remove"
                                                onClick={e => removeProperty(appProperty.propertyId)} />
                                        </div>

                                    </div>
                                )
                            })}
                            <div className="w-full flex justify-end">
                                <button type="button"
                                    className="text-white bg-green-700 hover:bg-green-800 focus:outline-none font-medium rounded-lg text-sm px-4 py-2 text-center dark:bg-green-600 dark:hover:bg-green-700 dark:focus:ring-green-800 mt-4"
                                    onClick={addProperty}
                                >Add Property</button>
                            </div>

                        </>
                    }

                    {
                        !selectedApp?.uiId &&
                        <>
                            <p className="mb-2">Select an Instance App to edit its properties. Then ( if required ) use the Replicate tab to copy it over to apps in other instances, across scopes. </p>
                        </>
                    }
                </div>
            }
            {/* {selectedTab === IInterfaceTabOptions.REPLICATE &&
                <div className="p-6 text-medium text-gray-500 dark:text-gray-400 dark:bg-gray-800 rounded-lg w-full">
                    <p className="mb-2">Select apps from the left & instances from the list below to copy over the apps ( with / without the properties )</p>
                </div>
            } */}
        </div>
    )
}

export default ConfigurationArea;