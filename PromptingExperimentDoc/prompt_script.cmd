@echo off
@REM Set up a local environment for variables etc.
setlocal

@REM %%F will give us prompot ID number, e.g. prompt1
for %%F in (LLMTransformation_Legata2Rebeca_properties\Version1_Zero_shot\Rule19\*.property) do (
    echo Running RMC with %%F
    echo.     

    @REM Create output folders
    if not exist LLMTransformation_Legata2Rebeca_properties\Version1_Zero_shot\Rule19\RMCoutput_%%~nF mkdir LLMTransformation_Legata2Rebeca_properties\Version1_Zero_shot\Rule19\RMCoutput_%%~nF
    if not exist LLMTransformation_Legata2Rebeca_properties\Version1_Zero_shot\Rule19\statespace_output mkdir LLMTransformation_Legata2Rebeca_properties\Version1_Zero_shot\Rule19\statespace_output
    
    @REM %%G will give us the "long" scenario name, e.g. S1VEL11LEN160DRA20HAZnPDaEOa_S2VEL11LEN160DRA20HAZnPDaEOa_theMapUCaSHCLaSAFS3_FOGa
    for %%G in (RebecaCodeScenarios\Rule19RebecaCodeScenarios\*.rebeca) do (
        echo Running RMC with %%G
        echo.       

        if not exist LLMTransformation_Legata2Rebeca_properties\Version1_Zero_shot\Rule19\RMCoutput_%%~nF\%%~nG mkdir LLMTransformation_Legata2Rebeca_properties\Version1_Zero_shot\Rule19\RMCoutput_%%~nF\%%~nG
        java -jar rmc-2.13.jar -s %%G -p %%F -o LLMTransformation_Legata2Rebeca_properties\Version1_Zero_shot\Rule19\RMCoutput_%%~nF\%%~nG -e TIMED_REBECA -x
        g++ LLMTransformation_Legata2Rebeca_properties\Version1_Zero_shot\Rule19\RMCoutput_%%~nF\%%~nG\*.cpp -w -o LLMTransformation_Legata2Rebeca_properties\Version1_Zero_shot\Rule19\RMCoutput_%%~nF\%%~nG\%%~nF_%%~nG.exe
        
        
        LLMTransformation_Legata2Rebeca_properties\Version1_Zero_shot\Rule19\RMCoutput_%%~nF\%%~nG\%%~nF_%%~nG.exe > LLMTransformation_Legata2Rebeca_properties\Version1_Zero_shot\Rule19\statespace_output\%%~nF_%%~nG.txt
        move statespace.xml LLMTransformation_Legata2Rebeca_properties\Version1_Zero_shot\Rule19\statespace_output\%%~nF_%%~nG.xml
    )

)


echo Done!
