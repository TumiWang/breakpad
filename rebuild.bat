echo off

cd %~dp0

set prefixDir=prefix
set buildDir=build
set buildType=Release

if exist %prefixDir% (
    rmdir /s /q %prefixDir%
)

if exist %buildDir% (
    rmdir /s /q %buildDir%
)

@REM cmake -B %buildDir% -S . -G "Visual Studio 17 2022" -A win32 -T v141_xp -DCMAKE_BUILD_TYPE=%buildType%
cmake -B %buildDir% -S . -G "Visual Studio 17 2022" -A x64 -DCMAKE_BUILD_TYPE=%buildType%

if not %errorlevel% equ 0 (
    echo "Failed to generate project with the cmake"
    exit
)

cmake --build %buildDir% --config %buildType%

if not %errorlevel% equ 0 (
    echo "Failed to build project with the cmake"
    exit
)

cmake --install %buildDir% --prefix %prefixDir%