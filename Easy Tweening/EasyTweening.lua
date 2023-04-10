local Tweenservice = game:GetService('TweenService')
local BT = {}
BT.__index = BT

local StartTime = 0

local BTCons = {}
BTCons.__index = BTCons

local BTFunctions = {}
BTFunctions.__index = BTFunctions
local BTFunctionsPlayed = {}
BTFunctionsPlayed.__index = BTFunctionsPlayed
local Threads = {}

local delayed = Instance.new('BoolValue')

function BT:new(ThreadName: string)
	assert(type(ThreadName) == 'string', "Argument #1 \"ThreadName\" should be a string.")
	
	local t = {}
	t._name = ThreadName
	
	Threads[#Threads + 1] = {
		_Status = "Paused",
		_ThreadName = t._name,
		_connections = {}
	}
	
	return setmetatable(t, BTCons)
end

function BT.GetThreads()
	local ThreadInfo = {}
	for TIndex, TData in pairs(Threads) do
		ThreadInfo[TIndex] = TData
	end
	
	return ThreadInfo
end

local function FindThreadInTable(ThreadName: string)
	assert(type(ThreadName) == "string", "Argument #1 \"ThreadName\" should be a string.")

	for Index, Data in pairs(Threads) do
		if (Data._ThreadName == ThreadName) then
			return true, Data, Index
		end
	end

	return false, nil, nil
end

function BT.GetThreadData(ThreadName: string)
	local Found, Data, Index = FindThreadInTable(ThreadName)
	
	assert(Found == true, ("%s is not a valid thread"):format(ThreadName))
	
	return {
		INDEX = Index,
		DATA = Data
	}
end

function BTCons:CreateTween(Object: Instance, TweenInformation: TweenInfo, Goal: { any })
	assert(typeof(Object) == "Instance", "Argument #1 \"Object\" should be an Instance.")
	assert(typeof(TweenInformation) == "TweenInfo", "Argument #2 \"TweenInformation\" should be a TweenInfo.")
	assert(type(Goal) == "table", "Argument #3 \"Object\" should be a table / array / list.")
	
	local Found, Thread = FindThreadInTable(self._name)

	if not Found and Thread == nil then
		warn(("Thread Error: %s is already an available thread."):format(self._name))
		return
	end
	
	local Tween = Tweenservice:Create(Object, TweenInformation, Goal)
	self._tween = Tween
	Tween:GetPropertyChangedSignal('PlaybackState'):Connect(function()
		if Tween.PlaybackState == Enum.PlaybackState.Playing then
			StartTime = tick()
			delayed.Value = false
		elseif Tween.PlaybackState == Enum.PlaybackState.Delayed then
			delayed.Value = true
		end
	end)
	local t = {}
	t._tween = self._tween or Tween
	t._name = self._name

	--setmetatable(t, BTCons)
	setmetatable(BTCons, t)
	
	return setmetatable(self, BTFunctions)
end

local played = Instance.new('BoolValue')

function BTFunctionsPlayed:completed(Callback, ...)
	local Tween = self._tween
	local args = {...}
	assert(type(Callback) == "function", "Argument #1 \"Callback\" should be a function.")
	assert(Tween.ClassName == "Tween" and typeof(Tween) == "Instance", "Argument #1 \"Tween\" should be a Tween")

	local Found, Data = FindThreadInTable(self._name)

	if table.find(Data._connections, 'completed') then
		error("Function: 'Completed' is already connected.", 1)
		return
	end
	assert(Found == true, ("%s is not a valid thread"):format(self._name))
	table.insert(Data._connections, 'completed')
	local CompletedFunction = function(Playback)
		local Found, Data = FindThreadInTable(self._name)

		if Found == false then
			warn(("%s is not a valid thread"):format(self._name))
		end
		if Playback == Enum.PlaybackState.Completed then
			Data._Status = Tween.PlaybackState.Name
			Callback(Playback, table.unpack(args))
		end
	end

	Tween.Completed:Connect(CompletedFunction)

	return setmetatable(self, BTFunctionsPlayed)
end

function BTFunctionsPlayed:cancelled(Callback, ...)
	local Tween = self._tween
	local args = {...}
	assert(type(Callback) == "function", "Argument #1 \"Callback\" should be a function.")
	assert(Tween.ClassName == "Tween" and typeof(Tween) == "Instance", "Argument #1 \"Tween\" should be a Tween")

	local Found, Data = FindThreadInTable(self._name)

	if table.find(Data._connections, 'cancelled') then
		error("Function: 'Cancelled' is already connected.", 1)
		return
	end
	assert(Found == true, ("%s is not a valid thread"):format(self._name))
	table.insert(Data._connections, 'cancelled')

	local CancelledFunction = function(Playback)
		local Found, Data = FindThreadInTable(self._name)

		if Found == false then
			warn(("%s is not a valid thread"):format(self._name))
		end
		if Playback == Enum.PlaybackState.Cancelled then
			Data._Status = Tween.PlaybackState.Name
			Callback(Playback, table.unpack(args))
		end
	end

	Tween.Completed:Connect(CancelledFunction)

	return setmetatable(self, BTFunctionsPlayed)
end

function BTFunctionsPlayed:stop(StopDelay: number)
	if played.Value == false then
		repeat wait() until played.Value == true
	end
	StopDelay = StopDelay or 0
	local Found, Data, Index = FindThreadInTable(self._name)

	assert(Found == true, "Thread was not found.")
	assert(type(StopDelay) == "number", "Argument #1 \"StopDelay\" should be a number.")
	assert(self._tween.ClassName == "Tween" and typeof(self._tween) == "Instance", "Tween is not existing or nil.")

	task.delay(StopDelay, function()
		Threads[Index]._Status = "Cancelled"
		self._tween:Cancel()
		table.remove(Threads, Index)
	end)

	return setmetatable(self, BTFunctionsPlayed)
end

function BTFunctionsPlayed:pause(PauseDelay: number)
	PauseDelay = PauseDelay or 0
	local Found, Data, Index = FindThreadInTable(self._name)

	assert(Found == true, "Thread was not found.")
	assert(type(PauseDelay) == "number", "Argument #1 \"StopDelay\" should be a number.")
	assert(self._tween.ClassName == "Tween" and typeof(self._tween) == "Instance", "Tween is not existing or nil.")

	task.delay(PauseDelay, function()
		Threads[Index]._Status = "Cancelled"
		self._tween:Pause()
		table.remove(Threads, Index)
	end)

	return setmetatable(self, BTFunctionsPlayed)
end

function BTFunctionsPlayed:playing(Callback, ...)
	local Tween = self._tween
	local args = {...}
	assert(type(Callback) == "function", "Argument #1 \"Callback\" should be a function.")
	assert(Tween.ClassName == "Tween" and typeof(Tween) == "Instance", "Argument #1 \"Tween\" should be a Tween")

	local Found, Data = FindThreadInTable(self._name)

	if table.find(Data._connections, 'playing') then
		error("Function: 'Playing' is already connected.", 1)
		return
	end
	assert(Found == true, ("%s is not a valid thread"):format(self._name))
	table.insert(Data._connections, 'playing')

	local PlayingFunction = function(Tween)
		while true do
			local Found, Data = FindThreadInTable(self._name)

			if Found == false then
				warn(("%s is not a valid thread"):format(self._name))
				break
			end
			local Playback = Tween.PlaybackState
			
			if Playback == Enum.PlaybackState.Playing then
				Data._Status = Tween.PlaybackState.Name
				Callback(Playback, table.unpack(args))
				task.wait()
			end
			task.wait()
		end
	end
	
	task.spawn(PlayingFunction, Tween)

	return setmetatable(self, BTFunctionsPlayed)
end

function BTFunctionsPlayed:started(Callback, ...)
	local Tween = self._tween
	local args = {...}
	assert(type(Callback) == "function", "Argument #1 \"Callback\" should be a function.")
	assert(Tween.ClassName == "Tween" and typeof(Tween) == "Instance", "Argument #1 \"Tween\" should be a Tween")

	local Found, Data = FindThreadInTable(self._name)

	if table.find(Data._connections, 'started') then
		error("Function: 'Started' is already connected.", 1)
		return
	end
	
	played:GetPropertyChangedSignal('Value'):Connect(function()
		if played.Value == true then
			table.insert(Data._connections, 'started')
			Callback(table.unpack(args))
		end
	end)

	return setmetatable(self, BTFunctionsPlayed)
end

function BTFunctionsPlayed:paused(Callback, ...)
	local Tween = self._tween
	local args = {...}
	assert(type(Callback) == "function", "Argument #1 \"Callback\" should be a function.")
	assert(Tween.ClassName == "Tween" and typeof(Tween) == "Instance", "Argument #1 \"Tween\" should be a Tween")

	local Found, Data = FindThreadInTable(self._name)

	if table.find(Data._connections, 'paused') then
		error("Function: 'Paused' is already connected.", 1)
		return
	end
	assert(Found == true, ("%s is not a valid thread"):format(self._name))
	table.insert(Data._connections, 'paused')

	local PausedFunction = function()
		local Found, Data = FindThreadInTable(self._name)

		if Found == false then
			warn(("%s is not a valid thread"):format(self._name))
		end
		local Playback = Tween.PlaybackState

		if Playback == Enum.PlaybackState.Playing then
			Data._Status = Tween.PlaybackState.Name
			Callback(Playback, table.unpack(args))
		end
	end

	Tween:GetPropertyChangedSignal('PlaybackState'):Connect(PausedFunction)

	return setmetatable(self, BTFunctionsPlayed)
end

function BTFunctionsPlayed:delayed(Callback, ...)
	local Tween = self._tween
	local args = {...}
	assert(type(Callback) == "function", "Argument #1 \"Callback\" should be a function.")
	assert(Tween.ClassName == "Tween" and typeof(Tween) == "Instance", "Argument #1 \"Tween\" should be a Tween")

	local Found, Data = FindThreadInTable(self._name)

	if table.find(Data._connections, 'delayed') then
		error("Function: 'Delayed' is already connected.", 1)
		return
	end
	assert(Found == true, ("%s is not a valid thread"):format(self._name))
	table.insert(Data._connections, 'delayed')

	local DelayedFunction = function(Tween)
		while true do
			local Found, Data = FindThreadInTable(self._name)

			if Found == false then
				warn(("%s is not a valid thread"):format(self._name))
				break
			end
			local Playback = Tween.PlaybackState

			if Playback == Enum.PlaybackState.Delayed then
				delayed.Value = true
				Data._Status = Tween.PlaybackState.Name
				Callback(Playback, table.unpack(args))
				task.wait()
			end
			task.wait()
		end
	end

	task.spawn(DelayedFunction, Tween)

	return setmetatable(self, BTFunctionsPlayed)
end

function BTFunctions:play(StartDelay: number)

	StartDelay = StartDelay or 0
	assert(type(StartDelay) == "number", "Argument #1 \"StartDelay\" should be a number.")
	assert(self._tween.ClassName == "Tween" and typeof(self._tween) == "Instance", "Tween is nil or invalid")

	task.delay(StartDelay, function()
		self._tween:Play()
		played.Value = true
	end)

	self._name = self._name

	return setmetatable(self, BTFunctionsPlayed)
end

function BTFunctions:begin(Callback, ...)
	local Tween = self._tween
	local args = {...}
	assert(type(Callback) == "function", "Argument #1 \"Callback\" should be a function.")
	assert(Tween.ClassName == "Tween" and typeof(Tween) == "Instance", "Argument #1 \"Tween\" should be a Tween")

	local Found, Data = FindThreadInTable(self._name)

	if table.find(Data._connections, 'begin') then
		error("Function: 'Begin' is already connected.", 1)
		return
	end
	assert(Found == true, ("%s is not a valid thread"):format(self._name))
	table.insert(Data._connections, 'begin')

	local BeginFunction = function()
		local Found, Data = FindThreadInTable(self._name)

		assert(Found == true, ("%s is not a valid thread"):format(self._name))
		
		local Playback = Tween.PlaybackState

		if Playback == Enum.PlaybackState.Begin then
			Data._Status = Tween.PlaybackState.Name
			Callback(Playback, table.unpack(args))
		end
	end

	BeginFunction(Tween)

	return setmetatable(self, BTFunctions)
end

function BTFunctionsPlayed:delay(Time: number, Callback, ...)
	local args = {...}
	assert(type(Time) == 'number', "Argument #1 \"Time\" should be a number.")
	assert(typeof(Callback) == 'function', "Argument #1 \"Time\" should be a function.")
	
	if played.Value == false then
		repeat wait() until played.Value == true
	end

	if delayed.Value == true then
		repeat wait() until delayed.Value == false
	end
	
	task.delay(Time, function()
		Callback(table.unpack(args))
	end)
	
	return setmetatable(self, BTFunctionsPlayed)
end

function BTFunctionsPlayed:getTween()
	assert(self._tween.ClassName == "Tween" and typeof(self._tween) == "Instance", "\"module:getTween\" failed because \"self._tween\" is not a class type of Tween.")
	return self._tween
end

function BT.getTimeToGoal(Tween: Tween)
	if getmetatable(BTCons)._name == nil then
		warn("_name not found")
		return
	end
	local Found, Data = FindThreadInTable(getmetatable(BTCons)._name)
	
	if not Found then
		warn("Thread not found in table.")
		return
	end
	
	if Tween == nil then
		if getmetatable(BTCons)._tween ~= nil then
			Tween = getmetatable(BTCons)._tween
		else
			warn("Tween doesn't exist.")
			return
		end
	end
	
	assert(Tween.ClassName == "Tween" and typeof(Tween) == "Instance", "Argument #1 \"Tween\" should be a class type of Tween.")
	
	local FinishTime = 0
	
	FinishTime = tick()
	
	local timeleft = math.clamp(((FinishTime - StartTime) / getmetatable(BTCons)._tween.TweenInfo.Time), 0, 1)
	
	return timeleft
end

return BT
