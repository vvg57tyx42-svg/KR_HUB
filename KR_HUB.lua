-- KR HUB 🌈 完全版 (GitHub用)
loadstring(game:HttpGet('https://raw.githubusercontent.com/shlexware/Rayfield/main/source.lua'))()
local p=game.Players.LocalPlayer
local c=p.Character or p.CharacterAdded:Wait()
local hrp=c:WaitForChild("HumanoidRootPart")
local uis,runs,cam=game:GetService("UserInputService"),game:GetService("RunService"),workspace.CurrentCamera
local KR=Rayfield:CreateWindow({Name="KR HUB 🌈",LoadingTitle="KR HUB",LoadingSubtitle="By You"})
local G=KR:CreateTab("一般"); local E=KR:CreateTab("ESP")

-- 高速スピード
local speed=16
G:CreateSlider({Name="Speed",Range={16,200},Increment=1,CurrentValue=16,Callback=function(v)speed=v end})
runs.Stepped:Connect(function()pcall(function()c:FindFirstChildOfClass("Humanoid").WalkSpeed=speed end)end)

-- 無限ジャンプ
local infJ=false
G:CreateToggle({Name="無限ジャンプ",CurrentValue=false,Flag="infJ",Callback=function(v)infJ=v end})
uis.JumpRequest:Connect(function() if infJ then c:ChangeState("Jumping") end end)

-- オートエイム1
local aim=false
G:CreateToggle({Name="オートエイム1",CurrentValue=false,Callback=function(v)aim=v end})
runs.RenderStepped:Connect(function()
 if not aim then return end
 local t,d=nil,math.huge
 for _,pl in pairs(workspace:GetDescendants()) do
  if pl:IsA("Model") and pl:FindFirstChild("Head") and pl~=c then
   local mag=(pl.Head.Position-hrp.Position).magnitude
   if mag<d then d=mag;t=pl.Head end
  end
 end
 if t then cam.CFrame=CFrame.new(cam.CFrame.Position,t.Position) end
end)

-- オートエイム2
local aim2=false; local radius=100
G:CreateInput({Name="円サイズ",PlaceholderText="100",RemoveTextAfterFocusLost=false,Callback=function(t)radius=tonumber(t) or 100 end})
G:CreateToggle({Name="オートエイム2",CurrentValue=false,Callback=function(v)aim2=v end})
runs.RenderStepped:Connect(function()
 if not aim2 then return end
 for _,pl in pairs(workspace:GetDescendants()) do
  if pl:IsA("Model") and pl:FindFirstChild("Head") and pl~=c then
   local pos,on=cam:WorldToViewportPoint(pl.Head.Position)
   if on and (Vector2.new(pos.X,pos.Y)-Vector2.new(cam.ViewportSize.X/2,cam.ViewportSize.Y/2)).Magnitude<radius then
    cam.CFrame=CFrame.new(cam.CFrame.Position,pl.Head.Position)
   end
  end
 end
end)

-- 飛ぶ
local flying=false
G:CreateToggle({Name="飛ぶ",CurrentValue=false,Callback=function(v)flying=v end})
local bv=Instance.new("BodyVelocity",hrp); bv.MaxForce=Vector3.new(0,0,0)
runs.RenderStepped:Connect(function()
 if flying then bv.MaxForce=Vector3.one*9e9; bv.Velocity=Vector3.new((uis:IsKeyDown(Enum.KeyCode.W)and1 or 0)*speed, (uis:IsKeyDown(Enum.KeyCode.Space)and50 or 0)-(uis:IsKeyDown(Enum.KeyCode.LeftShift)and50 or 0), (uis:IsKeyDown(Enum.KeyCode.D)and1 or 0)*speed) end
end)

-- 人に寄る
local follow=false
G:CreateToggle({Name="人に寄る",CurrentValue=false,Callback=function(v)follow=v end})
runs.Stepped:Connect(function()
 if not follow then return end
 local target
 for _,pl in pairs(workspace:GetChildren()) do
  if pl:IsA("Model") and pl:FindFirstChild("Head") and pl~=c then target=pl break end
 end
 if target then hrp.CFrame=hrp.CFrame:Lerp(CFrame.new(target.Head.Position-Vector3.new(0,0,3)),0.1) end
end)

-- 反対
G:CreateButton({Name="反対",Callback=function() hrp.CFrame=hrp.CFrame*CFrame.Angles(0,math.rad(180),0) end})

-- 回転
local spin=false
G:CreateToggle({Name="回転",CurrentValue=false,Callback=function(v)spin=v end})
runs.RenderStepped:Connect(function() if spin then hrp.CFrame=hrp.CFrame*CFrame.Angles(0,math.rad(5),0) end end)

-- すり抜け
local noclip=false
G:CreateToggle({Name="すり抜け",CurrentValue=false,Callback=function(v)noclip=v end})
runs.Stepped:Connect(function() if noclip then for _,p in pairs(c:GetDescendants()) do if p:IsA("BasePart") then p.CanCollide=false end end end end)

-- ESP
local esp=false; local rainbow=false; local names={}
E:CreateToggle({Name="ESP",CurrentValue=false,Callback=function(v)esp=v end})
E:CreateToggle({Name="虹色",CurrentValue=false,Callback=function(v)rainbow=v end})
runs.RenderStepped:Connect(function()
 if not esp then return end
 for _,pl in pairs(workspace:GetChildren()) do
  if pl:IsA("Model") and pl:FindFirstChild("Head") and pl~=c then
   local pos,on=cam:WorldToViewportPoint(pl.Head.Position)
   if on then
    local t=Drawing.new("Text")
    t.Text=pl.Name; t.Position=Vector2.new(pos.X,pos.Y)
    t.Color=rainbow and Color3.fromHSV(tick()%5/5,1,1) or Color3.new(1,0,0)
    t.Size=13; t.Center=true; table.insert(names,t)
   end
  end
 end
 task.wait(0.1)
 for _,n in pairs(names) do n:Remove() end names={}
end)
