@echo off
chcp 65001 > nul

nginx -s stop

echo Nginx 已停止

pause

endlocal
