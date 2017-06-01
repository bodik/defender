rmdir /s /q build dist

rem c:\Python27\python.exe build.py py2exe
c:\python27\scripts\pyinstaller --onefile test.py

if "%PROCESSOR_ARCHITECTURE%" == "x86" (
	set OUT="x32"
) else (
	set OUT="x64"
)

copy dist\test.exe test%OUT%.exe

