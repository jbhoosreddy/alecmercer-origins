@ECHO OFF



CHOICE /N /C CDEFGHIJKLMNOPQRSTUVWXYZ /M "Enter drive letter of 3dsMax Installation:"

IF %ERRORLEVEL%==1 set DRIVE=C
IF %ERRORLEVEL%==2 set DRIVE=D
IF %ERRORLEVEL%==3 set DRIVE=E
IF %ERRORLEVEL%==4 set DRIVE=F
IF %ERRORLEVEL%==5 set DRIVE=G
IF %ERRORLEVEL%==6 set DRIVE=H
IF %ERRORLEVEL%==7 set DRIVE=I
IF %ERRORLEVEL%==8 set DRIVE=J
IF %ERRORLEVEL%==9 set DRIVE=K
IF %ERRORLEVEL%==10 set DRIVE=L
IF %ERRORLEVEL%==11 set DRIVE=M
IF %ERRORLEVEL%==12 set DRIVE=N
IF %ERRORLEVEL%==13 set DRIVE=O
IF %ERRORLEVEL%==14 set DRIVE=P
IF %ERRORLEVEL%==15 set DRIVE=Q
IF %ERRORLEVEL%==16 set DRIVE=R
IF %ERRORLEVEL%==17 set DRIVE=S
IF %ERRORLEVEL%==18 set DRIVE=T
IF %ERRORLEVEL%==19 set DRIVE=U
IF %ERRORLEVEL%==20 set DRIVE=V
IF %ERRORLEVEL%==21 set DRIVE=W
IF %ERRORLEVEL%==22 set DRIVE=X
IF %ERRORLEVEL%==23 set DRIVE=Y
IF %ERRORLEVEL%==24 set DRIVE=Z

:1
IF EXIST "%DRIVE%:\Program Files\Autodesk\3ds Max 2008" GOTO MAX2008_64
:2
IF EXIST "%DRIVE%:\Program Files\Autodesk\3ds Max 2009" GOTO MAX2009_64
:3
IF EXIST "%DRIVE%:\Program Files\Autodesk\3ds Max 2010" GOTO MAX2010_64
:4
IF EXIST "%DRIVE%:\Program Files\Autodesk\3ds Max 2011" GOTO MAX2011_64
:5
IF EXIST "%DRIVE%:\Program Files\Autodesk\3ds Max 2012" GOTO MAX2012_64

:6
IF EXIST "%DRIVE%:\Program Files (x86)\Autodesk\3ds Max 2008" GOTO MAX2008_32
:7
IF EXIST "%DRIVE%:\Program Files (x86)\Autodesk\3ds Max 2009" GOTO MAX2009_32
:8
IF EXIST "%DRIVE%:\Program Files (x86)\Autodesk\3ds Max 2010" GOTO MAX2010_32
:9
IF EXIST "%DRIVE%:\Program Files (x86)\Autodesk\3ds Max 2011" GOTO MAX2011_32
:10
IF EXIST "%DRIVE%:\Program Files (x86)\Autodesk\3ds Max 2012" GOTO MAX2012_32
GOTO:EOF

: MAX2008_64
@ECHO ON
xcopy /Y/R LoadCryMaxTools.ms "%DRIVE%:\Program Files\Autodesk\3ds Max 2008\scripts\startup"
xcopy /Y/R ..\CryExport10_64.dlu "%DRIVE%:\Program Files\Autodesk\3ds Max 2008\plugins"
IF EXIST "%DRIVE%:\Program Files\Autodesk\3ds Max 2008\scripts\startup\LoadCryTools.ms" del "%DRIVE%:\Program Files\Autodesk\3ds Max 2008\scripts\startup\LoadCryTools.ms"
GOTO 2

: MAX2009_64
@ECHO ON
xcopy /Y/R LoadCryMaxTools.ms "%DRIVE%:\Program Files\Autodesk\3ds Max 2009\scripts\startup"
xcopy /Y/R ..\CryExport11_64.dlu "%DRIVE%:\Program Files\Autodesk\3ds Max 2009\plugins"
IF EXIST "%DRIVE%:\Program Files\Autodesk\3ds Max 2009\scripts\startup\LoadCryTools.ms" del "%DRIVE%:\Program Files\Autodesk\3ds Max 2009\scripts\startup\LoadCryTools.ms"
GOTO 3

: MAX2010_64
@ECHO ON
xcopy /Y/R LoadCryMaxTools.ms "%DRIVE%:\Program Files\Autodesk\3ds Max 2010\scripts\startup"
xcopy /Y/R ..\CryExport12_64.dlu "%DRIVE%:\Program Files\Autodesk\3ds Max 2010\plugins"
IF EXIST "%DRIVE%:\Program Files\Autodesk\3ds Max 2010\scripts\startup\LoadCryTools.ms" del "%DRIVE%:\Program Files\Autodesk\3ds Max 2010\scripts\startup\LoadCryTools.ms"
GOTO 4

: MAX2011_64
@ECHO ON
xcopy /Y/R LoadCryMaxTools.ms "%DRIVE%:\Program Files\Autodesk\3ds Max 2011\scripts\startup"
xcopy /Y/R ..\CryExport13_64.dlu "%DRIVE%:\Program Files\Autodesk\3ds Max 2011\plugins"
IF EXIST "%DRIVE%:\Program Files\Autodesk\3ds Max 2011\scripts\startup\LoadCryTools.ms" del "%DRIVE%:\Program Files\Autodesk\3ds Max 2011\scripts\startup\LoadCryTools.ms"
GOTO 5

: MAX2012_64
@ECHO ON
xcopy /Y/R LoadCryMaxTools.ms "%DRIVE%:\Program Files\Autodesk\3ds Max 2012\scripts\startup"
xcopy /Y/R ..\CryExport14_64.dlu "%DRIVE%:\Program Files\Autodesk\3ds Max 2012\plugins"
IF EXIST "%DRIVE%:\Program Files\Autodesk\3ds Max 2012\scripts\startup\LoadCryTools.ms" del "%DRIVE%:\Program Files\Autodesk\3ds Max 2012\scripts\startup\LoadCryTools.ms"
GOTO 6

: MAX2008_32
@ECHO ON
xcopy /Y/R LoadCryMaxTools.ms "%DRIVE%:\Program Files (x86)\Autodesk\3ds Max 2008\scripts\startup"
xcopy /Y/R ..\CryExport10.dlu "%DRIVE%:\Program Files (x86)\Autodesk\3ds Max 2008\plugins"
IF EXIST "%DRIVE%:\Program Files (x86)\Autodesk\3ds Max 2008\scripts\startup\LoadCryTools.ms" del "%DRIVE%:\Program Files (x86)\Autodesk\3ds Max 2008\scripts\startup\LoadCryTools.ms"
GOTO 7

: MAX2009_32
@ECHO ON
xcopy /Y/R LoadCryMaxTools.ms "%DRIVE%:\Program Files (x86)\Autodesk\3ds Max 2009\scripts\startup"
xcopy /Y/R ..\CryExport11.dlu "%DRIVE%:\Program Files (x86)\Autodesk\3ds Max 2009\plugins"
IF EXIST "%DRIVE%:\Program Files (x86)\Autodesk\3ds Max 2009\scripts\startup\LoadCryTools.ms" del "%DRIVE%:\Program Files (x86)\Autodesk\3ds Max 2009\scripts\startup\LoadCryTools.ms"
GOTO 8

: MAX2010_32
@ECHO ON
xcopy /Y/R LoadCryMaxTools.ms "%DRIVE%:\Program Files (x86)\Autodesk\3ds Max 2010\scripts\startup"
xcopy /Y/R ..\CryExport12.dlu "%DRIVE%:\Program Files (x86)\Autodesk\3ds Max 2010\plugins"
IF EXIST "%DRIVE%:\Program Files (x86)\Autodesk\3ds Max 2010\scripts\startup\LoadCryTools.ms" del "%DRIVE%:\Program Files (x86)\Autodesk\3ds Max 2010\scripts\startup\LoadCryTools.ms"
GOTO 9

: MAX2011_32
@ECHO ON
xcopy /Y/R LoadCryMaxTools.ms "%DRIVE%:\Program Files (x86)\Autodesk\3ds Max 2011\scripts\startup"
xcopy /Y/R ..\CryExport13.dlu "%DRIVE%:\Program Files (x86)\Autodesk\3ds Max 2011\plugins"
IF EXIST "%DRIVE%:\Program Files (x86)\Autodesk\3ds Max 2011\scripts\startup\LoadCryTools.ms" del "%DRIVE%:\Program Files (x86)\Autodesk\3ds Max 2011\scripts\startup\LoadCryTools.ms"
GOTO 10

: MAX2012_32
@ECHO ON
xcopy /Y/R LoadCryMaxTools.ms "%DRIVE%:\Program Files (x86)\Autodesk\3ds Max 2012\scripts\startup"
xcopy /Y/R ..\CryExport14.dlu "%DRIVE%:\Program Files (x86)\Autodesk\3ds Max 2012\plugins"
IF EXIST "%DRIVE%:\Program Files (x86)\Autodesk\3ds Max 2012\scripts\startup\LoadCryTools.ms" del "%DRIVE%:\Program Files (x86)\Autodesk\3ds Max 2012\scripts\startup\LoadCryTools.ms"
GOTO:EOF