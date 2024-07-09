PHS = PHS or {}
PHS.Settings = PHS.Settings or {}

include("autorun/config/sh_config.lua")

ENT.Type = "ai"
ENT.Base = "base_ai"
ENT.PrintName = "Health Insurance NPC"
ENT.Author = "Piwwow (piwwowtheproto)"
ENT.Category = "PHS"
ENT.Spawnable = true
ENT.AdminOnly = false


scripted_ents.Register(ENT, "phs_insurancenpc")