@echo off
echo Installing Claude Code Reminder dependencies...
echo.

REM Check if Python is installed
python --version >nul 2>&1
if errorlevel 1 (
    echo [ERROR] Python is not installed or not in PATH
    echo Please install Python from https://python.org
    pause
    exit /b 1
)

echo Installing plyer for system notifications...
pip install plyer --quiet

echo.
echo [SUCCESS] Dependencies installed!
echo Claude Code Reminder will now use Windows system notifications.
echo.
pause