import { customAlphabet } from 'nanoid';
import { forwardRef, useEffect, useImperativeHandle, useState } from "react";
import { FaExclamation } from "react-icons/fa";
import { FaHeartCircleExclamation } from "react-icons/fa6";
import { MdOutlineAdd } from "react-icons/md";
import useAppContext from "../../contexts/AppContext";
import { IAppOption, IInstance, IProperty, IUIAppDisplay, NA } from "../../interfaces";
import AppCard from "./AppCard";
import ConfigurationArea from './ConfigurationArea';

const warningBackground = 'bg-red-200';
const nanoid = customAlphabet('ABCDEF1234567890', 6);

const InstanceCard = forwardRef((props: { instance: IInstance, newApp: IAppOption | undefined }, ref) => {

    const { instance, newApp } = props;
    // console.log(instance);

    const { id, cores: instanceCores = 0, memory: instanceMemory = 0, reservedCores, reservedMemory, apps: currentApps } = instance;

    const [hasIp, setHasIp] = useState<boolean>(instance.ip !== NA);
    const { providerList, appsList } = useAppContext();

    const [selectedAppId, setSelectedAppId] = useState<string>("");
    const [selectedApp, setSelectedApp] = useState<IUIAppDisplay>();

    const [deletedAppIds, setDeletedAppIds] = useState<number[]>([]);

    const [propertiesMap, setPropertiesMap] = useState<{ [id: string]: IProperty[] }>({});

    const parsedConfigurationDetails =
        typeof instance.configurationDetails === 'string' ? JSON.parse(instance.configurationDetails) : (instance.configurationDetails ?? {});

    useEffect(() => {
        setHasIp(instance.ip !== NA);
    }, [instance]);

    const [memoryAllocated, setMemoryAllocated] = useState(0);
    const [coresAllocated, setCoresAllocated] = useState(0);

    const [instanceApps, setInstanceApps] = useState<IUIAppDisplay[]>([]);

    useImperativeHandle(ref, () => ({
        sendDetails() {
            // console.log(propertiesMap);
            return {
                instanceApps: instanceApps.map(instanceApp => {
                    return {
                        ...instanceApp,
                        properties: propertiesMap[instanceApp.uiId!] ?? instanceApp.properties
                    }
                }),
                deletedAppIds
            }
        }
    }), [instanceApps, propertiesMap, memoryAllocated, coresAllocated, deletedAppIds]);

    function updateInstanceApps(updatedInstanceApps: IUIAppDisplay[]) {
        // console.log("updatedInstanceApps :", updatedInstanceApps);
        setInstanceApps([...updatedInstanceApps]);
    }

    // Initial useEffect for modifying currentApps
    useEffect(() => {
        // console.log("Calling InstanceCard for the first time");
        const transformedCurrentApps = (currentApps ?? []).map(currentApp => {
            const additionalDetails = appsList.find(appListItem => appListItem.identifierId === currentApp.appId);
            const currentAppId = currentApp.id;

            const propertiesToUse = currentApp.properties ?? additionalDetails?.properties ?? [];
            return {
                ...currentApp,
                ...additionalDetails,
                uiId: nanoid(),
                currentAppId,
                properties: propertiesToUse
            }
        });

        // console.log(transformedCurrentApps);
        updateInstanceApps([...transformedCurrentApps]);
        reset();
    }, [currentApps]);

    function reset() {
        setDeletedAppIds([]);
        setSelectedAppId("");
        setSelectedApp(undefined);
        setPropertiesMap({});
    }

    useEffect(() => {
        if (newApp) {
            updateInstanceApps([{ ...newApp, currentAppId: -1 }, ...instanceApps]);
        }
    }, [newApp?.uiId]);


    // useEffect(() => {
    //     console.log(instanceApps);
    // }, [instanceApps]);


    useEffect(() => {
        updateConsumption()
    }, [instanceApps]);


    useEffect(() => {
        // console.log("Selected App modified", selectedApp);
        if (selectedAppId) {
            const newInstanceList = instanceApps.map(instanceApp => {
                if (selectedApp && instanceApp.uiId === selectedApp?.uiId) {
                    return { ...instanceApp, properties: selectedApp.properties }
                }
                return instanceApp;
            });
            updateInstanceApps(newInstanceList);
        }
    }, [selectedAppId]);


    function appDeleted(e, app: IUIAppDisplay) {
        e.stopPropagation();
        if (app.currentAppId && app.currentAppId !== -1) {
            setDeletedAppIds([...deletedAppIds, app.currentAppId]);
        }

        if (app.isNewlyAdded || app.isUnfulfilled) {
            updateInstanceApps(instanceApps.filter(instanceApp => instanceApp.uiId !== app.uiId));
            if (app.uiId === selectedAppId) {
                clearSelectedApp();
            }
        }
    }

    function appEdited(app: IUIAppDisplay) {
        updateInstanceApps(instanceApps.map(instanceApp => {
            if (instanceApp.uiId === app.uiId) {
                return app;
            }

            return instanceApp;
        }))
    }

    function updateConsumption() {
        // console.log("updateConsumption : ", instanceApps?.length);
        let memoryAllocated = 0;
        let coresAllocated = 0;

        instanceApps?.forEach(app => {
            memoryAllocated += app.memory ?? app.defaultMemory ?? 0;
            coresAllocated += app.cores ?? app.defaultCores ?? 0;
        });

        setMemoryAllocated(memoryAllocated + (reservedMemory ?? 0));
        setCoresAllocated(coresAllocated + (reservedCores ?? 0));
    }

    function handleAppSelection(appUiId: string) {
        setSelectedAppId(appUiId);
    }

    function handleAppCopy(e: MouseEvent, appUiId: string) {
        e.stopPropagation();
        const appToCopy = instanceApps.find(instanceApp => instanceApp.uiId === appUiId);
        const appWithProperties = {
            ...appToCopy,
            properties: propertiesMap[appUiId] ?? appToCopy?.properties,
            uiId: nanoid(),
            isNewlyAdded: true,
            currentAppId: -1
        }
        updateInstanceApps([{ ...appWithProperties }, ...instanceApps]);
    }

    function clearSelectedApp() {
        setSelectedAppId("");
    }

    useEffect(() => {
        const selectedApp = instanceApps.find(instanceApp => instanceApp.uiId === selectedAppId);
        setSelectedApp(selectedApp);

        if (!propertiesMap[selectedAppId]) {
            const properties =
                typeof selectedApp?.properties === 'string' ? JSON.parse(selectedApp.properties) : (selectedApp?.properties ?? []);
            setPropertiesMap({
                ...propertiesMap,
                [selectedAppId]: properties.map((property: IProperty) => ({ ...property, propertyId: nanoid() }))
            });
        }
    }, [selectedAppId]);

    function handleAppPropertiesModified(properties: IProperty[]) {
        setPropertiesMap({
            ...propertiesMap,
            [selectedAppId]: properties
        });

        // const newInstanceList = instanceApps.map(instanceApp => {
        //     if (selectedAppId && instanceApp.uiId === selectedAppId) {
        //         return { ...instanceApp, properties }
        //     }
        //     return instanceApp;
        // });
        // // console.log(newInstanceList);
        // updateInstanceApps(newInstanceList);
    }

    return (
        <div className="grid grid-cols-12 gap-4">
            <div className={`instanceCardThumbnail rounded-md shadow-md bg-white relative border w-full h-[calc(80vh-4rem)] flex flex-col col-span-8`}
                style={{ borderColor: `${providerList.find(provider => provider.id === instance.providerId)?.providerColor}aa` ?? '#777' }}>
                <header className="w-full rounded-tl-md rounded-tr-md relative flex justify-between items-center gap-8 h-16"
                    style={{ backgroundColor: `${providerList.find(provider => provider.id === instance.providerId)?.providerColor}aa` ?? '#777' }}>

                    <div>
                        <p className="px-3 py-2 pb-0.5 text-base font-medium text-gray-900 capitalize">{instance.name}</p>
                        {parsedConfigurationDetails?.instanceType &&
                            <p className="px-3 pb-2 text-sm font-medium text-gray-600 italic">
                                {parsedConfigurationDetails?.region} | {parsedConfigurationDetails?.instanceType}
                            </p>
                        }
                    </div>
                </header>

                <main className="p-6 flex-grow overflow-y-auto scrollbar-thin" onClick={clearSelectedApp}>
                    {(!instanceApps || instanceApps.length === 0) && <span className="text-[92%] text-gray-500">
                        Click <MdOutlineAdd className="inline-block text-xl font-semibold" /> on any app from the left menu to add it to this Instance. <br /> Clicking on a selected app, would open up its properties panel, to the right.
                    </span>}
                    {instanceApps && <div className="gap-6 grid grid-cols-3 ">
                        {instanceApps.length > 0 &&
                            instanceApps.map(instanceApp => (
                                <AppCard app={instanceApp} key={instanceApp.uiId}
                                    appDeleted={appDeleted}
                                    appEdited={appEdited}
                                    handleAppCopy={handleAppCopy}
                                    handleAppSelection={handleAppSelection}
                                    isSelected={selectedAppId === instanceApp.uiId}
                                />
                            ))
                        }
                    </div>
                    }
                </main>

                <div className="grid grid-cols-12 gap-1 items-center h-16 border-t border-gray-300">
                    <div className={`col-span-4 p-2 text-center relative ${memoryAllocated > instanceMemory ? warningBackground : ''}`}>
                        <div>
                            <span className="text-sm text-gray-800">{memoryAllocated}</span> <span className="text-sm text-gray-400">/ </span> <span className="text-sm text-gray-600">{instanceMemory ?? 0} GB</span>
                        </div>
                        <span className="text-gray-900 text-sm">RAM</span>
                        {(memoryAllocated >= instanceMemory) && <FaExclamation className="text-red-800 text-base absolute top-1 right-1" />}
                    </div>
                    <div className={`col-span-4 p-2 text-center relative ${coresAllocated > instanceCores ? warningBackground : ''}`}>
                        <div>
                            <span className="text-sm text-gray-800">{coresAllocated}</span> <span className="text-sm text-gray-400">/ </span> <span className="text-sm text-gray-600">{instanceCores ?? 0}</span >
                        </div>
                        <span className="text-gray-900 text-sm">Cores</span>
                        {(coresAllocated >= instanceCores) && <FaExclamation className="text-red-800 text-base absolute top-1 right-1" />}
                    </div>
                </div>

                {!hasIp && <FaHeartCircleExclamation className="fill-current text-red-400 text-3xl absolute" title="Instance Not deployed yet"
                    style={{ right: '2px', bottom: '2px' }} />
                }
            </div>
            <div className="col-span-4">
                <ConfigurationArea selectedApp={selectedApp} propertiesMap={propertiesMap}
                    handleAppPropertiesModified={handleAppPropertiesModified} />
            </div>
        </div>
    )
});

export default InstanceCard;