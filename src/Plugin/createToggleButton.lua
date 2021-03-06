--[[
    Creates the button to toggle the plugin widget.

    This function also sets up some events to toggle the widget when the button
    is clicked, and to sync up the button's "active" state with the widget.

	@return () -> () -- Returns a callback for disconnecting button events
]]
local function createToggleButton(toolbar: PluginToolbar, widget: DockWidgetPluginGui)
	local button = toolbar:CreateButton(widget.Name, "Open story view", "rbxassetid://10277153751")

	local click = button.Click:Connect(function()
		widget.Enabled = not widget.Enabled
	end)

	local enabled = widget:GetPropertyChangedSignal("Enabled"):Connect(function()
		button:SetActive(widget.Enabled)
	end)

	return function()
		click:Disconnect()
		enabled:Disconnect()
	end
end

return createToggleButton
