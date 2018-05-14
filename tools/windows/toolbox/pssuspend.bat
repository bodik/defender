@echo off
if "%PROCESSOR_ARCHITECTURE%" == "x86" (set PROG=pssuspend.exe) else (set PROG=pssuspend64.exe)
%~dp0%PROG% %*
