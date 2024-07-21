import { useEffect, useRef, useState } from "react";
import { MdOutlineAdd } from "react-icons/md";
import { RiArrowDropDownLine, RiArrowDropUpLine } from "react-icons/ri";
import useAxiosAuth from "../lib/hooks/useAxiosAuth";
import FormDialog from "./baseComponents/FormDialog";
import ScopeReplicationSelector from "./forms/ScopeReplicationSelector";

const ScopeAdd = ({ createNewScope, refreshScope, className, label, width, opensUp = true }:
    { createNewScope: () => void, refreshScope: () => void, className?: string, label?: string, width?: string, opensUp: boolean }) => {

    const [isHiddenActionVisible, setIsHiddenActionVisible] = useState(false);
    const hiddenActionRef = useRef<HTMLDivElement>(null);
    const [isReplicationModalVisible, setIsReplicationModalVisible] = useState<boolean>(false);

    const scopeReplicationForm = useRef(null);

    const axiosAuth = useAxiosAuth();

    // Close dropdown if clicked outside
    useEffect(() => {
        const handleClickOutside = (event: MouseEvent) => {
            if (hiddenActionRef.current && !hiddenActionRef.current.contains(event.target as Node)) {
                setIsHiddenActionVisible(false);
            }
        };

        document.addEventListener('mousedown', handleClickOutside);
        return () => {
            document.removeEventListener('mousedown', handleClickOutside);
        };
    }, []);

    const handleHiddenActionSelected = () => {
        setIsHiddenActionVisible(false);
        setIsReplicationModalVisible(true);
    }

    const closeModal = () => {
        setIsReplicationModalVisible(false);
    }

    async function handleReplication() {
        if (scopeReplicationForm.current) {
            const replicationDetails = scopeReplicationForm.current?.getReplicationDetails();
            await axiosAuth.post('/replication/scope', {
                data: replicationDetails
            }).then(res => res.data);
            setIsReplicationModalVisible(false);
            refreshScope();
        }
    }

    return (
        <>
            <button className={`bg-purple-800 border-purple-700 border pl-4 cursor-pointer flex items-center justify-between text-gray-200 rounded-md focus:outline-none ${className} ${width}`}>
                <div onClick={createNewScope} className="flex items-center flex-grow">
                    <MdOutlineAdd className="text-gray-100 mr-1 text-lg" /> <span className={`font-inter font-semibold ${label ? 'text-base' : 'text-xs'}`}>{label ?? "SCOPE"}</span>
                </div>
                <div className="border-l border-gray-200 px-2 relative" ref={hiddenActionRef}>
                    {opensUp && <RiArrowDropUpLine className="text-3xl" onClick={e => setIsHiddenActionVisible(!isHiddenActionVisible)} />}
                    {!opensUp && <RiArrowDropDownLine className="text-3xl" onClick={e => setIsHiddenActionVisible(!isHiddenActionVisible)} />}
                    {isHiddenActionVisible &&
                        <div
                            className={`z-10 text-purple-800 dark:text-gray-200 bg-gray-300 shadow ${width} dark:bg-gray-700 absolute right-0 
                            ${opensUp ? '-top-3 origin-top transform -translate-y-full' : 'top-3 origin-bottom transform translate-y-full'}
                            p-1 inline-flex items-center justify-center cursor-pointer hover:text-purple-900 hover:bg-gray-200`}
                            onClick={handleHiddenActionSelected}>
                            From Another Mode
                        </div>}
                </div>
            </button>
            {
                isReplicationModalVisible &&
                <FormDialog
                    FormComponent={<ScopeReplicationSelector ref={scopeReplicationForm} />}
                    closeModal={closeModal}
                    modalHeading="Replicate Scopes and Instances from another mode"
                    className="!p-2 max-w-screen-lg !w-[80vw]"
                    actionBtnLabel="Replicate"
                    confirmAction={handleReplication}
                />
            }
        </>

    )
}

export default ScopeAdd;