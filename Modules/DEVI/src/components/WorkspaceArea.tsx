/* eslint-disable @typescript-eslint/no-explicit-any */
import { MouseEvent, useCallback, useEffect, useRef, useState } from 'react';
import { Link, useParams } from 'react-router-dom';
import styles from '../components/styles/workspaceArea.styles.module.css';
import useAppContext from '../contexts/AppContext';
import { IMode, IScope, IScopeForm, ISelectorOption, IVision } from '../interfaces';
import useAxiosAuth from '../lib/hooks/useAxiosAuth';
import ScopeAdd from './ScopeAdd';
import Drawer from './baseComponents/Drawer';
import FormDialog from './baseComponents/FormDialog';
import Loading from './baseComponents/Loading';
import ScopeCard from './cards/ScopeCard';
import ScopeCreationForm from './forms/ScopeCreationForm';

import { FaRegListAlt } from "react-icons/fa";
import { MdSettings } from "react-icons/md";
import ToggleButton from './baseComponents/ToggleButton';

import { FaUpload } from "react-icons/fa6";
import { GiLoad } from "react-icons/gi";
import { LuKeySquare } from "react-icons/lu";
import Selector from './baseComponents/Selector';

const WorkspaceArea = () => {

  const { visionId } = useParams();

  const { setInitialSecrets, storeVisionModes, storeSelectedMode } = useAppContext();

  const [scopeList, setScopeList] = useState<IScope[]>([]);

  const [availableModes, setAvailableModes] = useState<ISelectorOption[]>([]);
  const [modeChosen, setModeChosen] = useState<ISelectorOption>();
  // const [secretsList, setSecretsList] = useState<ISecret[]>([]);

  const [isCreateModalVisible, setIsCreateModalVisible] = useState<boolean>(false);
  const [isLoading, setIsLoading] = useState<boolean>(false);

  const [isEditModalVisible, setIsEditModalVisible] = useState<boolean>(false);
  const [currentSelectedScope, setCurrentSelectedScope] = useState<IScope>();

  const [clickedPosition, setClickedPosition] = useState<{ x: number, y: number }>({ x: -1, y: -1 });
  const [selectedNode, setSelectedNode] = useState<number | null>(null);

  const scopeCreationForm = useRef(null);
  const scopeEditForm = useRef(null);

  const axiosAuth = useAxiosAuth();

  // Get current modes and store them in context
  const getCurrentVisionModes = useCallback(async () => {
    setIsLoading(true);
    const { data }: { data: IVision } = await axiosAuth.get(`/vision/${visionId}`).then(res => res.data);
    setIsLoading(false);

    const modesDataModified: ISelectorOption[] = (data.modes ?? []).map((mode: IMode) => ({
      id: mode.modeId,
      label: mode.label,
      value: mode.modeId,
      color: mode.color
    }))

    // console.log("modesDataModified :", modesDataModified);
    setAvailableModes(modesDataModified);
    setModeChosen(modesDataModified[0]);

    // AppContext Persists
    storeVisionModes(data.modes ?? []);
    storeSelectedMode(modesDataModified[0]);
  }, []);

  useEffect(() => {
    getCurrentVisionModes();
  }, [getCurrentVisionModes])

  // Gets the scope list - sets their x & y Pos to random values, if they don't exist previously and then persists them
  const getCurrentScopes = useCallback(async () => {
    setIsLoading(true);
    const { data }: { data: IVision } =
      await axiosAuth.get(`/vision/${visionId}?scopes=true&modeId=${modeChosen?.id}`).then(res => res.data);
    const scopes = data.scopes ?? [];
    // const { modes } = data;

    const processedData: IScope[] = scopes?.map((scopeItem: IScope) => {
      const { xPos, yPos } = assignRandomPos(scopeItem);

      const patchObject: any = {};
      let isPatchRequired = false;

      if (scopeItem.xPos === -1) {
        patchObject.xPos = xPos;
        isPatchRequired = true;
      }

      if (scopeItem.xPos === -1) {
        patchObject.yPos = yPos;
        isPatchRequired = true;
      }

      if (isPatchRequired) {
        axiosAuth.patch(`/scope/${scopeItem.id}`, {
          data: patchObject
        }).then(res => res.data);
      }

      return {
        ...scopeItem,
        xPos,
        yPos,
        prevPos: { xPos, yPos }
      }
    });
    setIsLoading(false);
    setScopeList(processedData);
  }, [visionId, modeChosen?.id]);

  const getCurrentSecrets = useCallback(async () => {
    const { data: secretsData } = await axiosAuth.get(`/secrets/${visionId}`).then(res => res.data);
    console.log(secretsData);
    setInitialSecrets(secretsData);
  }, [visionId]);

  useEffect(() => {
    if (modeChosen?.id) {
      getCurrentScopes();
      getCurrentSecrets();
    }
  }, [getCurrentScopes, getCurrentSecrets, modeChosen]);

  useEffect(() => {
    setSelectedNode(null);
  }, [])

  /*************** Scope creation & edit ********************/
  function createNewScope() {
    setIsCreateModalVisible(true);
  }

  async function handleCreation() {
    if (scopeCreationForm.current) {
      const details: IScopeForm = scopeCreationForm.current?.sendDetails();
      const createdScope = await axiosAuth.post('/scope', {
        data: {
          name: details.scopeName,
          description: details.scopeDescription,
          visionId,
          modeId: modeChosen?.id
        }
      }).then(res => res.data);
      setIsCreateModalVisible(false);

      const { xPos, yPos } = assignRandomPos(createdScope);
      Object.assign(createdScope, {
        xPos, yPos
      })

      setScopeList([...scopeList, createdScope]);
    }
  }

  const editScopeHandler = (details: IScope) => {
    setCurrentSelectedScope(details);
    setIsEditModalVisible(true);
  };

  async function handleEdit() {
    if (scopeEditForm.current) {
      const details: IScopeForm = scopeEditForm.current?.sendDetails();
      await axiosAuth.patch(`/scope/${currentSelectedScope?.id}`, {
        data: {
          name: details.scopeName,
          description: details.scopeDescription
        }
      }).then(res => res.data);
      setIsEditModalVisible(false);

      setScopeList((scopeList) => scopeList.map((scopeNode) => {
        if (scopeNode.id === currentSelectedScope?.id) {
          return {
            ...scopeNode,
            name: details.scopeName,
            description: details.scopeDescription,
          }
        }

        return scopeNode;
      }))
    }
  }

  const deleteScopeHandler = async () => {
    await axiosAuth.delete(`/scope/${visionId}/${currentSelectedScope?.id}`).then(res => res.data);
    // await getCurrentScopes();

    setScopeList((scopeList) => scopeList.filter(scopeNode => scopeNode.id !== currentSelectedScope?.id));

    // setCurrentSelectedScope(undefined);
    setIsEditModalVisible(false);
  };
  /*************** Scope creation & edit ********************/


  /*************** Modal Close ********************/
  function closeModal() {
    setIsCreateModalVisible(false);
  }

  function closeEditModal() {
    setIsEditModalVisible(false);
  }
  /*************** Modal Close *********************/


  /*************** Mouse Drag Handlers *******************/
  function handleMouseUpOnBoard() {
    setClickedPosition({ x: -1, y: -1 });

    if (selectedNode) {
      // console.log(deltaX, deltaY);
      const scopeNode = scopeList.find(node => node.id === selectedNode);
      if (scopeNode) {
        axiosAuth.patch(`/scope/${scopeNode.id}`, {
          data: {
            xPos: scopeNode.xPos,
            yPos: scopeNode.yPos
          }
        }).then(res => res.data);
      }
    }

    setSelectedNode(null);
  }

  function handleMouseMoveOnBoard(event: MouseEvent) {
    if (clickedPosition.x > 0 && clickedPosition.y > 0) {
      const deltaX = event.clientX - clickedPosition.x;
      const deltaY = event.clientY - clickedPosition.y;

      // console.log(selectedNode);
      if (selectedNode) {
        // console.log(deltaX, deltaY);
        setScopeList((scopeList) => scopeList.map((scopeNode) => {
          if (scopeNode.id === selectedNode) {
            const newXPos = capXPos(scopeNode.prevPos.xPos + deltaX);
            // newXPos = newXPos > 20 ? newXPos : 20;

            const newYPos = capYPos(scopeNode.prevPos.yPos + deltaY);
            // newYPos = newYPos > 20 ? newYPos : 20;

            return {
              ...scopeNode,
              xPos: newXPos,
              yPos: newYPos
            }
          }

          return scopeNode;
        }))
        // const scopeNode = scopeList.find(node => node.id === selectedNode);
        // if (scopeNode) {
        //   console.log("Updating scopeNode");
        //   scopeNode.xPos = scopeNode.prevPos.xPos + deltaX;
        //   scopeNode.yPos = scopeNode.prevPos.yPos + deltaY;
        // }
      }
    }
  }

  function handleOnMouseDownScopeNode(id: number, event: MouseEvent) {
    // console.log(id, event.clientX, event.clientY);
    setSelectedNode(id);
    setClickedPosition({ x: event.clientX, y: event.clientY });

    const scopeNode = scopeList.find(node => node.id === id);
    if (scopeNode) {
      scopeNode.prevPos = {
        xPos: scopeNode.xPos,
        yPos: scopeNode.yPos
      }
    }
  }
  /*************** Mouse Drag Handlers *******************/


  async function refreshScope() {
    await getCurrentScopes();
  }

  return (
    // <div className={`${isNavbarOpen ? 'ml-0' : 'm-0'} bg-slate-200 relative h-full
    //   transition-margin duration-300  flex flex-col`}
    //   onMouseMove={handleMouseMoveOnBoard}
    //   onMouseUp={handleMouseUpOnBoard}
    // >
    <div className={`m-0 bg-slate-200 relative h-full transition-margin duration-300  flex flex-col`}
      onMouseMove={handleMouseMoveOnBoard}
      onMouseUp={handleMouseUpOnBoard}
    >
      <div className={`flex-grow overflow-y-auto scrollbar-hide ${styles.boardWrapper}`}
        style={{ backgroundImage: `radial-gradient(circle, ${modeChosen?.color ?? '#ccc'} 1px, rgba(0, 0, 0 ,0) 1px)` }}
      >
        {modeChosen?.id && <div className="h-2 w-full sticky top-0" style={{ 'backgroundColor': modeChosen?.color }}></div>}
        {isLoading && <Loading />}
        {
          !isLoading && scopeList?.length === 0 &&
          <div className="w-full h-full flex items-center justify-center flex-col font-inter col-span-full text-gray-600">
            <p>You have not added any <b>SCOPES</b> for this mode</p>
            <div className="w-80 mt-2">
              {/* <PrimaryButton label='Add Scope' callToAction={createNewScope} className="w-full py-3" /> */}
              <ScopeAdd createNewScope={createNewScope} refreshScope={refreshScope}
                className="py-2" width="w-80" label='Add Scope' opensUp={false} />
            </div>
          </div>
        }
        {
          !isLoading && scopeList?.length > 0 &&
          <>
            {
              scopeList.map((scope: IScope) => {
                return (
                  <ScopeCard key={scope.id}
                    scopeDetails={scope}
                    isSelected={selectedNode === scope.id}
                    onMouseDownNode={handleOnMouseDownScopeNode}
                    editScopeHandler={editScopeHandler}
                  />
                )
              })
            }
          </>
        }
      </div>
      <div className="h-[6%] p-2 px-0 border-t border-slate-300">
        {scopeList?.length > 0 &&
          <div className="flex items-center justify-between">
            <div className="flex items-center gap-x-4 divide-x divide-slate-400 px-4">
              <div className="loadSaveOptions flex items-center gap-x-4 text-2xl">
                <GiLoad className="cursor-pointer text-slate-700" title="Load Vision" />
                <FaUpload className="cursor-pointer text-slate-700" title="Save Vision" />
              </div>

              <div className="settings flex items-center gap-x-4 text-2xl pl-3">
                <div className="relative">
                  <LuKeySquare className="text-2xl cursor-pointer text-red-700" title="Vision Encryption Key" />
                </div>
                <Link to={`/settings/${visionId}`}>
                  <MdSettings className="text-2xl cursor-pointer text-slate-700" title="Vision Settings" />
                </Link>
                <div className="inline-flex items-center cursor-pointer">
                  <FaRegListAlt className="text-xl cursor-pointer text-slate-700" />
                  <span className="text-xs ml-2" title="Legend">Legend</span>
                </div>
              </div>

              <div className="inline-flex items-center pl-3">
                <ToggleButton />
                <span className="text-xs ml-2" title="Design Mode">Design</span>
              </div>
            </div>

            <div className="flex gap-x-4 pr-4">
              <ScopeAdd createNewScope={createNewScope} refreshScope={refreshScope} width="w-48" opensUp={true} />
              <Selector
                options={availableModes}
                optionSelected={option => { setModeChosen(option); storeSelectedMode(option) }}
                currentSelection={modeChosen}
                opensUp={true}
                defaultLabel="Select Mode"
              />
            </div>
          </div>
        }
        {scopeList?.length === 0 &&
          <div className="flex items-center justify-end pr-4">
            <div className="flex">
              <Selector
                options={availableModes}
                optionSelected={option => { setModeChosen(option); storeSelectedMode(option) }}
                currentSelection={modeChosen}
                opensUp={true}
                defaultLabel="Select Mode"
              />
            </div>
          </div>
        }
      </div>
      {
        isCreateModalVisible &&
        <FormDialog modalHeading='New Scope'
          FormComponent={<ScopeCreationForm details={{} as IScope} ref={scopeCreationForm} />}
          closeModal={closeModal}
          confirmAction={handleCreation}
          actionBtnLabel='Create'
        />
      }
      {
        <Drawer
          FormComponent={<ScopeCreationForm details={currentSelectedScope} ref={scopeEditForm} />}
          onClose={closeEditModal}
          ctaHandler={handleEdit}
          isOpen={isEditModalVisible && currentSelectedScope !== undefined}
          editLabel='Update'
          modalHeading='Scope Details'
          isDeleteEnabled={true}
          deleteHandler={deleteScopeHandler}
        />
      }

    </div >

  );
};

function getRandomPositionX() {
  return Math.floor(Math.random() * (window.innerWidth - 160) + 30);
}

function getRandomPositionY() {
  return Math.floor(Math.random() * (window.innerHeight - 120) + 0);
}

function capXPos(x: number): number {
  return x > 20 ? x : 20;
}

function capYPos(y: number): number {
  return y > 20 ? y : 20;
}

function assignRandomPos(scopeItem: IScope) {
  const xPos = capXPos(scopeItem.xPos === -1 ? getRandomPositionX() : scopeItem.xPos);
  const yPos = capYPos(scopeItem.yPos === -1 ? getRandomPositionY() : scopeItem.yPos);
  return { xPos, yPos };
}

export default WorkspaceArea;