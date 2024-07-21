import { useEffect, useState } from "react";
import { IAppOption, IInstance, NA } from "../../interfaces";

import { FaExpandAlt } from "react-icons/fa";
import { FaHeartCircleExclamation } from "react-icons/fa6";
import useAppContext from "../../contexts/AppContext";

interface ThumbnailCardProps {
    instance: IInstance,
    expandInstance: (id: number) => void
}

const InstanceThumbnailCard: React.FC<ThumbnailCardProps> = ({ instance, expandInstance }) => {

    const [hasIp, setHasIp] = useState<boolean>(instance.ip !== NA);
    const { providerList, appsList } = useAppContext();

    const [instanceApps, setInstanceApps] = useState<{ iconUrl: string; name: string; isUnfulfilled: boolean; id: number }[]>([]);

    const parsedConfigurationDetails =
        typeof instance.configurationDetails === 'string' ? JSON.parse(instance.configurationDetails) : (instance.configurationDetails ?? {});

    useEffect(() => {
        setHasIp(instance.ip !== NA);

        const modifiedApps = instance.apps?.map(app => {
            const additionalDetails: IAppOption | undefined = appsList.find(appListItem => appListItem.identifierId === app.appId);
            return {
                iconUrl: additionalDetails?.iconUrl ?? "",
                name: additionalDetails?.name ?? "",
                isUnfulfilled: app.isUnfulfilled,
                id: app.id
            }
        });
        setInstanceApps(modifiedApps);
    }, [instance]);

    console.log("Rerendering Instance - ", instance.id, " - Scope Id ", instance.scopeId);

    return (
        <>
            <div className={`instanceCardThumbnail rounded-md shadow-md bg-white inline-block resize min-w-48 max-w-xs min-h-36 relative border`}
                style={{ borderColor: `${providerList.find(provider => provider.id === instance.providerId)?.providerColor}aa` ?? '#777' }}>
                <header className="w-full rounded-tl-md rounded-tr-md relative flex justify-between items-center gap-8"
                    style={{ backgroundColor: `${providerList.find(provider => provider.id === instance.providerId)?.providerColor}aa` ?? '#777' }}>

                    <div>
                        <p className="px-3 py-2 pb-0.5 text-xs font-medium text-gray-900 capitalize">{instance.name}</p>
                        {parsedConfigurationDetails?.instanceType &&
                            <p className="px-3 pb-2 text-xs font-medium text-gray-600 italic">
                                {parsedConfigurationDetails?.region} | {parsedConfigurationDetails?.instanceType}
                            </p>
                        }
                    </div>
                    <FaExpandAlt className="mr-2 cursor-pointer text-gray-700" title="Edit" onClick={e => expandInstance(instance.id)} />
                </header>

                <main className="flex flex-wrap p-2 gap-2">
                    {instanceApps.length === 0
                        && <span className="text-xs text-gray-500">Stack would show up here</span>
                    }
                    {
                        instanceApps.length > 0 && instanceApps.map(instanceApp => {
                            return (
                                <div className="relative" key={instanceApp.id}>
                                    <img src={instanceApp.iconUrl}
                                        className={`w-12 h-12 box-border inline ${instanceApp.isUnfulfilled ? 'border-red-500 border shadow-xl shadow-red-200' : 'border-green-600 border shadow-xl shadow-green-200'} rounded-full p-0.5`}
                                        alt={instanceApp.name} title={instanceApp.name} />
                                    {/* {instanceApp.isUnfulfilled && <div className="absolute -left-2 -top-2 bg-red-200 p-1 rounded-full">
                                        <FaExclamation className="w-3 h-3 text-red-800" title="Not Deployed" />
                                    </div>} */}
                                </div>
                            )

                        })
                    }
                </main>

                {!hasIp && <FaHeartCircleExclamation className="fill-current text-red-400 text-base absolute"
                    style={{ right: '2px', bottom: '2px' }} />
                }
            </div>
        </>

    )
}

export default InstanceThumbnailCard;