/* eslint-disable @typescript-eslint/no-unused-vars */
import { MdOutlineDelete, MdOutlineEdit, MdOutlineRemoveRedEye } from "react-icons/md";
import { Link, useNavigate } from "react-router-dom";
import { IVision } from '../../interfaces';

const VisionCard = ({ details, editVisionHandler, deleteVisionHandler }:
    { details: IVision, editVisionHandler: (details: IVision) => void, deleteVisionHandler: (details: IVision) => void }) => {

    const navigate = useNavigate();

    function handleVisionSelection() {
        navigate(`/visions/${details.id}`);
    }

    return (
        <div className="w-full min-h-48 p-6 pb-3 bg-gray-200 border border-gray-300 rounded-sm shadow-md dark:bg-gray-800 dark:border-gray-700 
        font-inter flex flex-col">
            <div className="flex flex-col justify-start flex-1">
                <Link to={`/visions/${details.id}`}>
                    <h3 className="mb-2 text-xl font-inter font-medium tracking-tight text-purple-800 dark:text-white">{details.name}</h3>
                </Link>
                <p className="mb-3 text-sm font-normal text-gray-700 dark:text-gray-400">{details.description}</p>
            </div>
            <div className="flex items-center justify-between w-full mt-4 gap-4">
                <MdOutlineDelete
                    className="text-xl border border-dotted border-gray-400 p-1 w-8 h-8 cursor-pointer text-red-600 rounded-md"
                    title="Delete" onClick={e => deleteVisionHandler(details)} />
                <div className="flex items-center gap-2">
                    <MdOutlineEdit
                        className="text-xl border border-dotted border-gray-400 p-1 w-8 h-8 cursor-pointer text-blue-600 rounded-md"
                        title="Edit" onClick={e => editVisionHandler(details)} />
                    <Link to={`/visions/${details.id}`}>
                        <MdOutlineRemoveRedEye
                            className="text-xl border border-dotted border-gray-400 p-1 w-8 h-8 cursor-pointer text-gray-600 rounded-md"
                            title="View" onClick={handleVisionSelection} />
                    </Link>
                </div>
            </div>
        </div>
    );
};

export default VisionCard;