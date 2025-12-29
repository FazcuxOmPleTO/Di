local Players = game:GetService("Players")
local player = Players.LocalPlayer
local hui = gethui()

-- pega as GUIs do JJ
local jjGuis = {}

for _, gui in ipairs(hui:GetChildren()) do
	if gui:IsA("ScreenGui") and (gui.Name == "JJSploitGui" or gui.Name == "internal_drawing") then
		table.insert(jjGuis, gui)
	end
end

-- funções
local function hideJJ()
	for _, gui in ipairs(jjGuis) do
		pcall(function()
			gui.Enabled = false
		end)
	end
end

local function showJJ()
	for _, gui in ipairs(jjGuis) do
		pcall(function()
			gui.Enabled = true
		end)
	end
end

-- escuta o chat
player.Chatted:Connect(function(msg)
	msg = msg:lower():gsub("%s+", "")

	if msg == "n" then
		hideJJ()
	elseif msg == "s" then
		showJJ()
	end
end)
