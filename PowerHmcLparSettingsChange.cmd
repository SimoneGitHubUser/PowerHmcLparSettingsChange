@echo off
rem setLocal EnableDelayedExpansion

set localdir=%cd%
set plinkdir="C:\_Appoggio\Putty"
set tempfolder=tmp

FOR /F "tokens=1" %%A IN (%localdir%\_var_hmc_ip.txt) DO set hmc_ip=%%A
FOR /F "tokens=1" %%B IN (%localdir%\_var_hmc_user.txt) DO set hmc_user=%%B
FOR /F "tokens=1" %%C IN (%localdir%\_var_hmc_password.txt) DO set hmc_password=%%C
FOR /F "tokens=1" %%D IN (%localdir%\_var_lpar_id.txt) DO set lpar_id=%%D
FOR /F "tokens=1" %%E IN (%localdir%\_var_lpar_profile.txt) DO set lpar_profile=%%E
FOR /F "tokens=1" %%F IN (%localdir%\_var_managed_server_name.txt) DO set managed_server_name=%%F
FOR /F "delims=" %%G IN (%localdir%\_var_lpar_off_state.txt) DO set lpar_off_state=%%G
FOR /F "tokens=1" %%H IN (%localdir%\_var_lpar_on_state.txt) DO set lpar_on_state=%%H
FOR /F "tokens=1" %%I IN (%localdir%\_var_seconds_wait_01.txt) DO set seconds_wait_01=%%I
FOR /F "tokens=1" %%L IN (%localdir%\_var_lpar_parameter.txt) DO set lpar_parameter=%%L
FOR /F "tokens=1" %%M IN (%localdir%\_var_lpar_parameter_set_value.txt) DO set lpar_parameter_set_value=%%M


	Rem DOSWindowResizing
rem	mode con:cols=80 lines=30
	Rem end DOSWindowResizing
	
	Rem DOSWindowChangeColor
	color 0A
	Rem end DOSWindowChangeColor



REM lpar_state_01=%%z
REM lpar_state_02=%%y
REM %%W
REM %%X
REM %%V
REM %%U


title HMC_%hmc_ip%_%managed_server_name%_Lpar_id_%lpar_id%


pause

mkdir %localdir%\%tempfolder%

echo ..           												>  %localdir%\HMC_%hmc_ip%_%managed_server_name%_Lpar_id_%lpar_id%_log.txt
echo hmc_ip.....................%hmc_ip%						>> %localdir%\HMC_%hmc_ip%_%managed_server_name%_Lpar_id_%lpar_id%_log.txt
echo hmc_user...................%hmc_user%						>> %localdir%\HMC_%hmc_ip%_%managed_server_name%_Lpar_id_%lpar_id%_log.txt
echo hmc_password...............%hmc_password%					>> %localdir%\HMC_%hmc_ip%_%managed_server_name%_Lpar_id_%lpar_id%_log.txt
echo lpar_id....................%lpar_id%						>> %localdir%\HMC_%hmc_ip%_%managed_server_name%_Lpar_id_%lpar_id%_log.txt
echo lpar_profile...............%lpar_profile%					>> %localdir%\HMC_%hmc_ip%_%managed_server_name%_Lpar_id_%lpar_id%_log.txt
echo managed_server_name........%managed_server_name%			>> %localdir%\HMC_%hmc_ip%_%managed_server_name%_Lpar_id_%lpar_id%_log.txt
echo lpar_on_state..............%lpar_on_state%					>> %localdir%\HMC_%hmc_ip%_%managed_server_name%_Lpar_id_%lpar_id%_log.txt
echo lpar_off_state.............%lpar_off_state%				>> %localdir%\HMC_%hmc_ip%_%managed_server_name%_Lpar_id_%lpar_id%_log.txt
echo seconds_wait_01............%seconds_wait_01%				>> %localdir%\HMC_%hmc_ip%_%managed_server_name%_Lpar_id_%lpar_id%_log.txt
echo lpar_parameter.............%lpar_parameter%				>> %localdir%\HMC_%hmc_ip%_%managed_server_name%_Lpar_id_%lpar_id%_log.txt
echo lpar_parameter_set_value...%lpar_parameter_set_value%		>> %localdir%\HMC_%hmc_ip%_%managed_server_name%_Lpar_id_%lpar_id%_log.txt
echo date time..................%Date% %time%					>> %localdir%\HMC_%hmc_ip%_%managed_server_name%_Lpar_id_%lpar_id%_log.txt
echo ..           												>> %localdir%\HMC_%hmc_ip%_%managed_server_name%_Lpar_id_%lpar_id%_log.txt

cls


echo ..           											
echo hmc_ip.....................%hmc_ip%					
echo hmc_user...................%hmc_user%					
echo hmc_password...............%hmc_password%				
echo lpar_id....................%lpar_id%					
echo lpar_profile...............%lpar_profile%				
echo managed_server_name........%managed_server_name%		
echo lpar_on_state..............%lpar_on_state%				
echo lpar_off_state.............%lpar_off_state%			
echo seconds_wait_01............%seconds_wait_01%			
echo lpar_parameter.............%lpar_parameter%			
echo lpar_parameter_set_value...%lpar_parameter_set_value%	
echo date time..................%Date% %time%
echo ..


:CheckIfAllReady


	:PingTheHmc
	
	echo Let's try to ping HMC %hmc_ip%
	echo %date%_%time% ### PingTheHmc	 >>%localdir%\HMC_%hmc_ip%_%managed_server_name%_Lpar_id_%lpar_id%_log.txt
	echo Let's try to ping HMC %hmc_ip% >>%localdir%\HMC_%hmc_ip%_%managed_server_name%_Lpar_id_%lpar_id%_log.txt
	
	ping %hmc_ip% | find "Reply from %hmc_ip%" > nul
	if not errorlevel 1 (
		echo HMC %hmc_ip% is online - ping success.
		echo .
		echo HMC %hmc_ip% is online - ping success. >>%localdir%\HMC_%hmc_ip%_%managed_server_name%_Lpar_id_%lpar_id%_log.txt
	) else (
		echo HMC %hmc_ip% has been taken down, waiting for few seconds to check again
		echo Check also hmc_ip value 	
		echo HMC %hmc_ip% has been taken down, waiting for few seconds to check again >>%localdir%\HMC_%hmc_ip%_%managed_server_name%_Lpar_id_%lpar_id%_log.txt
				
		ping localhost -n 1 -w 3000 >NUL
		goto :PingTheHmc
	) 
	:EndPingTheHmc

	:HmcPromptCheck
	echo %date%_%time% ### HmcPromptCheck	 >>%localdir%\HMC_%hmc_ip%_%managed_server_name%_Lpar_id_%lpar_id%_log.txt
	
	echo ********************************************************
	echo * If "access denied" is prompted below.................*
	echo * 1) Close this window with Ctrl+C.....................*
	echo * 2) Check user and password values....................*
	echo * 3) In case, do not use blanks, or special characters.*
	echo *                                                      *
	echo ********************************************************
	
	
	
	%plinkdir%\plink.exe -l  %hmc_user% -pw %hmc_password% %hmc_ip% whoami >%localdir%\%tempfolder%\HMC_%hmc_ip%_%managed_server_name%_Lpar_id_%lpar_id%_HmcPromptCheck.txt
	FOR /F "delims=" %%T IN (%localdir%\%tempfolder%\HMC_%hmc_ip%_%managed_server_name%_Lpar_id_%lpar_id%_HmcPromptCheck.txt) DO set _HmcPromptCheck=%%T
	
	echo .
	if %_HmcPromptCheck%==%hmc_user% echo HMC %hmc_ip% is online and respond to login - user=%_HmcPromptCheck%
	if %_HmcPromptCheck%==%hmc_user% echo HMC %hmc_ip% is online and respond to login - user=%_HmcPromptCheck% >>%localdir%\HMC_%hmc_ip%_%managed_server_name%_Lpar_id_%lpar_id%_log.txt
	:EndHmcPromptCheck

	:ManagedServerCheck
	echo %date%_%time% ### ManagedServerCheck	 >>%localdir%\HMC_%hmc_ip%_%managed_server_name%_Lpar_id_%lpar_id%_log.txt
	
	%plinkdir%\plink.exe -l  %hmc_user% -pw %hmc_password% %hmc_ip% lssyscfg -r sys -F name >>%localdir%\HMC_%hmc_ip%_%managed_server_name%_Lpar_id_%lpar_id%_log.txt
	%plinkdir%\plink.exe -l  %hmc_user% -pw %hmc_password% %hmc_ip% lssyscfg -r sys -F name >%localdir%\%tempfolder%\HMC_%hmc_ip%_%managed_server_name%_Lpar_id_%lpar_id%_ManagedServerCheck.txt																
	
	
	findstr /m "%managed_server_name%" %localdir%\%tempfolder%\HMC_%hmc_ip%_%managed_server_name%_Lpar_id_%lpar_id%_ManagedServerCheck.txt >Nul
	if %errorlevel%==0 (
	echo Server %managed_server_name% is managed by HMC %hmc_ip% -- check passed 
	echo Server %managed_server_name% is managed by HMC %hmc_ip% -- check passed >>%localdir%\HMC_%hmc_ip%_%managed_server_name%_Lpar_id_%lpar_id%_log.txt
	)
	
	if %errorlevel%==1 (
	echo Server %managed_server_name% not found -- check failed!
	echo Server %managed_server_name% not found -- check failed! >>%localdir%\HMC_%hmc_ip%_%managed_server_name%_Lpar_id_%lpar_id%_log.txt
	echo Server managed by HMC %hmc_ip% are:
	type %localdir%\%tempfolder%\HMC_%hmc_ip%_%managed_server_name%_Lpar_id_%lpar_id%_ManagedServerCheck.txt
	echo Check and fix hmc_ip or managed_server_name values
	goto :EndNoActions
	
	)
	rem pause
	:EndManagedServerCheck

	:LparCheck
	
	echo %date%_%time% ### LparCheck	 >>%localdir%\HMC_%hmc_ip%_%managed_server_name%_Lpar_id_%lpar_id%_log.txt
	%plinkdir%\plink.exe -l  %hmc_user% -pw %hmc_password% %hmc_ip% lssyscfg -r lpar -m %managed_server_name% -F lpar_id >>%localdir%\HMC_%hmc_ip%_%managed_server_name%_Lpar_id_%lpar_id%_log.txt
	%plinkdir%\plink.exe -l  %hmc_user% -pw %hmc_password% %hmc_ip% lssyscfg -r lpar -m %managed_server_name% -F lpar_id >%localdir%\%tempfolder%\HMC_%hmc_ip%_%managed_server_name%_Lpar_id_%lpar_id%_LparCheck.txt												
	
		for /f "delims=" %%a in (%localdir%\%tempfolder%\HMC_%hmc_ip%_%managed_server_name%_Lpar_id_%lpar_id%_LparCheck.txt) do set var=%%a&call :process
		goto :ExitLparCheckFailed
	
			:process
			rem echo var=%var%
			echo var=%var% >>%localdir%\HMC_%hmc_ip%_%managed_server_name%_Lpar_id_%lpar_id%_log.txt
			if %var%==%lpar_id% goto :ExitLparCheckOk
			goto :eof
			

		:ExitLparCheckFailed
		echo Lparid %lpar_id% not found -- check failed!
		echo Lparid %lpar_id% not found -- check failed! >>%localdir%\HMC_%hmc_ip%_%managed_server_name%_Lpar_id_%lpar_id%_log.txt
		echo Lparids defined on server %managed_server_name% are:
		type %localdir%\%tempfolder%\HMC_%hmc_ip%_%managed_server_name%_Lpar_id_%lpar_id%_LparCheck.txt
		echo Check and fix managed_server_name or lpar_id values
		goto :EndNoActions
		:EndExitLparCheckFailed
		
		
		
		:ExitLparCheckOk
		echo Lparid %lpar_id% found on server %managed_server_name% -- check passed
		echo Lparid %lpar_id% found on server %managed_server_name% -- check passed >>%localdir%\HMC_%hmc_ip%_%managed_server_name%_Lpar_id_%lpar_id%_log.txt
		rem goto :CheckLparReferenceCode01
		:EndExitLparCheckOk		

	:EndLparCheck

	cls
	echo ####################################################################
	echo # All prechecks completed successfully                             #
	echo # Press any key to continue                                        #
	echo # If you continue, the process will begin to check lpar %lpar_id%
	echo # When it will be "off", the process will change parameter         #
	echo # and then will power on lpar %lpar_id%        
	echo # ....or Press Ctrl+C to Exit                                      #
	echo ####################################################################
	pause
	goto :CheckLparReferenceCode01

:EndCheckIfAllReady

:CheckLparReferenceCode01

echo %date%_%time% ### CheckLparReferenceCode01	 >>%localdir%\HMC_%hmc_ip%_%managed_server_name%_Lpar_id_%lpar_id%_log.txt
%plinkdir%\plink.exe -l  %hmc_user% -pw %hmc_password% %hmc_ip% lsrefcode -r lpar -m %managed_server_name% -n 1 --filter "lpar_ids=%lpar_id%" >>%localdir%\HMC_%hmc_ip%_%managed_server_name%_Lpar_id_%lpar_id%_log.txt
:EndCheckLparReferenceCode01

:CheckLparStatus01
echo %date%_%time% ### CheckLparStatus	 >>%localdir%\HMC_%hmc_ip%_%managed_server_name%_Lpar_id_%lpar_id%_log.txt
%plinkdir%\plink.exe -l  %hmc_user% -pw %hmc_password% %hmc_ip% lssyscfg -r lpar -m %managed_server_name% --filter "lpar_ids=%lpar_id%" -F name,lpar_id,state >>%localdir%\HMC_%hmc_ip%_%managed_server_name%_Lpar_id_%lpar_id%_log.txt
%plinkdir%\plink.exe -l  %hmc_user% -pw %hmc_password% %hmc_ip% lssyscfg -r lpar -m %managed_server_name% --filter "lpar_ids=%lpar_id%" -F state >%localdir%\%tempfolder%\HMC_%hmc_ip%_%managed_server_name%_Lpar_id_%lpar_id%_state.txt
:EndCheckLparStatus01

:VerifyLparStatus01
echo %date%_%time% ### VerifyLparStatus01	 >>%localdir%\HMC_%hmc_ip%_%managed_server_name%_Lpar_id_%lpar_id%_log.txt

REM Remove blank spaces from lpar state files
@If Exist "%localdir%\_var_lpar_off_state.txt" (For /F Delims^=^ EOL^= %%W In ('More /T1 "%localdir%\_var_lpar_off_state.txt"')Do @Set "$=%%W"&Call Echo(%%$: =%%)>"%localdir%\%tempfolder%\_var_lpar_off_state_01.txt"
@If Exist "%localdir%\%tempfolder%\HMC_%hmc_ip%_%managed_server_name%_Lpar_id_%lpar_id%_state.txt" (For /F Delims^=^ EOL^= %%X In ('More /T1 "%localdir%\%tempfolder%\HMC_%hmc_ip%_%managed_server_name%_Lpar_id_%lpar_id%_state.txt"')Do @Set "$=%%X"&Call Echo(%%$: =%%)>"%localdir%\%tempfolder%\_var_lpar_off_state_02.txt"

REM Import lpar states from files (without blanks)
FOR /F "delims=" %%z IN (%localdir%\%tempfolder%\_var_lpar_off_state_01.txt) DO set lpar_state_01=%%z
FOR /F "delims=" %%y IN (%localdir%\%tempfolder%\_var_lpar_off_state_02.txt) DO set lpar_state_02=%%y

echo Required state is %lpar_state_01%			>>%localdir%\HMC_%hmc_ip%_%managed_server_name%_Lpar_id_%lpar_id%_log.txt
echo The lpar state is %lpar_state_02%			>>%localdir%\HMC_%hmc_ip%_%managed_server_name%_Lpar_id_%lpar_id%_log.txt

if %lpar_state_01%==%lpar_state_02% goto :ChangeSettings
if NOT %lpar_state_01%==%lpar_state_02% goto :Wait01
:EndVerifyLparStatus01

:Wait01
echo %date%_%time% ### Wait01	 >>%localdir%\HMC_%hmc_ip%_%managed_server_name%_Lpar_id_%lpar_id%_log.txt
timeout /T %seconds_wait_01%
cls
echo .. Waiting for lpar state %lpar_off_state%	>>%localdir%\HMC_%hmc_ip%_%managed_server_name%_Lpar_id_%lpar_id%_log.txt
echo .. Waiting for lpar state %lpar_off_state%	

goto :CheckLparReferenceCode01
:EndWait01

:ChangeSettings

REM Check parameter, change value, and check after changed
echo .. Lpar state is %lpar_off_state%
echo %date%_%time% ### ChangeSettings	 >>%localdir%\HMC_%hmc_ip%_%managed_server_name%_Lpar_id_%lpar_id%_log.txt
%plinkdir%\plink.exe -l  %hmc_user% -pw %hmc_password% %hmc_ip% lssyscfg -r lpar -m %managed_server_name% --filter "lpar_ids=%lpar_id%" -F %lpar_parameter% >>%localdir%\%tempfolder%\_temp.txt
FOR /F "delims=" %%V IN (%localdir%\%tempfolder%\_temp.txt) DO set value01=%%V


echo Current %lpar_parameter% is.....%value01%>>%localdir%\HMC_%hmc_ip%_%managed_server_name%_Lpar_id_%lpar_id%_log.txt
echo Required %lpar_parameter% is....%lpar_parameter_set_value%>>%localdir%\HMC_%hmc_ip%_%managed_server_name%_Lpar_id_%lpar_id%_log.txt
echo Current %lpar_parameter% is.....%value01%
echo Required %lpar_parameter% is....%lpar_parameter_set_value%

if %lpar_parameter_set_value%==%value01% goto :Exit01

%plinkdir%\plink.exe -l  %hmc_user% -pw %hmc_password% %hmc_ip% chsyscfg -r lpar -m %managed_server_name% -i 'lpar_id=%lpar_id%,%lpar_parameter%=%lpar_parameter_set_value%' >>%localdir%\HMC_%hmc_ip%_%managed_server_name%_Lpar_id_%lpar_id%_log.txt
echo Submit change of %lpar_parameter% >>%localdir%\HMC_%hmc_ip%_%managed_server_name%_Lpar_id_%lpar_id%_log.txt
echo Submit change of %lpar_parameter% 


%plinkdir%\plink.exe -l  %hmc_user% -pw %hmc_password% %hmc_ip% lssyscfg -r lpar -m %managed_server_name% --filter "lpar_ids=%lpar_id%" -F %lpar_parameter% >>%localdir%\%tempfolder%\_temp.txt
FOR /F "delims=" %%U IN (%localdir%\%tempfolder%\_temp.txt) DO set value02=%%U

echo Current %lpar_parameter% is.....%value02%>>%localdir%\HMC_%hmc_ip%_%managed_server_name%_Lpar_id_%lpar_id%_log.txt
echo Required %lpar_parameter% is....%lpar_parameter_set_value%>>%localdir%\HMC_%hmc_ip%_%managed_server_name%_Lpar_id_%lpar_id%_log.txt


echo Current %lpar_parameter% is.....%value02%
echo Required %lpar_parameter% is....%lpar_parameter_set_value%


if %lpar_parameter_set_value%==%value02% goto :Exit02
if NOT %lpar_parameter_set_value%==%value02% goto :Exit03
:EndChangeSettings

:Exit01
echo ----- Nothing to do ----- >>%localdir%\HMC_%hmc_ip%_%managed_server_name%_Lpar_id_%lpar_id%_log.txt
echo ----- Nothing to do -----
goto :LparPowerOn
:EndExit01

:Exit02
echo ----- Parameter changed ----- >>%localdir%\HMC_%hmc_ip%_%managed_server_name%_Lpar_id_%lpar_id%_log.txt
echo ----- Parameter changed -----
goto :LparPowerOn
:EndExit02

:Exit03
echo ----- General Error, check logs ----- >>%localdir%\HMC_%hmc_ip%_%managed_server_name%_Lpar_id_%lpar_id%_log.txt
echo ----- General Error, check logs -----
goto :LparPowerOn
:EndExit03

:LparPowerOn
echo %date%_%time% ### LparPowerOn	 >>%localdir%\HMC_%hmc_ip%_%managed_server_name%_Lpar_id_%lpar_id%_log.txt
%plinkdir%\plink.exe -l  %hmc_user% -pw %hmc_password% %hmc_ip% chsysstate -r lpar -m %managed_server_name% -o on --id %lpar_id% -f %lpar_profile% >>%localdir%\HMC_%hmc_ip%_%managed_server_name%_Lpar_id_%lpar_id%_log.txt
echo Submit Lpar Power on >>%localdir%\HMC_%hmc_ip%_%managed_server_name%_Lpar_id_%lpar_id%_log.txt
echo Submit Lpar Power on 
:EndLparPowerOn

:CheckLparReferenceCode02
echo %date%_%time% ### CheckLparReferenceCode02	 >>%localdir%\HMC_%hmc_ip%_%managed_server_name%_Lpar_id_%lpar_id%_log.txt
%plinkdir%\plink.exe -l  %hmc_user% -pw %hmc_password% %hmc_ip% lsrefcode -r lpar -m %managed_server_name% -n 1 --filter "lpar_ids=%lpar_id%" >>%localdir%\HMC_%hmc_ip%_%managed_server_name%_Lpar_id_%lpar_id%_log.txt
:EndCheckLparReferenceCode02

:CheckLparStatus02
echo %date%_%time% ### CheckLparStatus02	 >>%localdir%\HMC_%hmc_ip%_%managed_server_name%_Lpar_id_%lpar_id%_log.txt
%plinkdir%\plink.exe -l  %hmc_user% -pw %hmc_password% %hmc_ip% lssyscfg -r lpar -m %managed_server_name% --filter "lpar_ids=%lpar_id%" -F name,lpar_id,state >>%localdir%\HMC_%hmc_ip%_%managed_server_name%_Lpar_id_%lpar_id%_log.txt
%plinkdir%\plink.exe -l  %hmc_user% -pw %hmc_password% %hmc_ip% lssyscfg -r lpar -m %managed_server_name% --filter "lpar_ids=%lpar_id%" -F state >%localdir%\%tempfolder%\HMC_%hmc_ip%_%managed_server_name%_Lpar_id_%lpar_id%_state.txt
:EndCheckLparStatus02

:VerifyLparStatus02
echo %date%_%time% ### VerifyLparStatus02	 >>%localdir%\HMC_%hmc_ip%_%managed_server_name%_Lpar_id_%lpar_id%_log.txt

REM Remove blank spaces from lpar state files
@If Exist "%localdir%\_var_lpar_on_state.txt" (For /F Delims^=^ EOL^= %%W In ('More /T1 "%localdir%\_var_lpar_on_state.txt"')Do @Set "$=%%W"&Call Echo(%%$: =%%)>"%localdir%\%tempfolder%\_var_lpar_on_state_01.txt"
@If Exist "%localdir%\%tempfolder%\HMC_%hmc_ip%_%managed_server_name%_Lpar_id_%lpar_id%_state.txt" (For /F Delims^=^ EOL^= %%X In ('More /T1 "%localdir%\%tempfolder%\HMC_%hmc_ip%_%managed_server_name%_Lpar_id_%lpar_id%_state.txt"')Do @Set "$=%%X"&Call Echo(%%$: =%%)>"%localdir%\%tempfolder%\_var_lpar_on_state_02.txt"

REM Import lpar states from files (without blanks)
FOR /F "delims=" %%z IN (%localdir%\%tempfolder%\_var_lpar_on_state_01.txt) DO set lpar_state_01=%%z
FOR /F "delims=" %%y IN (%localdir%\%tempfolder%\_var_lpar_on_state_02.txt) DO set lpar_state_02=%%y

echo Required state is %lpar_state_01%			>>%localdir%\HMC_%hmc_ip%_%managed_server_name%_Lpar_id_%lpar_id%_log.txt
echo The lpar state is %lpar_state_02%			>>%localdir%\HMC_%hmc_ip%_%managed_server_name%_Lpar_id_%lpar_id%_log.txt

if %lpar_state_01%==%lpar_state_02% goto :EndOk
if NOT %lpar_state_01%==%lpar_state_02% goto :Wait02
:EndVerifyLparStatus02

:Wait02
echo %date%_%time% ### Wait02	 >>%localdir%\HMC_%hmc_ip%_%managed_server_name%_Lpar_id_%lpar_id%_log.txt
timeout /T %seconds_wait_01%
echo .. Waiting for lpar state %lpar_on_state%	>>%localdir%\HMC_%hmc_ip%_%managed_server_name%_Lpar_id_%lpar_id%_log.txt
echo .. Waiting for lpar state %lpar_on_state%	
goto :CheckLparReferenceCode02
:EndWait02

:EndOk
echo %date%_%time% ### EndOk	 >>%localdir%\HMC_%hmc_ip%_%managed_server_name%_Lpar_id_%lpar_id%_log.txt
echo .. Lpar state is %lpar_on_state%	>>%localdir%\HMC_%hmc_ip%_%managed_server_name%_Lpar_id_%lpar_id%_log.txt
echo .. Lpar state is %lpar_on_state%
pause
exit
:EndEndOk

:EndNoActions
echo %date%_%time% ### EndNoActions	 >>%localdir%\HMC_%hmc_ip%_%managed_server_name%_Lpar_id_%lpar_id%_log.txt
echo .. Check Var Values	>>%localdir%\HMC_%hmc_ip%_%managed_server_name%_Lpar_id_%lpar_id%_log.txt
echo .. Check Var Values
pause
exit
:EndEndNoActions
pause