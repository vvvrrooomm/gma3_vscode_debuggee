local debuggee = {}

require("gma3_helpers")
local lfs = require 'lfs'
local socket = require 'socket.core'
local json = require "json"
local handlers = {}
local sock
local directorySeperator = package.config:sub(1, 1)
local sourceBasePath = '.'
local storedVariables = {}
local nextVarRef = 1
local baseDepth
local breaker
local sendEvent
local dumpCommunication = false
local ignoreFirstFrameInC = false
local debugTargetCo = nil
local redirectedPrintFunction
local dumpGMA3 = false; -- used for analysing the debugger
local breakpointsPerPath = {}

local onError = nil
local addUserdataVar = nil

if HostType == nil then
    function HostType()
        return 'darwin';
    end
end

if Printf == nil then
    function Printf(msg)
        print(msg)
    end
end

if assert == nil then
    function assert(condition, message)
        if not condition then
            print(message or "Assertion failed!")
            print("continuing")
        end
    end
end


function tprint (tbl, indent)
  if not indent then indent = 0 end
  local toprint = string.rep(" ", indent) .. "{\r\n"
  indent = indent + 2 
  for k, v in pairs(tbl) do
    toprint = toprint .. string.rep(" ", indent)
    if (type(k) == "number") then
      toprint = toprint .. "[" .. k .. "] = "
    elseif (type(k) == "string") then
      toprint = toprint  .. k ..  "= "   
    end
    if (type(v) == "number") then
      toprint = toprint .. v .. ",\r\n"
    elseif (type(v) == "string") then
      toprint = toprint .. "\"" .. v .. "\",\r\n"
    elseif (type(v) == "table") then
      toprint = toprint .. tprint(v, indent + 2) .. ",\r\n"
    else
      toprint = toprint .. "\"" .. tostring(v) .. "\",\r\n"
    end
  end
  toprint = toprint .. string.rep(" ", indent-2) .. "}"
  return toprint
end

local vscode=require('vscode-debuggee')
local success,sock = vscode.start(json,{controllerHost="localhost",controllerPort=56789})
print("Debugger started", success, sock)