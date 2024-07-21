// src/context/AppContext.tsx
import React, { ReactNode, createContext, useCallback, useContext, useEffect, useState } from 'react';
import { IAppOption, IMode, IProvider, ISecret, ISelectorOption } from '../interfaces';
import useAxiosAuth from '../lib/hooks/useAxiosAuth';

interface AppContextProps {
    secrets: ISecret[];
    providerList: IProvider[];
    appsList: IAppOption[];
    visionModes: ISelectorOption[];
    currentMode: ISelectorOption | undefined;
    setInitialSecrets: (secrets: ISecret[]) => void;
    addSecret: (secret: ISecret) => void;
    removeSecret: (secret: ISecret) => void;
    storeVisionModes: (modes: IMode[]) => void;
    storeSelectedMode: (modes: ISelectorOption) => void;
}

const AppContext = createContext<AppContextProps | undefined>(undefined);

export const AppProvider: React.FC<{ children: ReactNode }> = ({ children }) => {
    const [secrets, setSecrets] = useState<ISecret[]>([]);
    const [providerList, setProviderList] = useState<IProvider[]>([]);

    const [visionModes, setVisionModes] = useState<ISelectorOption[]>([]);
    const [currentMode, setCurrentMode] = useState<ISelectorOption>();

    const [appsList, setAppsList] = useState<IAppOption[]>([]);
    const axiosAuth = useAxiosAuth();

    const setInitialSecrets = (secrets: ISecret[]) => {
        setSecrets(secrets);
    }

    const addSecret = (secret: ISecret) => {
        setSecrets(prevItems => [...prevItems, secret]);
    };

    const removeSecret = (secret: ISecret) => {
        setSecrets(prevItems => prevItems.filter(i => i !== secret));
    };

    const getProviders = useCallback(async () => {
        const { data } = await axiosAuth.get(`/provider`).then(res => res.data);
        setProviderList(data);
    }, []);

    const getAppList = useCallback(async () => {
        const { data } = await axiosAuth.get(`/stack/options`).then(res => res.data);
        setAppsList(data);
    }, []);

    const storeVisionModes = (modes: IMode[]) => {
        const modifiedModes = modes.map((mode: IMode) => ({
            id: mode.modeId,
            label: mode.label,
            value: mode.modeId,
            color: mode.color
        }));
        setVisionModes(modifiedModes);
    }

    const storeSelectedMode = (mode: ISelectorOption) => {
        setCurrentMode(mode);
    }

    useEffect(() => {
        getProviders();
        getAppList();
    }, [getProviders, getAppList]);

    return (
        <AppContext.Provider value={{
            secrets, providerList, appsList, visionModes, currentMode,
            setInitialSecrets, addSecret, removeSecret, storeVisionModes, storeSelectedMode
        }}>
            {children}
        </AppContext.Provider>
    );
};

const useAppContext = () => {
    const context = useContext(AppContext);
    if (context === undefined) {
        throw new Error('useAppContext must be used within an AppProvider');
    }
    return context;
};

export default useAppContext;