InstanceRepeater = InstanceRepeater or {}
local T = {}
InstanceRepeater.Theme = T
local roles = {
  accent = {0.85, 0.68, 0.32},
  buttonFill = {0.06, 0.12, 0.24},
  background = {0.02, 0.02, 0.02},
  text = {0.92, 0.92, 0.92},
}
function T.Color(key)
  local c = roles[key] or roles.text
  return Turbine.UI.Color(1, c[1], c[2], c[3])
end
function T.Button(parent, x, y, w, h, caption, callback)
  local border = Turbine.UI.Control()
  border:SetParent(parent)
  border:SetPosition(x,y)
  border:SetSize(w,h)
  border:SetBackColor(T.Color("accent"))
  local label = Turbine.UI.Label()
  label:SetParent(border)
  label:SetPosition(1,1)
  label:SetSize(w-2,h-2)
  label:SetBackColor(T.Color("buttonFill"))
  label:SetForeColor(T.Color("accent"))
  label:SetFont(Turbine.UI.Lotro.Font.Verdana14)
  label:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleCenter)
  label:SetText(caption)
  label:SetMouseVisible(false)
  border.SetText = function(_,value) label:SetText(value) end
  border.MouseClick = function(_,args)
    if args.Button == Turbine.UI.MouseButton.Left and callback then callback() end
  end
  return border
end
