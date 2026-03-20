-- actboy_protocol.lua
-- Implementation of the Debug Adapter Protocol (DAP) schema in Lua
-- This module provides functions to create and handle DAP messages
-- Assumes a sendJson(dict) function that sends a Lua table as JSON and returns the response as a Lua table

local actboy_protocol = {}

-- Sequence number for messages
local seq_counter = 0

-- Base ProtocolMessage
function actboy_protocol.createProtocolMessage(type)
    return {
        seq = seq_counter,
        type = type
    }
end

-- Request
function actboy_protocol.createRequest(command, arguments)
    local msg = actboy_protocol.createProtocolMessage("request")
    msg.command = command
    msg.arguments = arguments
    seq_counter = seq_counter + 1
    return msg
end

-- Response
function actboy_protocol.createResponse(request_seq, success, command, body, message)
    local msg = actboy_protocol.createProtocolMessage("response")
    msg.request_seq = request_seq
    msg.success = success
    msg.command = command
    msg.body = body
    if not success then
        msg.message = message
    end
    seq_counter = seq_counter + 1
    return msg
end

-- Event
function actboy_protocol.createEvent(event, body)
    local msg = actboy_protocol.createProtocolMessage("event")
    msg.event = event
    msg.body = body
    seq_counter = seq_counter + 1
    return msg
end

-- Send a request using the assumed sendJson function
function actboy_protocol.sendRequest(command, arguments)
    local request = actboy_protocol.createRequest(command, arguments)
    -- Assume sendJson is available globally or passed in
    -- return sendJson(request)
    return request
end

-- Specific request types (examples)
function actboy_protocol.initialize(args)
    return actboy_protocol.sendRequest("initialize", args)
end

function actboy_protocol.launch(args)
    return actboy_protocol.sendRequest("launch", args)
end

function actboy_protocol.attach(args)
    return actboy_protocol.sendRequest("attach", args)
end

function actboy_protocol.disconnect(args)
    return actboy_protocol.sendRequest("disconnect", args)
end

function actboy_protocol.terminate(args)
    return actboy_protocol.sendRequest("terminate", args)
end

function actboy_protocol.restart(args)
    return actboy_protocol.sendRequest("restart", args)
end

function actboy_protocol.setBreakpoints(args)
    return actboy_protocol.sendRequest("setBreakpoints", args)
end

function actboy_protocol.setFunctionBreakpoints(args)
    return actboy_protocol.sendRequest("setFunctionBreakpoints", args)
end

function actboy_protocol.setExceptionBreakpoints(args)
    return actboy_protocol.sendRequest("setExceptionBreakpoints", args)
end

function actboy_protocol.configurationDone(args)
    return actboy_protocol.sendRequest("configurationDone", args)
end

function actboy_protocol.continue(args)
    return actboy_protocol.sendRequest("continue", args)
end

function actboy_protocol.next(args)
    return actboy_protocol.sendRequest("next", args)
end

function actboy_protocol.stepIn(args)
    return actboy_protocol.sendRequest("stepIn", args)
end

function actboy_protocol.stepOut(args)
    return actboy_protocol.sendRequest("stepOut", args)
end

function actboy_protocol.stepBack(args)
    return actboy_protocol.sendRequest("stepBack", args)
end

function actboy_protocol.reverseContinue(args)
    return actboy_protocol.sendRequest("reverseContinue", args)
end

function actboy_protocol.restartFrame(args)
    return actboy_protocol.sendRequest("restartFrame", args)
end

function actboy_protocol.gotoLine(args)
    return actboy_protocol.sendRequest("goto", args)
end

function actboy_protocol.pause(args)
    return actboy_protocol.sendRequest("pause", args)
end

function actboy_protocol.stackTrace(args)
    return actboy_protocol.sendRequest("stackTrace", args)
end

function actboy_protocol.scopes(args)
    return actboy_protocol.sendRequest("scopes", args)
end

function actboy_protocol.variables(args)
    return actboy_protocol.sendRequest("variables", args)
end

function actboy_protocol.setVariable(args)
    return actboy_protocol.sendRequest("setVariable", args)
end

function actboy_protocol.source(args)
    return actboy_protocol.sendRequest("source", args)
end

function actboy_protocol.threads(args)
    return actboy_protocol.sendRequest("threads", args)
end

function actboy_protocol.terminateThreads(args)
    return actboy_protocol.sendRequest("terminateThreads", args)
end

function actboy_protocol.modules(args)
    return actboy_protocol.sendRequest("modules", args)
end

function actboy_protocol.loadedSources(args)
    return actboy_protocol.sendRequest("loadedSources", args)
end

function actboy_protocol.evaluate(args)
    return actboy_protocol.sendRequest("evaluate", args)
end

function actboy_protocol.setExpression(args)
    return actboy_protocol.sendRequest("setExpression", args)
end

function actboy_protocol.stepInTargets(args)
    return actboy_protocol.sendRequest("stepInTargets", args)
end

function actboy_protocol.gotoTargets(args)
    return actboy_protocol.sendRequest("gotoTargets", args)
end

function actboy_protocol.completions(args)
    return actboy_protocol.sendRequest("completions", args)
end

function actboy_protocol.exceptionInfo(args)
    return actboy_protocol.sendRequest("exceptionInfo", args)
end

function actboy_protocol.readMemory(args)
    return actboy_protocol.sendRequest("readMemory", args)
end

function actboy_protocol.writeMemory(args)
    return actboy_protocol.sendRequest("writeMemory", args)
end

function actboy_protocol.disassemble(args)
    return actboy_protocol.sendRequest("disassemble", args)
end

function actboy_protocol.cancel(args)
    return actboy_protocol.sendRequest("cancel", args)
end

-- Event creators (examples)
function actboy_protocol.initialized()
    return actboy_protocol.createEvent("initialized")
end

function actboy_protocol.stopped(reason, threadId, description, text, allThreadsStopped)
    local body = {
        reason = reason,
        threadId = threadId,
        description = description,
        text = text,
        allThreadsStopped = allThreadsStopped
    }
    return actboy_protocol.createEvent("stopped", body)
end

function actboy_protocol.continued(threadId, allThreadsContinued)
    local body = {
        threadId = threadId,
        allThreadsContinued = allThreadsContinued
    }
    return actboy_protocol.createEvent("continued", body)
end

function actboy_protocol.exited(exitCode)
    local body = {
        exitCode = exitCode
    }
    return actboy_protocol.createEvent("exited", body)
end

function actboy_protocol.terminated(restart)
    local body = {}
    if restart then
        body.restart = restart
    end
    return actboy_protocol.createEvent("terminated", body)
end

function actboy_protocol.thread(reason, threadId)
    local body = {
        reason = reason,
        threadId = threadId
    }
    return actboy_protocol.createEvent("thread", body)
end

function actboy_protocol.output(output, category)
    local body = {
        output = output,
        category = category or "console"
    }
    return actboy_protocol.createEvent("output", body)
end

-- Add more as needed based on the schema

return actboy_protocol