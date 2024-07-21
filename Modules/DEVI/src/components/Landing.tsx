import { useCallback, useEffect, useRef, useState } from "react";
import { IVision, IVisionForm } from "../interfaces";
import useAxiosAuth from "../lib/hooks/useAxiosAuth";
import FormDialog from "./baseComponents/FormDialog";
import Loading from "./baseComponents/Loading";
import PrimaryButton from "./baseComponents/PrimaryButton";
import NewVisionCard from "./cards/NewVisionCard";
import VisionCard from "./cards/VisionCard";
import VisionCreationForm from "./forms/VisionCreationForm";

const Landing = () => {

    const [visionList, setVisionList] = useState<IVision[]>([]);
    const [isCreateModalVisible, setIsCreateModalVisible] = useState<boolean>(false);
    const [isLoading, setIsLoading] = useState<boolean>(false);

    const [isEditModalVisible, setIsEditModalVisible] = useState<boolean>(false);
    const [currentSelectedVision, setCurrentSelectedVision] = useState<IVision>();

    const visionCreationForm = useRef(null);
    const visionEditForm = useRef(null);

    const axiosAuth = useAxiosAuth();

    const getCurrentVisions = useCallback(async () => {
        setIsLoading(true);
        const { data } = await axiosAuth.get('/vision').then(res => res.data);
        setIsLoading(false);
        setVisionList(data);
    }, []);

    useEffect(() => {
        getCurrentVisions();
    }, [getCurrentVisions])

    function createNewVision() {
        setIsCreateModalVisible(true);
        // console.log("Creating new vision");
    }

    function editVisionHandler(details: IVision) {
        setIsEditModalVisible(true);
        setCurrentSelectedVision(details);
    }

    function closeModal() {
        setIsCreateModalVisible(false);
    }

    function closeEditModal() {
        setIsEditModalVisible(false);
    }

    async function handleCreation() {
        if (visionCreationForm.current) {
            const details: IVisionForm = visionCreationForm.current?.sendDetails();
            await axiosAuth.post('/vision', {
                data: {
                    name: details.visionName,
                    description: details.visionDescription,
                    modes: details.modes
                }
            }).then(res => res.data);
            setIsCreateModalVisible(false);

            await getCurrentVisions();
        }
    }

    async function handleEdit() {
        if (visionEditForm.current) {
            const details: IVisionForm = visionEditForm.current?.sendDetails();
            await axiosAuth.patch(`/vision/${currentSelectedVision?.id}`, {
                data: {
                    name: details.visionName,
                    description: details.visionDescription
                }
            }).then(res => res.data);
            setIsEditModalVisible(false);
            await getCurrentVisions();
        }
    }

    async function deleteVisionHandler(details: IVision) {
        await axiosAuth.delete(`/vision/${details?.id}`).then(res => res.data);
        await getCurrentVisions();
    }

    return (
        <div className="flex-grow overflow-y-auto">
            {isLoading && <Loading />}
            {
                !isLoading && visionList.length === 0 &&
                <div className="w-full h-full flex items-center justify-center flex-col font-inter col-span-full">
                    <p>You have not created any <b>VISIONS</b> yet.</p>
                    <div className="w-80 mt-2">
                        <PrimaryButton label='Create new Vision' callToAction={createNewVision} className="w-full py-3" />
                    </div>
                </div>
            }
            {
                !isLoading && visionList.length > 0 &&
                <div className="grid grid-cols-[auto_1fr_auto] m-4">
                    <div className="grid grid-cols-4 gap-8">
                        <div className="col-span-1">
                            <NewVisionCard createNewVision={createNewVision} />
                        </div>
                        {
                            visionList.map((vision: IVision) => {
                                return (
                                    <div className="col-span-1" key={vision.id}>
                                        <VisionCard details={vision}
                                            editVisionHandler={editVisionHandler} deleteVisionHandler={deleteVisionHandler} />
                                    </div>
                                )
                            })
                        }
                    </div>
                </div>
            }
            {
                isCreateModalVisible &&
                <FormDialog modalHeading='New Vision'
                    FormComponent={<VisionCreationForm details={{} as IVision} ref={visionCreationForm} />}
                    closeModal={closeModal}
                    confirmAction={handleCreation}
                    actionBtnLabel="Create"
                />
            }
            {
                isEditModalVisible &&
                <FormDialog modalHeading='Edit Vision'
                    FormComponent={<VisionCreationForm details={currentSelectedVision} ref={visionEditForm} />}
                    closeModal={closeEditModal}
                    confirmAction={handleEdit}
                    actionBtnLabel="Update"
                />
            }
        </div>
    );
};

export default Landing;