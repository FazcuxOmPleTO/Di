local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local currentSize = Vector3.new(1.5, 1.5, 1.5)

-- Função auxiliar para detectar se um objeto tem face/decals
local function hasFaceMarker(obj)
	if not obj then return false end
	if obj:FindFirstChild("face") then return true end
	for _, c in ipairs(obj:GetChildren()) do
		if c:IsA("Decal") or c:IsA("Texture") then
			return true
		end
	end
	return false
end

-- Aplica a modificação à cabeça do jogador
local function applyToPart(part, model)
	if not part or not model then return end
	if model == LocalPlayer.Character then return end
	if model:FindFirstChild("FakeVisualCabesa") then return end

	pcall(function()
		local fake = part:Clone()
		fake.Name = "FakeVisualCabesa"
		fake.Size = Vector3.new(1, 1, 1)
		fake.Transparency = 0
		fake.CanCollide = false
		fake.Anchored = false
		fake.Massless = true
		fake.Parent = model

		fake.CFrame = part.CFrame

		-- esconder cabeça original
		part.Size = currentSize
		part.Transparency = 1
		part.CanCollide = false
		part.Massless = true

		local face = part:FindFirstChild("face")
		if face and face:IsA("Decal") then face.Transparency = 1 end
		for _, c in ipairs(part:GetChildren()) do
			if c:IsA("Decal") or c:IsA("Texture") then
				c.Transparency = 1
			end
		end

		-- weld simples
		local weld = Instance.new("WeldConstraint")
		weld.Part0 = fake
		weld.Part1 = part
		weld.Parent = fake

		part:GetPropertyChangedSignal("Size"):Connect(function()
			if part.Size ~= currentSize then
				part.Size = currentSize
			end
		end)
	end)
end

-- Função para processar um personagem recém-criado
local function processCharacter(char)
	if not char then return end
	task.wait(0.5)
	for _, obj in ipairs(char:GetDescendants()) do
		if obj:IsA("BasePart") and hasFaceMarker(obj) then
			local model = obj:FindFirstAncestorOfClass("Model")
			if model and model:FindFirstChildOfClass("Humanoid") then
				applyToPart(obj, model)
			end
		end
	end
end

-- Monitora todos os jogadores (sem scan pesado)
for _, plr in ipairs(Players:GetPlayers()) do
	if plr ~= LocalPlayer then
		if plr.Character then
			processCharacter(plr.Character)
		end
		plr.CharacterAdded:Connect(processCharacter)
	end
end

Players.PlayerAdded:Connect(function(plr)
	if plr ~= LocalPlayer then
		plr.CharacterAdded:Connect(processCharacter)
	end
end)
