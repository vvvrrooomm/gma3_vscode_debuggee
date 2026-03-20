---------------------------------------------------------------------------
function activateDebuggee()
    local json = require 'json'
    debuggee = require 'vscode-debuggee'

    local config = {
        dumpCommunication = true, -- dump communication in debug console
        dumpGMA3 = false,
        controllerHost = "127.0.0.1",
        controllerPort = 56789
    }

    if (HostType() == "Linux" or HostType() == "Console") then
        local cmdresult = gma3_helpers:osExecuteWithResult("grep nfs /proc/mounts | cut -f1 -d ':'");
        if (cmdresult ~= nil) then
            config.controllerHost = cmdresult;
            Echo("LUA debugger IP: " .. config.controllerHost);
        end
    end

    local startResult, breakerType = debuggee.start(json, config)
    Printf('json library:         ' .. tostring(json))
    Printf('debuggee library:     ' .. tostring(debuggee))
    Printf('debuggee breakertype: ' .. tostring(breakerType))
    Printf('debuggee startresult: ' .. tostring(startResult))
    return debuggee;
end

function Echo(...)
    Printf(...)
end
---------------------------------------------------------------------------
return activateDebuggee
