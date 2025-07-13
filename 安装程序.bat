@echo off
setlocal enabledelayedexpansion

:: ============================================================================
:: Python MC Pro Launcher 安装程序 (v9 Renaissance - 回归本质最终版)
:: 适用于 Windows 10 / 11
:: ============================================================================

:: --- 脚本配置 ---
set "LAUNCHER_NAME=Python MC Pro Launcher"
set "PYTHON_SCRIPT_NAME=start_launcher.py"
set "ZIP_FILE_NAME=data.zip"
set "SCRIPT_DIR=%~dp0"

:: 检查是否以管理员身份运行
>nul 2>&1 "%SYSTEMROOT%\system32\cacls.exe" "%SYSTEMROOT%\system32\config\system"
if '%errorlevel%' NEQ '0' (
    echo. & echo  错误：请以管理员身份运行此安装程序！ & echo.
    echo  请右键点击 install.bat，然后选择 "以管理员身份运行"。 & echo.
    pause & exit
)

:start
cls
echo. & echo  =========================================================================
echo   欢迎使用 %LAUNCHER_NAME% 安装向导 (回归本质最终版)
echo  ========================================================================= & echo.
echo   此版本将创建最稳定可靠的快捷方式。
echo   启动时可能会闪过一个黑色窗口，这是正常现象。
echo. & pause

:: ... [步骤 1, 2, 3, 4 与上一版完全相同] ...
:check_python
cls
echo. & echo  --- [步骤 1/4] 正在检查 Python 环境 --- & echo.
where python >nul 2>nul
if %errorlevel% neq 0 ( goto python_not_found )
echo   检测到 Python 已安装。 & where python & echo.
echo   正在检查 Pip...
python -m pip --version >nul 2>nul
if %errorlevel% neq 0 ( echo   错误：检测到 Python，但 Pip 模块无法使用。 & pause & exit )
echo   Pip 环境正常。 & echo. & pause
goto install_dependencies

:python_not_found
cls
echo. & echo  --- [错误] 未检测到 Python 环境 --- & echo.
echo   启动器需要 Python 才能运行。
echo   在 Windows 11 上，推荐通过 Microsoft Store 安装。 & echo.
echo   您想现在打开 Microsoft Store 的 Python 页面吗？
set /p "choice= (Y/N): "
if /i "%choice%"=="Y" ( start ms-windows-store://pdp/?productid=9P7QFQMJRFP7 )
echo. & echo   请在安装完 Python 后，重新运行此安装程序。 & echo. & pause & exit

:install_dependencies
cls
echo. & echo  --- [步骤 2/4] 正在安装/更新依赖库 --- & echo.
echo   这将需要一些时间，请保持网络连接... & echo.
set "dependencies=customtkinter requests packaging psutil minecraft-launcher-lib"
for %%d in (%dependencies%) do (
    echo   正在处理 %%d...
    python -m pip install --upgrade %%d
    if !errorlevel! neq 0 ( echo. & echo   错误：安装 %%d 失败！ & pause & exit )
)
echo. & echo   所有依赖库均已成功安装或更新！ & echo. & pause

:select_path
cls
echo. & echo  --- [步骤 3/4] 请选择安装路径 --- & echo.
set "DEFAULT_INSTALL_PATH=%ProgramFiles%\%LAUNCHER_NAME%"
echo   默认安装路径为: & echo   %DEFAULT_INSTALL_PATH% & echo.
set /p "INSTALL_PATH=请直接按回车使用默认路径，或输入新路径: "
if not defined INSTALL_PATH ( set "INSTALL_PATH=%DEFAULT_INSTALL_PATH%" )
echo. & echo   将安装到: "%INSTALL_PATH%" & echo. & pause

:unzip_files
cls
echo. & echo  --- [步骤 4/4] 正在部署核心文件 --- & echo.
if not exist "%SCRIPT_DIR%%ZIP_FILE_NAME%" ( echo   错误：找不到核心资源包 "%SCRIPT_DIR%%ZIP_FILE_NAME%"！ & pause & exit )
set "TEMP_DIR=%TEMP%\%LAUNCHER_NAME%_install_%RANDOM%"
mkdir "%TEMP_DIR%"
if !errorlevel! neq 0 ( echo 错误：无法创建临时目录。 & pause & exit )
echo   正在将核心文件解压到临时目录...
powershell -ExecutionPolicy Bypass -Command "Expand-Archive -Path '%SCRIPT_DIR%%ZIP_FILE_NAME%' -DestinationPath '%TEMP_DIR%' -Force"
if !errorlevel! neq 0 ( echo   错误：解压文件到临时目录失败！ & rmdir /S /Q "%TEMP_DIR%" & pause & exit )
echo   解压成功！ & echo.
echo   正在将文件部署到最终安装路径...
if exist "%INSTALL_PATH%" ( rmdir /S /Q "%INSTALL_PATH%" )
move "%TEMP_DIR%" "%INSTALL_PATH%"
if !errorlevel! neq 0 ( echo   错误：无法将文件移动到 "%INSTALL_PATH%"！ & rmdir /S /Q "%TEMP_DIR%" & pause & exit )
if not exist "%INSTALL_PATH%\%PYTHON_SCRIPT_NAME%" ( echo   错误：部署后未找到 "%PYTHON_SCRIPT_NAME%"。 & pause & exit )
echo. & echo   文件部署成功！ & echo. & pause

:create_shortcuts
cls
echo. & echo  --- [最终步骤] 正在创建快捷方式和卸载程序 --- & echo.

:: --- 核心修改：彻底抛弃 VBS，直接创建快捷方式 ---
echo   正在创建最可靠的快捷方式...
set "PYTHONW_PATH="
:: 查找 pythonw.exe 的路径
for /f "delims=" %%i in ('where pythonw.exe') do (
    if not defined PYTHONW_PATH set "PYTHONW_PATH=%%i"
)

if not defined PYTHONW_PATH (
    echo.
    echo   致命错误：在您的系统中找不到 pythonw.exe！
    echo   这通常意味着 Python 安装不完整或路径未正确配置。
    echo   安装无法继续。
    pause
    exit
)
echo   找到 pythonw.exe 位于: %PYTHONW_PATH%

set "PYTHON_SCRIPT_FULL_PATH=%INSTALL_PATH%\%PYTHON_SCRIPT_NAME%"
set "SHORTCUT_PATH=%USERPROFILE%\Desktop\%LAUNCHER_NAME%.lnk"
set "TARGET_PATH=%PYTHONW_PATH%"
set "ARGUMENTS_PATH=%PYTHON_SCRIPT_FULL_PATH%"
set "WORKING_DIR=%INSTALL_PATH%"
set "ICON_LOCATION=%SystemRoot%\System32\imageres.dll,15"

:: 使用 PowerShell 创建一个直接指向 pythonw.exe 并传递脚本作为参数的快捷方式
set "ps_command=$ws = New-Object -ComObject WScript.Shell; $s = $ws.CreateShortcut('%SHORTCUT_PATH%'); $s.TargetPath = '%TARGET_PATH%'; $s.Arguments = '""%ARGUMENTS_PATH%""'; $s.IconLocation = '%ICON_LOCATION%'; $s.WorkingDirectory = '%WORKING_DIR%'; $s.Save()"
powershell -ExecutionPolicy Bypass -Command "& {%ps_command%}"

echo   正在创建卸载程序...
(
    echo @echo off
    echo title %LAUNCHER_NAME% 卸载程序
    echo set /p "confirm=您确定要卸载吗？(Y/N): "
    echo if /i "%%confirm%%" neq "Y" exit
    echo del /F /Q "%USERPROFILE%\Desktop\%LAUNCHER_NAME%.lnk"
    echo rmdir /S /Q "%INSTALL_PATH%"
    echo echo %LAUNCHER_NAME% 已成功卸载。
    echo pause
    echo exit
) > "%INSTALL_PATH%\uninstall.bat"

:finish
cls
echo. & echo  =========================================================================
echo   安装完成！
echo  ========================================================================= & echo.
echo   %LAUNCHER_NAME% 已成功安装到您的计算机。
echo   您现在可以从桌面上的快捷方式启动它。 & echo.
echo   安装路径: "%INSTALL_PATH%" & echo.
echo   如果需要卸载，请运行该目录下的 uninstall.bat 文件。 & echo.
pause
exit
