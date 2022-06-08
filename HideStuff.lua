local frame = CreateFrame("Frame")
local events = {}
local updatePending = false

local buttons = {}

for i = 1, 12 do
  tinsert(buttons, _G["ActionButton"..i])
  tinsert(buttons, _G["MultiBarBottomLeftButton"..i])
  tinsert(buttons, _G["MultiBarBottomRightButton"..i])
  tinsert(buttons, _G["MultiBarLeftButton"..i])
  tinsert(buttons, _G["MultiBarRightButton"..i])
end

-- hide macro names
for _, button in pairs(buttons) do
  button.Name:Hide()
end

-- shorten long keybinds
local function updateHotkeys(self)
  local hotkey = self.HotKey
  local text = hotkey:GetText()

  text = gsub(text, "(s%-)", "S")
  text = gsub(text, "(a%-)", "A")
  text = gsub(text, "(c%-)", "C")
  text = gsub(text, "(st%-)", "C")

  for i = 1, 30 do
    text = gsub(text, _G["KEY_BUTTON"..i], "M"..i)
  end

  for i = 1, 9 do
    text = gsub(text, _G["KEY_NUMPAD"..i], "Nu"..i)
  end

  text = gsub(text, KEY_NUMPADDECIMAL, "Nu.")
  text = gsub(text, KEY_NUMPADDIVIDE, "Nu/")
  text = gsub(text, KEY_NUMPADMINUS, "Nu-")
  text = gsub(text, KEY_NUMPADMULTIPLY, "Nu*")
  text = gsub(text, KEY_NUMPADPLUS, "Nu+")

  text = gsub(text, KEY_MOUSEWHEELUP, "WU")
  text = gsub(text, KEY_MOUSEWHEELDOWN, "WD")
  text = gsub(text, KEY_NUMLOCK, "NuL")
  text = gsub(text, KEY_PAGEUP, "PU")
  text = gsub(text, KEY_PAGEDOWN, "PD")
  text = gsub(text, KEY_SPACE, "_")
  text = gsub(text, KEY_INSERT, "Ins")
  text = gsub(text, KEY_HOME, "Hm")
  text = gsub(text, KEY_DELETE, "Del")
  text = gsub(text, "Capslock", "Caps")

  hotkey:SetText(text)
end

for _, button in pairs(buttons) do
  hooksecurefunc(button, "UpdateHotkeys", updateHotkeys)
end

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

