:: git open <branch/commit> <path-to-file>
:: or
:: git open <path-to-file>
:: parameters..
:: --interactive/-i <- will prompt with which program to open the file..?
@echo off
SETLOCAL enabledelayedexpansion

IF [%1]==[] EXIT
IF NOT [%4]==[] EXIT

SET a=0
SET b=0
SET interactive=0
IF %1==-i SET a=1
IF %1==--interactive SET a=1
IF %a%==1 SET /A "b+=1" & SET "interactive=1" & SET "argument1=%2" & SET argument2=%3
SET a=0
IF "%2"=="-i" SET a=1
IF "%2"=="--interactive" SET a=1
IF %a%==1 SET /A "b+=1" & SET "interactive=1" & SET "argument1=%1" & SET argument2=%3
SET a=0
IF "%3"=="-i" SET a=1
IF "%3"=="--interactive" SET a=1
IF %a%==1 SET /A "b+=1" & SET "interactive=1" & SET "argument1=%1" & SET argument2=%2

IF %b% GTR 1 EXIT
IF %interactive%==0 SET "argument1=%1" & SET "argument2=%2"

IF [%argument2%]==[] (
	SET branchOrCommit=
	::                 ^
	::                 if staged.. staged, otherwise.. HEAD
	SET pathToFile=%argument1%
) ELSE (
	SET branchOrCommit=%argument1%
	SET pathToFile=%argument2%
)

git show %branchOrCommit%:%pathToFile% > NUL || EXIT

SET a=$a=[System.IO.Path]::GetTempFileName();
:: NOTE: using delayed expansion here to prevent e.g. "| Out-Null" from causing issues
SET a=!a! Remove-Item $a;
SET a=!a! New-Item $a -ItemType \"Directory\" ^| Out-Null;

SET a=!a! cmd.exe /C (\"git show %branchOrCommit%:%pathToFile% ^> `\"\" + $a + \"\%pathToFile%`\"\");
SET a=!a! $b = New-Object System.Diagnostics.Process;
IF %interactive%==1 (
	SET a=!a! $b.StartInfo.Filename = \"openwith.exe\";
	SET a=!a! $b.StartInfo.Arguments = $a + \"\%pathToFile%\";
) ELSE (
	SET a=!a! $b.StartInfo.Filename = $a + \"\%pathToFile%\";
)
SET a=!a! $b.start() ^| Out-Null;
IF %interactive%==1 SET a=!a! Wait-Process -InputObject $b;
::                            ^
::                            wait for openwith.exe dialog to close
SET a=!a! Start-Sleep -Milliseconds 500;
::        ^
:: wait for arbitrary amount of time as I don't know how to wait for file to finish opening
SET a=!a! Remove-Item -Recurse $a;

powershell.exe -Command "!a!"