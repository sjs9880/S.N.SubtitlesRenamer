:: (C) 2018. _SN_(sjs9880) all rights reserved.
:: 제작 _SN_ [ http://sjs9880.blog.me/221360978385 ] 2018.012.09 배포
:: 본 스크립트는 파일 검색, 파일 생성, 이름 변경에 관한 명령어가 포함돼있으며 사용 중 파일 손상이나 유실의 위험이 있습니다.

@ECHO OFF
TITLE S.N.SubtitlesRenamer v2.8 :: 자막 매칭 스크립트
PUSHD "%~dp0"

IF NOT EXIST Setting.ini (
	ECHO Setting.ini 파일이 없습니다.
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
	ECHO VideoExtension.ini 를 생성합니다.
	ECHO MP4>>VideoExtension.ini
	ECHO MKV>>VideoExtension.ini
	ECHO AVI>>VideoExtension.ini
)
IF EXIST SubtitleExtension.ini (
	ECHO SubtitleExtension.ini ... OK
) ELSE (
	SET /a error=1
	ECHO SubtitleExtension.ini ... NO
	ECHO SubtitleExtension.ini 를 생성합니다.
	ECHO SMI>>SubtitleExtension.ini
	ECHO ASS>>SubtitleExtension.ini
	ECHO SRT>>SubtitleExtension.ini
)
IF %error%==1 (
	ECHO VideoExtension.ini 또는 SubtitleExtension.ini 파일이 없어 재생성 되었습니다.
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
							ECHO "해당 영상 파일의 이름과 일치하는 자막 파일이 존재 합니다. [ %%C\!D:~0,-4!.%%A ]"
							IF NOT "!D:~0,-4!"=="!E:~0,-4!" (
								SET /a "countA-=1" 
							)
						)
						IF !error!==0 (
							ECHO "[ %%C ]속 자막 파일의 이름을 변경합니다. [ !E:~0,-4!.%%B 〓》!D:~0,-4!.%%B ]"
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
ECHO 자막 매칭이 완료되었습니다.
IF %LoopTime%==0 PAUSE
IF %LoopTime% LEQ 30 (
	CHOICE /N /T %LoopTime% /D Y /M " %LoopTime% 초 후 종료됩니다."
	) ELSE (
	CHOICE /N /T 3 /D Y /M " 3 초 후 종료됩니다."
)

:END
POPD