SETLOCAL ENABLEDELAYEDEXPANSION
:: find all wi-fi devices
for /F "eol=: tokens=1 delims=, " %%I IN ('devcon find * ^| find /I "wireless"') DO (
	set WIFIDEV=%%I
	:: Cut some symbols and add asterisks
	set WIFIDEV2=^*!WIFIDEV:~4,17!^*
	:: Mirroring &
	set WIFIDEV3=!WIFIDEV2:^&=^^^&!
	:: Enable all wi-fi adapters. Will work only from admin
	devcon enable !WIFIDEV3!
)
for /F "eol=: tokens=1 delims=, " %%I IN ('devcon find * ^| find /I "802.11"') DO (
	set WIFIDEV0=%%I
	:: Cut some symbols and add asterisks
	set WIFIDEV02=^*!WIFIDEV0:~4,17!^*
	:: Mirroring &
	set WIFIDEV03=!WIFIDEV02:^&=^^^&!
	:: Enable all wi-fi adapters. Will work only from admin
	devcon enable !WIFIDEV03!
)
endlocal

timeout 10
:: Cut milliseconds
set normtime=%TIME:~0,8%
:: Change : to - in timestamp string
set normtime2=%normtime::=-%
set tmpname=%COMPUTERNAME%_%DATE%_%NORMTIME2%.txt
:: get all SSID's avaliable

netsh wlan show all > "%tmpname%"
