/* eslint-disable @typescript-eslint/no-unused-vars */
import { ReactNode } from "react";
import { MdClose } from "react-icons/md";

const FormDialog = ({ modalHeading, FormComponent, closeModal, confirmAction,
    actionBtnLabel, goMax, showHeader = true, showFormActions = true, className }:
    {
        modalHeading?: string,
        FormComponent: ReactNode,
        closeModal: () => void,
        confirmAction?: () => void;
        actionBtnLabel?: string;
        goMax?: boolean,
        showHeader?: boolean
        showFormActions?: boolean
        className?: string
    }) => {

    return (
        <div id="static-modal" tabIndex={-1} aria-hidden="true" className="overflow-y-auto overflow-x-hidden 
            fixed top-0 right-0 left-0 bottom-0 z-50 justify-center items-center w-full md:inset-0 h-[calc(100%-1px)] max-h-full bg-slate-700/70">
            <div className={`relative top-20 mx-auto p-4 w-full ${goMax ? 'max-w-screen-2xl' : 'max-w-2xl'} max-h-full ${className}`}>
                <div className="relative bg-gray-200 rounded-md shadow-md dark:bg-gray-700 flex flex-col h-[85vh] ">
                    {/* <!-- Modal header --> */}
                    {showHeader && <div className="flex items-center justify-between p-4 md:p-5 border-b border-gray-300 rounded-t dark:border-gray-600 h-16 mb-4">
                        <h3 className="text-xl font-medium text-gray-900 dark:text-white">
                            {modalHeading}
                        </h3>
                        <button type="button" className="text-gray-400 bg-transparent hover:bg-gray-200 hover:text-gray-900 rounded-lg text-sm w-8 h-8 ms-auto inline-flex justify-center items-center dark:hover:bg-gray-600 dark:hover:text-white"
                            onClick={e => closeModal()}
                        >
                            <MdClose className="text-xl" />
                            <span className="sr-only">Close modal</span>
                        </button>
                    </div>}
                    {/* <!-- Modal Body --> */}
                    <div className="px-2 md:px-4 py-4 space-y-4 flex-grow overflow-y-scroll scrollbar-hide">
                        {FormComponent}
                    </div>
                    {/* <!-- Modal footer --> */}
                    {showFormActions && <div className="flex items-center h-16 py-4 px-4 mt-4 justify-between border-t border-gray-300 rounded-b dark:border-gray-600">
                        <button type="button"
                            className="py-2.5 px-5 text-sm font-medium text-gray-900 focus:outline-none bg-white rounded-lg border border-gray-300 hover:bg-gray-100 hover:text-blue-700 focus:z-10 focus:ring-4 focus:ring-gray-100 dark:focus:ring-gray-700 dark:bg-gray-800 dark:text-gray-400 dark:border-gray-600 dark:hover:text-white dark:hover:bg-gray-700"
                            onClick={e => closeModal()}
                        >Cancel</button>
                        <button type="button"
                            className="text-white bg-blue-700 hover:bg-blue-800 focus:ring-4 focus:outline-none focus:ring-blue-300 font-medium rounded-lg text-sm px-5 py-2.5 text-center dark:bg-blue-600 dark:hover:bg-blue-700 dark:focus:ring-blue-800"
                            onClick={confirmAction}
                        >{actionBtnLabel}</button>
                    </div>}
                </div>
            </div>
        </div>
    )
}

export default FormDialog;
