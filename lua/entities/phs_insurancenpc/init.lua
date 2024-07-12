AddCSLuaFile("shared.lua")
AddCSLuaFile("cl_init.lua")
include("shared.lua")

PHS = PHS or {}
PHS.Settings = PHS.Settings or {}

util.AddNetworkString("OpenInsuranceMenu")
util.AddNetworkString("PHS.YesInsurance")

function ENT:Initialize()
    self:SetModel(PHS.Settings.NPCModel)
    self:SetHullType(HULL_HUMAN)
    self:SetHullSizeNormal()
    self:SetNPCState(NPC_STATE_SCRIPT)
    self:SetSolid(SOLID_BBOX)
    self:SetUseType(SIMPLE_USE)
end

function ENT:Use(player, caller)
    if not player:IsPlayer() then return end
    net.Start("OpenInsuranceMenu")
    net.WriteInt(PHS.Settings.InsuranceCost, 32)
    net.WriteInt(PHS.Settings.TimeRemoval, 16)  
    net.Send(player)
end

net.Receive("PHS.YesInsurance", function(len, ply)
    if IsValid(ply) and ply:IsPlayer() then
        if ply:GetNWBool("HasInsurance", false) then
            ply:ChatPrint("You already have insurance.")
            return
        end

        local cost = PHS.Settings.InsuranceCost
        if ply:getDarkRPVar("money") >= cost then
            ply:addMoney(-cost)
            ply:SetNWBool("HasInsurance", true)
            ply:ChatPrint("You have successfully purchased insurance.")
        else
            ply:ChatPrint("You do not have enough money to purchase insurance.")
        end
    end
end)