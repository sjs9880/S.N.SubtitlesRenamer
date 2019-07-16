:: (C) 2018. _SN_(sjs9880) all rights reserved.
:: ���� _SN_ [ http://sjs9880.blog.me/221360978385 ] 2018.012.09 ����
:: �� ��ũ��Ʈ�� ���� �˻�, ���� ����, �̸� ���濡 ���� ��ɾ ���Ե������� ��� �� ���� �ջ��̳� ������ ������ �ֽ��ϴ�.

@ECHO OFF
TITLE S.N.SubtitlesRenamer v2.8 :: �ڸ� ��Ī ��ũ��Ʈ
PUSHD "%~dp0"

IF NOT EXIST Setting.ini (
	ECHO Setting.ini ������ �����ϴ�.
	PAUSE
	GOTO END
)

FOR /f "tokens=1,2 delims==	" %%A in (Setting.ini) do (
	IF %%A==output SET output=%%B
	IF %%A==LoopTime SET /a LoopTime=%%B
)

SET /a error=0
IF EXIST VideoExtension.ini (
	ECHO VideoExtension.ini ... OK
) ELSE (
	SET /a error=1
	ECHO VideoExtension.ini ... NO
	ECHO VideoExtension.ini �� �����մϴ�.
	ECHO MP4>>VideoExtension.ini
	ECHO MKV>>VideoExtension.ini
	ECHO AVI>>VideoExtension.ini
)
IF EXIST SubtitleExtension.ini (
	ECHO SubtitleExtension.ini ... OK
) ELSE (
	SET /a error=1
	ECHO SubtitleExtension.ini ... NO
	ECHO SubtitleExtension.ini �� �����մϴ�.
	ECHO SMI>>SubtitleExtension.ini
	ECHO ASS>>SubtitleExtension.ini
	ECHO SRT>>SubtitleExtension.ini
)
IF %error%==1 (
	ECHO VideoExtension.ini �Ǵ� SubtitleExtension.ini ������ ���� ����� �Ǿ����ϴ�.
	PAUSE
)

ECHO.
SETlocal enabledelayedexpansion
SET /a "countA=0"
SET /a "countB=0"
SET /a "error=0"
FOR /f "tokens=*" %%A IN (VideoExtension.ini) DO (
	FOR /f "tokens=*" %%B IN (SubtitleExtension.ini) DO (
		FOR /f "tokens=*" %%C IN ('DIR "!output!" /A:D /B') DO (
			DIR "!output!\%%C\*.%%A" /A:-D /O:N /B>>Videolist
			DIR "!output!\%%C\*.%%B" /A:-D /O:N /B>>Subtitlelist
			SET /a "countA=0" 
			FOR /f "tokens=*" %%D IN (Videolist) DO (
				SET "D=%%D"
				SET /a "countA+=1" 
				SET /a "countB=0" 
				FOR /f "tokens=*" %%E IN (Subtitlelist) DO (
					SET "E=%%E"
					SET /a "countB+=1" 
					IF !countA!==!countB! (
						IF EXIST "!output!\%%C\!D:~0,-4!.%%B" (
							SET /a "error+=1"
							ECHO "�ش� ���� ������ �̸��� ��ġ�ϴ� �ڸ� ������ ���� �մϴ�. [ %%C\!D:~0,-4!.%%A ]"
							IF NOT "!D:~0,-4!"=="!E:~0,-4!" (
								SET /a "countA-=1" 
							)
						)
						IF !error!==0 (
							ECHO "[ %%C ]�� �ڸ� ������ �̸��� �����մϴ�. [ !E:~0,-4!.%%B �롷!D:~0,-4!.%%B ]"
							REN "!output!\%%C\!E:~0,-4!.%%B" "!D:~0,-4!.%%B"
						)
						SET /a "error=0"
					)
				)
			)
			DEL Videolist
			DEL Subtitlelist
		)
	)
)
endlocal

ECHO.
ECHO �ڸ� ��Ī�� �Ϸ�Ǿ����ϴ�.
IF %LoopTime%==0 PAUSE
IF %LoopTime% LEQ 30 (
	CHOICE /N /T %LoopTime% /D Y /M " %LoopTime% �� �� ����˴ϴ�."
	) ELSE (
	CHOICE /N /T 3 /D Y /M " 3 �� �� ����˴ϴ�."
)

:END
POPD