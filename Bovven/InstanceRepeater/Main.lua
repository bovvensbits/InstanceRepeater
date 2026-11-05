import "Turbine"
import "Turbine.Gameplay"
import "Turbine.UI"
import "Turbine.UI.Lotro"
import "Bovven.InstanceRepeater.Theme"
import "Bovven.InstanceRepeater.Launcher"

local Theme = InstanceRepeater.Theme
local KEY = "SavedPlayers_v1"
local UI_KEY = "LauncherSettings_v1"
local uiSettings = Turbine.PluginData.Load(Turbine.DataScope.Character, UI_KEY)
if type(uiSettings) ~= "table" then uiSettings = {} end
local function saveUI() Turbine.PluginData.Save(Turbine.DataScope.Character, UI_KEY, uiSettings) end
local saved = Turbine.PluginData.Load(Turbine.DataScope.Character, KEY)
if type(saved) ~= "table" then saved = {} end
local index, expanded = 1, false
local groupLimit = 6
local function persist()
  Turbine.PluginData.Save(Turbine.DataScope.Character, KEY, saved)
end

local win = Turbine.UI.Lotro.Window()
win:SetText("Instance Repeater")
win:SetSize(340,346)
win:SetPosition(200,180)
local background = Turbine.UI.Control()
background:SetParent(win)
background:SetPosition(9,52)
background:SetSize(322,285)
background:SetBackColor(Theme.Color("background"))
background:SetMouseVisible(false)

local function label(y,text,h)
  local v = Turbine.UI.Label()
  v:SetParent(win)
  v:SetPosition(18,y)
  v:SetSize(304,h or 22)
  v:SetFont(Turbine.UI.Lotro.Font.Verdana14)
  v:SetForeColor(Theme.Color("accent"))
  v:SetText(text)
  return v
end
local function button(y,text,fn)
  return Theme.Button(win,16,y,308,28,text,fn)
end

local header = label(63,"Gruppe: 0 / 6 gespeichert")
header:SetFont(Turbine.UI.Lotro.Font.TrajanPro14 or Turbine.UI.Lotro.Font.Verdana14)
local status = label(91,"Bereit",28)
local roster = Turbine.UI.ListBox()
roster:SetParent(win)
roster:SetPosition(22,354)
roster:SetSize(296,188)
roster:SetVisible(false)

-- Mask the native quickslot artwork behind the same framed control style used by StatsToolbox.
-- Only the genuine Quickslot receives mouse input and executes the alias.
local inviteFrame = Turbine.UI.Control()
inviteFrame:SetParent(win)
inviteFrame:SetPosition(16,165)
inviteFrame:SetSize(308,30)
inviteFrame:SetBackColor(Theme.Color("accent"))
local inviteFill = Turbine.UI.Control()
inviteFill:SetParent(inviteFrame)
inviteFill:SetPosition(1,1)
inviteFill:SetSize(306,28)
inviteFill:SetBackColor(Theme.Color("buttonFill"))
inviteFill:SetMouseVisible(false)
local slotMask = Turbine.UI.Control()
slotMask:SetParent(inviteFrame)
slotMask:SetPosition(1,1)
slotMask:SetSize(306,28)
-- Child coordinates outside the parent control are clipped by LOTRO UI.
local slot = Turbine.UI.Lotro.Quickslot()
slot:SetParent(slotMask)
slot:SetPosition(-34,-34)
slot:SetSize(340,62)
slot:SetAllowDrop(false)
slot:SetUseOnRightClick(false)
local slotCaption = Turbine.UI.Label()
slotCaption:SetParent(inviteFrame)
slotCaption:SetPosition(2,2)
slotCaption:SetSize(304,26)
slotCaption:SetFont(Turbine.UI.Lotro.Font.Verdana14)
slotCaption:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleCenter)
slotCaption:SetForeColor(Theme.Color("accent"))
slotCaption:SetMouseVisible(false)
slotCaption:SetText("Nächsten Spieler einladen")

local function updateSlot()
  if #saved == 0 then
    slot:SetShortcut(nil)
    slotCaption:SetText("Keine Spieler gespeichert")
  elseif index > #saved then
    slot:SetShortcut(nil)
    slotCaption:SetText("Einladungsfolge abgeschlossen")
  else
    local name = tostring(saved[index])
    if name:find("[\r\n;/]") then
      slot:SetShortcut(nil)
      status:SetText("Ungültiger Spielername")
      return
    end
    local shortcut = Turbine.UI.Lotro.Shortcut(Turbine.UI.Lotro.ShortcutType.Alias, "")
    shortcut:SetData("/invite " .. name)
    slot:SetShortcut(shortcut)
    slotCaption:SetText("Einladen: " .. name .. " (" .. index .. "/" .. #saved .. ")")
  end
end
local function refresh()
  header:SetText("Gruppe: " .. #saved .. " / " .. groupLimit .. " gespeichert")
  roster:ClearItems()
  for i=1,#saved do
    local item = Turbine.UI.Label()
    item:SetSize(288,23)
    item:SetFont(Turbine.UI.Lotro.Font.Verdana12)
    item:SetForeColor(Theme.Color("text"))
    item:SetText(i .. ". " .. tostring(saved[i]))
    roster:AddItem(item)
  end
  updateSlot()
end

button(127,"Aktuelle Gruppe speichern",function()
  local player = Turbine.Gameplay.LocalPlayer:GetInstance()
  local party = player and player:GetParty()
  if not party then status:SetText("Keine Gruppe gefunden") return end
  local names,seen = {},{}
  for i=1,party:GetMemberCount() do
    local member = party:GetMember(i)
    if member then
      local name = member:GetName()
      if name and name ~= player:GetName() and not seen[name] and #names < groupLimit - 1 then
        names[#names+1]=name
        seen[name]=true
      end
    end
  end
  if #names == 0 then status:SetText("Keine Mitspieler gefunden") return end
  saved=names
  index=1
  persist()
  refresh()
  status:SetText(#saved .. " Mitspieler gespeichert")
end)

-- The LOTRO client must verify whether the click event advances after alias activation.
slot.MouseClick = function(_,args)
  if args.Button == Turbine.UI.MouseButton.Left and index <= #saved then
    index=index+1
    updateSlot()
    status:SetText("Fortschritt: " .. math.min(index-1,#saved) .. " / " .. #saved)
  end
end

button(202,"Leave Instance: Portrait-Menü",function()
  status:SetText("Rechtsklick Portrait > Leave Instance")
end)
button(237,"Einladungen zurücksetzen",function()
  index=1
  updateSlot()
  status:SetText("Einladungsfolge zurückgesetzt")
end)

local modeButton
modeButton = Theme.Button(win,16,306,308,28,"Modus: 6 Spieler",function()
  groupLimit = (groupLimit == 6) and 12 or 6
  modeButton:SetText("Modus: " .. groupLimit .. " Spieler")
  refresh()
end)
local toggle
local function resize()
  roster:SetVisible(expanded)
  win:SetSize(340,expanded and 557 or 346)
  background:SetSize(322,expanded and 496 or 285)
  toggle:SetText(expanded and "Spielerliste ausblenden ▲" or "Spielerliste anzeigen ▼")
end
toggle = button(272,"Spielerliste anzeigen ▼",function()
  expanded=not expanded
  resize()
end)
refresh()
win:SetVisible(uiSettings.windowHidden ~= true)
local function toggleWindow()
  local visible = not win:IsVisible()
  win:SetVisible(visible)
  uiSettings.windowHidden = not visible
  saveUI()
end
local launcher = InstanceRepeater.Launcher.Create(uiSettings, saveUI, {
  toggleWindow = toggleWindow,
  reload = function()
    persist()
    saveUI()
    local ok, err = pcall(function() Turbine.PluginManager.LoadPlugin("~InstanceRepeaterReloader") end)
    if not ok then Turbine.Shell.WriteLine("InstanceRepeater: Reload fehlgeschlagen: " .. tostring(err)) end
  end,
  resetInvites = function() index = 1; updateSlot(); status:SetText("Einladungsfolge zurückgesetzt") end,
  showRoster = function() if not expanded then expanded = true; resize() end; win:SetVisible(true); uiSettings.windowHidden = false; saveUI() end,
  showWindow = function() win:SetVisible(true); uiSettings.windowHidden = false; saveUI() end,
})
plugin.Unload = function() persist(); saveUI() end
