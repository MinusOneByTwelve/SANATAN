import React, { ReactNode } from 'react';
import { MdClose, MdOutlineDelete } from 'react-icons/md';

interface DrawerProps {
    isOpen: boolean;
    onClose: () => void;
    ctaHandler: () => void;
    deleteHandler?: () => void;
    editLabel: string;
    FormComponent: ReactNode;
    modalHeading: string;
    additionalInfoHeader?: string;
    goMax?: boolean
    isDeleteEnabled?: boolean
}

const Drawer: React.FC<DrawerProps> = ({ isOpen, onClose, ctaHandler, FormComponent, editLabel, modalHeading, additionalInfoHeader, goMax, isDeleteEnabled, deleteHandler }) => {
    return (
        <div
            className={`fixed top-0 right-0 h-full ${goMax ? 'w-3/5' : 'w-96'} bg-white ${isOpen ? 'shadow-lg shadow-slate-400' : ''} transform transition-transform duration-300 z-50 ${isOpen ? 'translate-x-0' : 'translate-x-full'} flex flex-col`}
        >
            <div className="flex items-center justify-between p-4 md:p-5 rounded-t dark:border-gray-600">
                <h3 className="text-base font-medium text-gray-900 dark:text-white">
                    {modalHeading} - {additionalInfoHeader && <span className="text-xl text-purple-700">{additionalInfoHeader}</span>}
                </h3>
                <button type="button" className="text-gray-400 bg-transparent hover:bg-gray-200 hover:text-gray-900 rounded-lg text-sm w-8 h-8 ms-auto inline-flex justify-center items-center dark:hover:bg-gray-600 dark:hover:text-white"
                    onClick={onClose}
                >
                    <MdClose className="text-xl" />
                    <span className="sr-only">Close Drawer</span>
                </button>
            </div>
            <div className="p-4 flex-1 flex-grow overflow-y-auto">
                {FormComponent}
            </div>
            {/* <!-- Modal footer --> */}
            <div className="flex items-center justify-between p-4 md:p-5 border-gray-200 rounded-b dark:border-gray-600">
                {
                    isDeleteEnabled &&
                    <button type="button"
                        className="py-2.5 px-5 text-sm font-medium text-gray-900 focus:outline-none bg-white rounded-md border border-red-300 
                        hover:bg-red-300 hover:text-white
                        dark:bg-gray-800 dark:text-gray-400 dark:border-gray-600 dark:hover:text-white dark:hover:bg-gray-700 flex items-center"
                        onClick={deleteHandler}
                    ><MdOutlineDelete
                            className="text-base w-6 h-6 cursor-pointer text-red-500 rounded-md"
                            title="Delete" />
                        <span>Delete</span>
                    </button>
                }
                {/* <button type="button"
                    className="py-2.5 px-5 ms-3 text-sm font-medium text-gray-900 focus:outline-none bg-white rounded-lg border border-gray-200 hover:bg-gray-100 hover:text-blue-700 focus:z-10 focus:ring-4 focus:ring-gray-100 dark:focus:ring-gray-700 dark:bg-gray-800 dark:text-gray-400 dark:border-gray-600 dark:hover:text-white dark:hover:bg-gray-700"
                    onClick={onClose}
                >Cancel</button> */}
                <button type="button"
                    className="text-white bg-blue-700 hover:bg-blue-800 focus:ring-4 focus:outline-none focus:ring-blue-300 font-medium rounded-lg text-sm px-5 py-2.5 text-center dark:bg-blue-600 dark:hover:bg-blue-700 dark:focus:ring-blue-800"
                    onClick={ctaHandler}
                >{editLabel}</button>
            </div>
        </div >
    );
};

export default Drawer;