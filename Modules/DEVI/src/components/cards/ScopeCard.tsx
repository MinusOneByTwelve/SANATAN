/* eslint-disable @typescript-eslint/no-unused-vars */
import { MouseEvent, memo, useCallback, useEffect, useRef, useState } from "react";
import { BsFillRocketTakeoffFill } from "react-icons/bs";
import { MdOutlineAddCircleOutline, MdOutlineDragIndicator } from "react-icons/md";
import { IInstance, IInstanceConfigurationForm, IScope } from "../../interfaces";
import useAxiosAuth from "../../lib/hooks/useAxiosAuth";
import AppAdditionForm from "../appAddition/AppAdditionForm";
import Drawer from "../baseComponents/Drawer";
import FormDialog from "../baseComponents/FormDialog";
import InstanceCreationForm from "../forms/InstanceCreationForm";
import InstanceDeploymentForm from "../instanceDeployment/InstanceDeploymentForm";
import styles from "../styles/scopeNode.styles.module.css";
import InstanceThumbnailCard from "./InstanceCardThumbnail";

/* eslint-disable @typescript-eslint/no-explicit-any */
interface IScopeProps {
    scopeDetails: IScope,
    isSelected: boolean
    onMouseDownNode: (id: number, event: MouseEvent) => void,
    editScopeHandler: (details: IScope) => void,
    // deleteScopeHandler: (details: IScope) => void,
}

const ScopeCard = memo((props: IScopeProps) => {

    const [scopeInstances, setScopeInstances] = useState<IInstance[]>([]);
    const [isLoading, setIsLoading] = useState<boolean>(false);

    const [selectedInstanceId, setSelectedInstanceId] = useState<number>(-1);

    const [isCreateModalVisible, setIsCreateModalVisible] = useState<boolean>(false);
    const [isDeployModalVisible, setIsDeployModalVisible] = useState<boolean>(false);

    const axiosAuth = useAxiosAuth();
    // const [cardDimensions, setCardDimensions] = useState<ICardDimensions>({
    //     width: 256,
    //     height: 192
    // });

    const getScopeInstances = useCallback(async () => {
        setIsLoading(true);
        const { data } = await axiosAuth.get(`/scope/${props.scopeDetails?.id}/allInstances`).then(res => res.data);
        setIsLoading(false);
        setScopeInstances(data);
    }, [props.scopeDetails?.id]);

    useEffect(() => {
        getScopeInstances();
    }, [getScopeInstances]);

    // useEffect(() => {
    //     setScopeInstances(props.scopeDetails.instances ?? []);
    // }, [props.scopeDetails.id])

    const { scopeDetails, onMouseDownNode, editScopeHandler } = props;

    console.log("Rerendering - ", scopeDetails.id);
    console.log(scopeDetails);

    const instanceConfigurationCreationForm = useRef(null);

    /*************** Instance creation & edit ********************/
    // const onResize = (event: any, { node, size, handle }: { node: any, size: any, handle: any }) => {
    //     console.log(size);
    //     setCardDimensions({ width: size.width, height: size.height });
    // };

    async function handleCreation() {
        if (instanceConfigurationCreationForm.current) {
            const details: IInstanceConfigurationForm = instanceConfigurationCreationForm.current?.sendDetails();
            // console.log(details);

            const createdInstances = await axiosAuth.post('/instance', {
                data: {
                    ...details,
                }
            }).then(res => res.data);
            // console.log(createdInstances);

            setIsCreateModalVisible(false);

            const newScopeInstancesList = [...scopeInstances, ...createdInstances]
            setScopeInstances((newScopeInstancesList));
        }
    }
    /*************** Instance creation & edit ********************/

    /*************** Modal Open & Close ********************/
    function addInstanceHandler() {
        setIsCreateModalVisible(true);
    }

    function closeModal() {
        setIsCreateModalVisible(false);
    }

    function expandInstance(instanceId: number) {
        setSelectedInstanceId(instanceId);
    }

    function closeInstanceEditModal(editedInstance?: IInstance) {
        setSelectedInstanceId(-1);
        // console.log(editedInstance);
        if (editedInstance) {
            setScopeInstances(scopeInstances.map(scopeInstance => {
                if (scopeInstance.id === editedInstance.id) {
                    return editedInstance;
                }

                return scopeInstance;
            }))
        }
    }

    function deployInstances() {
        setIsDeployModalVisible(true);
    }

    function closeInstanceDeployModal(isDeploymentAttempted?: boolean) {
        setIsDeployModalVisible(false);
    }
    /*************** Modal Open & Close *********************/

    // useEffect(() => {
    //     console.log("Calling useEffect" + scopeDetails.id);
    // }, [scopeDetails.id]);


    return (
        <>
            {/* <Resizable height={cardDimensions.height} width={cardDimensions.width} onResize={onResize}> */}
            <div className={`${styles.scopeCard} bg-gray-100 absolute rounded-sm font-inter pb-4 max-w-4xl ${styles.node} ${props.isSelected} ? ${styles.nodeSelected}: ''`}
                style={{
                    transform: `translate(${scopeDetails.xPos}px, ${scopeDetails.yPos}px)`
                }}
            >
                <div className="p-2 pt-4 flex items-center justify-between">
                    <div className="flex items-center justify-between mr-8">
                        <MdOutlineDragIndicator className="text-purple-500 text-lg cursor-move mr-2"
                            onMouseDown={e => onMouseDownNode(scopeDetails.id, e)} />
                        <h3 className="font-inter font-medium text-sm cursor-pointer"
                            onClick={e => editScopeHandler(scopeDetails)}>{scopeDetails.name}</h3>
                    </div>
                    <div className="flex items-center gap-x-1">
                        <BsFillRocketTakeoffFill
                            className="w-5 h-5 p-1 box-content cursor-pointer text-blue-600 hover:text-blue-800 hover:border-blue-800
                            inline-block border border-transparent rounded-md" title="Deploy"
                            onClick={deployInstances}
                        />
                        {/* <MdOutlineContentCopy
                            className="w-5 h-5 cursor-pointer text-purple-500 inline-block" title="Copy" /> */}
                        <MdOutlineAddCircleOutline
                            className="text-base w-6 h-6 p-1 box-content cursor-pointer text-purple-600 hover:text-purple-800 hover:border-purple-800 
                            border border-transparent rounded-md"
                            title="Add Instance" onClick={e => addInstanceHandler()} />
                    </div>
                </div>
                <div className="flex flex-wrap gap-4 items-start px-4 mt-3">
                    {
                        scopeInstances.length > 0 &&
                        scopeInstances.map(instance => {
                            return (
                                <InstanceThumbnailCard instance={instance} key={instance.id} expandInstance={expandInstance} />
                            )
                        })
                    }
                    {
                        scopeInstances.length === 0 &&
                        <span className="text-xs text-gray-500"> There are no instances in this scope yet. </span>
                    }
                </div>

            </div>
            <Drawer
                modalHeading="Instance Add/Edit"
                additionalInfoHeader={scopeDetails.name}
                goMax={true}
                FormComponent={<InstanceCreationForm scopeDetails={scopeDetails} details={{}} ref={instanceConfigurationCreationForm} />}
                onClose={closeModal}
                isOpen={isCreateModalVisible}
                editLabel="Add Instance(s)"
                ctaHandler={handleCreation}
            />
            {
                selectedInstanceId > 0 &&
                <FormDialog
                    showHeader={false}
                    FormComponent={<AppAdditionForm closeModal={closeInstanceEditModal}
                        selectedInstanceId={selectedInstanceId}
                    />}
                    closeModal={closeInstanceEditModal}
                    goMax={true}
                    actionBtnLabel="Add Apps to Instance"
                    showFormActions={false}
                />
            }
            {
                isDeployModalVisible &&
                <FormDialog
                    showHeader={false}
                    FormComponent={<InstanceDeploymentForm closeModal={closeInstanceDeployModal}
                        scopeId={scopeDetails.id}
                    />}
                    closeModal={closeInstanceDeployModal}
                    className="!p-2 max-w-screen-lg !w-[80vw]"
                    actionBtnLabel="Deploy Instances"
                    showFormActions={false}
                />
            }
        </>
    );
}, arePropsEqual)

function arePropsEqual(oldProps: IScopeProps, newProps: IScopeProps) {
    // console.log(oldProps.scopeDetails.xPos, newProps.scopeDetails.xPos);
    const comparisonResult =
        oldProps.scopeDetails.id === newProps.scopeDetails.id &&
        oldProps.scopeDetails.name === newProps.scopeDetails.name &&
        oldProps.scopeDetails.isProcessed === newProps.scopeDetails.isProcessed &&
        oldProps.scopeDetails.xPos === newProps.scopeDetails.xPos &&
        oldProps.scopeDetails.yPos === newProps.scopeDetails.yPos;
    // console.log(comparisonResult, oldProps.scopeDetails.id, newProps.scopeDetails.id);
    return comparisonResult;
}

export default ScopeCard;