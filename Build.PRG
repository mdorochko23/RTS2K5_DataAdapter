LPARAMETERS tbRecompile AS Boolean
LOCAL lsDOS AS String, lsDLLFile AS String, lsProject AS String

lsDLLFile = FullPath(".\RTS.DATA.DLL")
lsProject = FullPath(".\Project\Data.pjx" )


*-- Unregister the dll
lsDOS = [RUN Regsvr32 /U "] + lsDLLFile + ["]
&lsDOS.


*-- Rebuild it
IF tbRecompile Then
	BUILD MTDLL (lsDLLFile) FROM (lsProject) RECOMPILE
ELSE
	BUILD MTDLL (lsDLLFile) FROM (lsProject) 
ENDIF

*-- ReRegister it
lsDOS = [RUN Regsvr32 "] + FullPath(".\RTS.DATA.DLL") + ["]
&lsDOS.

DECLARE INTEGER GetPrivateProfileString IN Win32API AS GetPrivStr ;
                    String cSec, ;
                    String cKey, ;
                    String cDef, ;
                    String @cBuf, ;
                    Integer nBufSize, ;
                    String cINIFile
lc_copyRTS = SPACE(500)
ln_len=GetPrivStr("Data","copyRTS","\",@lc_copyRTS,500,SYS(5)+CURDIR()+"rts.ini")
lc_copyRTS= LEFT(lc_copyRTS,ln_Len)
    
=AGETFILEVERSION(la_version, ".\RTS.DATA.DLL")
lc_copyRTS=ALLTRIM(lc_copyRTS)+"copyrts.dbf"
USE &lc_copyRTS ALIAS copyrts SHARED
IF ALLTRIM(dllversion)!=ALLTRIM(la_version[1,4])
   replace dllversion WITH ALLTRIM(la_version[1,4])
   replace dllblddate WITH DATE()
ENDIF
USE    