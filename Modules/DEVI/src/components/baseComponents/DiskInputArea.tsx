/* eslint-disable @typescript-eslint/no-unused-vars */
/* eslint-disable @typescript-eslint/no-explicit-any */
import { customAlphabet } from 'nanoid';
import { useEffect, useState } from 'react';
import { MdOutlineAddCircleOutline, MdOutlineDelete } from 'react-icons/md';

const nanoid = customAlphabet('ABCDEF1234567890', 6);

interface IDisk {
    id: string;
    index: number;
    size?: number;
    diskType: string;
    isOs: boolean;
    internalDiskName: string;
}

const osDisk: IDisk = {
    id: nanoid(),
    index: 0,
    diskType: '',
    isOs: true,
    internalDiskName: `/opt/MatsyaPData/_`
}

const DiskInputArea: React.FC<{ entryModified: (details: any) => void }> = ({ entryModified }) => {
    const [disks, setDisks] = useState<IDisk[]>([osDisk]);

    function changeDiskValue(disk: IDisk, fieldName: string, value: string | number) {
        Object.assign(disk, {
            [fieldName]: value
        });

        setDisks(disks => {
            return disks.map((item, j) => {
                if (item.id === disk.id) {
                    return disk;
                } else {
                    return item;
                }
            });
        })
    }

    function addDisk() {
        setDisks(disks => {
            const newDisk = {
                id: nanoid(),
                index: disks.length + 1,
                diskType: '',
                isOs: false,
                internalDiskName: `/opt/MatsyaPData/_`
            }

            return disks.concat(newDisk);
        });
    }

    function removeDisk(diskId: string) {
        setDisks(disks => {
            return disks.filter(disk => disk.id !== diskId);
        });
    }

    useEffect(() => {
        entryModified({ disks: disks });
    }, [disks])

    return (
        <div className="grid grid-cols-6 items-center pt-4 font-inter">
            {/* <label className={`col-span-6 mb-2 font-medium text-base text-blue-800`}>
                Disk
            </label> */}
            <div className={`col-span-6`}>
                {disks.map((disk, index) => {
                    return (
                        <div className="grid grid-cols-12 gap-4 items-start mb-4 text-gray-700" key={disk.id}>
                            <div className="col-span-1">
                                {index + 1}
                            </div>
                            <div className="col-span-1 font-medium ">
                                {disk.isOs ? 'OS' : ''}
                            </div>
                            <div className="col-span-3 flex flex-col">
                                {/* <label className="col-span-6 mb-1 font-medium text-sm text-blue-800 flex gap-x-2 items-center">
                                    <InfoIcon text={"Disk Size. All sizes are in GB. 1TB = 1000 GB"} />
                                    <span>Disk size</span>
                                </label> */}
                                <input type="text" placeholder="Disk Capacity"
                                    className={`sizeInput w-full px-3 py-2 placeholder-blueGray-300 text-blueGray-600 relative bg-white rounded text-sm border border-gray-300 focus:border-gray-400 shadow-md outline-none focus:outline-none`}
                                    value={disk.size}
                                    onChange={(event) => event.target.value ? changeDiskValue(disk, 'size', event.target.value) : ''} />
                            </div>
                            <div className="col-span-3 flex flex-col">
                                {/* <label className="col-span-6 mb-1 font-medium text-sm text-blue-800 flex gap-x-2 items-center">
                                    <InfoIcon text={"Disk Type. SSD | HDD etc."} />
                                    <span>Disk type</span>
                                </label> */}
                                <input type="text" placeholder="Disk Type"
                                    className={`diskType px-3 py-2 placeholder-blueGray-300 text-blueGray-600 relative bg-white rounded text-sm border border-gray-300 focus:border-gray-400 shadow-md outline-none focus:outline-none w-full pl-3}`}
                                    value={disk.diskType}
                                    onChange={(event) => changeDiskValue(disk, 'diskType', event.target.value)} />
                                <p className="text-gray-600 mt-2 text-left text-[72%] break-words">

                                </p>
                            </div>
                            <div className="col-span-3 pl-4 italic font-medium tracking-wider text-sm">
                                <label>{`${disk.internalDiskName}${index}`}</label>
                            </div>
                            <div className="col-span-1 flex">
                                <MdOutlineAddCircleOutline
                                    className="text-2xl relative cursor-pointer text-green-800 rounded-md"
                                    title="Add Disk" onClick={e => addDisk()} />
                                {index > 0 &&
                                    <MdOutlineDelete
                                        className="text-2xl border cursor-pointer text-red-600 rounded-md"
                                        title="Remove Disk" onClick={e => removeDisk(disk.id)} />
                                }
                            </div>
                        </div>
                    )
                })}
            </div>
        </div>
    )
}

export default DiskInputArea;