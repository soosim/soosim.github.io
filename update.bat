@echo off

goto start

::安装 amwiki 扩展
::npm install -g amWiki
::查看帮助
::amWiki help

:start
call amWiki -v>nul

if %errorlevel% neq 0 goto A

:: starting
call amwiki update nav

echo -------------------------------------------------
echo.
echo 		按任意键关闭
echo.
pause>nul
exit

:A
echo.
echo 		请检查nodejs与amwiki是否安装成功
echo.
pause
exit