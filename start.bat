@echo off
chcp 65001 > nul

setlocal enabledelayedexpansion

set "NGINX_DIR=%~dp0"
set "NGINX_CONF=%NGINX_DIR%conf\nginx.conf"

REM 查找 CatWrt 目录或以 CatWrt- 开头的目录
set "WEB_DIR="
for /d %%d in ("%NGINX_DIR%CatWrt*") do (
    if exist "%%d" (
        set "WEB_DIR=%%d"
    )
)

REM 如果找到 CatWrt 目录，修改 Nginx 配置文件
if defined WEB_DIR (
    echo 使用目录 %WEB_DIR% 作为网页根目录
    set "WEB_DIR=%WEB_DIR:\=/%"
    powershell -Command "(Get-Content -Raw %NGINX_CONF%) -replace 'root\s+\S+;', 'root !WEB_DIR!;' | Set-Content %NGINX_CONF%"
) else (
    echo 错误：未找到 CatWrt 目录
    pause
    exit /b 1
)

cd /d "%NGINX_DIR%"
start nginx

REM 获取本机 IP 地址并显示
for /f "tokens=14" %%i in ('ipconfig ^| findstr /i "IPv4"') do set IP_ADDR=%%i
echo Nginx 已启动，你可以通过此地址使 CatWrt 获取到本地副本软件源 http://%IP_ADDR%

pause

endlocal
