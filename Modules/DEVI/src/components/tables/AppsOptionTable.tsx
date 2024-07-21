import React, { useRef, useState } from "react";
import { MdClose, MdOutlineCheck, MdOutlineDelete, MdOutlineEdit } from "react-icons/md";
import { IAppOption } from "../../interfaces";
import useAxiosAuth from "../../lib/hooks/useAxiosAuth";
import PrimaryButton from "../baseComponents/PrimaryButton";
import styles from './stackOptionTable.styles.module.css';

const AppsOptionTable = ({ appsList }: { appsList: IAppOption[] }) => {

    const [displayStackOptionList, setDisplayStackOptionList] =
        useState(appsList.sort((s1, s2) => s1.name.localeCompare(s2.name)));
    const editOptionsRef = useRef<IAppOption>();

    const [editedOption, setEditedOption] = useState<IAppOption>();
    const [isAddingNewRow, setIsAddingNewRow] = useState<boolean>(false);

    const axiosAuth = useAxiosAuth();

    function editRow(editedStackOption: IAppOption) {
        setDisplayStackOptionList(displayStackOptionList.map(displayStackOption => {
            if (displayStackOption.id === editedStackOption.id) {
                setEditedOption({ ...displayStackOption });
                displayStackOption.isEditMode = true;
                editOptionsRef.current = displayStackOption;
            } else {
                displayStackOption.isEditMode = false;
            }

            return displayStackOption;
        }));
    }

    function deleteRow(stackOption: IAppOption) {
        setDisplayStackOptionList(
            displayStackOptionList.filter(displayStackOption => displayStackOption.id !== stackOption.id)
        );
    }

    function cancelEdit() {
        if (isAddingNewRow) {
            setDisplayStackOptionList(
                displayStackOptionList.filter(displayStackOption => displayStackOption.id !== editedOption?.id)
            );
            setIsAddingNewRow(false);
        } else {
            setDisplayStackOptionList(
                displayStackOptionList.map(displayStackOption => {
                    if (editedOption && displayStackOption.id === editedOption?.id) {
                        return editedOption;
                    }
                    return displayStackOption;
                })
            );
        }
    }

    function addNewStackOptionItem() {
        console.log(isAddingNewRow);
        if (isAddingNewRow) {
            return;
        }
        const newRow = {
            id: Math.ceil((Math.random() * 1000) + 50),
            name: "New Stack Option",
            isEditMode: true,
        }
        setEditedOption({ ...newRow });
        editOptionsRef.current = newRow;
        const modifiedStackOptionList = [...displayStackOptionList, newRow];
        setDisplayStackOptionList(modifiedStackOptionList);
        setIsAddingNewRow(true);
    }

    async function saveChanges(editedStackOption: IAppOption) {
        if (isAddingNewRow) {
            await axiosAuth.post('/stack/options', {
                data: {
                    ...editedStackOption,
                }
            }).then(res => res.data);
            setIsAddingNewRow(false);
        } else {
            await axiosAuth.patch('/stack/options', {
                data: {
                    ...editedStackOption,
                }
            }).then(res => res.data);
        }

        setDisplayStackOptionList(displayStackOptionList.map(displayStackOption => {
            if (displayStackOption.id === editedStackOption.id) {
                setEditedOption(undefined);
                displayStackOption.isEditMode = false;
                return editedStackOption;
            }
            return displayStackOption;
        }));
    }

    return [
        // <div className="relative w-full overflow-x-auto shadow-md">
        <div className="h-[720px] overflow-y-auto scrollbar-thin scrollbar-short block w-full pb-4 relative">
            <table className="min-w-full divide-y divide-gray-200 text-sm text-left rtl:text-right text-gray-500 dark:text-gray-400">
                <caption className="pt-5 pb-6 text-base font-semibold text-left rtl:text-right text-gray-900 bg-white dark:text-white dark:bg-gray-800">
                    Stack List Details
                    <p className="mt-1 text-sm font-normal text-gray-500 dark:text-gray-400 max-w-screen-xl">Here are the details for the stack items. The system includes a default list of software versions, along with their download URLs. <br /> You have the flexibility to edit all of these details, including the icons and default properties. You can also add new stack entries here, which will be visible across all visions.</p>
                </caption>
                <thead className="text-xs text-gray-600 uppercase bg-gray-50 dark:bg-gray-700 dark:text-gray-400 sticky top-0 z-10">
                    <tr className="w-full bg-gray-50">
                        <th scope="col" className="px-4 py-2 min-w-48 underline sticky left-0 bg-white">
                            Stack name
                        </th>
                        <th scope="col" className="px-4 py-2 min-w-20 underline">
                            Version
                        </th>
                        <th scope="col" className="px-4 py-2 min-w-64 max-w-72 underline">
                            Download Url
                        </th>
                        <th scope="col" className="px-4 py-2 min-w-32 max-w-72 underline">
                            Icon Url
                        </th>
                        <th scope="col" className="px-4 py-2 min-w-48 underline">
                            Suite ( version )
                        </th>
                        <th scope="col" className="px-4 py-2 min-w-32 underline">
                            Identifier
                        </th>
                        <th scope="col" className="px-4 py-2 min-w-28 underline">
                            Is Open
                        </th>
                        <th scope="col" className="px-4 py-2 min-w-96 max-w-96 underline">
                            Properties
                        </th>
                    </tr>
                </thead>
                <tbody>
                    {
                        displayStackOptionList.map(stackOption => {
                            return (
                                <React.Fragment key={stackOption.id}>
                                    {!stackOption.isEditMode &&
                                        <tr className="text-[96%] bg-white border-b dark:bg-gray-800 dark:border-gray-700 w-full text-gray-700 hover:bg-gray-300 dark:hover:bg-gray-600 align-middle relative group">
                                            <th className="px-4 py-3 text-[110%] min-w-48 whitespace-nowrap dark:text-white sticky left-0 bg-white group-hover:bg-gray-300">
                                                <div className="h-[100%] flex items-center">
                                                    <div className="flex flex-col">
                                                        <span className="font-medium text-blue-900">{stackOption.name}</span>
                                                        {stackOption.suite && <span className="text-[96%] text-gray-500">{stackOption.suite} - {stackOption.suiteVersion}</span>}
                                                    </div>
                                                    <MdOutlineEdit
                                                        className="ml-2 w-5 h-5 cursor-pointer text-blue-600 hidden hover:text-blue-900 box-content group-hover:inline" title="Edit"
                                                        onClick={e => editRow(stackOption)} />
                                                </div>
                                            </th>
                                            <td className="px-4 py-3 min-w-20">
                                                {stackOption.version}
                                            </td>
                                            <td className="px-4 py-3 break-words min-w-64 max-w-72">
                                                {stackOption.downloadUrl === "" ? 'N.A' : stackOption.downloadUrl}
                                            </td>
                                            <td className="px-4 py-3 break-words min-w-32 max-w-72">
                                                <img src={stackOption.iconUrl}
                                                    className="w-10 h-10 box-border inline border-dotted border border-purple-600 rounded-full p-0.5"
                                                    alt={stackOption.name} />
                                                {/* {stackOption.iconUrl} */}
                                            </td>
                                            <td className="px-4 py-3 min-w-48">
                                                {stackOption.suite} - {stackOption.suiteVersion}
                                            </td>
                                            <td className="px-4 py-3 min-w-20">
                                                {stackOption.identifier}
                                            </td>
                                            <td className="px-4 py-3 min-w-28">
                                                {stackOption.isOpen ? 'True' : '-'}
                                            </td>
                                            <td className="px-4 py-3 min-w-96 max-w-96">
                                                {JSON.stringify(stackOption.properties, null, 2)}
                                            </td>
                                        </tr>
                                    }
                                    {stackOption.isEditMode && editOptionsRef.current &&
                                        <>
                                            <tr className="bg-slate-300 dark:bg-gray-800 dark:border-gray-700 w-full text-gray-700 dark:hover:bg-gray-600 align-middle relative group text-[96%]"
                                                key={stackOption.id}>
                                                <th className="px-4 py-3 text-[110%] min-w-48 font-medium text-blue-900 whitespace-nowrap dark:text-white sticky left-0 bg-slate-300">
                                                    {
                                                        isAddingNewRow ?
                                                            <input type="text" id="version-input" className={`${styles.tableEditInput}`}
                                                                onChange={e => editOptionsRef.current ?
                                                                    editOptionsRef.current.name = e.target.value : null}
                                                                defaultValue={stackOption.name}
                                                            /> : <span>{stackOption.name}</span>
                                                    }
                                                </th>
                                                <td className="px-4 py-3 min-w-20">
                                                    {
                                                        (typeof stackOption.version === 'string' || isAddingNewRow) ?
                                                            <input type="text" id="version-input" className={`${styles.tableEditInput}`}
                                                                onChange={e => editOptionsRef.current ?
                                                                    editOptionsRef.current.version = e.target.value : null}
                                                                defaultValue={stackOption.version}
                                                            /> : 'N.A'
                                                    }
                                                </td>
                                                <td className="px-4 py-3 break-words min-w-64 max-w-72">
                                                    <input type="text" id="downloadUrl-input" className={`${styles.tableEditInput}`}
                                                        onChange={e => editOptionsRef.current ?
                                                            editOptionsRef.current.downloadUrl = e.target.value : null}
                                                        defaultValue={stackOption.downloadUrl}
                                                    />
                                                </td>
                                                <td className="px-4 py-3 break-words min-w-64 max-w-72">
                                                    <input type="text" id="iconUrl-input" className={`${styles.tableEditInput}`}
                                                        onChange={e => editOptionsRef.current ?
                                                            editOptionsRef.current.iconUrl = e.target.value : null}
                                                        defaultValue={stackOption.iconUrl}
                                                    />
                                                </td>
                                                <td className="px-4 py-3 min-w-48">
                                                    <input type="text" id="suite-input" className={`${styles.tableEditInput}`}
                                                        onChange={e => {
                                                            if (editOptionsRef.current) {
                                                                const values = e.target.value.split("-");
                                                                if (values.length > 1) {
                                                                    editOptionsRef.current.suite = values[0]?.trim();
                                                                    editOptionsRef.current.suiteVersion = values[1]?.trim();
                                                                }
                                                            }
                                                        }}
                                                        defaultValue={`${stackOption.suite ?? "suite"} - ${stackOption.suiteVersion ?? "version"}`}
                                                    />
                                                </td>
                                                <td className="px-4 py-3 min-w-20">
                                                    <input type="text" id="identifier-input" className={`${styles.tableEditInput}`}
                                                        onChange={e => editOptionsRef.current ?
                                                            editOptionsRef.current.identifier = e.target.value : null}
                                                        defaultValue={stackOption.identifier}
                                                    />
                                                </td>
                                                <td className="px-4 py-3 min-w-28">
                                                    {stackOption.isOpen ? 'True' : '-'}
                                                </td>
                                                <td className="px-4 py-3 min-w-96 max-w-96">
                                                    <pre>
                                                        <textarea id="properties-input" rows={6}
                                                            className={`${styles.tableEditInput} whitespace-pre-line`}
                                                            onChange={e => editOptionsRef.current ?
                                                                editOptionsRef.current.properties = JSON.parse(e.target.value) : null}
                                                            defaultValue={JSON.stringify(stackOption.properties, null, "\t")}
                                                        />
                                                    </pre>
                                                </td>
                                            </tr>
                                            <tr className="w-full">
                                                <td className="absolute right-0 flex items-center justify-between gap-3 space-x-2 bg-slate-300 p-4 z-10">
                                                    <MdClose
                                                        className="text-3xl cursor-pointer font-semibold text-blue-700 hover:text-blue-900 border border-dashed border-gray-400" title="Cancel"
                                                        onClick={cancelEdit}
                                                    />
                                                    <MdOutlineCheck
                                                        className="text-3xl cursor-pointer font-semibold text-green-700 hover:text-green-900 border border-dashed border-gray-400" title="Save"
                                                        onClick={e => saveChanges(stackOption)}
                                                    />
                                                    <MdOutlineDelete
                                                        className="text-3xl cursor-pointer font-semibold text-red-600 hover:text-red-900 border border-dashed border-gray-400" title="Delete"
                                                        onClick={e => deleteRow(stackOption)} />
                                                </td>
                                            </tr>
                                        </>
                                    }
                                </ React.Fragment>
                            )
                        })
                    }
                </tbody>
            </table>
        </div>,
        <PrimaryButton callToAction={addNewStackOptionItem} label="Add New Stack Item" className="w-full mt-4 shadow-2xl shadow-purple-600" />]
    // </div>
}

export default AppsOptionTable