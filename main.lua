--https://github.com/Mokiros/roblox-FE-compatibility
if game:GetService("RunService"):IsClient() then error("Script must be server-side in order to work; use h/ and not hl/") end
local Player,game,owner = owner,game
local RealPlayer = Player
do
	print("FE Compatibility code V2 by Mokiros")
	local RealPlayer = RealPlayer
	script.Parent = RealPlayer.Character

	--Fake event to make stuff like Mouse.KeyDown work
	local Disconnect_Function = function(this)
		this[1].Functions[this[2]] = nil
	end
	local Disconnect_Metatable = {__index={disconnect=Disconnect_Function,Disconnect=Disconnect_Function}}
	local FakeEvent_Metatable = {__index={
		Connect = function(this,f)
			local i = tostring(math.random(0,10000))
			while this.Functions[i] do
				i = tostring(math.random(0,10000))
			end
			this.Functions[i] = f
			return setmetatable({this,i},Disconnect_Metatable)
		end
	}}
	FakeEvent_Metatable.__index.connect = FakeEvent_Metatable.__index.Connect
	local function fakeEvent()
		return setmetatable({Functions={}},FakeEvent_Metatable)
	end

	--Creating fake input objects with fake variables
	local FakeMouse = {Hit=CFrame.new(),KeyUp=fakeEvent(),KeyDown=fakeEvent(),Button1Up=fakeEvent(),Button1Down=fakeEvent(),Button2Up=fakeEvent(),Button2Down=fakeEvent()}
	FakeMouse.keyUp = FakeMouse.KeyUp
	FakeMouse.keyDown = FakeMouse.KeyDown
	local UIS = {InputBegan=fakeEvent(),InputEnded=fakeEvent()}
	local CAS = {Actions={},BindAction=function(self,name,fun,touch,...)
		CAS.Actions[name] = fun and {Name=name,Function=fun,Keys={...}} or nil
	end}
	--Merged 2 functions into one by checking amount of arguments
	CAS.UnbindAction = CAS.BindAction

	--This function will trigger the events that have been :Connect()'ed
	local function TriggerEvent(self,ev,...)
		for _,f in pairs(self[ev].Functions) do
			f(...)
		end
	end
	FakeMouse.TriggerEvent = TriggerEvent
	UIS.TriggerEvent = TriggerEvent

	--Client communication
	local Event = Instance.new("RemoteEvent")
	Event.Name = "UserInput_Event"
	Event.OnServerEvent:Connect(function(plr,io)
		if plr~=RealPlayer then return end
		FakeMouse.Target = io.Target
		FakeMouse.Hit = io.Hit
		if not io.isMouse then
			local b = io.UserInputState == Enum.UserInputState.Begin
			if io.UserInputType == Enum.UserInputType.MouseButton1 then
				return FakeMouse:TriggerEvent(b and "Button1Down" or "Button1Up")
			end
			if io.UserInputType == Enum.UserInputType.MouseButton2 then
				return FakeMouse:TriggerEvent(b and "Button2Down" or "Button2Up")
			end
			for _,t in pairs(CAS.Actions) do
				for _,k in pairs(t.Keys) do
					if k==io.KeyCode then
						t.Function(t.Name,io.UserInputState,io)
					end
				end
			end
			FakeMouse:TriggerEvent(b and "KeyDown" or "KeyUp",io.KeyCode.Name:lower())
			UIS:TriggerEvent(b and "InputBegan" or "InputEnded",io,false)
		end
	end)
	Event.Parent = NLS([==[local Event = script:WaitForChild("UserInput_Event")
	local Mouse = owner:GetMouse()
	local UIS = game:GetService("UserInputService")
	local input = function(io,RobloxHandled)
		if RobloxHandled then return end
		--Since InputObject is a client-side instance, we create and pass table instead
		Event:FireServer({KeyCode=io.KeyCode,UserInputType=io.UserInputType,UserInputState=io.UserInputState,Hit=Mouse.Hit,Target=Mouse.Target})
	end
	UIS.InputBegan:Connect(input)
	UIS.InputEnded:Connect(input)

	local h,t
	--Give the server mouse data every second frame, but only if the values changed
	--If player is not moving their mouse, client won't fire events
	local HB = game:GetService("RunService").Heartbeat
	while true do
		if h~=Mouse.Hit or t~=Mouse.Target then
			h,t=Mouse.Hit,Mouse.Target
			Event:FireServer({isMouse=true,Target=t,Hit=h})
		end
		--Wait 2 frames
		for i=1,2 do
			HB:Wait()
		end
	end]==],script)

	----Sandboxed game object that allows the usage of client-side methods and services
	--Real game object
	local RealGame = game

	--Metatable for fake service
	local FakeService_Metatable = {
		__index = function(self,k)
			local s = rawget(self,"_RealService")
			if s then
				return typeof(s[k])=="function"
					and function(_,...)return s[k](s,...)end or s[k]
			end
		end,
		__newindex = function(self,k,v)
			local s = rawget(self,"_RealService")
			if s then s[k]=v end
		end
	}
	local function FakeService(t,RealService)
		t._RealService = typeof(RealService)=="string" and RealGame:GetService(RealService) or RealService
		return setmetatable(t,FakeService_Metatable)
	end

	--Fake game object
	local FakeGame = {
		GetService = function(self,s)
			return rawget(self,s) or RealGame:GetService(s)
		end,
		Players = FakeService({
			LocalPlayer = FakeService({GetMouse=function(self)return FakeMouse end},Player)
		},"Players"),
		UserInputService = FakeService(UIS,"UserInputService"),
		ContextActionService = FakeService(CAS,"ContextActionService"),
		RunService = FakeService({
			_btrs = {},
			RenderStepped = RealGame:GetService("RunService").Heartbeat,
			BindToRenderStep = function(self,name,_,fun)
				self._btrs[name] = self.Heartbeat:Connect(fun)
			end,
			UnbindFromRenderStep = function(self,name)
				self._btrs[name]:Disconnect()
			end,
		},"RunService")
	}
	rawset(FakeGame.Players,"localPlayer",FakeGame.Players.LocalPlayer)
	FakeGame.service = FakeGame.GetService
	FakeService(FakeGame,game)
	--Changing owner to fake player object to support owner:GetMouse()
	game,owner = FakeGame,FakeGame.Players.LocalPlayer
end

local ArtificialHB = Instance.new("BindableEvent",script)
ArtificialHB.Name = "ArtificialHB"

ArtificialHB = script:WaitForChild("ArtificialHB")

local TargetFps = 60
local TargetFrame = 1 / TargetFps
local f = 0

game:GetService("RunService").Heartbeat:Connect(function(s)
	f = f + s
	if f >= TargetFrame then
		for i = 1,math.min(math.floor(f/TargetFrame),100) do
			ArtificialHB:Fire(TargetFps)
		end
		f = f - TargetFrame * math.floor(f/TargetFrame)
	end
end)

function Swait(n)
	if n then
		for i = 1,n do
			ArtificialHB.Event:Wait()
		end
	else
		ArtificialHB.Event:Wait()
	end
end

local mouse = owner:GetMouse()
local character = owner.Character
local hum = character:FindFirstChildWhichIsA("Humanoid")

if hum.RigType == Enum.HumanoidRigType.R15 then
	print("This script doesnt support R15 body type, consider changing your body type to R6 so you wont get any errors.")
end

local sprint = false
local fly = false
local extremepunch = false

local ts = game:GetService("TweenService")

local walk = Instance.new("Sound")
walk.Name = "Walk"
walk.SoundId = "rbxassetid://1873899289"
walk.Looped = true
walk.RollOffMaxDistance = 110
walk.RollOffMode = Enum.RollOffMode.Linear
walk.Volume = 0.7
walk.Parent = character.Torso

local sus = Instance.new("Sound")
sus.Name = "Sussy"
sus.SoundId = "rbxassetid://6595509931"
sus.Parent = character.HumanoidRootPart
sus.Volume = 1

local zombies = {}
local RAC0 = character.Torso["Right Shoulder"].C0
local LAC0 = character.Torso["Left Shoulder"].C0
local RLC0 = character.Torso["Right Hip"].C0
local LLC0 = character.Torso["Left Hip"].C0
local TorsoC0 = character.HumanoidRootPart["RootJoint"].C0
local HeadC0 = character.Torso["Neck"].C0
local debounce = false
local fire = false
local firedbc = false
local runservice = game:GetService("RunService")
humanoid = character:findFirstChildOfClass("Humanoid")
local rightleg = Instance.new("Weld", character.Torso)
rightleg.Part0 = character.Torso
rightleg.Part1 = character["Right Leg"]
rightleg.C0 = CFrame.new(0.5,-2,0)
rightleg.Name = "RightLegWeld"
local leftleg = Instance.new("Weld", character.Torso)
leftleg.Part0 = character.Torso
leftleg.Part1 = character["Left Leg"]
leftleg.C0 = CFrame.new(-0.5,-1,0)
leftleg.Name = "LeftLegWeld"
local humanoidrootpart = Instance.new("Weld", character.HumanoidRootPart)
humanoidrootpart.Part0 = character.HumanoidRootPart
humanoidrootpart.Part1 = character.Torso
humanoidrootpart.Name = "HumanoidRootPartWeld"
rootpart = character.HumanoidRootPart

local billboard = Instance.new("BillboardGui")
billboard.Parent = character.Head
billboard.StudsOffset = Vector3.new(0,3,0)
billboard.Size = UDim2.new(4,0,1,0)
local text = Instance.new("TextLabel")
text.Parent = billboard
text.Text = "EPIC SLAYER PRO"
text.BackgroundTransparency = 1
text.BorderSizePixel = 0
text.Size = UDim2.new(1,0,1,0)
text.TextScaled = true
text.TextStrokeTransparency = 0
text.TextStrokeColor3 = Color3.new(0,0,0)
text.TextColor3 = Color3.new(255,0,0)
text.Font = Enum.Font.Bangers

ScreenGui0 = Instance.new("ScreenGui")
Frame1 = Instance.new("Frame")
TextLabel2 = Instance.new("TextLabel")
ScrollingFrame3 = Instance.new("ScrollingFrame")
UIGridLayout4 = Instance.new("UIGridLayout")
TextLabel5 = Instance.new("TextLabel")
TextLabel6 = Instance.new("TextLabel")
TextLabel7 = Instance.new("TextLabel")
TextLabel8 = Instance.new("TextLabel")
TextLabel9 = Instance.new("TextLabel")
TextLabel10 = Instance.new("TextLabel")
ScreenGui0.Name = "Fard gui lol"
ScreenGui0.Parent = owner.PlayerGui
ScreenGui0.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
Frame1.Parent = ScreenGui0
Frame1.Position = UDim2.new(0.837000787, 0, 0.513957262, 0)
Frame1.Size = UDim2.new(0, 197, 0, 303)
Frame1.AnchorPoint = Vector2.new(0.5, 0.5)
Frame1.BackgroundColor = BrickColor.new("Toothpaste")
Frame1.BackgroundColor3 = Color3.new(0, 1, 1)
Frame1.BackgroundTransparency = 0.80000001192093
TextLabel2.Parent = Frame1
TextLabel2.Position = UDim2.new(0.0609137043, 0, 0, 0)
TextLabel2.Size = UDim2.new(0, 172, 0, 82)
TextLabel2.BackgroundColor = BrickColor.new("Institutional white")
TextLabel2.BackgroundColor3 = Color3.new(1, 1, 1)
TextLabel2.BackgroundTransparency = 1
TextLabel2.Font = Enum.Font.Cartoon
TextLabel2.FontSize = Enum.FontSize.Size14
TextLabel2.Text = "very fard controls "
TextLabel2.TextColor = BrickColor.new("Institutional white")
TextLabel2.TextColor3 = Color3.new(1, 1, 1)
TextLabel2.TextScaled = true
TextLabel2.TextSize = 14
TextLabel2.TextStrokeTransparency = 0
TextLabel2.TextWrap = true
TextLabel2.TextWrapped = true
ScrollingFrame3.Parent = Frame1
ScrollingFrame3.Position = UDim2.new(0, 0, 0.333333343, 0)
ScrollingFrame3.Size = UDim2.new(0, 197, 0, 148)
ScrollingFrame3.Active = true
ScrollingFrame3.BackgroundColor = BrickColor.new("Institutional white")
ScrollingFrame3.BackgroundColor3 = Color3.new(1, 1, 1)
ScrollingFrame3.BackgroundTransparency = 1
ScrollingFrame3.BorderSizePixel = 0
UIGridLayout4.Parent = ScrollingFrame3
UIGridLayout4.SortOrder = Enum.SortOrder.LayoutOrder
UIGridLayout4.CellSize = UDim2.new(0, 184, 0, 50)
TextLabel5.Parent = ScrollingFrame3
TextLabel5.Size = UDim2.new(0, 200, 0, 50)
TextLabel5.BackgroundColor = BrickColor.new("Institutional white")
TextLabel5.BackgroundColor3 = Color3.new(1, 1, 1)
TextLabel5.BackgroundTransparency = 1
TextLabel5.Font = Enum.Font.SourceSans
TextLabel5.FontSize = Enum.FontSize.Size14
TextLabel5.Text = "f = do taco bell fard"
TextLabel5.TextColor = BrickColor.new("Institutional white")
TextLabel5.TextColor3 = Color3.new(1, 1, 1)
TextLabel5.TextScaled = true
TextLabel5.TextSize = 14
TextLabel5.TextStrokeTransparency = 0
TextLabel5.TextWrap = true
TextLabel5.TextWrapped = true
TextLabel6.Parent = ScrollingFrame3
TextLabel6.Size = UDim2.new(0, 200, 0, 50)
TextLabel6.BackgroundColor = BrickColor.new("Institutional white")
TextLabel6.BackgroundColor3 = Color3.new(1, 1, 1)
TextLabel6.BackgroundTransparency = 1
TextLabel6.Font = Enum.Font.SourceSans
TextLabel6.FontSize = Enum.FontSize.Size14
TextLabel6.Text = "x = slap someone from universe"
TextLabel6.TextColor = BrickColor.new("Institutional white")
TextLabel6.TextColor3 = Color3.new(1, 1, 1)
TextLabel6.TextScaled = true
TextLabel6.TextSize = 14
TextLabel6.TextStrokeTransparency = 0
TextLabel6.TextWrap = true
TextLabel6.TextWrapped = true
TextLabel7.Parent = ScrollingFrame3
TextLabel7.Size = UDim2.new(0, 200, 0, 50)
TextLabel7.BackgroundColor = BrickColor.new("Institutional white")
TextLabel7.BackgroundColor3 = Color3.new(1, 1, 1)
TextLabel7.BackgroundTransparency = 1
TextLabel7.Font = Enum.Font.SourceSans
TextLabel7.FontSize = Enum.FontSize.Size14
TextLabel7.Text = "click = slap someone"
TextLabel7.TextColor = BrickColor.new("Institutional white")
TextLabel7.TextColor3 = Color3.new(1, 1, 1)
TextLabel7.TextScaled = true
TextLabel7.TextSize = 14
TextLabel7.TextStrokeTransparency = 0
TextLabel7.TextWrap = true
TextLabel7.TextWrapped = true
TextLabel8.Parent = ScrollingFrame3
TextLabel8.Size = UDim2.new(0, 200, 0, 50)
TextLabel8.BackgroundColor = BrickColor.new("Institutional white")
TextLabel8.BackgroundColor3 = Color3.new(1, 1, 1)
TextLabel8.BackgroundTransparency = 1
TextLabel8.Font = Enum.Font.SourceSans
TextLabel8.FontSize = Enum.FontSize.Size14
TextLabel8.Text = "g = make someone sus"
TextLabel8.TextColor = BrickColor.new("Institutional white")
TextLabel8.TextColor3 = Color3.new(1, 1, 1)
TextLabel8.TextScaled = true
TextLabel8.TextSize = 14
TextLabel8.TextStrokeTransparency = 0
TextLabel8.TextWrap = true
TextLabel8.TextWrapped = true
TextLabel9.Parent = ScrollingFrame3
TextLabel9.Size = UDim2.new(0, 200, 0, 50)
TextLabel9.BackgroundColor = BrickColor.new("Institutional white")
TextLabel9.BackgroundColor3 = Color3.new(1, 1, 1)
TextLabel9.BackgroundTransparency = 1
TextLabel9.Font = Enum.Font.SourceSans
TextLabel9.FontSize = Enum.FontSize.Size14
TextLabel9.Text = "left shift = runn"
TextLabel9.TextColor = BrickColor.new("Institutional white")
TextLabel9.TextColor3 = Color3.new(1, 1, 1)
TextLabel9.TextScaled = true
TextLabel9.TextSize = 14
TextLabel9.TextStrokeTransparency = 0
TextLabel9.TextWrap = true
TextLabel9.TextWrapped = true
TextLabel10.Parent = ScrollingFrame3
TextLabel10.Size = UDim2.new(0, 200, 0, 50)
TextLabel10.BackgroundColor = BrickColor.new("Institutional white")
TextLabel10.BackgroundColor3 = Color3.new(1, 1, 1)
TextLabel10.BackgroundTransparency = 1
TextLabel10.Font = Enum.Font.SourceSans
TextLabel10.FontSize = Enum.FontSize.Size14
TextLabel10.Text = "l = fard"
TextLabel10.TextColor = BrickColor.new("Institutional white")
TextLabel10.TextColor3 = Color3.new(1, 1, 1)
TextLabel10.TextScaled = true
TextLabel10.TextSize = 14
TextLabel10.TextStrokeTransparency = 0
TextLabel10.TextWrap = true
TextLabel10.TextWrapped = true

Fard = Instance.new("ParticleEmitter")
Fard.Parent = character.Torso
Fard.Speed = NumberRange.new(10, 10)
Fard.Color = ColorSequence.new(Color3.new(0.207843, 0.137255, 0.101961),Color3.new(0.0588235, 0.0588235, 0.0588235))
Fard.Enabled = false
Fard.LightInfluence = 1
Fard.Texture = "rbxasset://textures/particles/smoke_main.dds"
Fard.Size = NumberSequence.new(2.2499995231628,0)
Fard.Lifetime = NumberRange.new(5, 5)
Fard.LockedToPart = false
Fard.Rate = 18
Fard.SpreadAngle = Vector2.new(180, -180)
Fard.VelocitySpread = 180

EpicPunch = Instance.new("ParticleEmitter")
EpicPunch.Parent = character["Left Arm"]
EpicPunch.Color = ColorSequence.new(Color3.new(1, 1, 0),Color3.new(0.784314, 0.784314, 0))
EpicPunch.Enabled = false
EpicPunch.LightInfluence = 1
EpicPunch.Texture = "http://www.roblox.com/asset/?id=134531274"
EpicPunch.Size = NumberSequence.new(0.10000000149012,0.10000000149012)
EpicPunch.Acceleration = Vector3.new(0, -25, 0)
EpicPunch.Lifetime = NumberRange.new(1, 1)
EpicPunch.LockedToPart = true
EpicPunch.Rate = 100
EpicPunch.SpreadAngle = Vector2.new(30, 30)
EpicPunch.VelocitySpread = 30

fardsound = Instance.new("Sound")
fardsound.Name = "fard"
fardsound.Parent = character.Torso
fardsound.SoundId = "rbxassetid://7071904730"
fardsound.Volume = 3

local rainbow1 = ts:Create(text, TweenInfo.new(1, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, 0, false, 0),{
	TextColor3 = Color3.fromRGB(255,0,0)
})
local rainbow2 = ts:Create(text, TweenInfo.new(1, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, 0, false, 0),{
	TextColor3 = Color3.fromRGB(255,120,0)
})
local rainbow3 = ts:Create(text, TweenInfo.new(1, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, 0, false, 0),{
	TextColor3 = Color3.fromRGB(255,255,0)
})
local rainbow4 = ts:Create(text, TweenInfo.new(1, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, 0, false, 0),{
	TextColor3 = Color3.fromRGB(0,255,0)
})
local rainbow5 = ts:Create(text, TweenInfo.new(1, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, 0, false, 0),{
	TextColor3 = Color3.fromRGB(0,255,255)
})
local rainbow6 = ts:Create(text, TweenInfo.new(1, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, 0, false, 0),{
	TextColor3 = Color3.fromRGB(0,0,255)
})

local farddbc = false

function spawnZombie(position)
	local npc = Instance.new("Model", workspace)
	npc.Name = "Zombie"
	local hrp = Instance.new("Part", npc)
	hrp.Name = "HumanoidRootPart"
	hrp.Position = position
	hrp.Transparency = 1
	hrp.CanCollide = true
	hrp.Size = Vector3.new(2, 2, 1)
	local torso = Instance.new("Part", npc)
	torso.Name = "Torso"
	torso.Position = hrp.Position
	torso.Transparency = 0
	torso.CanCollide = true
	torso.Size = Vector3.new(2, 2, 1)
	local ra = Instance.new("Part", npc)
	ra.Name = "Right Arm"
	ra.Position = torso.Position + Vector3.new(1.5,0,0)
	ra.Transparency = 0
	ra.CanCollide = true
	ra.Size = Vector3.new(1,2,1)
	local la = Instance.new("Part", npc)
	la.Name = "Left Arm"
	la.Position = torso.Position - Vector3.new(1.5,0,0)
	la.Transparency = 0
	la.CanCollide = true
	la.Size = Vector3.new(1,2,1)
	local rl = Instance.new("Part", npc)
	rl.Name = "Right Leg"
	rl.Position = torso.Position + Vector3.new(0.5,0,0) - Vector3.new(0,2,0)
	rl.Transparency = 0
	rl.CanCollide = true
	rl.Size = Vector3.new(1,2,1)
	local ll = Instance.new("Part", npc)
	ll.Name = "Left Leg"
	ll.Position = torso.Position - Vector3.new(0.5,2,0)
	ll.Transparency = 0
	ll.CanCollide = true
	ll.Size = Vector3.new(1,2,1)
	local h = Instance.new("Part", npc)
	h.Name = "Head"
	h.Position = torso.Position + Vector3.new(0,1,0)
	h.Transparency = 0
	h.CanCollide = true
	h.Size = Vector3.new(2,1,1)
	local mesh = Instance.new("SpecialMesh", h)
	mesh.Scale = Vector3.new(1.25,1.25,1.25)
	local face = Instance.new("Decal",h)
	face.Texture = "rbxasset://textures/face.png"
	face.Name = "Face"
	local nh = Instance.new("Humanoid")
	nh.Parent = npc
	local rootHip = Instance.new("Motor6D", hrp)
	rootHip.Name = "Root Hip"
	rootHip.Part0 = hrp
	rootHip.Part1 = torso
	rootHip.C0 = CFrame.new(0, 0, 0, -1, 0, 0, 0, 0, 1, 0, 1, 0)
	rootHip.C1 = CFrame.new(0, 0, 0, -1, 0, 0, 0, 0, 1, 0, 1, 0)
	local neckJ = Instance.new("Motor6D", torso)
	neckJ.Name = "Neck"
	neckJ.Part0 = torso
	neckJ.Part1 = h
	neckJ.C0 = CFrame.new(0, 1, 0, -1, 0, 0, 0, 0, 1, 0, 1, 0)
	neckJ.C1 = CFrame.new(0, -0.5, 0, -1, 0, 0, 0, 0, 1, 0, 1, 0)
	local rightshoulder = Instance.new("Motor6D", torso)
	rightshoulder.Name = "Right Shoulder"
	rightshoulder.Part0 = torso
	rightshoulder.Part1 = ra
	rightshoulder.C0 = CFrame.new(1, 0.5, 0, -4.37113883e-08, 0, 1, -0, 0.99999994, 0, -1, 0, -4.37113883e-08)
	rightshoulder.C1 = CFrame.new(-0.5, 0.5, 0, -4.37113883e-08, 0, 1, 0, 0.99999994, 0, -1, 0, -4.37113883e-08)
	local leftshoulder = Instance.new("Motor6D", torso)
	leftshoulder.Name = "Left Shoulder"
	leftshoulder.Part0 = torso
	leftshoulder.Part1 = la
	leftshoulder.C0 = CFrame.new(-1, 0.5, 0, -4.37113883e-08, 0, -1, 0, 0.99999994, 0, 1, 0, -4.37113883e-08)
	leftshoulder.C1 = CFrame.new(0.5, 0.5, 0, -4.37113883e-08, 0, -1, 0, 0.99999994, 0, 1, 0, -4.37113883e-08 )
	local righthip = Instance.new("Motor6D", torso)
	righthip.Name = "Right Hip"
	righthip.Part0 = torso
	righthip.Part1 = rl
	righthip.C0 = CFrame.new(1, -1, 0, -4.37113883e-08, 0, 1, -0, 0.99999994, 0, -1, 0, -4.37113883e-08)
	righthip.C1 = CFrame.new(0.5, 1, 0, -4.37113883e-08, 0, 1, 0, 0.99999994, 0, -1, 0, -4.37113883e-08)
	local lefthip = Instance.new("Motor6D", torso)
	lefthip.Name = "Left Hip"
	lefthip.Part0 = torso
	lefthip.Part1 = ll
	lefthip.C0 = CFrame.new(-1, -1, 0, -4.37113883e-08, 0, -1, 0, 0.99999994, 0, 1, 0, -4.37113883e-08)
	lefthip.C1 = CFrame.new(-0.5, 1, 0, -4.37113883e-08, 0, -1, 0, 0.99999994, 0, 1, 0, -4.37113883e-08 )
	
	torso.BrickColor = BrickColor.new("Burnt Sienna")
	ll.BrickColor = BrickColor.new("Burnt Sienna")
	rl.BrickColor = BrickColor.new("Burnt Sienna")
	h.BrickColor = BrickColor.new("Artichoke")
	la.BrickColor = BrickColor.new("Artichoke")
	ra.BrickColor = BrickColor.new("Artichoke")
	
	nh.MaxHealth = 110
	nh.Health = 110
	
	
end

function partShoot(startPos, endPos)
	coroutine.resume(coroutine.create(function()
		local part = Instance.new("Part", script)
		local size = math.random(3,5)
		local rnd = math.random(1,2)
		part.Name = "FirePart"
		part.Material = Enum.Material.Neon
		part.Position = startPos
		part.Size = Vector3.new(size, size, size)
		if rnd == 1 then
			part.BrickColor = BrickColor.new("Bright red")
		else
			part.BrickColor = BrickColor.new("Bright orange")
		end
		part.Anchored = true
		part.CanCollide = false
		part.CanQuery = false
		part.Transparency = math.random(0,0.8)
		part.Touched:Connect(function(hit)
			if hit ~= nil and hit.Parent:IsA("Model") and hit:IsA("BasePart") and hit.Parent:FindFirstChildWhichIsA("Humanoid") then
				local hum = hit.Parent:FindFirstChildWhichIsA("Humanoid")
				hum.Health -= math.random(1,2)
			end
		end)
		for i = 0,1,0.1 do
			part.CFrame = part.CFrame:Lerp(CFrame.new(endPos.X, endPos.Y, endPos.Z), i)
			part.CFrame = part.CFrame:Lerp(part.CFrame * CFrame.Angles(math.rad(math.random(-360,360)),math.rad(math.random(-360,360)),math.rad(math.random(-360,360))), i)
			task.wait()
		end
		part:Destroy()
	end))
end

local RAWeld = Instance.new("Weld")
RAWeld.Parent = character.Torso
RAWeld.Part0 = character.Torso
RAWeld.Part1 = character["Right Arm"]
RAWeld.C0 = character.Torso["Right Shoulder"].C0
RAWeld.C1 = character.Torso["Right Shoulder"].C1

local LAWeld = Instance.new("Weld")
LAWeld.Parent = character.Torso
LAWeld.Part0 = character.Torso
LAWeld.Part1 = character["Left Arm"]
LAWeld.C0 = character.Torso["Left Shoulder"].C0
LAWeld.C1 = character.Torso["Left Shoulder"].C1

local HeadWeld = Instance.new("Weld")
HeadWeld.Parent = character.Torso
HeadWeld.Part0 = character.Torso
HeadWeld.Part1 = character["Head"]
HeadWeld.C0 = character.Torso["Neck"].C0
HeadWeld.C1 = character.Torso["Neck"].C1

hum.MaxHealth = math.huge
hum.Health = math.huge

local dbc = false

coroutine.resume(coroutine.create(function()
	while true do
		rainbow1:Play()
		rainbow1.Completed:Wait()
		rainbow2:Play()
		rainbow2.Completed:Wait()
		rainbow3:Play()
		rainbow3.Completed:Wait()
		rainbow4:Play()
		rainbow4.Completed:Wait()
		rainbow5:Play()
		rainbow5.Completed:Wait()
		rainbow6:Play()
		rainbow6.Completed:Wait()
	end
end))

mouse.Button1Down:Connect(function()
	if debounce == false then
		local num = math.random(1,2)
		if num == 1 then
			debounce = true
			for i = 0,1,0.1 do
				RAWeld.C0 = RAWeld.C0:Lerp(RAC0 * CFrame.Angles(0, math.rad(-0.057), 0), i)
				LAWeld.C0 = LAWeld.C0:Lerp(LAC0 * CFrame.new(0, 0, 0.001) * CFrame.Angles(0, math.rad(0.057),0), i)
				task.wait()
			end
			for i = 0,1,0.1 do
				RAWeld.C0 = RAWeld.C0:Lerp(RAC0 * CFrame.Angles(0, math.rad(4.985), 0), i)
				LAWeld.C0 = LAWeld.C0:Lerp(LAC0 * CFrame.new(0.707, 0, -0.707) * CFrame.Angles(0, math.rad(44.977), math.rad(-90.012)), i)
				task.wait()
			end
			for i = 0,1,0.1 do
				RAWeld.C0 = RAWeld.C0:Lerp(RAC0 * CFrame.Angles(0, math.rad(-5.042), 0), i)
				LAWeld.C0 = LAWeld.C0:Lerp(LAC0 * CFrame.new(-0.061, 0, 0.238) * CFrame.Angles(0, math.rad(-62.51), math.rad(-90.012)), i)
				task.wait()
			end
			
			EpicPunch:Emit(10)
			for _,i in ipairs(workspace:GetDescendants()) do
				if i:IsA("Model") then
					if i ~= character then
						local hum = i:FindFirstChildWhichIsA("Humanoid")
						if hum then
							local dist = nil
							if i:FindFirstChild("HumanoidRootPart") then
								dist = (character.HumanoidRootPart.Position - i.HumanoidRootPart.Position).Magnitude
							elseif i:FindFirstChild("Torso") then
								dist = (character.HumanoidRootPart.Position - i.Torso.Position).Magnitude
							end
							if dist ~= nil then
								if dist < 5 then
									local hum = i:FindFirstChildWhichIsA("Humanoid")
									hum.Health -= math.random(5,15)
								end
							end
						end
					end
				end
			end
			for i = 0,1,0.1 do
				RAWeld.C0 = RAWeld.C0:Lerp(RAC0 * CFrame.Angles(0, math.rad(-0.057), 0), i)
				LAWeld.C0 = LAWeld.C0:Lerp(LAC0 * CFrame.new(0, 0, 0.001) * CFrame.Angles(0, math.rad(0.057), 0), i)
				task.wait()
			end
			for i = 0,1,0.1 do
				RAWeld.C0 = RAWeld.C0:Lerp(RAC0, i)
				LAWeld.C0 = LAWeld.C0:Lerp(LAC0, i)
				task.wait()
			end
			debounce = false
		else
			debounce = true
			for i = 0,1,0.1 do
				RAWeld.C0 = RAWeld.C0:Lerp(RAC0 * CFrame.Angles(0, math.rad(-0.057), 0), i)
				LAWeld.C0 = LAWeld.C0:Lerp(LAC0 * CFrame.new(0, 0, 0.001) * CFrame.Angles(0, math.rad(0.057),0), i)
				task.wait()
			end
			for i = 0,1,0.1 do
				RAWeld.C0 = RAWeld.C0:Lerp(RAC0 * CFrame.Angles(0, math.rad(4.985), 0), i)
				LAWeld.C0 = LAWeld.C0:Lerp(LAC0 * CFrame.new(0.707, 0, -0.707) * CFrame.Angles(0, math.rad(44.977), math.rad(-90.012)), i)
				task.wait()
			end
			for i = 0,1,0.1 do
				RAWeld.C0 = RAWeld.C0:Lerp(RAC0 * CFrame.Angles(0, math.rad(-5.042), 0), i)
				LAWeld.C0 = LAWeld.C0:Lerp(LAC0 * CFrame.new(-0.061, 0, 0.238) * CFrame.Angles(0, math.rad(-62.51), math.rad(-90.012)), i)
				task.wait()
			end
			
			EpicPunch:Emit(10)
			for _,i in ipairs(workspace:GetDescendants()) do
				if i:IsA("Model") then
					if i ~= character then
						local hum = i:FindFirstChildWhichIsA("Humanoid")
						if hum then
							local dist = nil
							if i:FindFirstChild("HumanoidRootPart") then
								dist = (character.HumanoidRootPart.Position - i.HumanoidRootPart.Position).Magnitude
							elseif i:FindFirstChild("Torso") then
								dist = (character.HumanoidRootPart.Position - i.Torso.Position).Magnitude
							end
							if dist ~= nil then
								if dist < 5 then
									local hum = i:FindFirstChildWhichIsA("Humanoid")
									hum.Health -= math.random(15,50)
								end
							end
						end
					end
				end
			end
			for i = 0,1,0.1 do
				RAWeld.C0 = RAWeld.C0:Lerp(RAC0 * CFrame.Angles(0, math.rad(-0.057), 0), i)
				LAWeld.C0 = LAWeld.C0:Lerp(LAC0 * CFrame.new(0, 0, 0.001) * CFrame.Angles(0, math.rad(0.057), 0), i)
				task.wait()
			end
			for i = 0,1,0.1 do
				RAWeld.C0 = RAWeld.C0:Lerp(RAC0, i)
				LAWeld.C0 = LAWeld.C0:Lerp(LAC0, i)
				task.wait()
			end
			debounce = false
		end
	end
end)

mouse.KeyDown:Connect(function(key)
	if key == "f" then
		fire = true
	end
end)

mouse.KeyUp:Connect(function(key)
	if key == "f" then
		fire = false
	end
end)

mouse.KeyDown:Connect(function(key)
	if key == "l" then
		if farddbc == false then
			farddbc = true
			Fard:Emit(800)
			fardsound:Play()
			fardsound.Ended:Wait()
			farddbc = false
		end
	end
end)

mouse.KeyDown:Connect(function(key)
	if key == "x" then
		if debounce == false and extremepunch == false then
			debounce = true
			extremepunch = true
			for i = 0,1,0.1 do
				RAWeld.C0 = RAWeld.C0:Lerp(RAC0 * CFrame.Angles(0, math.rad(-0.057), 0), i)
				LAWeld.C0 = LAWeld.C0:Lerp(LAC0 * CFrame.new(0, 0, 0.001) * CFrame.Angles(0, math.rad(0.057),0), i)
				task.wait()
			end
			for i = 0,1,0.1 do
				RAWeld.C0 = RAWeld.C0:Lerp(RAC0 * CFrame.Angles(0, math.rad(4.985), 0), i)
				LAWeld.C0 = LAWeld.C0:Lerp(LAC0 * CFrame.new(0.707, 0, -0.707) * CFrame.Angles(0, math.rad(44.977), math.rad(-90.012)), i)
				task.wait()
			end
			for i = 0,1,0.1 do
				RAWeld.C0 = RAWeld.C0:Lerp(RAC0 * CFrame.Angles(0, math.rad(-5.042), 0), i)
				LAWeld.C0 = LAWeld.C0:Lerp(LAC0 * CFrame.new(-0.061, 0, 0.238) * CFrame.Angles(0, math.rad(-62.51), math.rad(-90.012)), i)
				task.wait()
			end
			
			EpicPunch:Emit(10)
			for _,i in pairs(workspace:GetChildren()) do
				if i ~= character then
					local hum = i:FindFirstChildWhichIsA("Humanoid")
					if hum then
						local dist = nil
						if i:FindFirstChild("HumanoidRootPart") then
							dist = (character.HumanoidRootPart.Position - i.HumanoidRootPart.Position).Magnitude
						elseif i:FindFirstChild("Torso") then
							dist = (character.HumanoidRootPart.Position - i.Torso.Position).Magnitude
						end
						if dist ~= nil then
							if dist < 5 then
								for _,p in pairs(i:GetDescendants()) do
									if p:IsA("BasePart") then
										p.Anchored = true
										p.BrickColor = BrickColor.new("Really black")
										p.Transparency = 0
										p.Name = "yeet"
										coroutine.resume(coroutine.create(function()
											local tween = ts:Create(p, TweenInfo.new(2),{
												Transparency = 1;
												Position = p.Position + Vector3.new(0,1,0);
											})
											tween:Play()
											tween.Completed:Wait()
											p:Destroy()
											if not i:FindFirstChildWhichIsA("Part") then
												local plr = game.Players:GetPlayerFromCharacter(i)
												if plr then
													plr:LoadCharacter()
												end
											end
										end))
									elseif p:IsA("Decal") then
										p:Destroy()
									end
								end
							end
						end
					end
				end
			end
			for i = 0,1,0.1 do
				RAWeld.C0 = RAWeld.C0:Lerp(RAC0 * CFrame.Angles(0, math.rad(-0.057), 0), i)
				LAWeld.C0 = LAWeld.C0:Lerp(LAC0 * CFrame.new(0, 0, 0.001) * CFrame.Angles(0, math.rad(0.057), 0), i)
				task.wait()
			end
			for i = 0,1,0.1 do
				RAWeld.C0 = RAWeld.C0:Lerp(RAC0, i)
				LAWeld.C0 = LAWeld.C0:Lerp(LAC0, i)
				task.wait()
			end
			debounce = false
			task.wait(5)
			extremepunch = false
		end
	end
end)

mouse.KeyDown:Connect(function(key)
	if key == "g" then
		for _,i in pairs(workspace:GetChildren()) do
			if i ~= character then
				if i:FindFirstChild("HumanoidRootPart") then
					local dist = (i.HumanoidRootPart.Position - character.HumanoidRootPart.Position).Magnitude
					if dist < 5 then
						if not sus.IsPlaying then
							sus:Play()
						end
						if not i.HumanoidRootPart:FindFirstChild("SussyMesh") then
							local mesh = Instance.new("SpecialMesh")
							mesh.Name = "SussyMesh"
							mesh.TextureId = "rbxassetid://6382052846"
							mesh.MeshId = "rbxassetid://6382052801"
							mesh.Scale = Vector3.new(1.5,1.5,1.5)
							mesh.Parent = i.HumanoidRootPart
						end
						for _,p in pairs(i:GetDescendants()) do
							if p:IsA("BasePart") then
								if p.Name ~= "HumanoidRootPart" then
									p.Transparency = 1
								else
									p.Transparency = 0
								end
							elseif p:IsA("Decal") then
								p:Destroy()
							end
						end
					end
				elseif i:FindFirstChild("Torso") then
					local dist = (i.Torso.Position - character.HumanoidRootPart.Position).Magnitude
					if dist < 5 then
						if not sus.IsPlaying then
							sus:Play()
						end
						if not i.Torso:FindFirstChild("SussyMesh") then
							local mesh = Instance.new("SpecialMesh")
							mesh.Name = "SussyMesh"
							mesh.TextureId = "rbxassetid://6382052846"
							mesh.MeshId = "rbxassetid://6382052801"
							mesh.Scale = Vector3.new(1.5,1.5,1.5)
							mesh.Parent = i.Torso
						end
						for _,p in pairs(i:GetDescendants()) do
							if p:IsA("BasePart") and p.Name ~= "Torso" then
								p.Transparency = 1
							elseif p:IsA("Decal") then
								p:Destroy()
							end
						end
					end
				end
			end
		end
	end
end)

mouse.KeyDown:Connect(function(key)
	if key == "leftshift" then
		sprint = true
		--print("sprint")
	end
end)

mouse.KeyUp:Connect(function(key)
	if key == "leftshift" then
		sprint = false
	end
end)

coroutine.resume(coroutine.create(function()
	while task.wait() do

		if rootpart.Velocity.x > 1 or rootpart.Velocity.x < -1 or rootpart.Velocity.z > 1 or rootpart.Velocity.z < -1 then
			if dbc == false then
				dbc = true
				--print("walk")

			end
			humanoidrootpart.C0 = humanoidrootpart.C0:lerp(CFrame.new(0,math.sin(tick()*20)/15,0) * CFrame.Angles(0,math.rad(-rootpart.Orientation.y),math.cos(tick()*10)/15) * CFrame.fromEulerAnglesXYZ(humanoid.MoveDirection.z/6,0,-humanoid.MoveDirection.x/6) * CFrame.Angles(0,math.rad(rootpart.Orientation.y),0),0.3)

			leftleg.C0 = leftleg.C0:lerp(CFrame.new(-0.5,-1+math.cos(tick()*10)/4,0) * CFrame.Angles(0,math.rad(-rootpart.Orientation.y),0) * CFrame.fromEulerAnglesXYZ((-math.sin(tick()*10)*humanoid.MoveDirection.z)/1.5,0,(-math.sin(tick()*10)*-humanoid.MoveDirection.x)/1.5) * CFrame.Angles(0,math.rad(rootpart.Orientation.y),0) * CFrame.new(0,-1,0),0.3)
			rightleg.C0 = rightleg.C0:lerp(CFrame.new(0.5,-1-math.cos(tick()*10)/4,0) * CFrame.Angles(0,math.rad(-rootpart.Orientation.y),0) * CFrame.fromEulerAnglesXYZ((math.sin(tick()*10)*humanoid.MoveDirection.z)/1.5,0,(math.sin(tick()*10)*-humanoid.MoveDirection.x)/1.5) * CFrame.Angles(0,math.rad(rootpart.Orientation.y),0) * CFrame.new(0,-1,0),0.3)
		else
			if dbc == true then
				dbc = false
				--print("idle")

			end
			--humanoidrootpart.C0 = humanoidrootpart.C0:lerp(CFrame.new(0,math.sin(tick()*20)/15,0) * CFrame.Angles(0,math.rad(-rootpart.Orientation.y),math.cos(tick()*10)/15) * CFrame.fromEulerAnglesXYZ(humanoid.MoveDirection.z/6,0,-humanoid.MoveDirection.x/6) * CFrame.Angles(0,math.rad(rootpart.Orientation.y),0),0.3)

			humanoidrootpart.C0 = humanoidrootpart.C0:lerp(CFrame.new(0,math.sin(tick())/0,0) * CFrame.Angles(0,math.rad(0),math.sin(tick())/30),0.3)
			leftleg.C0 = leftleg.C0:lerp(CFrame.new(-0.5,-1-math.sin(tick())/20,0) * CFrame.Angles(0,0,math.rad(-3)-math.sin(tick())/30) * CFrame.new(0,-1,0),0.3)
			rightleg.C0 = rightleg.C0:lerp(CFrame.new(0.5,-1-math.sin(tick())/20,0) * CFrame.Angles(0,0,math.rad(3)-math.sin(tick())/30) * CFrame.new(0,-1,0),0.3)
		end

		if sprint == false then
			humanoid.WalkSpeed = 16
		else
			humanoid.WalkSpeed = 32
		end
		hum.MaxHealth = math.huge
		hum.Health = math.huge
		hum.Name = game:GetService("HttpService"):GenerateGUID(false)
		if hum.MoveDirection ~= Vector3.new(0,0,0) then
			local state = hum:GetState()
			if state == Enum.HumanoidStateType.Running or state == Enum.HumanoidStateType.RunningNoPhysics then
				if not walk.IsPlaying then
					walk:Play()
				end
				coroutine.resume(coroutine.create(function()
					local part = Instance.new("Part", workspace)
					part.BrickColor = BrickColor.new("Really black")
					part.Anchored = true
					part.Size = Vector3.new(4, 0.2, 4)
					part.Position = character.HumanoidRootPart.Position - Vector3.new(0,3,0)
					part.Transparency = 0.85
					part.CanCollide = false
					local mesh = Instance.new("SpecialMesh", part)
					mesh.MeshType = Enum.MeshType.Sphere
					for i = 0.85, 1, 0.05 do
						part.Transparency = i
						wait()
					end
					part:Destroy()
				end))
			else
				if walk.IsPlaying then
					walk:Pause()
				end
			end
		else
			if walk.IsPlaying then
				walk:Pause()
			end
		end
		if hum.DisplayDistanceType ~= Enum.HumanoidDisplayDistanceType.None then
			hum.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.None
		end
	end
end))

coroutine.resume(coroutine.create(function()
	while task.wait(0.05) do
		if fire == true then
			partShoot(character.Torso.Position, character.Torso.Position + (character.Torso.CFrame.LookVector * 30))
		end
	end
end))

hum.Died:Connect(function()
	ScreenGui0:Destroy()
end)
