@echo off
@REM Set up a local environment for variables etc.
setlocal enabledelayedexpansion

set "BASE=LLMLeg2Reb\V1\Rule19"
set "SCEN_DIR=RebecaCodeScenarios\Rule19RebecaCodeScenarios"

@REM %%F will give us prompot ID number, e.g. prompt1
for %%F in ("%BASE%\*.property") do (
    set "PROMPT=%%~nF"
    echo.
    echo === Processing prompt: !PROMPT! ===

    @REM Create output folders
    if not exist "%BASE%\RMCout_!PROMPT!"  mkdir "%BASE%\RMCout_!PROMPT!"
    if not exist "%BASE%\statespace_output" mkdir "%BASE%\statespace_output"
    
    @REM %%G will give us the "long" scenario name, e.g. S1VEL11LEN160DRA20HAZnPDaEOa_S2VEL11LEN160DRA20HAZnPDaEOa_theMapUCaSHCLaSAFS3_FOGa
    for %%G in ("%SCEN_DIR%\*.rebeca") do (
        set "SCEN=%%~nG"
        set "OUTDIR=%BASE%\RMCout_!PROMPT!\!SCEN!"
        echo.       

        if not exist "!OUTDIR!" mkdir "!OUTDIR!"
        java -jar rmc-2.13.jar -s "%%G" -p "%%F" -o "!OUTDIR!" -e TIMED_REBECA -x
        if errorlevel 1 (
            echo ERROR: RMC failed on %%G with code %ERRORLEVEL%
            exit /b 1
        )

            @rem ── Compile (fixed wildcard expansion)
            pushd "!OUTDIR!" || exit /b 1
            rem Make sure there are .cpp files to compile
            dir /b *.cpp >nul 2>&1
            if errorlevel 1 (
                echo ERROR: No .cpp files in "!OUTDIR!"
                popd
                exit /b 1
            )
            @rem Now compile: use unquoted wildcard so cmd expands it
            g++ *.cpp -w -o "..\!PROMPT!_!SCEN!.exe"
            if errorlevel 1 (
                echo ERROR: g++ failed to compile in "!OUTDIR!"
                popd
                exit /b 1
            )
            popd



        @rem ── Execute & capture
        !OUTDIR!\!PROMPT!_!SCEN!.exe > "%BASE%\statespace_output\!PROMPT!_!SCEN!.txt"
        if errorlevel 1 (
            echo WARNING: execution of !PROMPT!_!SCEN! returned %ERRORLEVEL%
        )

        @rem ── Move the XML, if it was generated
        if exist statespace.xml (  
            move statespace.xml "%BASE%\statespace_output\!PROMPT!_!SCEN!.xml"
        )

    )

)


echo Done!
