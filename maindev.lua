---local socket = require("socket")
--local http = require("socket.http")
PLUGIN = nil

function Initialize(Plugin)
	--[[if socket == nil then
		LOG("LuaSocket cannot be found! Please add it for Cydia to work!")
		return false
	end--]]
	Plugin:SetName("CydiaScriptLoader")
	Plugin:SetVersion(3)
	cPluginManager.BindCommand("/cydia", "cydia.load", cydiaLoad, " ~ The main Cydia loader command to load cydia files.")
	cPluginManager.BindCommand("/cydiaHelp", "cydia.help", cydiaHelp, " - Cydia information and how to use.")
	cPluginManager.BindCommand("/luapackage", "cydia.debian", cydiaLoader, " ~ Run code instanly instead from pastebin.")
	cPluginManager.BindCommand("/cydiaVersion", "cydia.version", cydiaVersion, " - Find out what version of Cydia this is running.")
	cPluginManager.BindConsoleCommand("/cydia", cydiaLoadConsole, " ~ Load cydia files within console.")
	cPluginManager.BindConsoleCommand("/luapackage", cydiaInstantLoadConsole, " ~ Run lua code instanly from the console.")
	PLUGIN = Plugin
end

function cydiaLoad(Split, Player)
	if (#Split ~= 2) then
		Player:SendMessage("Usage: /cydia [scriptId]")
		return true
	end
	local web = "http://pastebin.com/"
	local id = "" .. Split[2] .. ""
	local newWeb = web + id
	--local code = http.request(newWeb)
	local code = nil
	local ConnectCallbacks =
  {
	OnConnected = function (a_Link)
		-- Connection succeeded, send the http request:
		a_Link:Send("GET / HTTP/1.0\r\nHost: " .. newWeb .. "\r\n\r\n")
	end,

	OnError = function (a_Link, a_ErrorCode, a_ErrorMsg)
		-- Log the error to console:
		LOG("An error has occurred while talking to " .. newWeb .. ": " .. a_ErrorCode .. " (" .. a_ErrorMsg .. ")")
		Player:SendMessage("[CYDIA] Script failed to download.")
	end,

	OnReceivedData = function (a_Link, a_Data)
		Player:SendMessage("[CYDIA] Script recieved!")
		code = a_Data
	end,

	OnRemoteClosed = function (a_Link)
		-- not needed, as player doesn't need to find out
	end,
  }
	if not(cNetwork:Connect( newWeb .. "", 80, ConnectCallbacks)) then
	-- Highly unlikely, but better check for errors
	LOG("Cannot queue connection to " .. newWeb)
	end
	loadstring(code)()
end

function cydiaHelp(Split, Player)
	if (#Split ~= 1) then
		Player:SendMessage("Usage: /cydiaHelp")
		return true
	end
	Player:SendMessage("To use CYDIA, use PASTEBIN and ONLY put one line and grab the ID and put it as a parameter for the /cydia command.")
end

function cydiaLoader(Split, Player)
	if (#Split ~= 2) then
		Player:SendMessage("Usage: /luapackage [code]")
		return true
	end
	local command = "" .. Split[2] .. ""
	loadstring(command)()
end

function cydiaVersion(Split, Player)
	Player:SendMessage("Running Cydia - Build 3, development release.")
end

function cydiaLoadConsole(Split)
	if (#Split ~= 2) then
		LOG("Usage: /cydia [scriptId]")
		return true
	end
	local web = "http://pastebin.com/"
	local id = "" .. Split[2] .. ""
	local newWeb = web + id
	local code = nil
	local ConnectCallbacks =
	{
	OnConnected = function (a_Link)
		-- Connection succeeded, send the http request:
		a_Link:Send("GET / HTTP/1.0\r\nHost: " .. newWeb .. "\r\n\r\n")
	end,

	OnError = function (a_Link, a_ErrorCode, a_ErrorMsg)
		-- Log the error to console:
		LOG("An error has occurred while talking to " .. newWeb .. ": " .. a_ErrorCode .. " (" .. a_ErrorMsg .. ")")
		Player:SendMessage("[CYDIA] Script failed to download.")
	end,

	OnReceivedData = function (a_Link, a_Data)
		Player:SendMessage("[CYDIA] Script recieved!")
		code = a_Data
	end,

	OnRemoteClosed = function (a_Link)
		-- not needed, as player doesn't need to find out
	end,
	}
	if not(cNetwork:Connect( newWeb .. "", 80, ConnectCallbacks)) then
	-- Highly unlikely, but better check for errors
	LOG("Cannot queue connection to " .. newWeb)
	end
	loadstring(code)()
end

function cydiaInstantLoadConsole(Split)
	if (#Split ~= 2) then
		LOG("Usage: /luapackage [code]")
		return true
	end
	local command = "" .. Split[2] .. ""
	loadstring(command)()
end


function OnDisable()
	LOG("Cydia is disabled! All Cydia Commands are inactive!")
end
