@echo off
if "%PROCESSOR_ARCHITECTURE%" == "x86" (set PROG=procdump.exe) else (set PROG=procdump64.exe)
cd c:\Windows\Temp
%~dp0%PROG% -ma %*
