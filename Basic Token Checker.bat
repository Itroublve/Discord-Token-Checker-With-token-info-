@echo off
:0
echo Itroublve's Batch Token Checker
echo 1 - Check single token
echo 2 - Check tokens in "tokens.txt" 
echo 0 - Exit  
set /p f=
if "%f%" == "0" exit
if "%f%" == "2" cls & goto 3
if "%f%" == "1" (cls & goto 1 
) else (cls & goto 0)
:1
set /p token=Your token: 
cls
curl --silent -H "Content-Type: application/json" -H "Authorization: %token%" https://discordapp.com/api/v8/users/@me > %temp%\tokeninfo.json
echo. >> tokeninfo.json
find /i "401: Unauthorized" %temp%\tokeninfo.json >NUL
if errorlevel 1 (
	color 2 & echo Token is either valid or locked :/
	curl --silent -H "Content-Type: application/json" -H "Authorization: %token%" https://discordapp.com/api/v8/users/@me >> tokeninfo.json
	echo Saved token info in tokeninfo.json
) else (
	color 4 & echo Token is invalid!
	del %temp%\tokeninfo.json /q /f
	echo Saved token info in tokeninfo.json
)
set /P c=Do you want to check another token [Y/N]? 
if /I "%c%" EQU "Y" color 7 & cls & goto 1
if /I "%c%" EQU "N" goto 2
:2
exit
:3
if not exist "tokens.txt" echo "tokens.txt" not found!
for /F "usebackq tokens=*" %%A in ("tokens.txt") do (
curl --silent -H "Content-Type: application/json" -H "Authorization: %%A" https://discordapp.com/api/v8/users/@me > %temp%\tokeninfo.json
find /i "401: Unauthorized" %temp%\tokeninfo.json >NUL
if errorlevel 1 (
	echo [Valid | Locked] %%A
	echo %%A >> tokeninfo.json
	echo.
	) else (
		echo [Invalid] %%A
		del %temp%\tokeninfo.json /q /f )
		)
echo Valid token are saved in "tokeninfo.json" (if any)
set /P idk=Do you want to return to main screen [Y/N]? 
if /I "%idk%" EQU "Y" cls & goto 0
if /I "%idk%" EQU "N" goto 2
