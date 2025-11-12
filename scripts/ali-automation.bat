@echo off
REM ALI Automation wrapper for Windows
REM This batch file calls the PowerShell script

setlocal enabledelayedexpansion

REM Get the directory where this script is located
set "SCRIPT_DIR=%~dp0"

REM Call PowerShell script with all arguments
powershell.exe -ExecutionPolicy Bypass -NoProfile -File "%SCRIPT_DIR%ali-automation.ps1" %*

endlocal
