import { customAlphabet } from 'nanoid';
import { useCallback, useEffect, useRef, useState } from "react";
import { IAppOption, IInstance, IProperty, IUIAppDisplay } from "../../interfaces";
import useAxiosAuth from '../../lib/hooks/useAxiosAuth';
import Loading from '../baseComponents/Loading';
import AppSearchComponent from "./AppSearchComponent";
import InstanceCard from "./InstanceCard";

const nanoid = customAlphabet('ABCDEF1234567890', 6);

const AppAdditionForm = ({ selectedInstanceId, closeModal }:
    { selectedInstanceId: number, closeModal: (instance?: IInstance) => void }) => {

    const [appToAdd, setAppToAdd] = useState<IAppOption>();

    const [isLoading, setIsLoading] = useState<boolean>(false);
    const [instanceToUse, setInstanceToUse] = useState<IInstance | undefined>();

    const [isInstanceEdited, setIsInstanceEdited] = useState<boolean>(false);

    const instanceCardForm = useRef(null);

    const axiosAuth = useAxiosAuth();

    function addAppToInstance(app: IAppOption) {
        const newApp = { ...app, isNewlyAdded: true, uiId: nanoid() };
        setAppToAdd(newApp);
    }

    const getInstanceDetails = useCallback(async () => {
        setIsLoading(true);
        const data = await axiosAuth.get(`/instance/${selectedInstanceId}`).then(res => res.data);
        setIsLoading(false);
        setInstanceToUse(data);
    }, [selectedInstanceId]);

    useEffect(() => {
        getInstanceDetails();
    }, [getInstanceDetails]);


    function closeInstanceEditModal() {
        if (isInstanceEdited) {
            closeModal(instanceToUse!);
        } else {
            closeModal();
        }
    }


    async function handleAdditionToInstance() {
        if (instanceCardForm.current) {
            const { instanceApps, deletedAppIds }: { instanceApps: IUIAppDisplay[], deletedAppIds: number[] }
                = instanceCardForm.current?.sendDetails() ?? {};
            // console.log(instanceApps);

            const processedInstanceApps = instanceApps.map(instanceApp => {
                const properties =
                    typeof instanceApp.properties === 'string' ? JSON.parse(instanceApp.properties) : (instanceApp.properties ?? []);
                return {
                    cores: instanceApp.cores ?? instanceApp.defaultCores ?? 0,
                    memory: instanceApp.memory ?? instanceApp.defaultMemory ?? 0,
                    identifierId: instanceApp.identifierId,
                    isNewlyAdded: instanceApp.isNewlyAdded,
                    properties: properties.map((property: IProperty) => {
                        delete property.propertyId;
                        delete property.isNewlyAdded;
                        return property;
                    }),
                    id: instanceApp.currentAppId
                };
            });

            // console.log(processedInstanceApps);
            const updatedInstance = await axiosAuth.post(`/instance/${selectedInstanceId}`, {
                data: {
                    apps: processedInstanceApps,
                    deletedAppIds
                }
            }).then(res => res.data);
            setInstanceToUse(updatedInstance);
            setIsInstanceEdited(true);
        }
    }

    return (
        <>
            {isLoading && <Loading />}
            {!isLoading && instanceToUse && <div className="grid grid-cols-8 gap-4">
                <div className="col-span-2 h-[calc(80vh-4rem)] overflow-scroll scrollbar-hide">
                    <AppSearchComponent addAppToInstance={addAppToInstance} />
                </div>
                <div className="col-span-6">
                    <InstanceCard instance={instanceToUse} ref={instanceCardForm}
                        newApp={appToAdd} />
                </div>
            </div>}
            <div className="flex items-center h-16 py-4 px-4 mt-4 justify-between border-t border-gray-300 rounded-b dark:border-gray-600">
                <button type="button"
                    className="py-2.5 px-5 text-sm font-medium text-gray-900 focus:outline-none bg-white rounded-lg border border-gray-300 hover:bg-gray-100 hover:text-blue-700 focus:z-10 focus:ring-4 focus:ring-gray-100 dark:focus:ring-gray-700 dark:bg-gray-800 dark:text-gray-400 dark:border-gray-600 dark:hover:text-white dark:hover:bg-gray-700"
                    onClick={closeInstanceEditModal}
                >Close</button>
                <button type="button"
                    className="text-white bg-blue-700 hover:bg-blue-800 focus:ring-4 focus:outline-none focus:ring-blue-300 font-medium rounded-lg text-sm px-5 py-2.5 text-center dark:bg-blue-600 dark:hover:bg-blue-700 dark:focus:ring-blue-800"
                    onClick={handleAdditionToInstance}
                >Save Changes</button>
            </div>
        </>

    )
};

export default AppAdditionForm;