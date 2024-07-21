import { customAlphabet } from 'nanoid';
import { forwardRef, useImperativeHandle, useState } from "react";
import { HexColorPicker } from "react-colorful";
import { MdOutlineAddCircleOutline, MdOutlineDelete } from 'react-icons/md';
import { IMode, IVision } from "../../interfaces";
import InfoIcon from '../baseComponents/InfoIcon';

const nanoid = customAlphabet('ABCDEF1234567890', 6);

const defaultMode: IMode = {
    modeId: nanoid(),
    label: 'Dev',
    color: '#3c2eab'
}

const modesHint = "A deployment environment is a configured setting where software is deployed, tested, and executed. It includes hardware, operating systems, application servers, and network configurations. These environments could mimic the production setting to ensure smooth transitions and reliable performance. We call them <b>MODES</b>";

const VisionCreationForm = forwardRef((props: { details: IVision | undefined }, ref) => {

    const [modes, setModes] = useState<IMode[]>([defaultMode]);
    const [colorSelectorModeId, setColorselectorModeId] = useState<string>("");

    const [details, setDetails] = useState({
        visionName: props.details?.name ?? "",
        visionDescription: props.details?.description ?? ""
    });

    function updateDetails(value: string, fieldName: string) {
        const newDetails = {
            ...details,
            [fieldName]: value
        }
        setDetails(newDetails);
    }

    function changeModeValue(mode: IMode, fieldName: string, value: string | number) {
        setModes(modes => {
            return modes.map((item) => {
                if (item.modeId === mode.modeId) {
                    return { ...mode, [fieldName]: value };
                } else {
                    return item;
                }
            });
        })
    }

    function addMode() {
        setModes(modes => {
            const newMode = {
                modeId: nanoid(),
                label: '',
                color: '#777'
            }
            return modes.concat(newMode);
        });
    }

    function removeMode(modeId: string) {
        setModes(modes => {
            return modes.filter(mode => mode.modeId !== modeId);
        });
    }

    function openBox(e: Event, mode: IMode) {
        e?.stopPropagation();
        setColorselectorModeId(mode.modeId);
    }

    function formClicked(e: Event) {
        // console.log(e);
        const classList = (e.target as Element).classList;
        // console.log(classList, Array.isArray(classList));
        if (classList.length > 0 && classList.contains('react-colorful__pointer')) {
            return;
        }
        setColorselectorModeId("");
    }

    useImperativeHandle(ref, () => ({
        sendDetails() {
            console.log(modes);
            return {
                visionName: details.visionName,
                visionDescription: details.visionDescription,
                modes
            }
        }
    }), [details, modes]);

    return (
        <form className="px-4 mx-auto" onClick={e => formClicked(e)}>
            <div className="relative z-0 w-full mb-8 group">
                <input type="string" name="visionName" id="visionName"
                    className="block py-2.5 px-0 w-full text-sm text-gray-800 bg-transparent border-0 border-b-2 border-gray-300 appearance-none dark:text-white dark:border-gray-600 dark:focus:border-blue-500 focus:outline-none focus:ring-0 focus:border-blue-600 peer" placeholder="" required
                    onInput={e => updateDetails((e.target as HTMLInputElement).value, "visionName")}
                    value={details.visionName}
                />
                <label htmlFor="visionName"
                    className="peer-focus:font-medium absolute text-sm text-gray-500 dark:text-gray-400 duration-300 transform -translate-y-6 scale-75 top-3 -z-10 origin-[0] peer-focus:start-0 rtl:peer-focus:translate-x-1/4 rtl:peer-focus:left-auto peer-focus:text-blue-600 peer-focus:dark:text-blue-500 peer-placeholder-shown:scale-100 peer-placeholder-shown:translate-y-0 peer-focus:scale-75 peer-focus:-translate-y-6">
                    Name
                </label>
            </div>
            <div className="relative z-0 w-full mb-8 group">
                <textarea name="visionDesc" id="visionDesc"
                    className="block py-2.5 px-0 w-full text-sm text-gray-800 bg-transparent border-0 border-b-2 border-gray-300 appearance-none dark:text-white dark:border-gray-600 dark:focus:border-blue-500 focus:outline-none focus:ring-0 focus:border-blue-600 peer" placeholder=" " required
                    onInput={e => updateDetails((e.target as HTMLInputElement).value, "visionDescription")}
                    value={details.visionDescription}
                />
                <label htmlFor="visionDesc"
                    className="peer-focus:font-medium absolute text-sm text-gray-500 dark:text-gray-400 duration-300 transform -translate-y-6 scale-75 top-3 -z-10 origin-[0] peer-focus:start-0 rtl:peer-focus:translate-x-1/4 peer-focus:text-blue-600 peer-focus:dark:text-blue-500 peer-placeholder-shown:scale-100 peer-placeholder-shown:translate-y-0 peer-focus:scale-75 peer-focus:-translate-y-6">
                    Description
                </label>
            </div>
            <div className="mt-2">
                <fieldset className="border border-gray-300 p-4 rounded-md">
                    <legend>Modes <InfoIcon text={modesHint} className={"w-[360px]"} /></legend>
                    <p className="mb-6 text-sm font-normal text-gray-500 dark:text-gray-400">Common modes are development, testing, staging, and production environments.</p>
                    {modes.map((mode, index) => {
                        return (
                            <div className="grid grid-cols-3 gap-4 mb-4 text-gray-700 items-center" key={mode.modeId}>
                                {/* <div className="col-span-1">
                                    {index + 1}
                                </div> */}
                                <div className="col-span-1 font-medium ">
                                    <input type="text" placeholder="Mode Label"
                                        className={`w-full px-3 py-2 text-blueGray-600 bg-slate-300 relative text-[92%] border-b border-gray-300 focus:border-gray-400 shadow-md outline-none focus:outline-none`}
                                        value={mode.label}
                                        onChange={(event) => changeModeValue(mode, 'label', event.target.value)} />
                                </div>
                                <div className="col-span-1 font-medium relative">
                                    <div onClick={e => openBox(e, mode)}
                                        className="w-20 h-6 rounded-xl" style={{ backgroundColor: `${mode.color}` }}>
                                    </div>
                                    {colorSelectorModeId === mode.modeId && <HexColorPicker color={mode.color} onChange={value => changeModeValue(mode, 'color', value)} className="!absolute mt-1 z-20" />}
                                </div>
                                <div className="col-span-1 flex gap-x-4">
                                    <MdOutlineAddCircleOutline
                                        className="text-2xl relative cursor-pointer text-green-800 rounded-md"
                                        title="Add Disk" onClick={e => addMode()} />
                                    {index > 0 &&
                                        <MdOutlineDelete
                                            className="text-2xl border cursor-pointer text-red-600 rounded-md"
                                            title="Remove Disk" onClick={e => removeMode(mode.id)} />
                                    }
                                </div>
                            </div>
                        )
                    })}
                </fieldset>
            </div>
        </form>
    )
});

export default VisionCreationForm;