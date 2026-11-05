import "Turbine"
import "Turbine.Gameplay"
import "Turbine.UI"
import "Turbine.UI.Lotro"
import "InstanceRepeater.Theme"

local Theme = InstanceRepeater.Theme
local KEY = "SavedPlayers_v1"
local saved = Turbine.PluginData.Load(Turbine.DataScope.Character, KEY)
if type(saved) ~= "table" then saved = {} end
local index, expanded = 1, false
local function persist()
  Turbine.PluginData.Save(Turbine.DataScope.Character, KEY, saved)
end

local win = Turbine.UI.Lotro.Window()
win:SetText("Instance Repeater")
win:SetSize(340,310)
win:SetPosition(200,180)
local background = Turbine.UI.Control()
background:SetParent(win)
background:SetPosition(9,52)
background:SetSize(322,249)
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

local header = label(63,"Gruppe: 0 / 12 gespeichert")
header:SetFont(Turbine.UI.Lotro.Font.TrajanPro14 or Turbine.UI.Lotro.Font.Verdana14)
local status = label(91,"Bereit",28)
local roster = Turbine.UI.ListBox()
roster:SetParent(win)
roster:SetPosition(22,316)
roster:SetSize(296,188)
roster:SetVisible(false)

local slot = Turbine.UI.Lotro.Quickslot()
slot:SetParent(win)
slot:SetPosition(16,165)
slot:SetSize(308,30)
slot:SetAllowDrop(false)
local slotCaption = label(171,"Nächsten Spieler einladen")
slotCaption:SetMouseVisible(false)

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
    slot:SetShortcut(Turbine.UI.Lotro.Shortcut(
      Turbine.UI.Lotro.ShortcutType.Alias, "/invite " .. name))
    slotCaption:SetText("Einladen: " .. name .. " (" .. index .. "/" .. #saved .. ")")
  end
end
local function refresh()
  header:SetText("Gruppe: " .. #saved .. " / 12 gespeichert")
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
      if name and name ~= player:GetName() and not seen[name] and #names < 11 then
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

button(202,"Leave Instance (Anleitung)",function()
  status:SetText("Eigenes Portrait > Leave Instance")
end)
button(237,"Einladungen zurücksetzen",function()
  index=1
  updateSlot()
  status:SetText("Einladungsfolge zurückgesetzt")
end)

local toggle
local function resize()
  roster:SetVisible(expanded)
  win:SetSize(340,expanded and 521 or 310)
  background:SetSize(322,expanded and 460 or 249)
  toggle:SetText(expanded and "Spielerliste ausblenden ▲" or "Spielerliste anzeigen ▼")
end
toggle = button(272,"Spielerliste anzeigen ▼",function()
  expanded=not expanded
  resize()
end)
refresh()
win:SetVisible(true)
plugin.Unload = persist
