-- Reload helper. The main plugin starts this helper before it unloads.
import "Turbine"
import "Turbine.UI"
local driver = Turbine.UI.Control()
local frame = 0
driver.Update = function()
  frame = frame + 1
  if frame == 1 then
    Turbine.PluginManager.UnloadScriptState("InstanceRepeater")
  elseif frame == 5 then
    Turbine.PluginManager.LoadPlugin("InstanceRepeater")
    driver:SetWantsUpdates(false)
  end
end
driver:SetWantsUpdates(true)
InstanceRepeaterReloaderDriver = driver
