:: dBm = (quality / 2) - 100
@echo ON
SET /P RAWDATAFILE=
del tmp1.txt
SET /A FND=0
SET /A COUNT=0
SET TMPSTR="XXX"
SET JSONSTR="XXX"
SET /P YAAPIKEY=<yaapikey.txt
rem enableextensions
setlocal enabledelayedexpansion
rem /C:"BSSID:" 
FOR /f "skip=3 tokens=*" %%I in ('FINDSTR /C:"BSSID" /C:"Сигнал:" %RAWDATAFILE%') do (
	SET TMPSTR=%%I
	SET "TMPSTR=!!TMPSTR: =!!"
	SET "TMPSTR=!!TMPSTR:BSSID1:=!!"
	SET "TMPSTR=!!TMPSTR:Сигнал:=!!"
	SET "TMPSTR=!!TMPSTR::=-!!"
	SET "TMPSTR=!!TMPSTR:%%=!!"
	SET /a BLNVAR=!COUNT!%%2
	IF !BLNVAR!==1 (
		SET /A TMPSTR=^(!TMPSTR!/2^)-100
	)
	ECHO !TMPSTR!>>tmp1.txt
	SET /A COUNT+=1
)
del ywjds.txt
SET JSONSTR=json^={"common":{"version": "1.0","api_key":"
SET JSONSTR=%JSONSTR%%YAAPIKEY%
SET JSONSTR=%JSONSTR%=="},"wifi_networks":[
SET /A COUNT=0
FOR /f "tokens=*" %%Z in (tmp1.txt) do (
	SET /a BLNVAR=!COUNT!%%2
	SET TMPSTR=%%Z
	rem <Nul Set /P TMPSTR=!TMPSTR!
	IF !BLNVAR!==0 (
		SET JSONSTR=!JSONSTR!^{^"mac":"
		SET JSONSTR=!JSONSTR!!TMPSTR!
		SET JSONSTR=!JSONSTR!^","signal_strength":
	)
	IF !BLNVAR!==1 (
		SET JSONSTR=!JSONSTR!!TMPSTR!
		SET JSONSTR=!JSONSTR!,"age": 0,},
	)
	SET /A COUNT+=1
)
SET JSONSTR=%JSONSTR%]}
ECHO %JSONSTR%>>ywjds.txt
del geolocation*
wget --post-file=ywjds.txt http://api.lbs.yandex.net/geolocation
PAUSE
SET LON="XXX" 
SET LAT="XXX"
FOR /f "tokens=*" %%J in ('FINDSTR /C:"longitude" geolocation') do (
	SET "LON=%%J"
)
SET "LON=%LON:"longitude":=%"
SET "LON=%LON: =%"
SET "LON=%LON:,=%"
FOR /f "tokens=*" %%N in ('FINDSTR /C:"latitude" geolocation') do (
	SET LAT=%%N
)
SET "LAT=%LAT:"latitude":=%"
SET "LAT=%LAT: =%"
SET "LAT=%LAT:,=%"
rem "C:\Program Files\Mozilla Firefox\firefox.exe" https://yandex.ru/maps/^?ll=%LON%,%LAT%^&mode=search^&ol=geo
"C:\Program Files\Mozilla Firefox\firefox.exe" https://www.google.ru/maps/place/@%LAT%,%LON%,18z