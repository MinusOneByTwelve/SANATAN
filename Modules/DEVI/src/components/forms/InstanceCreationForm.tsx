/* eslint-disable @typescript-eslint/no-explicit-any */
import { forwardRef, useEffect, useImperativeHandle, useState } from "react";
import useAppContext from "../../contexts/AppContext";
import { IProvider, IScope, ProviderAcronym, SecretType } from "../../interfaces";
import DiskInputArea from "../baseComponents/DiskInputArea";
import InfoIcon from "../baseComponents/InfoIcon";
import InputList from "../baseComponents/InputList";
import ProviderSelector from "../baseComponents/ProviderSelector";
import SingleInputArea from "../baseComponents/SingleInput";

const hints: { [key: string]: string } = {
    copies: 'Number of Instances',
    instanceType: 'Varying combinations of CPU, memory, storage, and networking capacity',
    region: '<i>Region Code / Region Label</i>. Instances would be provisioned here. Regions are separate geographic areas.',
    zone: 'Availability Zones consist of one or more discrete data centers ( within a region ), each with redundant power, networking, and connectivity, and housed in separate facilities.',
    count: 'Max 99',
    namingConvention: 'Default would be - {scopeName}_{provider}_{region}_{instanceType}. A uniqueId would be appended at the end.',
    secret: 'Credentials file - that would be used to create these resources. If a new one is provided, then the encryption key will also be needed.',
    secretsKey: 'The key that was used to encrypt this file.',
    serviceAccount: 'Specific for GCP, for creating these resources.'
}

const providerHints: { [key: string]: { [key: string]: string } } = {
    [ProviderAcronym.AWS]: {
        region: '<a href="https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/Concepts.RegionsAndAvailabilityZones.html" target="_blank" rel="noopener noreferrer"> AWS Region List </a>',
        instanceType: '<a href="https://aws.amazon.com/ec2/instance-types/" target="_blank" rel="noopener noreferrer"> AWS Instance type </a>'
    }
};

enum fieldNames {
    SECRETS_FILE = 'secretFileLocation',
    SECRETS_ENCRYPTION_KEY = 'secretsEncryptionKey',
    SERVICE_ACCOUNT_FILE = 'serviceAccountFileLocation',
    SERVICE_ACCOUNT_ENCRYPTION_KEY = 'serviceAccountEncryptionKey',
    REGION = 'region',
    INSTANCE_TYPE = 'instanceType',
}

const getHint = (fieldName: string, acronym: ProviderAcronym): string => {
    let hint = "";

    if (hints[fieldName]) {
        hint += hints[fieldName];
    }

    if (providerHints[acronym] && providerHints[acronym][fieldName]) {
        hint += `- ${providerHints[acronym][fieldName]}`;
    }

    return hint;
}

const InstanceCreationForm = forwardRef((props: { scopeDetails: IScope, details: any }, ref) => {

    const { scopeDetails, details } = props;

    const [providerSelected, setProviderSelected] = useState<IProvider | undefined>();
    const [instanceDetails, setInstanceDetails] = useState(details);

    const { secrets } = useAppContext();
    // console.log(secrets);

    const [isSecretSelected, setIsSecretsSelected] = useState<boolean>(false);
    const [isServiceAccountSelected, setIsServiceAccountSelected] = useState<boolean>(false);

    useEffect(() => {
        setInstanceDetails({
            ...instanceDetails,
        })
    }, []);

    useImperativeHandle(ref, () => ({
        sendDetails() {
            return {
                providerSelected,
                instanceDetails: {
                    ...instanceDetails,
                    isNewSecret: !isSecretSelected,
                    isNewServiceAccount: !isServiceAccountSelected,
                },
                scopeId: scopeDetails.id,
                visionId: scopeDetails.visionId
            }
        }
    }), [instanceDetails, providerSelected]);

    function providerSelectionChanged(providerSelected: IProvider) {
        setProviderSelected(providerSelected);
    }

    function entryModified(details: { [key: string]: number | string | undefined }) {
        // const key = Object.keys(details)[0];
        const _instanceDetails = {
            ...instanceDetails,
            ...details,
        };
        // console.log(_instanceDetails);
        setInstanceDetails(_instanceDetails);
    }

    function inputListEntryChanged(fieldName: string, value: string, isSelected: boolean) {
        // If an option was not selected, then there is need to show the place to enter the key
        if (fieldName === fieldNames.SECRETS_FILE) {
            setIsSecretsSelected(isSelected);
            let details;
            if (isSelected) {
                const selectedSecret = secrets.find(secret => secret.fileName === value);
                details = { [fieldName]: selectedSecret?.fileName };
            } else {
                details = { [fieldName]: value };
            }
            entryModified(details);
        }

        if (fieldName === fieldNames.SERVICE_ACCOUNT_FILE) {
            setIsServiceAccountSelected(isSelected);
            let details;
            if (isSelected) {
                const selectedServiceAccount = secrets.find(secret => secret.fileName === value);
                details = { [fieldName]: selectedServiceAccount?.fileName };
            } else {
                details = { [fieldName]: value };
            }
            entryModified(details);
        }
    }

    return (
        <form className="w-full mx-auto font-inter">
            <div className={`OneSetOfProvider rounded-sm border ${providerSelected ? '' : 'border-gray-300/60'}  
            p-4 m-2 min-h-40 relative`} style={{ borderColor: `${providerSelected?.providerColor}aa` }}>
                <div className="grid grid-cols-7 gap-4 items-center">
                    <div className="col-span-3">
                        <ProviderSelector providerSelectionChanged={providerSelectionChanged} />
                    </div>
                </div>
                {
                    providerSelected?.acronym === ProviderAcronym.AWS &&
                    <div className="grid grid-cols-12 gap-6 gap-y-6 mt-6">
                        <div className="col-span-3">
                            <SingleInputArea
                                label="Region"
                                fieldName={fieldNames.REGION}
                                iconName={`${import.meta.env.VITE_PUBLIC_URL}/assets/region.svg`} iconText="Region"
                                hint={getHint(fieldNames.REGION, ProviderAcronym.AWS)}
                                labelSideBySide={false}
                                value=''
                                entryModified={entryModified} />
                        </div>
                        <div className="col-span-2">
                            <SingleInputArea
                                label="Zone"
                                fieldName="zone"
                                hint={hints.zone}
                                labelSideBySide={false}
                                value=''
                                entryModified={entryModified} />
                        </div>
                        <div className="col-span-3">
                            <SingleInputArea
                                label="Instance Type"
                                fieldName="instanceType"
                                iconName={`${import.meta.env.VITE_PUBLIC_URL}/assets/instance.svg`}
                                hint={getHint(fieldNames.INSTANCE_TYPE, ProviderAcronym.AWS)}
                                labelSideBySide={false}
                                value=''
                                entryModified={entryModified} />
                        </div>
                        <div className="col-span-1">
                            <SingleInputArea label="Count"
                                fieldName="copies"
                                hint={hints.copies}
                                labelSideBySide={false}
                                value=''
                                entryModified={entryModified} />
                        </div>
                        <div className="col-span-3">
                            <SingleInputArea label="Naming Convention"
                                // disabled={true}
                                fieldName="namingConvention"
                                hint={hints.namingConvention}
                                labelSideBySide={false}
                                value={instanceDetails.namingConvention}
                                entryModified={entryModified} />
                        </div>
                    </div>
                }
                {
                    providerSelected && providerSelected?.acronym !== ProviderAcronym.AWS &&
                    <>
                        <hr className="border-gray-300/80 mt-7" />
                        <label className="relative -top-3 font-medium text-[84%] text-blue-800 gap-x-2 bg-gray-50 inline-flex items-center pr-2">
                            <InfoIcon text={"<p>Disk Size. All sizes are in GB. 1TB = 1000 GB</p> <p>Disk Type. SSD | HDD etc.</p>"} />
                            <span>Disk Details</span>
                        </label>
                        <DiskInputArea entryModified={entryModified} />
                    </>
                }
                <hr className="border-gray-300/80 mt-4 mb-4" />
                {
                    providerSelected?.needsSecretKey &&
                    <div className="grid grid-cols-4 gap-6">
                        <div className={`${isSecretSelected ? 'col-span-4' : 'col-span-2'}`}>
                            <InputList
                                options={secrets
                                    .filter(secret => secret.providerId === providerSelected.id && secret.type === SecretType.SECRET)
                                    .map(secret => secret.fileName)
                                }
                                label="Secrets File Location"
                                hint={hints.secret}
                                fieldName={fieldNames.SECRETS_FILE}
                                inputListEntryChanged={inputListEntryChanged}
                            />
                        </div>
                        {!isSecretSelected &&
                            <div className="col-span-2">
                                <SingleInputArea label="Encryption Key"
                                    fieldName={fieldNames.SECRETS_ENCRYPTION_KEY}
                                    hint={hints.secretsKey}
                                    labelSideBySide={false}
                                    value=''
                                    entryModified={entryModified} />
                            </div>
                        }
                    </div>
                }
                {
                    providerSelected?.needsServiceAccount &&
                    <>
                        <hr className="border-gray-300/80 my-6" />
                        <div className="grid grid-cols-4 gap-6">
                            <div className={`${isServiceAccountSelected ? 'col-span-4' : 'col-span-2'}`}>
                                <InputList
                                    options={secrets
                                        .filter(secret => secret.providerId === providerSelected.id && secret.type === SecretType.SERVICE_ACCOUNT)
                                        .map(secret => secret.fileName)
                                    }
                                    label="Service Account File Location"
                                    hint={hints.serviceAccount}
                                    fieldName={fieldNames.SERVICE_ACCOUNT_FILE}
                                    inputListEntryChanged={inputListEntryChanged}
                                />
                            </div>
                            {!isServiceAccountSelected &&
                                <div className="col-span-2">
                                    <SingleInputArea label="Encryption Key"
                                        fieldName={fieldNames.SERVICE_ACCOUNT_ENCRYPTION_KEY}
                                        hint={hints.secretsKey}
                                        labelSideBySide={false}
                                        value=''
                                        entryModified={entryModified} />
                                </div>
                            }
                        </div>
                    </>

                }
            </div>
        </form >
    )

});

export default InstanceCreationForm;

