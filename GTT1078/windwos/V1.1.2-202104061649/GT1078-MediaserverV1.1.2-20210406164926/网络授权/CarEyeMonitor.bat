@echo off
rem 定义循环间隔时间和监测的服务：
set secs=30
set srvname="nginx_window_flv"

rem 本脚本以间隔secs秒对指定process名的进程进行CPU占有率监控, max_cpus为目标CPU上限占有率乘以CPU核心数的乘积
rem 如: 希望进程在超过50%时结束进程, 计算机CPU核心数为4, 则max_cpus的值设置为200
rem CPU占用上限, 需要乘以CPU核心数
set max_cpus=8
set process=nginx_window_flv

echo.
echo ========================================
echo == 查询计算机服务的状态， ==
echo == 每间隔%secs%秒种进行一次查询， ==
echo == 如发现异常，则立即启动。 ==
echo ========================================
echo.
echo 此脚本监测的服务是：%srvname%
echo.

if %srvname%. == . goto end

:chkit



rem 监控nginx服务器状态
rem 获取进程ID
setlocal enabledelayedexpansion
set /a ii=0
rem echo "Check %process% status..."
for /f "tokens=2 " %%a in ('tasklist  /fi "imagename eq %%process%%.exe" /nh') do (
	: echo %%a
	for /f "tokens=2 delims=," %%c in ('typeperf "\Process(%process%#!ii!)\%% Processor Time" -si 1 -sc 1 ^| find /V "\\"') do (
		if %%~c==-1 (
			goto :end0
		) else (
			echo %%~c%% / !max_cpus! --- %%a---
			if %%~c% GTR !max_cpus! (
				rem echo %%~c%% / !max_cpus! --- %%a---
				rem 持续监测10秒是否持续高占用
				for /l %%j in (1,1,10) do (
					ping -n 1 127.0.0.1 > nul
					for /f "tokens=2 delims=," %%d in ('typeperf "\Process(%process%#!ii!)\%% Processor Time" -si 1 -sc 1 ^| find /V "\\"') do (
						echo ---%%~d%%--- / !max_cpus!
						if %%~d% LSS !max_cpus! (
							goto :for0
						)
					)
				)
				echo "kill %process% %%a"
				taskkill /F /PID %%a
			)
		)
	)
:for0
	set /a ii+=1
)

:end0
rem 下面的命令用于延时，否则可能会导致cpu单个核心满载。
endlocal
rem echo "Waiting..."
ping -n %secs% 127.0.0.1 > nul
goto chkit

:end