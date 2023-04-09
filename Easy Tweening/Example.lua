--// Variables \\--
local EasyTweening = require(game.ReplicatedStorage.TweenModule)
local TweenInformation = TweenInfo.new(
		5, -- Time
		Enum.EasingStyle.Linear, -- Easing Style
		Enum.EasingDirection.InOut, -- Easing Direction
		0, -- Repeat Amount
		false, -- Reverse
		7 -- Delay
)
local Goals = {
    CFrame = workspace.Baseplate.CFrame * CFrame.new(0, 2, 0)
}
local Object = workspace.Baseplate

--// Methods \\--
local EasyTweeningNew = EasyTweening:new('Baseplate Tween') -- Thread Name
local Tween = EasyTweeningNew:CreateTween(Object, TweenInformation, Goals)begin(function(Playback, Func)
		print("Tween Loaded [Runs once before :play() invoked")
		Func()
	end, function()
		print('This is the "Func" variable in :begin()') 
	end):play(4):started(function(Data) 
		print('Tween Started [Invoked :play()]', Data) 
	end, "!"):completed(function(Playback, Number)
		print('Tween Completed [Tween Ended]', Number)
	end, 1):playing(function(Playback, InstanceName)
		print("Tween Playing [While it's running]", InstanceName)
	end, Object.Name):delayed(function(Playback, String)
		print("Tween Delayed [Hasn't ran yet due to \"Delay\" variable in TweenInfo", String)
	end, "Hello"):stop(2):getTween()

print(Tween.Instance) -- Prints "Baseplate"

for Index, ThreadData in pairs(Mod.GetThreads()) do -- Gets all threads
	print(Index, ThreadData)
end

for Index, ThreadData in pairs(Mod.GetThreadData("Baseplate Tween")) do -- Gets Tween off Thread Name
  print(Index, ThreadData)
end
