PHS = {}
PHS.Settings = {}

PHS.Settings.StaffRanks = {
    ["superadmin"] = true,
    ["admin"] = true
}

PHS.Settings.insurancePercentage = 0.75 -- How much will be covered under Insurance (75% saved by Default)

PHS.Settings.percentMoneyLost = 0.05 -- 5% of players money will be lost on death for "Medical Bills"

PHS.Settings.InsuranceCost = 5000 -- Price for Insurance

PHS.Settings.TimeRemoval = 60 -- Insurance Expires after 60 minutes, set to 0 to disable. 

PHS.Settings.RemoveOnDeath = true -- Remove insurance on Death? False to disable.

PHS.Settings.RemoveOnJobChange = true -- Remove insurance on Job Change? False to disable.

PHS.Settings.NPCModel = "models/breen.mdl"