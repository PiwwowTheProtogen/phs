PHS = PHS or {}

include("autorun/config/sh_config.lua")

local recentDeductions = {}


local function copewithdeath(ply)
    if not IsValid(ply) or not ply:IsPlayer() then return end

    local moneyAmount = ply:getDarkRPVar("money") or 0
    local percentMoneyLost = PHS.Settings.percentMoneyLost or 0
    local minimumMoneyLeft = PHS.Settings.minimumMoneyLeft or 0
    local deduction = math.floor(moneyAmount * percentMoneyLost)

    if not ply:GetNWBool("HasInsurance", false) and (moneyAmount - deduction < minimumMoneyLeft) then
        deduction = moneyAmount - minimumMoneyLeft
    end

    if deduction > 0 then
        ply:addMoney(-deduction)

        if ply:GetNWBool("HasInsurance", false) then    
            local insurancePercentage = PHS.Settings.insurancePercentage or 0
            local savedAmount = math.floor(deduction * insurancePercentage)
            local spent = deduction - savedAmount
            ply:addMoney(savedAmount)
            ply:ChatPrint("You paid $" .. spent .. " after insurance covered $" .. savedAmount .. ".")
        else
            ply:ChatPrint("You paid $" .. deduction .. " to the hospital.")
        end
    else
       ply:ChatPrint("The hospital treated your injuries pro-bono.")
    end

    recentDeductions[ply:SteamID()] = deduction
end 

hook.Add("PlayerDeath", "copewithdeath", copewithdeath)

local function ByeByeInsurance(ply)
    if ply:GetNWBool("HasInsurance", false) then
        ply:SetNWBool("HasInsurance", false)
        ply:ChatPrint("Your insurance has expired.")
    end
end

hook.Add("PlayerDisconnected", "ClearRecentDeductions", function(ply)
    recentDeductions[ply:SteamID()] = nil
end)

hook.Add("PlayerSpawn", "checkJobChange", function(ply)
    if not IsValid(ply) or not ply:IsPlayer() then return end
    if not ply:GetNWBool("HasInsurance", false) then return end

    local oldJob = ply:GetNWString("PreviousJob", "")
    local newJob = ply:Team()

    if PHS.Settings.RemoveOnJobChange == true and oldJob ~= "" and oldJob ~= newJob then
        ByeByeInsurance(ply)
    end

    ply:SetNWString("PreviousJob", newJob)
end)

hook.Add("PlayerDeath", "removeInsuranceOnDeath", function(ply)
    if IsValid(ply) and ply:IsPlayer() then
        ByeByeInsurance(ply)
    end
end)

  timer.Create("InsuranceTimer", PHS.Settings.TimeRemoval, 0, function()
    for _, player in ipairs(game.Players:GetPlayers()) do
      if player.JoinedAt > currentTime then
        if not player:GetNWBool("HasInsurance", false) then
          ByeByeInsurance(player)
        end
      end
    end
  end)