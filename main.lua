local api = require("api")

local high_ground_addon = {
	name = "High Ground",
	author = "Michaelqt",
	version = "1.2",
	desc = "Displays your bonus damage due to height."
}


local highGroundLabel

local updateLabelTimer = 0
local function OnUpdate(dt)
    if updateLabelTimer > 100 then 
        local _, _, playerZ = api.Unit:UnitWorldPosition("player")
        local _, _, targetZ = api.Unit:UnitWorldPosition("target")
        if targetZ ~= nil then 
            local targetFrame = ADDON:GetContent(UIC.TARGET_UNITFRAME)
            local heightBonus = 0
            local zDiff = playerZ - targetZ
            if zDiff > 1 then 
                heightBonus = 4 + (zDiff - 1) * 1.05
            end 

            if targetFrame:IsVisible() and heightBonus > 0 then
                local formattedBonus = string.format("%.0f", heightBonus)
                local formattedBonus = "(+" .. formattedBonus .. "% DMG)"
                highGroundLabel:SetText(formattedBonus)
                
            else
                highGroundLabel:SetText("")
            end 

            if targetFrame.abilityIconFrame ~= nil and targetFrame.abilityIconFrame:IsVisible() ~= false then 
                highGroundLabel:RemoveAllAnchors()
                highGroundLabel:AddAnchor("TOPRIGHT", targetFrame.abilityIconFrame, "TOPLEFT", -5, 8)
            else 
                highGroundLabel:RemoveAllAnchors()
                highGroundLabel:AddAnchor("TOPRIGHT", targetFrame.distanceLabel, "TOPLEFT", -5, 6)
            end 
        end
        updateLabelTimer = dt
    end
    updateLabelTimer = updateLabelTimer + dt
    
end 

local function OnLoad()
	local settings = api.GetSettings("high_ground")
    
    local targetFrame = ADDON:GetContent(UIC.TARGET_UNITFRAME)
    highGroundLabel = targetFrame:CreateChildWidget("label", "highGroundLabel", 0, true)
    highGroundLabel.style:SetAlign(ALIGN.RIGHT)
    highGroundLabel.style:SetShadow(true)
    ApplyTextColor(highGroundLabel, FONT_COLOR.ORANGE)
    highGroundLabel:AddAnchor("TOPRIGHT", targetFrame.distanceLabel, "TOPLEFT", -5, 6)
    api.On("UPDATE", OnUpdate)
	api.SaveSettings()
end

local function OnUnload()
	api.On("UPDATE", function() return end)
    highGroundLabel:Show(false)
    highGroundLabel:SetText("")
    highGroundLabel = nil
end

high_ground_addon.OnLoad = OnLoad
high_ground_addon.OnUnload = OnUnload

return high_ground_addon
