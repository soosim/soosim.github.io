@echo off

goto start

::��װ amwiki ��չ
::npm install -g amWiki
::�鿴����
::amWiki help

:start
call amWiki -v>nul

if %errorlevel% neq 0 goto A

:: starting
call amwiki update nav

echo -------------------------------------------------
echo.
echo 		��������ر�
echo.
pause>nul
exit

:A
echo.
echo 		����nodejs��amwiki�Ƿ�װ�ɹ�
echo.
pause
exit