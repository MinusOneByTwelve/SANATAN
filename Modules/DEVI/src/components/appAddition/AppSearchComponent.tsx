import { useEffect, useState } from "react";
import { MdSearch } from "react-icons/md";
import useAppContext from "../../contexts/AppContext";
import { IAppOption } from "../../interfaces";
import AppCardInList from "./AppCardInList";

const AppSearchComponent = ({ addAppToInstance }: { addAppToInstance: (app: IAppOption) => void }) => {

    const { appsList } = useAppContext();
    const [searchText, setSearchText] = useState("");
    const [appsDisplayList, setAppsDisplayList] = useState<IAppOption[]>(appsList);

    const searchTextChanged = (value: string) => {
        setSearchText(value);
    }

    useEffect(() => {
        if (searchText.length > 0) {
            setAppsDisplayList(appsList.filter(app => {
                const nameIncludesSearchText = app.name.includes(searchText);
                const identifierIncludesSearchText = app.identifier?.includes(searchText);
                const suiteIncludesSearchText = app.suite?.includes(searchText)

                return nameIncludesSearchText || identifierIncludesSearchText || suiteIncludesSearchText;
            }))
        } else {
            setAppsDisplayList(appsList);
        }
    }, [searchText]);

    return (
        <>
            <div className="flex mb-2 sticky top-0 bg-gray-100 z-10 shadow-md">
                <span className="inline-flex items-center px-2 text-sm text-gray-900 bg-gray-200 border border-e-0 border-gray-400 rounded-s-md dark:bg-gray-600 dark:text-gray-400 dark:border-gray-600">
                    <MdSearch className="text-xl" />
                </span>
                <input type="text"
                    className="rounded-none bg-gray-50 border border-gray-400 focus:border-gray-600 focus:outline-none
                    text-gray-700 block flex-1 w-full text-base p-2.5 dark:bg-gray-700 dark:border-gray-600 dark:placeholder-gray-400 
                    dark:text-white" placeholder="App Search"
                    value={searchText}
                    onChange={(event) => searchTextChanged(event.target.value)}
                />
                <span className="inline-flex items-center px-2 text-xs text-gray-900 bg-gray-200 border border-l-0 border-gray-400 rounded-e-md dark:bg-gray-600 dark:text-gray-400 dark:border-gray-600">
                    {appsDisplayList.length} Apps
                </span>
            </div>
            <div className="shadow-md border-t border-gray-300">
                <ul className="font-inter divide-y divide-gray-300 shadow-md">
                    {appsDisplayList.map(app => {
                        return (
                            <AppCardInList app={app} addAppToInstance={addAppToInstance} key={app.id} />
                        )
                    })}
                </ul>
            </div>
        </>

    )
}

export default AppSearchComponent;