@echo off
setlocal enabledelayedexpansion

REM This script runs inference based on the version and mode specified by the user.
REM Usage:
REM To run v1.0 inference: inference.bat v1.0 [normal|realtime]
REM To run v1.5 inference: inference.bat v1.5 [normal|realtime]

REM Check if the correct number of arguments is provided
if "%~2"=="" (
    echo Usage: %~nx0 ^<version^> ^<mode^>
    echo Example: %~nx0 v1.0 normal or %~nx0 v1.5 realtime
	pause
    exit /b 1
)

REM Get the version and mode from the user input
set "VERSION=%~1"
set "MODE=%~2"

REM Validate mode
if /i not "%MODE%"=="normal" if /i not "%MODE%"=="realtime" (
    echo Invalid mode specified. Please use 'normal' or 'realtime'.
	pause
    exit /b 1
)

REM Set config path and script name based on mode
if /i "%MODE%"=="normal" (
    set "CONFIG_PATH=.\configs\inference\test.yaml"
    set "RESULT_DIR=.\results\test"
    set "SCRIPT_NAME=scripts.inference"
) else (
    set "CONFIG_PATH=.\configs\inference\realtime.yaml"
    set "RESULT_DIR=.\results\realtime"
    set "SCRIPT_NAME=scripts.realtime_inference"
)

REM Define the model paths based on the version
if /i "%VERSION%"=="v1.0" (
    set "MODEL_DIR=.\models\musetalk"
    set "UNET_MODEL_PATH=!MODEL_DIR!\pytorch_model.bin"
    set "UNET_CONFIG=!MODEL_DIR!\musetalk.json"
    set "VERSION_ARG=v1"
) else if /i "%VERSION%"=="v1.5" (
    set "MODEL_DIR=.\models\musetalkV15"
    set "UNET_MODEL_PATH=!MODEL_DIR!\unet.pth"
    set "UNET_CONFIG=!MODEL_DIR!\musetalk.json"
    set "VERSION_ARG=v15"
) else (
    echo Invalid version specified. Please use v1.0 or v1.5.
	pause
    exit /b 1
)

REM Ensure app\ is on the import path so `scripts.*` resolves correctly on Windows
set "PYTHONPATH=%CD%\app;%PYTHONPATH%"

REM Base command arguments
set "CMD_ARGS=--inference_config "!CONFIG_PATH!" --result_dir "!RESULT_DIR!" --unet_model_path "!UNET_MODEL_PATH!" --unet_config "!UNET_CONFIG!" --version !VERSION_ARG!"

REM Add realtime-specific arguments if in realtime mode
if /i "%MODE%"=="realtime" (
    set "CMD_ARGS=!CMD_ARGS! --fps 25 --version !VERSION_ARG!"
)

REM Run inference
python -m !SCRIPT_NAME! !CMD_ARGS!

endlocal