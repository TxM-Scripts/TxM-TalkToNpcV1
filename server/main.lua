-- Framework detection
local Framework = nil
local ESX = nil
local QBCore = nil

if Config.Framework == "qbcore" then
    QBCore = exports['qb-core']:GetCoreObject()
    Framework = "qbcore"
elseif Config.Framework == "qbx" then
    QBCore = exports['qbx-core']:GetCoreObject()
    Framework = "qbx"
elseif Config.Framework == "esx" then
    TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
    Framework = "esx"
end

-- Unified Notify Function
local function Notify(src, message, msgType)
    if Framework == "qbcore" or Framework == "qbx" then
        TriggerClientEvent('QBCore:Notify', src, message, msgType)
    elseif Framework == "esx" then
        TriggerClientEvent('esx:showNotification', src, message)
    end
end

-- Job Dialogue Config
local JobClientEvents = {
    test = {
        start = "I will assist you.",
        stop = "Thank you for stopping by.",
    },
}

-- Event: Start Job
RegisterServerEvent("TxM-DialogueV1:startJob", function(job)
    local src = source
    local jobConfig = JobClientEvents[job]
    if jobConfig and jobConfig.start then
        Notify(src, jobConfig.start, "success")
    else
        print("⚠️ Job or start message not found for:", job)
        Notify(src, "Job not found.", "error")
    end
end)

-- Event: End Job
RegisterServerEvent("TxM-DialogueV1:endJob", function(job)
    local src = source
    local jobConfig = JobClientEvents[job]
    if jobConfig and jobConfig.stop then
        Notify(src, jobConfig.stop, "error")
    else
        print("⚠️ Job or stop message not found for:", job)
        Notify(src, "Unable to stop. Job not found.", "error")
    end
end)
