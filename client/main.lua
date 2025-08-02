-- Framework Setup
local Framework = {}
local frameworkType = Config.Framework or "qbcore"

if frameworkType == "qbcore" then
    Framework = exports['qb-core']:GetCoreObject()
elseif frameworkType == "qbx" then
    Framework = exports['qbx-core']:GetCoreObject()
elseif frameworkType == "esx" then
    Framework = exports['es_extended']:getSharedObject()
else
    print("[TxM-DialogueV1] ❌ Unsupported framework: " .. frameworkType)
    return
end

-- NPC Data & Variables
local spawnedNPCs = {}
local npcCam = nil
local dialogueTempNPC = nil
local dialogueTempData = nil
local interactionDistance = 2.0
local fadeDistance = 2.0

-- Spawn NPCs
CreateThread(function()
    for _, npcData in pairs(Config.NPCs) do
        RequestModel(npcData.model)
        while not HasModelLoaded(npcData.model) do Wait(0) end

        local ped = CreatePed(4, npcData.model, npcData.coords.x, npcData.coords.y, npcData.coords.z - 1.0, npcData.coords.w, false, true)
        FreezeEntityPosition(ped, true)
        SetEntityInvincible(ped, true)
        SetBlockingOfNonTemporaryEvents(ped, true)

        if npcData.scenario then
            TaskStartScenarioInPlace(ped, npcData.scenario, 0, true)
        end

        if npcData.blip and npcData.blip.enable then
            local blip = AddBlipForCoord(npcData.coords.x, npcData.coords.y, npcData.coords.z)
            SetBlipSprite(blip, npcData.blip.sprite)
            SetBlipColour(blip, npcData.blip.color)
            SetBlipScale(blip, npcData.blip.scale or 0.7)
            SetBlipAsShortRange(blip, true)
            BeginTextCommandSetBlipName("STRING")
            AddTextComponentString(npcData.blip.name or "NPC")
            EndTextCommandSetBlipName(blip)
        end

        exports.interact:AddInteraction({
            coords = GetEntityCoords(ped),
            distance = 8.0,
            interactDst = 1.8,
            id = 'npc_' .. tostring(npcData.id),
            name = npcData.targetLabel or "Talk",
            options = {
                {
                    label = npcData.interactLabel or "Talk",
                    action = function(entity, coords, args)
                        OpenDialogueUI(ped, npcData)
                    end,
                },
            }
        })

        table.insert(spawnedNPCs, { ped = ped, data = npcData })
    end
end)

-- Dialogue Handling
function OpenDialogueUI(npcPed, npcData)
    SetNuiFocus(true, true)
    FocusCameraOnPed(npcPed)
    dialogueTempNPC = npcPed
    dialogueTempData = npcData
    SendNUIMessage({
        action = "openDialogue",
        dialogue = {
            name = npcData.name,
            role = npcData.role,
            text = npcData.dialogue.text,
            options = npcData.dialogue.options
        }
    })
end

function FocusCameraOnPed(ped)
    if not DoesEntityExist(ped) then return end
    local camCoords = GetOffsetFromEntityInWorldCoords(ped, 0.0, 0.6, 0.65)
    npcCam = CreateCam("DEFAULT_SCRIPTED_CAMERA", true)
    SetCamCoord(npcCam, camCoords.x, camCoords.y, camCoords.z)
    PointCamAtEntity(npcCam, ped, 0.0, 0.0, 0.65)
    SetCamActive(npcCam, true)
    RenderScriptCams(true, true, 500, true, true)
end

function ClearNPCCamera()
    if npcCam then
        RenderScriptCams(false, true, 500, true, true)
        DestroyCam(npcCam, false)
        npcCam = nil
    end
end

-- NUI Callbacks
RegisterNUICallback("clearCam", function(_, cb)
    ClearNPCCamera()
    cb({})
end)

RegisterNUICallback("closeDialogue", function(_, cb)
    SetNuiFocus(false, false)
    ClearNPCCamera()
    cb({})
end)

-- Action Handlers
local actionHandlers = {
    star_test = function()
        TriggerServerEvent("TxM-DialogueV1:startJob", "test")
    end,
    end_test = function()
        TriggerServerEvent("TxM-DialogueV1:endJob", "test")
    end,
}

RegisterNUICallback("optionSelected", function(data, cb)
    local action = data.action
    if not action then
        Notify("Invalid action!", "error")
        cb({})
        return
    end
    if actionHandlers[action] then
        actionHandlers[action]()
    else
        Notify("No corresponding action found!", "error")
        print("⚠️ Unhandled action from NUI:", action)
    end
    SetNuiFocus(false, false)
    ClearNPCCamera()
    cb({})
end)

-- Notify Function
function Notify(text, type)
    if frameworkType == "esx" then
        TriggerEvent('esx:showNotification', text)
    else
        Framework.Functions.Notify(text, type or "primary")
    end
end