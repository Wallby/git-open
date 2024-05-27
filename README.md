# git open

**Setup**

To setup the `git open` alias I recommed to..
1. open command prompt/windows powershell
2. type `git config --global alias.open tmp`
3. go to the home folder (`ctrl`+`r` then type in `%HOMEPATH%`)
4. paste in git-open.bat
5. open .gitconfig which is also in home folder
6. replace `open = tmp` with `open = !~/git-open.bat`
7. save .gitconfig

One line version of git-open.bat..
```
@echo off & SETLOCAL enabledelayedexpansion & ( IF [%1]==[] EXIT ) & ( IF NOT [%4]==[] EXIT ) & SET "a=0" & SET "b=0" & SET "interactive=0" & ( IF %1==-i SET "a=1" ) & ( IF %1==--interactive SET "a=1" ) & ( IF !a!==1 SET /A "b+=1" & SET "interactive=1" & SET "argument1=%2" & SET "argument2=%3" ) & SET "a=0" & ( IF "%2"=="-i" SET "a=1" ) & ( IF "%2"=="--interactive" SET "a=1" ) & ( IF !a!==1 SET /A "b+=1" & SET "interactive=1" & SET "argument1=%1" & SET "argument2=%3" ) & SET "a=0" & ( IF "%3"=="-i" SET "a=1" ) & ( IF "%3"=="--interactive" SET "a=1" ) & ( IF !a!==1 SET /A "b+=1" & SET "interactive=1" & SET "argument1=%1" & SET "argument2=%2" ) & ( IF !b! GTR 1 EXIT ) & ( IF !interactive!==0 SET "argument1=%1" & SET "argument2=%2" ) & ( IF [!argument2!]==[] ( ( SET "branchOrCommit=" ) & ( SET "pathToFile=!argument1!" ) ) ELSE ( ( SET "branchOrCommit=!argument1!" ) & ( SET "pathToFile=!argument2!" ) ) ) & (git show !branchOrCommit!:!pathToFile! > NUL || EXIT) & ( SET "a=$a=[System.IO.Path]::GetTempFileName(); Remove-Item $a; New-Item $a -ItemType \"Directory\" | Out-Null; $b=$a + (\"\!pathToFile!\" -replace '/','\'); New-Item $b -Force ^| Out-Null; cmd.exe /C (\"git show !branchOrCommit!:!pathToFile! ^> `\"\" + $b + \"`\"\"); $c = New-Object System.Diagnostics.Process;" ) & ( IF !interactive!==1 ( SET "a=!a! $c.StartInfo.Filename = \"openwith.exe\"; $c.StartInfo.Arguments = $b;" ) ELSE ( SET "a=!a! $c.StartInfo.Filename = $b;" ) ) & ( SET "a=!a! $c.start() ^| Out-Null;" ) & ( IF !interactive!==1 SET "a=!a! Wait-Process -InputObject $c;" ) & ( SET "a=!a! Start-Sleep -Milliseconds 500; Remove-Item -Recurse $a;" ) & powershell.exe -Command "!a!"
```

**Usage**

There's two ways you can use `git open`..  
* `git open <path-to-file>`
* `git open <branch/commit> <path-to-file>`

`git open <path-to-file>` will..
* if the file at `path-to-file` is staged.. open the staged file
* otherwise.. open the file from HEAD (i.e. normally the last commit)

`git open <branch/commit> <path-to-file>` will open the file from the specified branch or commit.

*NOTE: the value that can be specified for `commit` here is displayed in the SHA1 ID box in gitk if selecting a commit (usually no more than the 10 first characters have to be copied, as long as there isn't any ambiguity with another commit it will suffice)*

Regardless of which way of using `git open`, you can additionally provide the `-i/--interactive parameter` anywhere which will prompt for choosing a program with which to open the file instead of using the default program.

*NOTE: e.g. `git open -i <branch/commit> <path-to-file>` and `git open <branch/commit> --interactive <path-to-file>` mean the same*

**Examples**

If e.g. there is a file a.tif which was committed and now `git status` outputs..
```
On branch <branch>
Your branch is up to date with 'origin/<branch>'.

Changes to be committed:
  (use "git restore --staged <file>..." to unstage)
        modified:   a.tif

Untracked files:
  (use "git add <file>..." to include in what will be committed)
        a.tif
```
To open a.tif from the previous commit type `git open HEAD a.tif`.  
To open the staged a.tif type `git open a.tif`.  
To open the unstaged a.tif type `.\a.tif`.

To open a.tif from a specific commit type `git open <commit> a.tif`.  
To open a.tif from the commit before a specific commit type `git open <commit>~1 a.tif`.  
To open a.tif from the second to last commit type `git open HEAD~1 a.tif`.