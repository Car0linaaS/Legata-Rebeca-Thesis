@REM This script takes property files from a folder and runs them together with rebeca files,
@REM generating statespace output.
@REM This way we can e.g. take five different rebeca code scenarios and three property files,
@REM and running all possible combinations - a total of 15 runs - instead of having to do so
@REM manually in Afra.
@REM A prequisite for this is that the RMC.jar has to exist in the same folder as the script.

@REM To run the script, open up a command prompt and navigate to the folder of the script,
@REM as the relative file paths is relative to the command prompt.
@REM Once in the correct folder, just run "prompt_script.cmd".
@REM File structure according to BASE and SCEN_DIR below.

@echo off
@REM Set up a local environment for variables etc.
setlocal enabledelayedexpansion

@REM Relative file path for property files to run
set "BASE=LLMLeg2Reb\V2_few_shot\Rule19"
@REM Relative file path for rebeca model code files to run
set "SCEN_DIR=RebecaCodeScenarios\Rule19RebecaCodeScenarios"

@REM We want to test every property file that exists in the specified folder
@REM to check both syntax and verification results
@REM %%F will give us prompt ID number, e.g. prompt1
for %%F in ("%BASE%\*.property") do (
    set "PROMPT=%%~nF"
    echo.
    echo.
    echo === Processing prompt: !PROMPT! ===

    @REM Create output folder to save C++ and .exe-files
    if not exist "%BASE%\RMCout_!PROMPT!"  mkdir "%BASE%\RMCout_!PROMPT!"
    @REM Create output folder to save our statespace output
    if not exist "%BASE%\statespace_output" mkdir "%BASE%\statespace_output"
    
    @REM For every property file, we want to run all model code files that exists in the specified folder
    for %%G in ("%SCEN_DIR%\*.rebeca") do (
        set "SCEN=%%~nG"
        set "OUTDIR=%BASE%\RMCout_!PROMPT!\!SCEN!"
        echo.       

        @REM RMC will take the property- and rebeca file and output cpp files
        if not exist "!OUTDIR!" mkdir "!OUTDIR!"
        java -jar rmc-2.13.jar -s "%%G" -p "%%F" -o "!OUTDIR!" -e TIMED_REBECA -x
        if errorlevel 1 (
            echo ERROR: RMC failed on %%G with code %ERRORLEVEL%
        )

        @rem Check that cpp files have been generated
        pushd "!OUTDIR!" || exit /b 1
        rem Make sure there are .cpp files to compile
        dir /b *.cpp >nul 2>&1
        if errorlevel 1 (
            echo ERROR: No .cpp files in "!OUTDIR!"
            popd
        )
        @rem Now compile: use unquoted wildcard so cmd expands it
        g++ *.cpp -w -o ..\!PROMPT!_!SCEN!.exe
        if errorlevel 1 (
            echo ERROR: g++ failed to compile in "!OUTDIR!"
            popd
        )
        popd



        @rem Execute the generated .exe file & capture output
        %BASE%\RMCout_!PROMPT!\!PROMPT!_!SCEN!.exe > "%BASE%\statespace_output\!PROMPT!_!SCEN!.txt"
        if errorlevel 1 (
            echo WARNING: execution of !PROMPT!_!SCEN! returned %ERRORLEVEL%
        )

        @rem ── Move the XML, if it was generated, as it otherwise gets overwritten in the next loop
        if exist statespace.xml (  
            move statespace.xml "%BASE%\statespace_output\!PROMPT!_!SCEN!.xml"
        )

    )

)


echo Done!
