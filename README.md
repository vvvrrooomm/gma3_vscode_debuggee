
Grand MA3 vscode debug adapter
===

the lua debug adapter included with GMA3 up to current version is a copy of
https://github.com/devcat-studio/VSCodeLuaDebug/blob/master/debuggee/vscode-debuggee.lua
which in turn is based on the microsoft sample implementation for c# https://github.com/microsoft/vscode-mono-debug

the line protocol used by both is somewhat dated. 
this repo updates vscode-debugee to implement the current state of the vscode DAP protocol https://microsoft.github.io/debug-adapter-protocol/specification
which makes it work with more up-to-date vscode debug extensions, such as https://github.com/actboy168/lua-debug
