local frame = CreateFrame("Frame")
local events = {}
local updatePending = false

local function updateUserInterace()
  for i = 1, _G["MAX_BOSS_FRAMES"] do
    _G["Boss"..i.."TargetFrame"]:SetScale(1.0)
  end

  MainMenuBarArtFrameBackground:Hide()

  MainMenuBarArtFrame.LeftEndCap:Hide()
  MainMenuBarArtFrame.RightEndCap:Hide()
  MainMenuBarArtFrame.PageNumber:Hide()

  ActionBarUpButton:Hide()
  ActionBarDownButton:Hide()

  MicroButtonAndBagsBar:Hide()

  ObjectiveTrackerFrame:SetMovable(true)
  ObjectiveTrackerFrame:SetUserPlaced(true)
  --ObjectiveTrackerFrame:ClearAllPoints()
  --ObjectiveTrackerFrame:SetParent("UIParent")
  ObjectiveTrackerFrame:SetPoint("TOPRIGHT", "UIParent", "TOPRIGHT", -200, -60)

  MinimapCluster:SetPoint("TOPRIGHT", "UIParent", "TOPRIGHT", -725, -30)

  VehicleSeatIndicator:Hide()
  VehicleSeatIndicator:UnregisterAllEvents()
end

function events:PLAYER_REGEN_ENABLED(...)
  if updatePending then
    --print('PLAYER_REGEN_ENABLED: updatePending = true')
    updateUserInterace()
    updatePending = false
  --else
    --print('PLAYER_REGEN_ENABLED: updatePending = false')
  end
end

function events:PLAYER_ENTERING_WORLD(...)
  if not InCombatLockdown() then
    --print('PLAYER_ENTERING_WORLD: updatePending = false')
    updateUserInterace()
  else
    --print('PLAYER_ENTERING_WORLD: updatePending = true')
    updatePending = true
  end
end

frame:SetScript("OnEvent", function(self, event, ...)
  events[event](self, ...)
end);

for event, _ in pairs(events) do
  frame:RegisterEvent(event)
end

