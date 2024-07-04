@echo off
chcp 65001 > nul

setlocal enabledelayedexpansion

set "NGINX_DIR=%~dp0"
set "NGINX_CONF=%NGINX_DIR%conf\nginx.conf"
set "TEMP_CONF=%NGINX_DIR%conf\nginx_temp.conf"

set "WEB_DIR="
for /d %%d in ("%NGINX_DIR%CatWrt*") do (
    if exist "%%d" (
        set "WEB_DIR=%%d"
    )
)

if defined WEB_DIR (
    echo 使用目录 %WEB_DIR% 作为网页根目录
    set "WEB_DIR=%WEB_DIR:\=/%"

    if exist "%NGINX_CONF%" (
        > "%TEMP_CONF%" (
            for /f "usebackq tokens=*" %%l in ("%NGINX_CONF%") do (
                set "line=%%l"
                if "%%l"=="root " (
                    echo root !WEB_DIR!;
                ) else (
                    echo %%l
                )
            )
        )
        move /Y "%TEMP_CONF%" "%NGINX_CONF%"
    ) else (
        echo 错误：找不到配置文件 %NGINX_CONF%
        pause
        exit /b 1
    )
) else (
    echo 错误：未找到 CatWrt 目录
    pause
    exit /b 1
)

cd /d "%NGINX_DIR%"
start nginx

set "IP_ADDR="
for /f "tokens=1,2 delims=:" %%a in ('ipconfig ^| findstr /i "Ethernet adapter Wireless LAN adapter"') do (
    for /f "tokens=14" %%i in ('ipconfig ^| findstr /i "IPv4 Address\|IPv4 地址"') do (
        if not defined IP_ADDR (
            set "IP_ADDR=%%i"
        )
    )
)

if defined IP_ADDR (
    echo Nginx 已启动，你可以通过此地址使 CatWrt 获取到本地副本软件源 http://%IP_ADDR%
) else (
    echo 错误：未找到有效的 IPv4 地址
)

pause

endlocal
