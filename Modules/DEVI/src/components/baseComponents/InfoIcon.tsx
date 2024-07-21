// src/components/InfoIcon.tsx
import React from 'react';
import styles from "../styles/infoIcon.styles.module.css";

interface InfoIconProps {
    text: string;
    className?: string;
}

const InfoIcon: React.FC<InfoIconProps> = ({ text, className }) => {
    return (
        <div className={`relative inline-block ${styles.tooltip}`}
        >
            <div
                className="flex items-center justify-center w-4 h-4 bg-blue-600 text-white text-xs rounded-full cursor-pointer opacity-70"
            >
                i
            </div>
            <div className={`absolute top-1 mt-1 w-56 p-2 bg-gray-700 text-white rounded shadow-lg text-[92%] 
                break-words z-20 ${styles.tooltipText} ${className}`}>
                <p className={`break-words`} dangerouslySetInnerHTML={{ __html: text! }}></p>
            </div>
        </div>
    );
};


export default InfoIcon;
