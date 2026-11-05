-- Instance Repeater launcher, interaction model based on StatsToolbox/Launcher.lua.
-- Standalone artwork so InstanceRepeater does not require StatsToolbox to be installed.
InstanceRepeater = InstanceRepeater or {}
local Launcher = {}
InstanceRepeater.Launcher = Launcher

local SIZE = 40
local function color(r,g,b) return Turbine.UI.Color(1,r,g,b) end
function Launcher.Create(settings, saveSettings, actions)
  local self = {}
  local w = Turbine.UI.Window()
  self.window = w
  w:SetSize(SIZE,SIZE)
  w:SetZOrder(10)
  local function clamp(x,y)
    local sw,sh = Turbine.UI.Display.GetWidth(),Turbine.UI.Display.GetHeight()
    x = math.max(0,math.min(sw-SIZE,tonumber(x) or sw-260))
    y = math.max(0,math.min(sh-SIZE,tonumber(y) or 240))
    w:SetPosition(math.floor(x),math.floor(y))
  end
  clamp(settings.launcherX,settings.launcherY)

  local outer = Turbine.UI.Control()
  outer:SetParent(w)
  outer:SetSize(SIZE,SIZE)
  outer:SetBackColor(color(0.85,0.68,0.32))
  local inner = Turbine.UI.Control()
  inner:SetParent(outer)
  inner:SetPosition(2,2)
  inner:SetSize(SIZE-4,SIZE-4)
  inner:SetBackColor(color(0.02,0.02,0.02))
  inner:SetMouseVisible(false)
  local icon = Turbine.UI.Label()
  icon:SetParent(outer)
  icon:SetPosition(2,2)
  icon:SetSize(SIZE-4,SIZE-4)
  icon:SetFont(Turbine.UI.Lotro.Font.TrajanPro18 or Turbine.UI.Lotro.Font.Verdana16)
  icon:SetForeColor(color(0.85,0.68,0.32))
  icon:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleCenter)
  icon:SetText("IR")
  self.icon = icon

  function self:SetShown(shown)
    settings.launcherHidden = not shown or nil
    w:SetVisible(shown)
    saveSettings()
  end
  function self:ResetPosition()
    clamp(Turbine.UI.Display.GetWidth()-260,240)
    settings.launcherX,settings.launcherY = w:GetPosition()
    saveSettings()
  end
  local function menu()
    local m = Turbine.UI.ContextMenu()
    local items = m:GetItems()
    local function add(title,fn)
      local item = Turbine.UI.MenuItem(title)
      item.Click = function() fn() end
      items:Add(item)
    end
    add("Fenster anzeigen / ausblenden",actions.toggleWindow)
    add("Spielerliste anzeigen",actions.showRoster)
    add("Einladungsfolge zurücksetzen",actions.resetInvites)
    add("Button-Position zurücksetzen",function() self:ResetPosition() end)
    add("Button ausblenden (Neuladen zeigt ihn wieder)",function() self:SetShown(false) end)
    m:ShowMenu()
    self.menu = m
  end
  local dragging,moved,offsetX,offsetY,startX,startY = false,false,0,0,0,0
  icon.MouseEnter = function() outer:SetBackColor(color(1,0.82,0.38)) end
  icon.MouseLeave = function() if not dragging then outer:SetBackColor(color(0.85,0.68,0.32)) end end
  icon.MouseDown = function(_,args)
    if args.Button ~= Turbine.UI.MouseButton.Left then return end
    dragging,moved = true,false
    offsetX,offsetY = args.X,args.Y
    startX,startY = Turbine.UI.Display.GetMouseX(),Turbine.UI.Display.GetMouseY()
  end
  icon.MouseMove = function()
    if not dragging then return end
    local x,y = Turbine.UI.Display.GetMouseX(),Turbine.UI.Display.GetMouseY()
    if not moved and math.abs(x-startX)+math.abs(y-startY)>4 then moved=true end
    if moved then clamp(x-offsetX,y-offsetY) end
  end
  icon.MouseUp = function(_,args)
    if args.Button ~= Turbine.UI.MouseButton.Left or not dragging then return end
    dragging=false
    if moved then
      settings.launcherX,settings.launcherY = w:GetPosition()
      saveSettings()
    else actions.toggleWindow() end
  end
  icon.MouseClick = function(_,args)
    if args.Button == Turbine.UI.MouseButton.Right then menu() end
  end
  w:SetVisible(settings.launcherHidden ~= true)
  return self
end
