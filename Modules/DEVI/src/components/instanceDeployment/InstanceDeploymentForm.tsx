import { useCallback, useEffect, useState } from "react";
import { FaRegStopCircle } from "react-icons/fa";
import { MdCheckBoxOutlineBlank, MdDeleteSweep } from "react-icons/md";
import { useParams } from "react-router-dom";
import useAppContext from "../../contexts/AppContext";
import { IDeploymentDetails, IInstance, IScope } from "../../interfaces";
import useAxiosAuth from "../../lib/hooks/useAxiosAuth";
import Loading from "../baseComponents/Loading";
import ScopeInstanceListViewCard from "../cards/ScopeInstanceListViewCard";

const InstanceDeploymentForm = ({ scopeId, closeModal }:
    { scopeId: number, closeModal: (isDeploymentAttempted?: boolean) => void }) => {

    const { currentMode } = useAppContext();
    const { visionId } = useParams();
    const axiosAuth = useAxiosAuth();

    const [isLoading, setIsLoading] = useState(false);
    const [scopeList, setScopeList] = useState<IScope[]>([]);

    const [isDeploymentAttempted, setIsDeploymentAttempted] = useState<boolean>(false);

    const [deploymentData, setDeploymentData] = useState<{ [key: string]: IDeploymentDetails }>({});

    const getScopesForSelectedMode = useCallback(async () => {
        setIsLoading(true);
        const { data }: { data: IScope[] } =
            await axiosAuth.get(`/scope/${visionId}/getAllScopes?fetchInstances=true&modeId=${currentMode?.id}`).then(res => res.data);
        // const { modes } = data;

        setIsLoading(false);
        setScopeList(data);
    }, []);

    useEffect(() => {
        if (currentMode?.id) {
            getScopesForSelectedMode();
        }
    }, [currentMode?.id]);

    const selectionChanged = (scopeId: number, scopeSelected: boolean, instanceList: IInstance[]) => {

        const deployInstanceIds: number[] = [];
        const restartInstanceIds: number[] = [];
        const stopInstanceIds: number[] = [];
        const deleteInstanceIds: number[] = [];

        instanceList.forEach(instance => {
            if (instance.isSelected) {
                deployInstanceIds.push(instance.id)
            }

            if (instance.isMarkedForStart) {
                restartInstanceIds.push(instance.id)
            }

            if (instance.isMarkedForStop) {
                stopInstanceIds.push(instance.id)
            }

            if (instance.isMarkedForDeletion) {
                deleteInstanceIds.push(instance.id)
            }
        })

        setDeploymentData({
            ...deploymentData,
            [scopeId]: {
                deployInstanceIds,
                restartInstanceIds,
                stopInstanceIds,
                deleteInstanceIds,
            }
        })
        // console.log(scopeId, deployInstanceIds, restartInstanceIds, stopInstanceIds, deleteInstanceIds);
    }

    function handleInstanceDeployment() {
        setIsDeploymentAttempted(true);
        console.log(deploymentData);
    }

    return (
        <div className="flex flex-col h-[81vh]">
            <div className="h-20 p-4 mb-6">
                <h2>Instance Deployment</h2>
                <p className="text-sm text-gray-600 mb-1 mt-2">
                    Checking <MdCheckBoxOutlineBlank className="inline-block box-content w-5 h-5" /> would select an instance. Selected instances will be provisioned in the specified <i>Region</i> with the specified <i>Instance Type</i>.
                </p>
                <p className="text-sm text-gray-600 mb-4">
                    For a running instance, <FaRegStopCircle className="inline-block box-content w-5 h-5 text-gray-600 rounded-lg" /> stops an instance <span className="text-xs">(Based on your deployment, you might still continue to incur costs.)</span> & <MdDeleteSweep className="inline-block box-content w-5 h-5 text-gray-600" /> would stop & delete an Instance.
                </p>
            </div>

            {isLoading && <Loading />}

            {!isLoading && scopeList.length > 0 &&
                <div className="flex-grow flex flex-wrap gap-5 overflow-scroll scrollbar-hide p-4">
                    {scopeList.map((scope: IScope) => {
                        return (
                            <ScopeInstanceListViewCard scope={scope} key={scope.id} selectionChanged={selectionChanged}
                                isScopeSelectable={false} isDeployment={true} isDefaultSelected={scopeId === scope.id}
                            />
                        )
                    })}
                </div>
            }

            <div className="flex items-center h-16 py-4 px-4 justify-between border-t border-gray-300 rounded-b dark:border-gray-600">
                <button type="button"
                    className="py-2.5 px-5 text-sm font-medium text-gray-900 focus:outline-none bg-white rounded-lg border border-gray-300 hover:bg-gray-100 hover:text-blue-700 focus:z-10 focus:ring-4 focus:ring-gray-100 dark:focus:ring-gray-700 dark:bg-gray-800 dark:text-gray-400 dark:border-gray-600 dark:hover:text-white dark:hover:bg-gray-700"
                    onClick={e => closeModal(isDeploymentAttempted)}
                >Close</button>
                <button type="button"
                    className="text-white bg-blue-700 hover:bg-blue-800 focus:ring-4 focus:outline-none focus:ring-blue-300 font-medium rounded-lg text-sm px-5 py-2.5 text-center dark:bg-blue-600 dark:hover:bg-blue-700 dark:focus:ring-blue-800"
                    onClick={handleInstanceDeployment}
                >Deploy Instances</button>
            </div>
        </div>
    )
}

export default InstanceDeploymentForm;