@echo off
cls
echo *** Antorcha starten ***
echo.
echo  Antorcha wordt gestart in productie modus
echo.
set RAILS_ENV=production
call ruby script/server