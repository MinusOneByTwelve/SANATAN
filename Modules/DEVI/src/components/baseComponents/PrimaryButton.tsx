/* eslint-disable @typescript-eslint/no-explicit-any */
interface IProps {
    label: string, 
    callToAction: () => void, 
    className: string;
}

const PrimaryButton = (props: IProps) => {

    const {label, callToAction, className} = props;

    return (
        <button type="button" 
            className={`text-white bg-gradient-to-r from-purple-500 via-purple-600 to-purple-700 hover:bg-gradient-to-br focus:ring-1 focus:outline-none focus:ring-purple-300 dark:focus:ring-purple-800 font-medium rounded-md text-sm px-5 py-1.5 text-center uppercase ${className}`}
            onClick={callToAction}    
        >{label}</button>
    )
}

export default PrimaryButton;