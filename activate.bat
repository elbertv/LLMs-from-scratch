@echo off
set ENV_NAME=_pyllm

if exist %ENV_NAME%\Scripts\activate.bat (
    echo Activando entorno %ENV_NAME%...
    prompt $G
    call %ENV_NAME%\Scripts\activate.bat
    
) else (
    echo Error: No se encontro la carpeta '%ENV_NAME%'.
    pause
)