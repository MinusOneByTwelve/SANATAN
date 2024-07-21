import { useEffect, useState } from "react";
import InfoIcon from "./InfoIcon";

interface ISingleInput {
    label: string,
    fieldName: string,
    iconName?: string,
    iconText?: string,
    hint?: string,
    labelSideBySide: boolean,
    value: string,
    disabled?: boolean
    entryModified: (details: { [key: string]: string }) => void
}

const SingleInputArea: React.FC<ISingleInput> = ({ label, fieldName, iconName, iconText, hint, labelSideBySide, value, entryModified, disabled }) => {

    const [inputValue, setInputValue] = useState('');

    const changeValue = (value: string) => {
        setInputValue(value);
        entryModified({ [fieldName]: value });
    }

    useEffect(() => {
        setInputValue(value);
    }, [value])

    return (
        <div className="grid grid-cols-6 items-center">
            <label className={`${labelSideBySide ? 'col-span-1' : 'col-span-6 mb-1'} font-medium text-[84%] text-blue-800 flex gap-x-2 items-center`}>
                {hint && <InfoIcon text={hint} />}
                <span>{label}</span>
            </label>
            <div className={`${labelSideBySide ? 'col-span-5' : 'col-span-6'}`}>
                <div className="relative flex w-full flex-wrap items-center">
                    {iconName &&
                        <span className="h-full leading-snug font-normal absolute text-center text-blueGray-300 bg-transparent rounded text-base items-center justify-center w-8 pl-3 py-2 z-10">
                            <img src={iconName} alt={iconText}></img>
                        </span>
                    }
                    <input type="text" placeholder={iconText}
                        className={`px-2 py-2 placeholder-blueGray-300 text-blueGray-600 relative bg-white rounded text-sm border border-gray-300 focus:border-gray-400 shadow-md outline-none focus:outline-none focus:ring ring-purple-100 w-full ${iconName ? 'pl-10' : 'pl-3'} ${disabled ? 'text-gray-400 bg-gray-200 cursor-not-allowed' : 'text-gray-700'}`}
                        value={inputValue}
                        disabled={disabled}
                        onChange={(event) => changeValue(event.target.value)} />
                </div>
                {/* <p className={`text-sm text-gray-400 mt-1 ${labelSideBySide ? 'text-right' : 'text-left'}`}>{hint}</p> */}
                {/* {hint && <p className={`text-gray-600 mt-2 text-left text-[72%] break-words`} dangerouslySetInnerHTML={{ __html: hint! }}></p>} */}
            </div>
        </div>
    )
}

export default SingleInputArea;