/* eslint-disable @typescript-eslint/no-unused-vars */
import { useEffect, useRef, useState } from "react";
import { RiArrowDropDownLine, RiArrowDropUpLine } from "react-icons/ri";
import { ISelectorOption } from "../../interfaces";

const Selector = ({ currentSelection, options, optionSelected, opensUp, defaultLabel, className }:
    {
        currentSelection: ISelectorOption | undefined,
        options: ISelectorOption[],
        optionSelected: (option: ISelectorOption) => void,
        opensUp: boolean,
        defaultLabel: string,
        className?: string
    }) => {

    // console.log(currentSelection);
    // console.log(options);
    const [labelToShow, setLabelToShow] = useState(currentSelection?.label ?? defaultLabel);
    const [isOptionListVisible, setIsOptionListVisible] = useState(false);
    const dropdownRef = useRef<HTMLDivElement>(null);

    useEffect(() => {
        if (currentSelection) {
            setLabelToShow(currentSelection.label)
        }
    }, [currentSelection]);

    // Close dropdown if clicked outside
    useEffect(() => {
        const handleClickOutside = (event: MouseEvent) => {
            if (dropdownRef.current && !dropdownRef.current.contains(event.target as Node)) {
                setIsOptionListVisible(false);
            }
        };

        document.addEventListener('mousedown', handleClickOutside);
        return () => {
            document.removeEventListener('mousedown', handleClickOutside);
        };
    }, []);

    const handleOptionSelection = (option: ISelectorOption) => {
        setLabelToShow(option.label);
        setIsOptionListVisible(false);
        optionSelected(option);
    }

    return (
        <div className="relative" ref={dropdownRef}>
            <button id="selectorButton" data-dropdown-toggle="dropdown"
                className={`text-white bg-blue-700 hover:bg-blue-800 focus:ring-1 focus:outline-none focus:ring-blue-300 font-medium rounded-sm text-sm px-5 py-2.5 text-center inline-flex items-center justify-between dark:bg-blue-600 dark:hover:bg-blue-700 dark:focus:ring-blue-800 w-48 ${className}`} type="button"
                onClick={e => setIsOptionListVisible(!isOptionListVisible)}
            >{labelToShow}
                {!opensUp && <RiArrowDropDownLine className="text-xl" />}
                {opensUp && <RiArrowDropUpLine className="text-xl" />}
            </button>

            {isOptionListVisible &&
                <ul className={`z-10 text-sm text-gray-700 dark:text-gray-200 bg-white rounded-lg shadow w-44 dark:bg-gray-700 ${opensUp ? 'absolute left-0 right-0 -top-3 mt-2 origin-top transform -translate-y-full' : ''} ${className}`} aria-labelledby="selectorButton">
                    {
                        options.map(option => {
                            return (
                                <li key={option.id} onClick={e => handleOptionSelection(option)}>
                                    <span className="block px-4 py-2 hover:bg-gray-300 dark:hover:bg-gray-600 dark:hover:text-white border-b border-slate-300 cursor-pointer">{option.label}</span>
                                </li>
                            )
                        })
                    }
                </ul>
            }
        </ div>
    )
}

export default Selector;