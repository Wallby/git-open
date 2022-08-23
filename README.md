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
@echo off & SETLOCAL enabledelayedexpansion & ( IF [%1]==[] EXIT ) & ( IF NOT [%3]==[] EXIT ) & ( IF [%2]==[] ( ( SET "branchOrCommit=" ) & ( SET "pathToFile=%1" ) ) ELSE ( ( SET "branchOrCommit=%1" ) & ( SET "pathToFile=%2" ) ) ) & (git show !branchOrCommit!:!pathToFile! > NUL || EXIT) & ( SET "a=$a=[System.IO.Path]::GetTempFileName(); Remove-Item $a; New-Item $a -ItemType \"Directory\" | Out-Null; cmd.exe /C (\"git show !branchOrCommit!:!pathToFile! ^> `\"\" + $a + \"\!pathToFile!`\"\"); $b=Start-Process -FilePath ($a + \"\!pathToFile!\"); Start-Sleep -Milliseconds 500; Remove-Item -Recurse $a;") & powershell.exe -Command "!a!"
```

**Usage**

There's two ways you can use `git open`..  
* `git open <path-to-file>`
* `git open <branch/commit> <path-to-file>`

`git open <path-to-file>` will..
* if the file at `path-to-file` is staged.. open the staged file
* otherwise.. open the file from HEAD (i.e. normally the last commit)

`git open <branch/commit> <path-to-file>` will open the file from the specified branch or commit

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
To open a.tif from the previous commit type `git open HEAD a.tif`  
To open the staged a.tif type `git open a.tif`  
To open the unstaged a.tif type `.\a.tif`

To open a.tif from a specific commit type `git open <commit> a.tif`  
To open a.tif from the commit before a specific commit type `git open <commit>~1 a.tif`  
To open a.tif from the second to last commit type `git open HEAD~1 a.tif`