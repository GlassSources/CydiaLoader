local socket = require("socket")
local http = require("socket.http")
PLUGIN = nil

function Initialize(Plugin)
	if socket == nil then
		LOG("LuaSocket cannot be found! Please add it for Cydia to work!")
		return false
	end
	Plugin:SetName("CydiaScriptLoader")
	Plugin:SetVersion(1)
	cPluginManager.BindCommand("/cydia", "cydia.load", cydiaLoad, " ~ The main Cydia loader command to load cydia files.")
	cPluginManager.BindCommand("/cydiaHelp", "cydia.help", cydiaHelp, " - Cydia information and how to use.")
	cPluginManager.BindCommand("/luapackage", "cydia.debian", cydiaLoader, " ~ Run code instanly instead from pastebin.")
	cPluginManager.BindCommand("/cydiaVersion", "cydia.version", cydiaVersion, " - Find out what version of Cydia this is running.")
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
	local code = http.request(newWeb)
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
	Player:SendMessage("Running Cydia - Build 1, development release.")
end

function OnDisable()
	LOG("Cydia is disabled! All Cydia Commands are inactive!")
end
