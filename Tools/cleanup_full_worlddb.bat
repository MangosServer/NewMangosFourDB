@echo off
setlocal enabledelayedexpansion

set "targetDir=_full_worlddb"

echo Processing files in: %targetDir%
echo.

if not exist "%targetDir%" (
    echo Error: Directory not found: %targetDir%
    pause
    exit /b 1
)

set "vbsScript=%temp%\replace.vbs"

(
echo Set fso = CreateObject("Scripting.FileSystemObject"^)
echo Set args = WScript.Arguments
echo If args.Count ^< 1 Then WScript.Quit 0
echo filepath = args(0^)
echo If Not fso.FileExists(filepath^) Then WScript.Quit 0
echo Set file = fso.OpenTextFile(filepath, 1^)
echo content = file.ReadAll
echo file.Close
echo oldStr = "),"
echo newStr = ")," ^& vbCrLf
echo newContent = Replace(content, oldStr, newStr^)
echo oldStr2 = ") VALUES ("
echo newStr2 = ") VALUES " ^& vbCrLf ^& "("
echo newContent = Replace(newContent, oldStr2, newStr2^)
echo oldStr3 = "@@TIME_ZONE"
echo newStr3 = "@@SESSION.TIME_ZONE"
echo newContent = Replace(newContent, oldStr3, newStr3^)
echo If newContent ^<^> content Then
echo     Set outFile = fso.OpenTextFile(filepath, 2^)
echo     outFile.Write newContent
echo     outFile.Close
echo     WScript.Quit 1
echo Else
echo     WScript.Quit 0
echo End If
) > "%vbsScript%"

set "count=0"
set "total=0"

for %%f in ("%targetDir%\*") do (
    set /a total+=1
    set "filename=%%~nxf"
    
    echo Processing: !filename!
    
    cscript //nologo "%vbsScript%" "%%f"
    
    if errorlevel 1 (
        echo Modified: !filename!
        set /a count+=1
    ) else (
        echo No changes: !filename!
    )
)

del "%vbsScript%"

echo.
echo Total files processed: %total%
echo Files modified: %count%
pause
