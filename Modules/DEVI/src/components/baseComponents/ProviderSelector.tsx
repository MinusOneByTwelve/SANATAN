/* eslint-disable @typescript-eslint/no-unused-vars */
import { useState } from "react";
import { RiArrowDropDownLine } from "react-icons/ri";
import useAppContext from "../../contexts/AppContext";
import { IProvider } from "../../interfaces";


const ProviderSelector = ({ currentSelection, providerSelectionChanged }:
    { currentSelection?: IProvider | undefined, providerSelectionChanged: (selection: IProvider) => void }) => {

    const { providerList } = useAppContext();
    // const [providerList, setProviderList] = useState<IProvider[]>([]);
    // const axiosAuth = useAxiosAuth();

    const [optionSelected, setOptionSelected] = useState<IProvider | undefined>(currentSelection);
    const [isOptionListVisible, setIsOptionListVisible] = useState(false);

    // const getProviders = useCallback(async () => {
    //     const { data } = await axiosAuth.get(`/provider`).then(res => res.data);
    //     setProviderList(data);
    // }, []);

    // useEffect(() => {
    //     getProviders();
    // }, [getProviders]);

    const handleOptionSelection = (option: IProvider) => {
        setIsOptionListVisible(false);
        setOptionSelected(option);
        providerSelectionChanged(option);
    }

    return (
        <div className="w-full relative">
            <div id="selectorButton"
                className={`text-gray-800 bg-gray-200 hover:bg-gray-100 focus:outline-none font-medium rounded-t-md text-sm px-5 py-2.5 
                text-center dark:bg-slate-700 dark:hover:bg-slate-800 border ${optionSelected ? '' : 'border-gray-400'} flex items-center 
                justify-between w-full cursor-pointer`}
                style={{ borderColor: `${optionSelected?.providerColor}77` }}
                typeof="button"
                onClick={e => setIsOptionListVisible(!isOptionListVisible)}
            >{optionSelected ?
                <div className="flex items-center w-full gap-8">
                    <img src={`${import.meta.env.VITE_PUBLIC_URL}/assets/${optionSelected.icon}`} alt={optionSelected.name} className="h-9" />
                    <span>{optionSelected.name}</span>
                </div>
                : 'Select Provider'
                }
                <RiArrowDropDownLine className="text-xl" />
            </div>

            {isOptionListVisible &&
                <div className="z-10 bg-white rounded-sm shadow dark:bg-gray-700 w-full absolute border border-gray-300">
                    <ul className="text-sm text-gray-700 dark:text-gray-200 divide-y divide-gray-300" aria-labelledby="selectorButton">
                        {
                            providerList.map(provider => {
                                return (
                                    <li key={provider.id} onClick={e => handleOptionSelection(provider)} className="px-4 py-2 hover:bg-gray-200 dark:hover:bg-gray-600 dark:hover:text-white flex items-center gap-8 border-b min-h-16 cursor-pointer">
                                        <img src={`${import.meta.env.VITE_PUBLIC_URL}/assets/${provider.icon}`} alt={provider.name} className="h-9" />
                                        <span>{provider.name}</span>
                                    </li>
                                )
                            })
                        }
                    </ul>
                </div>
            }
        </div>
    )
}

export default ProviderSelector;