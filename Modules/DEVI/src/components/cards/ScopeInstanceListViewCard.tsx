import { useEffect, useState } from "react";
import { FaRegStopCircle } from "react-icons/fa";
import { MdDeleteSweep, MdOutlineRestartAlt } from "react-icons/md";
import { IInstance, IScope, NA } from "../../interfaces";

enum InstanceStateChange {
    RESTART = 'restart',
    STOP = 'stop',
    DELETE = 'delete'
}

const ScopeInstanceListViewCard = ({ scope, selectionChanged, isScopeSelectable = true, isDeployment = false, isDefaultSelected = false }: {
    scope: IScope,
    isScopeSelectable?: boolean,
    isDeployment?: boolean,
    isDefaultSelected?: boolean,
    selectionChanged: (scopeId: number, scopeSelected: boolean, instanceList: IInstance[]) => void
}) => {

    const [scopeSelected, setScopeSelected] = useState(false);
    const [instanceList, setInstanceList] = useState<IInstance[]>([]);

    const [allInstancesSelectable, setAllInstanceSelectable] = useState<boolean>(true);

    const handleScopeSelection = () => {
        const updatedInstances = scope.instances.map(instance => {
            return {
                ...instance,
                isSelected: !scopeSelected
            }
        });
        setInstanceList([...updatedInstances]);
        setScopeSelected(!scopeSelected);

        selectionChanged(scope.id, !scopeSelected, updatedInstances);
    };

    useEffect(() => {
        let updatedInstances = scope.instances;
        if (isDefaultSelected) {
            updatedInstances = scope.instances.map(instance => {
                instance.isSelected = isDefaultSelected;
                return instance;
            });
        }
        setAllInstanceSelectable(!isDefaultSelected);
        setInstanceList(updatedInstances);

        selectionChanged(scope.id, scopeSelected, updatedInstances);
    }, [scope.instances, isDefaultSelected]);

    const handleInstanceSelection = (instanceId: number) => {
        const updatedInstances = scope.instances.map(instance => {
            if (instance.id === instanceId) {
                instance.isSelected = !instance.isSelected;
            }
            return instance;
        });
        setInstanceList(updatedInstances);
        selectionChanged(scope.id, scopeSelected, updatedInstances);
    }

    const updateAllInstancesSelection = (isSelected: boolean) => {
        const updatedInstances = scope.instances.map(instance => {
            instance.isSelected = isSelected;
            return instance;
        });
        setInstanceList(updatedInstances);
        selectionChanged(scope.id, scopeSelected, updatedInstances);
        setAllInstanceSelectable(!isSelected);
    }

    function isInstanceSelectable(instance: IInstance) {
        let isSelectable = false;
        if (isDeployment) {
            if (instance.ip === NA) {
                isSelectable = true;
            }
        }

        if (!isDeployment) {
            if (isScopeSelectable) {
                isSelectable = scopeSelected;
            }
        }

        return isSelectable;
    }

    function getBorderDetails(instance: IInstance) {
        if (instance.isSelected) {
            return 'border border-blue-300 p-1 px-2';
        }

        if (instance.isMarkedForStop) {
            return 'border border-red-200 bg-red-100 p-1 px-2';
        }

        if (instance.isMarkedForDeletion) {
            return 'border border-red-300 bg-red-100 p-1 px-2';
        }

        if (instance.isMarkedForStart) {
            return 'border border-green-500 p-1 px-2';
        }

        return 'border border-transparent p-1 px-2';
    }

    function editInstanceState(instanceState: InstanceStateChange, selectedInstance: IInstance) {
        const updatedInstances = scope.instances.map(instance => {
            if (instance.id === selectedInstance.id) {
                if (instanceState === InstanceStateChange.STOP) {
                    instance.isMarkedForStop = !instance.isMarkedForStop;
                }

                if (instanceState === InstanceStateChange.DELETE) {
                    instance.isMarkedForDeletion = !instance.isMarkedForDeletion;
                    instance.isMarkedForStop = false;
                }

                if (instanceState === InstanceStateChange.RESTART) {
                    instance.isMarkedForStart = !instance.isMarkedForStart;
                }

                return instance;
            }
            return instance;
        });
        setInstanceList([...updatedInstances]);
        selectionChanged(scope.id, scopeSelected, updatedInstances);
    }

    return (
        <div className={`border border-gray-200 rounded-md shadow p-4 ${isDeployment ? 'h-fit' : ''} w-[calc(50%-10px)]`}>
            <div className="flex justify-between items-start">
                <div className="flex mb-4">
                    {isScopeSelectable && <div className="flex items-center h-5 mt-2">
                        <input id={scope.id.toString()} aria-describedby={`helper-${scope.id}-text`} type="checkbox" value=""
                            className="w-4 h-4 text-blue-600 bg-gray-100 border-gray-300 rounded focus:ring-blue-500 dark:focus:ring-blue-600 dark:ring-offset-gray-800 dark:focus:ring-offset-gray-800 dark:bg-gray-700 dark:border-gray-600"
                            onChange={handleScopeSelection}
                            checked={scopeSelected}
                        />
                    </div>}
                    <div className="ms-2 text-base">
                        <label htmlFor={scope.id.toString()} className="font-medium text-blue-800 dark:text-gray-300">{scope.name}</label>
                        <p id={`helper-${scope.id}-text`} className="text-xs font-normal text-gray-500 dark:text-gray-400">{scope.description}</p>
                    </div>
                </div>
                {(scopeSelected || isDeployment) && <div className="text-xs text-gray-600 mt-1">
                    {allInstancesSelectable && <span className="cursor-pointer hover:text-gray-800 hover:underline" onClick={e => updateAllInstancesSelection(true)}>Select All</span>}
                    {!allInstancesSelectable && <span className="cursor-pointer hover:text-gray-800 hover:underline" onClick={e => updateAllInstancesSelection(false)}>Deselect All</span>}
                </div>}
            </div>

            {
                instanceList.length > 0 &&
                <div className={`${isScopeSelectable ? "ml-6" : "ml-2"}`}>
                    {
                        instanceList.map(instance => {
                            const parsedConfigurationDetails =
                                typeof instance.configurationDetails === 'string' ? JSON.parse(instance.configurationDetails) : (instance.configurationDetails ?? {});
                            return (
                                <div className={`flex mb-3 justify-between ${getBorderDetails(instance)}`} key={instance.id}>
                                    <div className="flex">
                                        <div className="flex items-center h-5 mt-1">
                                            <input id={instance.id.toString()} type="checkbox" value=""
                                                className="w-4 h-4 text-blue-600 bg-gray-100 border-gray-300 rounded focus:ring-blue-500 dark:focus:ring-blue-600 dark:ring-offset-gray-800 dark:focus:ring-offset-gray-800 dark:bg-gray-700 dark:border-gray-600"
                                                onChange={e => handleInstanceSelection(instance.id)}
                                                checked={instance.isSelected}
                                                disabled={!isInstanceSelectable(instance)}
                                            />
                                        </div>
                                        <div className="ms-2 text-base">
                                            <label htmlFor={instance.id.toString()} className="text-[96%] font-medium text-gray-700 dark:text-gray-300">
                                                {instance.name}</label>
                                            <p className="text-xs font-normal text-gray-500 dark:text-gray-400">
                                                <label className="text-gray-600 mr-1">Region:</label>{parsedConfigurationDetails?.region} | <label className="text-gray-600 mr-1">Instance Type:</label>{parsedConfigurationDetails?.instanceType}
                                            </p>
                                        </div>
                                    </div>
                                    {
                                        isDeployment &&
                                        <div className="mt-1 flex gap-2 items-center">
                                            {
                                                // !instance.isRunning && instance.ip !== NA &&
                                                <MdOutlineRestartAlt className={`inline-block box-content w-5 h-5 cursor-pointer
                                                ${instance.isMarkedForStart ? 'text-green-500 border border-green-500 rounded-lg' : 'text-gray-600 border border-transparent'} p-1`}
                                                    title="Mark for restart"
                                                    onClick={e => editInstanceState(InstanceStateChange.RESTART, instance)} />
                                            }

                                            {
                                                // instance.isRunning && 
                                                <FaRegStopCircle
                                                    className={`inline-block box-content w-5 h-5 cursor-pointer
                                                        ${instance.isMarkedForStop ? 'text-red-500 border border-red-500 rounded-lg' : 'text-gray-600 border border-transparent'} p-1`}
                                                    title="Mark for stop"
                                                    onClick={e => editInstanceState(InstanceStateChange.STOP, instance)} />
                                            }

                                            {
                                                // instance.ip !== NA && 
                                                <MdDeleteSweep
                                                    className={`inline-block box-content w-6 h-6 cursor-pointer
                                                        ${instance.isMarkedForDeletion ? 'text-red-800 border border-red-700 rounded-lg' : 'text-gray-600 border border-transparent'} p-0.5`}
                                                    title="Mark for deletion"
                                                    onClick={e => editInstanceState(InstanceStateChange.DELETE, instance)} />
                                            }
                                        </div>
                                    }

                                </div>
                            )
                        })
                    }
                </div>
            }

        </div>
    )
}

export default ScopeInstanceListViewCard;