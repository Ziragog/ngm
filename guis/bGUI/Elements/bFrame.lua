local PANEL = {
	_bTitle = "Window",
	_bTitleColor = bGUI.Colors.White
}

function PANEL:GetTitle()
	return self._bTitle
end

function PANEL:GetTitleColor()
	return self._bTitleColor
end

function PANEL:SetTitle(newTitle)
	bGUI.CheckValueType(1, newTitle, "string")

	local shouldUpdate = self:PreTitleUpdate(newTitle)
	if not shouldUpdate then return end

	self._bTitle = newTitle

	self:OnTitleUpdate(newTitle)
end

function PANEL:SetTitleColor(newColor)
	bGUI.AssertValue(1, getmetatable(newColor), bGUI.Registry.Color)

	self._bTitleColor = newColor
end

function PANEL:Init()
	self:SetBackgroundColor(bGUI.Colors.DarkGray)

	self:SetFont("bGUI")
end

function PANEL:PaintBackground(x, y, w, h)
	surface.SetDrawColor(self:GetBackgroundColor())
	surface.DrawRect(x, y, w, h)
end

function PANEL:Paint(x, y, w)
	surface.SetFont(self:GetFont())
	surface.SetTextColor(self:GetTitleColor())

	local title = self:GetTitle()
	local tw, th = surface.GetTextSize(title)
	
	surface.SetTextPos(x + ((w / 2) - (tw / 2)), y + 3)
	surface.DrawText(title)
end

function PANEL:Think()
	if self:GetDragging() then
		local ox, oy = bGUI.GetDraggingOrigin()

		self:SetPos(gui.MouseX() - ox, gui.MouseY() - oy)
	end
end

function PANEL:OnLeftClick()
	local x, y = self:GetPos()
	local w = self:GetWidth()

	if bGUI.CursorInBounds(x, y, x + w, y + 20) then -- TODO: Make drag region changeable
		if bGUI.RequestDragging(self) then
			local ox, oy = bGUI.GetDraggingOrigin()

			bGUI.UpdateDraggingOrigin(ox - self:GetX(), oy - self:GetY())
		end
	end
end

function PANEL:PreTitleUpdate(newTitle)
	return true
end

function PANEL:OnTitleUpdate(newTitle)

end

bGUI.RegisterElement("bFrame", PANEL, "bPanel")