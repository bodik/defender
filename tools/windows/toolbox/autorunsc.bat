@echo off
if "%PROCESSOR_ARCHITECTURE%" == "x86" (set PROG=autorunsc.exe) else (set PROG=autorunsc64.exe)
%~dp0%PROG% -a * -c
