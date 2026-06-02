@echo off
rem ============================================================
rem  49296.com one-click auto publish
rem  NOTE: keep this .bat ASCII-only. cmd.exe miscounts bytes of
rem  multibyte (Chinese) chars under chcp 65001 and breaks lines.
rem  chcp 65001 is still needed so auto_publish.py UTF-8 logs show.
rem ============================================================
chcp 65001 >nul
title 49296.com Auto Publish
cd /d D:\49296.com

rem Use the Python that actually has the deps (google.generativeai, PIL).
set "PY=%LOCALAPPDATA%\Programs\Python\Python39\python.exe"
if not exist "%PY%" set "PY=py -3.9"

echo ============================================================
echo   49296.com Auto Publish
echo ------------------------------------------------------------
echo   Double-click   = full auto: AI topic + Google demand check
echo   Manual keyword = run in CMD:  %~nx0 "make.com gmail blueprint" 400 12
echo   Preview only   = add  --dry-run
echo   Skip review    = add  --skip-review
echo ============================================================
echo.

"%PY%" auto_publish.py %*

echo.
echo ============================================================
echo   Done. Press any key to close...
echo ============================================================
pause >nul
