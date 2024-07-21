import { forwardRef, useEffect, useImperativeHandle, useState } from "react";
import { IScope } from "../../interfaces";

const ScopeCreationForm = forwardRef((props: { details: IScope | undefined }, ref) => {

    const [details, setDetails] = useState({
        scopeName: props.details?.name ?? "",
        scopeDescription: props.details?.description ?? ""
    });

    useEffect(() => {
        // console.log(props.details);
        setDetails({
            scopeName: props.details?.name ?? "",
            scopeDescription: props.details?.description ?? ""
        })
    }, [props.details?.id])

    function updateDetails(value: string, fieldName: string) {
        // console.log(value, fieldName);
        const newDetails = {
            ...details,
            [fieldName]: value
        }
        setDetails(newDetails);
    }

    useImperativeHandle(ref, () => ({
        sendDetails() {
            return {
                scopeName: details.scopeName,
                scopeDescription: details.scopeDescription
            }
        }
    }), [details]);

    return (
        <form className="max-w-md mx-auto">
            <div className="relative z-0 w-full mb-8 group">
                <input type="string" name="scopeName" id="scopeName"
                    className="block py-2.5 px-0 w-full text-sm text-gray-900 bg-transparent border-0 border-b-2 border-gray-300 appearance-none dark:text-white dark:border-gray-600 dark:focus:border-blue-500 focus:outline-none focus:ring-0 focus:border-blue-600 peer" placeholder="" required
                    onInput={e => updateDetails((e.target as HTMLInputElement).value, "scopeName")}
                    value={details.scopeName}
                />
                <label htmlFor="scopeName"
                    className="peer-focus:font-medium absolute text-sm text-gray-500 dark:text-gray-400 duration-300 transform -translate-y-6 scale-75 top-3 -z-10 origin-[0] peer-focus:start-0 rtl:peer-focus:translate-x-1/4 rtl:peer-focus:left-auto peer-focus:text-blue-600 peer-focus:dark:text-blue-500 peer-placeholder-shown:scale-100 peer-placeholder-shown:translate-y-0 peer-focus:scale-75 peer-focus:-translate-y-6">
                    Name*
                </label>
            </div>
            <div className="relative z-0 w-full mb-8 group">
                <textarea name="scopeDescription" id="scopeDescription"
                    className="block py-2.5 px-0 w-full text-sm text-gray-900 bg-transparent border-0 border-b-2 border-gray-300 appearance-none dark:text-white dark:border-gray-600 dark:focus:border-blue-500 focus:outline-none focus:ring-0 focus:border-blue-600 peer" placeholder=" " required
                    onInput={e => updateDetails((e.target as HTMLInputElement).value, "scopeDescription")}
                    value={details.scopeDescription}
                />
                <label htmlFor="visionDesc"
                    className="peer-focus:font-medium absolute text-sm text-gray-500 dark:text-gray-400 duration-300 transform -translate-y-6 scale-75 top-3 -z-10 origin-[0] peer-focus:start-0 rtl:peer-focus:translate-x-1/4 peer-focus:text-blue-600 peer-focus:dark:text-blue-500 peer-placeholder-shown:scale-100 peer-placeholder-shown:translate-y-0 peer-focus:scale-75 peer-focus:-translate-y-6">
                    Description
                </label>
            </div>
        </form>
    )
});

export default ScopeCreationForm;