:: git open <branch/commit> <path-to-file>
:: or
:: git open <path-to-file>
@echo off
SETLOCAL enabledelayedexpansion

IF [%1]==[] EXIT
IF NOT [%3]==[] EXIT

IF [%2]==[] (
	SET branchOrCommit=
	::                 ^
	::                 if staged.. staged, otherwise.. HEAD
	SET pathToFile=%1
) ELSE (
	SET branchOrCommit=%1
	SET pathToFile=%2
)

git show %branchOrCommit%:%pathToFile% > NUL || EXIT

SET a=$a=[System.IO.Path]::GetTempFileName();
:: NOTE: using delayed expansion here to prevent e.g. "| Out-Null" from causing issues
SET a=!a! Remove-Item $a;
SET a=!a! New-Item $a -ItemType \"Directory\" ^| Out-Null;

SET a=!a! cmd.exe /C (\"git show %branchOrCommit%:%pathToFile% ^> `\"\" + $a + \"\%pathToFile%`\"\");
SET a=!a! $b=Start-Process -FilePath ($a + \"\%pathToFile%\");
SET a=!a! Start-Sleep -Milliseconds 500;
::        ^
:: wait for arbitrary amount of time as I don't know how to wait for file to finish opening
SET a=!a! Remove-Item -Recurse $a;

powershell.exe -Command "!a!"