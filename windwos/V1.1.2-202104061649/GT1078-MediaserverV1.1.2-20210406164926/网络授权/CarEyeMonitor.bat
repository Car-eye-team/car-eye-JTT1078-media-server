@echo off
rem ����ѭ�����ʱ��ͼ��ķ���
set secs=30
set srvname="nginx_window_flv"

rem ���ű��Լ��secs���ָ��process���Ľ��̽���CPUռ���ʼ��, max_cpusΪĿ��CPU����ռ���ʳ���CPU�������ĳ˻�
rem ��: ϣ�������ڳ���50%ʱ��������, �����CPU������Ϊ4, ��max_cpus��ֵ����Ϊ200
rem CPUռ������, ��Ҫ����CPU������
set max_cpus=8
set process=nginx_window_flv

echo.
echo ========================================
echo == ��ѯ����������״̬�� ==
echo == ÿ���%secs%���ֽ���һ�β�ѯ�� ==
echo == �緢���쳣�������������� ==
echo ========================================
echo.
echo �˽ű����ķ����ǣ�%srvname%
echo.

if %srvname%. == . goto end

:chkit



rem ���nginx������״̬
rem ��ȡ����ID
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
				rem �������10���Ƿ������ռ��
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
rem ���������������ʱ��������ܻᵼ��cpu�����������ء�
endlocal
rem echo "Waiting..."
ping -n %secs% 127.0.0.1 > nul
goto chkit

:end