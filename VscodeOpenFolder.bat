@echo off
setlocal enabledelayedexpansion

:: Find Code.exe path
set "vscode_path="
for %%i in (Code.exe) do set "vscode_path=%%~$PATH:i"
if not defined vscode_path (
    set "vscode_path=%LOCALAPPDATA%\Programs\Microsoft VS Code\Code.exe"
)

if not exist "!vscode_path!" (
    echo VSCode.exe not found. Please ensure it's installed and in the PATH.
    pause
    exit /b 1
)

:: Escape backslashes in the path
set "vscode_path_escaped=!vscode_path:\=\\!"

:: Define registry operations
(
echo Windows Registry Editor Version 5.00

echo [HKEY_CLASSES_ROOT\*\shell\Open with VSCode]
echo @="Edit with VSCode"
echo "Icon"="!vscode_path_escaped!,0"
echo "Position"=""

echo [HKEY_CLASSES_ROOT\*\shell\Open with VSCode\command]
echo @="\"!vscode_path_escaped!\" \"%%1\""

echo [HKEY_CLASSES_ROOT\Directory\shell\VSCode]
echo @="Open Folder as VSCode Project"
echo "Icon"="\"!vscode_path_escaped!\",0"
echo "Position"=""

echo [HKEY_CLASSES_ROOT\Directory\shell\VSCode\command]
echo @="\"!vscode_path_escaped!\" \"%%1\""

echo [HKEY_CLASSES_ROOT\Directory\Background\shell\VSCode]
echo @="Open Folder as VSCode Project"
echo "Icon"="\"!vscode_path_escaped!\",0"
echo "Position"=""

echo [HKEY_CLASSES_ROOT\Directory\Background\shell\VSCode\command]
echo @="\"!vscode_path_escaped!\" \"%%V\""
) > temp.reg

:: Import registry file
reg import temp.reg
if %errorlevel% neq 0 (
    echo Failed to import registry entries.
    goto cleanup
)

echo Registry entries added successfully.
echo VSCode path: !vscode_path!

:cleanup
:: Delete temporary file
del temp.reg

pause
