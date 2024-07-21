import { MdOutlineAddCircleOutline } from "react-icons/md";

const NewVisionCard = ({createNewVision}: {createNewVision: () => void}) => {
    return (
        <div className="w-full min-h-48 p-6 bg-gray-200 border border-gray-300 rounded-sm shadow-md dark:bg-gray-800 dark:border-gray-700 font-inter
            flex flex-col items-center justify-center cursor-pointer"
            onClick={createNewVision}
        >
            <MdOutlineAddCircleOutline className="text-8xl font-inter font-thin text-purple-600"/>
            <h2 className="text-purple-800">New Vision</h2>
        </div>
    );
};
  
export default NewVisionCard;