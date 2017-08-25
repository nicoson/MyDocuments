::========	set time stamp
echo off
set job_getList=test.exe
set job_getData=test2.exe
set /A stopServerTime=4
set /A startServerTime=8
set /A status=0


cd C:\Projects\cmd

:label-loop

	::set /A currentTime="%time:~,2%"
	set /A currentTime="%time:~7,1%"
	echo %time%

	::	=====	get into the cold period, stop the job and refresh the list table
	if %currentTime% geq %stopServerTime% (
		if %currentTime% lss %startServerTime% (
			if %status% equ 0 (
				set /A status=1
				echo "stop server"
				echo status changed to 1

				ping -n 3 127.1 >nul
				taskkill /f /im %job_getData%
				ping -n 3 127.1 >nul
				start %job_getList%
			)
		)
	)

	::	=====	get into the trading period, start the job
	if %currentTime% geq %startServerTime% (
		if %status% equ 1 (
			set /A status=0
			echo "start server"
			echo status changed to 0
			ping -n 3 127.1 >nul
			taskkill /f /im %job_getList%
			ping -n 3 127.1 >nul
			start %job_getData%	
		)
	)

	echo ================ %status%

	::	=====	sleep for 10 mins - 10x60+1
	ping -n 3 127.1 >nul

goto label-loop