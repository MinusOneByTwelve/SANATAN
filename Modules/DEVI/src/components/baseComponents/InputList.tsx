// src/components/InputList.tsx
import React, { useState } from 'react';
import InfoIcon from './InfoIcon';

interface InputListProps {
    options: string[];
    label: string;
    hint: string;
    fieldName: string;
    inputListEntryChanged: (fieldName: string, value: string, isSelected: boolean) => void;
}

const InputList: React.FC<InputListProps> = ({ options, label, hint, fieldName, inputListEntryChanged }) => {
    const [inputValue, setInputValue] = useState('');
    const [filteredOptions, setFilteredOptions] = useState(options);
    const [showOptions, setShowOptions] = useState(false);

    const handleInputChange = (event: React.ChangeEvent<HTMLInputElement>) => {
        const value = event.target.value;
        setInputValue(value);

        if (value) {
            const newFilteredOptions = options.filter(option =>
                option.toLowerCase().includes(value.toLowerCase())
            );
            setFilteredOptions(newFilteredOptions);
            setShowOptions(newFilteredOptions.length > 0);
        } else {
            setShowOptions(false);
        }
        inputListEntryChanged(fieldName, value, false);
    };

    const handleOptionClick = (option: string) => {
        setInputValue(option);
        setShowOptions(false);

        inputListEntryChanged(fieldName, option, true);
    };

    return (
        <div className="relative w-full">
            <label className="mb-1 font-medium text-[84%] text-blue-800 flex gap-x-2 items-center">
                {hint && <InfoIcon text={hint} />}
                <span>{label}</span>
            </label>
            <input
                type="text"
                value={inputValue}
                onChange={handleInputChange}
                onFocus={() => setShowOptions(true)}
                className="px-2 py-2 placeholder-blueGray-300 text-blueGray-600 relative bg-white rounded text-sm border border-gray-300 focus:border-gray-400 shadow-md outline-none focus:outline-none focus:ring ring-purple-100 w-full"
            />
            {showOptions && (
                <ul className="absolute z-10 w-full mt-1 bg-white border border-gray-300 rounded shadow-lg">
                    {filteredOptions.length > 0 ? (
                        filteredOptions.map((option, index) => (
                            <li
                                key={index}
                                className="px-4 py-2 cursor-pointer hover:bg-gray-200"
                                onClick={() => handleOptionClick(option)}
                            >
                                {option}
                            </li>
                        ))
                    ) : (
                        inputValue && <li className="px-4 py-2 text-gray-500">No options found</li>
                    )}
                </ul>
            )}
        </div>
    );
};

export default InputList;
