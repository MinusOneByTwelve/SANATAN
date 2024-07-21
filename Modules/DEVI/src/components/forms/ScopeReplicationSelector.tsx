import { forwardRef, useCallback, useEffect, useImperativeHandle, useState } from "react";
import { useParams } from "react-router-dom";
import useAppContext from "../../contexts/AppContext";
import { IInstance, IReplicationDetails, IScope, ISelectorOption, SameScopeNameResolutionOptions } from "../../interfaces";
import useAxiosAuth from "../../lib/hooks/useAxiosAuth";
import Loading from "../baseComponents/Loading";
import Selector from "../baseComponents/Selector";
import ScopeInstanceListViewCard from "../cards/ScopeInstanceListViewCard";

const ScopeReplicationSelector = forwardRef((props: unknown, ref) => {

    const { visionModes, currentMode } = useAppContext();
    const { visionId } = useParams();
    const axiosAuth = useAxiosAuth();

    const [modeChosen, setModeChosen] = useState<ISelectorOption>();
    const [isLoading, setIsLoading] = useState(false);

    const [scopeList, setScopeList] = useState<IScope[]>([]);

    const [replicationData, setReplicationData] = useState<{ [key: string]: IReplicationDetails }>({});
    const [sameScopeNameResolutionOption, setSameScopeNameResolutionOption] =
        useState<SameScopeNameResolutionOptions>(SameScopeNameResolutionOptions.COPY)

    const getScopesForSelectedMode = useCallback(async () => {
        setIsLoading(true);
        const { data }: { data: IScope[] } =
            await axiosAuth.get(`/scope/${visionId}/getAllScopes?fetchInstances=true&modeId=${modeChosen?.id}`).then(res => res.data);
        // const { modes } = data;

        setIsLoading(false);
        setScopeList(data);
    }, [visionId, modeChosen?.id]);

    useEffect(() => {
        if (modeChosen?.id) {
            getScopesForSelectedMode();
        }
    }, [modeChosen?.id]);

    useImperativeHandle(ref, () => ({
        getReplicationDetails() {
            return {
                replicationData,
                replicateToMode: currentMode?.value,
                replicateFromMode: modeChosen?.value,
                sameScopeNameResolutionOption
            }
        }
    }), [replicationData]);

    const selectionChanged = (scopeId: number, scopeSelected: boolean, instanceList: IInstance[]) => {
        setReplicationData({
            ...replicationData,
            [scopeId]: {
                isSelected: scopeSelected,
                selectedInstanceIds: instanceList.filter(instance => instance.isSelected).map(instance => instance.id)
            }
        })
        // console.log(scopeId, scopeSelected, instanceList);
    }

    return (
        <div className="px-4">
            <p className="text-sm text-gray-600 mb-4">This does not create links / references, but would copy over the selected <i>scopes & instances</i> to <b>{currentMode?.label}</b>. </p>

            <div className="flex mt-4 flex-wrap mb-4 shadow-sm p-4 justify-between">
                <div className="w-full text-gray-500 mb-2">
                    <p>Handle scopes with the same name?</p>
                </div>
                <div className="flex items-center">
                    <input id="replicate-copy" type="radio" name="sameScopeNameResolutionOption" className="w-4 h-4 border-gray-300 dark:focus:bg-blue-600 dark:bg-gray-700 dark:border-gray-600"
                        onChange={e => setSameScopeNameResolutionOption(SameScopeNameResolutionOptions.COPY)}
                        checked={sameScopeNameResolutionOption === SameScopeNameResolutionOptions.COPY} />
                    <div className="ms-2 text-sm">
                        <label htmlFor="replicate-copy" className="font-medium text-gray-700 dark:text-gray-300">Copy</label>
                        <p className="text-xs font-normal text-gray-500 dark:text-gray-400 -mt-0.5">
                            Mode will have duplicate names
                        </p>
                    </div>
                </div>

                <div className="flex items-center">
                    <input id="replicate-overwrite" type="radio" name="sameScopeNameResolutionOption" className="w-4 h-4 border-gray-300 dark:focus:bg-blue-600 dark:bg-gray-700 dark:border-gray-600"
                        onChange={e => setSameScopeNameResolutionOption(SameScopeNameResolutionOptions.OVERWRITE)}
                        checked={sameScopeNameResolutionOption === SameScopeNameResolutionOptions.OVERWRITE} />
                    <div className="ms-2 text-sm">
                        <label htmlFor="replicate-overwrite" className="font-medium text-gray-700 dark:text-gray-300">Overwrite</label>
                        <p className="text-xs font-normal text-gray-500 dark:text-gray-400 -mt-0.5">
                            Replaces the current scopes
                        </p>
                    </div>
                </div>

                <div className="flex items-center">
                    <input id="replicate-merge" type="radio" name="sameScopeNameResolutionOption" className="w-4 h-4 border-gray-300 dark:bg-gray-700 dark:border-gray-600"
                        onChange={e => setSameScopeNameResolutionOption(SameScopeNameResolutionOptions.MERGE)}
                        checked={sameScopeNameResolutionOption === SameScopeNameResolutionOptions.MERGE} />
                    <div className="ms-2 text-sm">
                        <label htmlFor="replicate-merge" className="font-medium text-gray-700 dark:text-gray-300">Merge</label>
                        <p className="text-xs font-normal text-gray-500 dark:text-gray-400 -mt-0.5">
                            Selected Instances will be added to existing scope
                        </p>
                    </div>
                </div>
            </div>

            {/* <hr className="border-gray-300/80 mt-4 mb-4" /> */}

            <label className="relative font-medium text-[96%] text-blue-800 gap-x-2 inline-flex items-center pr-2">
                <span>Mode Selected</span>
            </label>
            <Selector
                options={visionModes.filter(mode => mode.id !== currentMode?.id)}
                optionSelected={option => setModeChosen(option)}
                currentSelection={modeChosen}
                opensUp={false}
                defaultLabel="Select Mode To Replicate From"
                className="w-full border border-slate-400 bg-white !text-gray-700 hover:bg-gray-300 sticky top-0"
            />
            {isLoading && <Loading />}
            {!isLoading && scopeList.length > 0 &&
                <div className="mt-4 flex flex-wrap gap-5">
                    {scopeList.map((scope: IScope) => {
                        return (
                            <ScopeInstanceListViewCard scope={scope} key={scope.id} selectionChanged={selectionChanged} />
                        )
                    })}
                </div>
            }
        </div>
    )
});

export default ScopeReplicationSelector;