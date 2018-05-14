@echo off
if "%PROCESSOR_ARCHITECTURE%" == "x86" (set PROG=AnalyzePESig-crt-x86.exe) else (set PROG=AnalyzePESig-crt-x64.exe)
%~dp0%PROG% %*
