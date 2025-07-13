@echo off
setlocal enabledelayedexpansion

:: ============================================================================
:: Python MC Pro Launcher ��װ���� (v9 Renaissance - �ع鱾�����հ�)
:: ������ Windows 10 / 11
:: ============================================================================

:: --- �ű����� ---
set "LAUNCHER_NAME=Python MC Pro Launcher"
set "PYTHON_SCRIPT_NAME=start_launcher.py"
set "ZIP_FILE_NAME=data.zip"
set "SCRIPT_DIR=%~dp0"

:: ����Ƿ��Թ���Ա�������
>nul 2>&1 "%SYSTEMROOT%\system32\cacls.exe" "%SYSTEMROOT%\system32\config\system"
if '%errorlevel%' NEQ '0' (
    echo. & echo  �������Թ���Ա������д˰�װ���� & echo.
    echo  ���Ҽ���� install.bat��Ȼ��ѡ�� "�Թ���Ա�������"�� & echo.
    pause & exit
)

:start
cls
echo. & echo  =========================================================================
echo   ��ӭʹ�� %LAUNCHER_NAME% ��װ�� (�ع鱾�����հ�)
echo  ========================================================================= & echo.
echo   �˰汾���������ȶ��ɿ��Ŀ�ݷ�ʽ��
echo   ����ʱ���ܻ�����һ����ɫ���ڣ�������������
echo. & pause

:: ... [���� 1, 2, 3, 4 ����һ����ȫ��ͬ] ...
:check_python
cls
echo. & echo  --- [���� 1/4] ���ڼ�� Python ���� --- & echo.
where python >nul 2>nul
if %errorlevel% neq 0 ( goto python_not_found )
echo   ��⵽ Python �Ѱ�װ�� & where python & echo.
echo   ���ڼ�� Pip...
python -m pip --version >nul 2>nul
if %errorlevel% neq 0 ( echo   ���󣺼�⵽ Python���� Pip ģ���޷�ʹ�á� & pause & exit )
echo   Pip ���������� & echo. & pause
goto install_dependencies

:python_not_found
cls
echo. & echo  --- [����] δ��⵽ Python ���� --- & echo.
echo   ��������Ҫ Python �������С�
echo   �� Windows 11 �ϣ��Ƽ�ͨ�� Microsoft Store ��װ�� & echo.
echo   �������ڴ� Microsoft Store �� Python ҳ����
set /p "choice= (Y/N): "
if /i "%choice%"=="Y" ( start ms-windows-store://pdp/?productid=9P7QFQMJRFP7 )
echo. & echo   ���ڰ�װ�� Python ���������д˰�װ���� & echo. & pause & exit

:install_dependencies
cls
echo. & echo  --- [���� 2/4] ���ڰ�װ/���������� --- & echo.
echo   �⽫��ҪһЩʱ�䣬�뱣����������... & echo.
set "dependencies=customtkinter requests packaging psutil minecraft-launcher-lib"
for %%d in (%dependencies%) do (
    echo   ���ڴ��� %%d...
    python -m pip install --upgrade %%d
    if !errorlevel! neq 0 ( echo. & echo   ���󣺰�װ %%d ʧ�ܣ� & pause & exit )
)
echo. & echo   ������������ѳɹ���װ����£� & echo. & pause

:select_path
cls
echo. & echo  --- [���� 3/4] ��ѡ��װ·�� --- & echo.
set "DEFAULT_INSTALL_PATH=%ProgramFiles%\%LAUNCHER_NAME%"
echo   Ĭ�ϰ�װ·��Ϊ: & echo   %DEFAULT_INSTALL_PATH% & echo.
set /p "INSTALL_PATH=��ֱ�Ӱ��س�ʹ��Ĭ��·������������·��: "
if not defined INSTALL_PATH ( set "INSTALL_PATH=%DEFAULT_INSTALL_PATH%" )
echo. & echo   ����װ��: "%INSTALL_PATH%" & echo. & pause

:unzip_files
cls
echo. & echo  --- [���� 4/4] ���ڲ�������ļ� --- & echo.
if not exist "%SCRIPT_DIR%%ZIP_FILE_NAME%" ( echo   �����Ҳ���������Դ�� "%SCRIPT_DIR%%ZIP_FILE_NAME%"�� & pause & exit )
set "TEMP_DIR=%TEMP%\%LAUNCHER_NAME%_install_%RANDOM%"
mkdir "%TEMP_DIR%"
if !errorlevel! neq 0 ( echo �����޷�������ʱĿ¼�� & pause & exit )
echo   ���ڽ������ļ���ѹ����ʱĿ¼...
powershell -ExecutionPolicy Bypass -Command "Expand-Archive -Path '%SCRIPT_DIR%%ZIP_FILE_NAME%' -DestinationPath '%TEMP_DIR%' -Force"
if !errorlevel! neq 0 ( echo   ���󣺽�ѹ�ļ�����ʱĿ¼ʧ�ܣ� & rmdir /S /Q "%TEMP_DIR%" & pause & exit )
echo   ��ѹ�ɹ��� & echo.
echo   ���ڽ��ļ��������հ�װ·��...
if exist "%INSTALL_PATH%" ( rmdir /S /Q "%INSTALL_PATH%" )
move "%TEMP_DIR%" "%INSTALL_PATH%"
if !errorlevel! neq 0 ( echo   �����޷����ļ��ƶ��� "%INSTALL_PATH%"�� & rmdir /S /Q "%TEMP_DIR%" & pause & exit )
if not exist "%INSTALL_PATH%\%PYTHON_SCRIPT_NAME%" ( echo   ���󣺲����δ�ҵ� "%PYTHON_SCRIPT_NAME%"�� & pause & exit )
echo. & echo   �ļ�����ɹ��� & echo. & pause

:create_shortcuts
cls
echo. & echo  --- [���ղ���] ���ڴ�����ݷ�ʽ��ж�س��� --- & echo.

:: --- �����޸ģ��������� VBS��ֱ�Ӵ�����ݷ�ʽ ---
echo   ���ڴ�����ɿ��Ŀ�ݷ�ʽ...
set "PYTHONW_PATH="
:: ���� pythonw.exe ��·��
for /f "delims=" %%i in ('where pythonw.exe') do (
    if not defined PYTHONW_PATH set "PYTHONW_PATH=%%i"
)

if not defined PYTHONW_PATH (
    echo.
    echo   ��������������ϵͳ���Ҳ��� pythonw.exe��
    echo   ��ͨ����ζ�� Python ��װ��������·��δ��ȷ���á�
    echo   ��װ�޷�������
    pause
    exit
)
echo   �ҵ� pythonw.exe λ��: %PYTHONW_PATH%

set "PYTHON_SCRIPT_FULL_PATH=%INSTALL_PATH%\%PYTHON_SCRIPT_NAME%"
set "SHORTCUT_PATH=%USERPROFILE%\Desktop\%LAUNCHER_NAME%.lnk"
set "TARGET_PATH=%PYTHONW_PATH%"
set "ARGUMENTS_PATH=%PYTHON_SCRIPT_FULL_PATH%"
set "WORKING_DIR=%INSTALL_PATH%"
set "ICON_LOCATION=%SystemRoot%\System32\imageres.dll,15"

:: ʹ�� PowerShell ����һ��ֱ��ָ�� pythonw.exe �����ݽű���Ϊ�����Ŀ�ݷ�ʽ
set "ps_command=$ws = New-Object -ComObject WScript.Shell; $s = $ws.CreateShortcut('%SHORTCUT_PATH%'); $s.TargetPath = '%TARGET_PATH%'; $s.Arguments = '""%ARGUMENTS_PATH%""'; $s.IconLocation = '%ICON_LOCATION%'; $s.WorkingDirectory = '%WORKING_DIR%'; $s.Save()"
powershell -ExecutionPolicy Bypass -Command "& {%ps_command%}"

echo   ���ڴ���ж�س���...
(
    echo @echo off
    echo title %LAUNCHER_NAME% ж�س���
    echo set /p "confirm=��ȷ��Ҫж����(Y/N): "
    echo if /i "%%confirm%%" neq "Y" exit
    echo del /F /Q "%USERPROFILE%\Desktop\%LAUNCHER_NAME%.lnk"
    echo rmdir /S /Q "%INSTALL_PATH%"
    echo echo %LAUNCHER_NAME% �ѳɹ�ж�ء�
    echo pause
    echo exit
) > "%INSTALL_PATH%\uninstall.bat"

:finish
cls
echo. & echo  =========================================================================
echo   ��װ��ɣ�
echo  ========================================================================= & echo.
echo   %LAUNCHER_NAME% �ѳɹ���װ�����ļ������
echo   �����ڿ��Դ������ϵĿ�ݷ�ʽ�������� & echo.
echo   ��װ·��: "%INSTALL_PATH%" & echo.
echo   �����Ҫж�أ������и�Ŀ¼�µ� uninstall.bat �ļ��� & echo.
pause
exit
