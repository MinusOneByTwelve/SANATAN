import React, { useState } from 'react';

const ToggleButton: React.FC = () => {
    const [isOn, setIsOn] = useState(true);

    const toggle = () => {
        setIsOn(!isOn);
    };

    return (
        <div
            onClick={toggle}
            className={`w-16 h-4 flex items-center bg-gray-300 rounded-full p-1 cursor-pointer ${isOn ? 'bg-green-500' : 'bg-gray-300'
                }`}
        >
            <div
                className={`bg-white w-4 h-2 rounded-full shadow-md transform transition-transform ${isOn ? 'translate-x-10' : ''
                    }`}
            />
        </div>
    );
};

export default ToggleButton;