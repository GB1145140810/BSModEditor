@echo off
REM ModEditor Windows编译脚本
REM 使用方法: build.bat [debug|release|test]

setlocal enabledelayedexpansion

echo === ModEditor 编译脚本 ===
echo 开始时间: %date% %time%

REM 检查Java环境
java -version >nul 2>&1
if errorlevel 1 (
    echo 错误: 未找到Java环境
    echo 请安装JDK 11或更高版本
    pause
    exit /b 1
)

REM 检查Java版本
for /f "tokens=3" %%g in ('java -version 2^>^&1 ^| findstr /i "version"') do (
    set JAVA_VERSION=%%g
)
set JAVA_VERSION=%JAVA_VERSION:"=%
for /f "delims=. tokens=1" %%a in ("%JAVA_VERSION%") do set JAVA_MAJOR=%%a

if %JAVA_MAJOR% LSS 11 (
    echo 错误: Java版本过低，需要JDK 11+
    echo 当前版本: %JAVA_MAJOR%
    pause
    exit /b 1
)

echo Java版本: %JAVA_VERSION%

REM 设置执行权限
if exist gradlew (
    attrib -r gradlew
)

REM 解析参数
set BUILD_TYPE=%1
if "%BUILD_TYPE%"=="" set BUILD_TYPE=debug

if "%BUILD_TYPE%"=="debug" (
    echo 构建Debug版本...
    call gradlew assembleDebug
    echo Debug APK构建完成: app\build\outputs\apk\debug\app-debug.apk
    goto :end
)

if "%BUILD_TYPE%"=="release" (
    echo 构建Release版本...
    call gradlew assembleRelease
    echo Release APK构建完成: app\build\outputs\apk\release\app-release-unsigned.apk
    goto :end
)

if "%BUILD_TYPE%"=="test" (
    echo 运行测试...
    call gradlew test
    echo 测试完成
    goto :end
)

if "%BUILD_TYPE%"=="clean" (
    echo 清理构建...
    call gradlew clean
    echo 清理完成
    goto :end
)

echo 用法: %0 [debug^|release^|test^|clean]
echo   debug   - 构建Debug版本
echo   release - 构建Release版本
echo   test    - 运行测试
echo   clean   - 清理构建
pause
exit /b 1

:end
echo 完成时间: %date% %time%
echo === 编译完成 ===
pause