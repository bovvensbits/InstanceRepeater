-- Separate-apartment helper: unload the main plugin, then load it again.
import "Turbine"
import "Turbine.UI"
local TARGET = "InstanceRepeater"
local driver = Turbine.UI.Control()
local frame = 0
local function attempt(action, label)
  local ok, result = pcall(action)
  if not ok or result == false then
    Turbine.Shell.WriteLine("InstanceRepeater: " .. label .. " fehlgeschlagen: " .. tostring(result))
    return false
  end
  return true
end
driver.Update = function()
  frame = frame + 1
  if frame == 1 then
    Turbine.Shell.WriteLine("InstanceRepeater: Plugin wird entladen...")
    if not attempt(function() return Turbine.PluginManager.UnloadScriptState(TARGET) end, "Entladen") then
      driver:SetWantsUpdates(false)
    end
  elseif frame == 10 then
    Turbine.Shell.WriteLine("InstanceRepeater: Plugin wird geladen...")
    if attempt(function() return Turbine.PluginManager.LoadPlugin(TARGET) end, "Laden") then
      Turbine.Shell.WriteLine("InstanceRepeater: Reload abgeschlossen.")
    end
    driver:SetWantsUpdates(false)
  end
end
driver:SetWantsUpdates(true)
InstanceRepeaterReloaderDriver = driver
