-- Console
-- Crazyman32
-- May 30, 2019

--[[

	Properties:

		Console.Enabled


	Methods:

		Console:Log(...)
		Console:Warn(...)
		Console:Error(errorMessage)
		Console:Assert(condition, ...)
		Console:Time([label])
		Console:TimeLog([label])
		Console:TimeEnd([label])
		Console:GetHistory()


	Events:
	
		Console.MessageOut(message, messageType)

--]]



local Console = {
	Enabled = true;
}

local DEFAULT_TIME_LABEL = "default"

local timeLabels = {}


local errorEvent = Instance.new("BindableEvent")
errorEvent.Event:Connect(function(err)
	error(err, 0)
end)


local function ResolveTimeLabel(label)
	if (label == nil) then label = DEFAULT_TIME_LABEL end
	assert(type(label) == "string", "Label must be a string or nil")
	return label
end


function Console:Log(...)
	if (not self.Enabled) then return end
	print(...)
end


function Console:Warn(...)
	if (not self.Enabled) then return end
	warn(...)
end


function Console:Error(err)
	if (not self.Enabled) then return end
	errorEvent:Fire(err)
end


function Console:Assert(condition, ...)
	if (not condition) then
		self:Error(...)
	end
end


function Console:Time(label)
	label = ResolveTimeLabel(label)
	if (timeLabels[label]) then
		self:Warn("Timer '" .. label .. "' already exists")
		return
	end
	timeLabels[label] = tick()
end


function Console:TimeLog(label)
	label = ResolveTimeLabel(label)
	if (not timeLabels[label]) then
		self:Warn("Timer '" .. label .. "' does not exist")
		return
	end
	local duration = ((tick() - timeLabels[label]) * 1000)
	self:Log(label .. ": " .. tostring(duration) .. "ms")
end


function Console:TimeEnd(label)
	label = ResolveTimeLabel(label)
	self:TimeLog(label)
	timeLabels[label] = nil
end


function Console:GetHistory()
	return game:GetService("LogService"):GetLogHistory()
end


function Console:Init()
	self.MessageOut = game:GetService("LogService").MessageOut
end


return Console