AddCSLuaFile("shared.lua")
include("shared.lua")

surface.CreateFont( "iloveinsurance", {
	font = "ChatFont", 
	extended = true,
	size = 15,
	weight = 350,
	blursize = 0,
	scanlines = 0,
	antialias = true,
	underline = false,
	italic = false,
	strikeout = false,
	symbol = false,
	rotary = false,
	shadow = false,
	additive = false,
	outline = false,
} )

function ENT:Draw()
    self:DrawModel()

    local ang = self:GetAngles()
    local pos = self:GetPos() + Vector(0, 0, 85)

    ang:RotateAroundAxis(ang:Forward(), 90)
    ang:RotateAroundAxis(ang:Right(), -90)

    cam.Start3D2D(pos, ang, 0.25)
        draw.RoundedBox(10, -125, -15, 250, 30, Color(60,60,60,200))
        draw.SimpleText("Health Insurance",  "DermaLarge", 0, 0, Color(255, 255, 255, 235), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    cam.End3D2D()
end

net.Receive("OpenInsuranceMenu", function()
    local insuranceCost = net.ReadInt(32)
    local PANEL = vgui.Create("DFrame")
    PANEL:SetTitle("")
    PANEL:SetSize(300, 125)
    PANEL:Center()
    PANEL:SetDraggable(false)
    PANEL:ShowCloseButton(false)
    PANEL:MakePopup()
	PANEL.Paint = function(self)
		draw.RoundedBox(0, 0, 0, 300, 25, Color(60,60,60,200))
		draw.DrawText("Health Insurance", "iloveinsurance", 150, 5, Color(255,255,255), TEXT_ALIGN_CENTER)
	end
	
    local menutext = vgui.Create("DPanel", PANEL)
    menutext:SetText("")
    menutext:SetPos(PANEL:GetWide() - 300, PANEL:GetTall() - 100)
    menutext:SetSize(400,125)
	menutext.Paint = function(self)
		draw.RoundedBox(0, 0, 0, 400, 125, Color(40,40,40,235))
		draw.DrawText("Would you like to purchase insurance for " .. DarkRP.formatMoney( insuranceCost ) .. "?", "iloveinsurance", 150, 20, Color(255,255,255), TEXT_ALIGN_CENTER)
	end

    local yah = vgui.Create("DButton", PANEL)
    yah:SetText("")
    yah:SetSize(100, 30)
    yah:SetPos((PANEL:GetWide() - yah:GetWide()) / 2 - 60, 80)  -- Center the button horizontally
    yah.Paint = function(self, w, h)
		draw.RoundedBox(10, 0, 0, 100, 30, Color(100,195,100,235))
		draw.DrawText("Yes", "iloveinsurance", w/2, 7, Color(0,0,0), TEXT_ALIGN_CENTER)
	end
    yah.DoClick = function()
        net.Start("PHS.YesInsurance")
        net.SendToServer()
        PANEL:Close()
    end

    local nope = vgui.Create("DButton", PANEL)
    nope:SetText("")
    nope:SetSize(100, 30)
    nope:SetPos((PANEL:GetWide() - nope:GetWide()) / 2 + 60, 80)  -- Center the button horizontally
    nope.Paint = function(self, w, h)
		draw.RoundedBox(10, 0, 0, 100, 30, Color(195,100,100,235))
		draw.DrawText("No", "iloveinsurance", w/2, 7, Color(2,0,0), TEXT_ALIGN_CENTER)
	end
    nope.DoClick = function()
        PANEL:Close()
    end
end)