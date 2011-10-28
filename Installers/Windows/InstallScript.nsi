# Initially auto-generated by EclipseNSIS Script Wizard
# Mar 9, 2011 7:11:12 PM

Name Enchanting

# General Symbol Definitions
!define REGKEY "SOFTWARE\$(^Name)"
!define VERSION 0.0.8.0
VIProductVersion 0.0.8.0
!define COMPANY ""
!define URL http://enchanting.robotclub.ab.ca/

!addincludedir Include
!include "OpenLinkInNewWindow.nsh"

# MultiUser Symbol Definitions
!define MULTIUSER_EXECUTIONLEVEL Admin
!define MULTIUSER_MUI
!define MULTIUSER_INSTALLMODE_DEFAULT_REGISTRY_KEY "${REGKEY}"
!define MULTIUSER_INSTALLMODE_DEFAULT_REGISTRY_VALUENAME MultiUserInstallMode
!define MULTIUSER_INSTALLMODE_COMMANDLINE
!define MULTIUSER_INSTALLMODE_INSTDIR Enchanting
!define MULTIUSER_INSTALLMODE_INSTDIR_REGISTRY_KEY "${REGKEY}"
!define MULTIUSER_INSTALLMODE_INSTDIR_REGISTRY_VALUE "Path"

# MUI Symbol Definitions
!define MUI_ICON "${NSISDIR}\Contrib\Graphics\Icons\modern-install-colorful.ico"
!define MUI_FINISHPAGE_NOAUTOCLOSE
!define MUI_STARTMENUPAGE_REGISTRY_ROOT HKLM
!define MUI_STARTMENUPAGE_NODISABLE
!define MUI_STARTMENUPAGE_REGISTRY_KEY ${REGKEY}
!define MUI_STARTMENUPAGE_REGISTRY_VALUENAME StartMenuGroup
!define MUI_STARTMENUPAGE_DEFAULTFOLDER Enchanting
!define MUI_FINISHPAGE_SHOWREADME $INSTDIR\ReadMe.txt
!define MUI_UNICON "${NSISDIR}\Contrib\Graphics\Icons\modern-uninstall-colorful.ico"
!define MUI_UNFINISHPAGE_NOAUTOCLOSE
!define MUI_LANGDLL_REGISTRY_ROOT HKLM
!define MUI_LANGDLL_REGISTRY_KEY ${REGKEY}
!define MUI_LANGDLL_REGISTRY_VALUENAME InstallerLanguage

# Included files
!include MultiUser.nsh
!include Sections.nsh
!include MUI2.nsh

# Reserved Files
!insertmacro MUI_RESERVEFILE_LANGDLL

# Variables
Var StartMenuGroup

# Installer pages
!insertmacro MUI_PAGE_WELCOME
!insertmacro MUI_PAGE_COMPONENTS
!insertmacro MULTIUSER_PAGE_INSTALLMODE
!insertmacro MUI_PAGE_DIRECTORY
!insertmacro MUI_PAGE_STARTMENU Application $StartMenuGroup
!insertmacro MUI_PAGE_INSTFILES
!insertmacro MUI_PAGE_FINISH
!insertmacro MUI_UNPAGE_CONFIRM
!insertmacro MUI_UNPAGE_INSTFILES

# Languages used by installer
!include "Languages.nsh"

# Installer attributes
OutFile Enchanting-${VERSION}-Setup.exe
InstallDir Enchanting
CRCCheck on
XPStyle on
ShowInstDetails hide
VIAddVersionKey /LANG=${LANG_ENGLISH} ProductName Enchanting
VIAddVersionKey /LANG=${LANG_ENGLISH} ProductVersion "${VERSION}"
VIAddVersionKey /LANG=${LANG_ENGLISH} CompanyName "${COMPANY}"
VIAddVersionKey /LANG=${LANG_ENGLISH} CompanyWebsite "${URL}"
VIAddVersionKey /LANG=${LANG_ENGLISH} FileVersion "${VERSION}"
VIAddVersionKey /LANG=${LANG_ENGLISH} FileDescription ""
VIAddVersionKey /LANG=${LANG_ENGLISH} LegalCopyright ""
InstallDirRegKey HKLM "${REGKEY}" Path
ShowUninstDetails hide


#Funnctions for Prerequites

Var NXT_DRIVER_PRESENT
Var URL
Var MISSING_MSG
        	
Function HasNXTDriver
	Push $0
	#ReadRegStr $0 HKLM SOFTWARE\VXIPNP_Alliance\VXIPNP\CurrentVersion "VXIPNPPATH"	; key is not removed by the NXT driver uninstaller
	ReadRegStr $0 HKLM SOFTWARE\VXIPNP_Alliance\VXIPNP\CurrentVersion "FRAMEWORK_PATH"
	StrCmp "" "$0" DriverNotPresent DriverPresent
	
	DriverNotPresent:
		StrCpy $NXT_DRIVER_PRESENT "0"
		Goto Done
	DriverPresent:
		StrCpy $NXT_DRIVER_PRESENT "1"
		Goto Done
	Done:
		Pop $0
FunctionEnd


Function CheckForPreRequisites
	Call HasNXTDriver
	# StrCpy $PREREQS_PRESENT "00"	# for testing purposes
	StrCmp "$NXT_DRIVER_PRESENT" "0" MissingNXTDriver
	Goto MissingNothing
		
	MissingNXTDriver:
		DetailPrint "Fantom driver for the NXT is missing."
		StrCpy $URL "http://enchanting.robotclub.ab.ca/Install+NXT+Driver+On+Windows"
		StrCpy $MISSING_MSG "You need to install LEGO's Fantom driver to communicate with the NXT before continuing.  Would you like instructions on how to install it?"
		goto AlertAndOfferAssistance
	
	MissingNothing:
		DetailPrint "Found Fantom driver for the NXT"
		goto Done

	AlertAndOfferAssistance:
		MessageBox MB_YESNO $MISSING_MSG IDYES ShowHelp IDNO QuitInstaller
	
	ShowHelp:
		${OpenURL} $URL
		
	QuitInstaller:
		Abort 
		
	Done:
FunctionEnd

# Installer sections

Section Enchanting SEC0002
    SectionIn RO
    SetOutPath $INSTDIR
    SetOverwrite on
    
    # Build should fail is Harmony JDK is not included
    # (It isn't in the source tree. See ThirdParty/Install Harmony.txt for details.)
    File ..\..\ThirdParty\harmony_jdk6\NOTICE
    
    # Now, get the rest of the files needed for Enchanting
    File /r /x *.bzr* /x Installers /x BaseEnchanting.* /x *.app /x Artwork /x *macosx* /x *linux* /x Plugins /x enchanting_squeak_vm /x ScratchSkin /x *.sh /x Enchanting.changes /x SqueakV2.sources /x Classes /x Documentation /x Tools /x Media /x Projects /x *.*~* /x omit-from-release /x javaw.exe ..\..\*
    WriteRegStr HKLM "${REGKEY}\Components" Main 1
SectionEnd

SectionGroup /e Optional SECGRP0001
    Section "Startmenu Shortcut" SEC0003
        SetOutPath "$INSTDIR"
		CreateDirectory "$SMPROGRAMS\$StartMenuGroup"
        CreateShortcut "$SMPROGRAMS\$StartMenuGroup\Enchanting.lnk" "$INSTDIR\Enchanting.exe"
        WriteRegStr HKLM "${REGKEY}\Components" "Startmenu Shortcut" 1
    SectionEnd

    Section "Desktop Shortcut" SEC0004
        SetOutPath "$INSTDIR"
        CreateShortcut "$DESKTOP\Enchanting.lnk" "$INSTDIR\Enchanting.exe"
        WriteRegStr HKLM "${REGKEY}\Components" "Desktop Shortcut" 1
    SectionEnd
SectionGroupEnd

Section Uninstaller SEC0005
    SectionIn RO
    WriteRegStr HKLM "${REGKEY}" Path $INSTDIR
    SetOutPath $INSTDIR
    WriteUninstaller $INSTDIR\uninstall.exe
    !insertmacro MUI_STARTMENU_WRITE_BEGIN Application
    SetOutPath $SMPROGRAMS\$StartMenuGroup
    CreateShortcut "$SMPROGRAMS\$StartMenuGroup\$(^UninstallLink).lnk" $INSTDIR\uninstall.exe
    !insertmacro MUI_STARTMENU_WRITE_END
    WriteRegStr HKLM "SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\$(^Name)" DisplayName "$(^Name)"
    WriteRegStr HKLM "SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\$(^Name)" DisplayVersion "${VERSION}"
    WriteRegStr HKLM "SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\$(^Name)" Publisher "${COMPANY}"
    WriteRegStr HKLM "SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\$(^Name)" URLInfoAbout "${URL}"
    WriteRegStr HKLM "SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\$(^Name)" DisplayIcon $INSTDIR\uninstall.exe
    WriteRegStr HKLM "SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\$(^Name)" UninstallString $INSTDIR\uninstall.exe
    WriteRegDWORD HKLM "SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\$(^Name)" NoModify 1
    WriteRegDWORD HKLM "SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\$(^Name)" NoRepair 1
SectionEnd

# Macro for selecting uninstaller sections
!macro SELECT_UNSECTION SECTION_NAME UNSECTION_ID
    Push $R0
    ReadRegStr $R0 HKLM "${REGKEY}\Components" "${SECTION_NAME}"
    StrCmp $R0 1 0 next${UNSECTION_ID}
    !insertmacro SelectSection "${UNSECTION_ID}"
    GoTo done${UNSECTION_ID}
next${UNSECTION_ID}:
    !insertmacro UnselectSection "${UNSECTION_ID}"
done${UNSECTION_ID}:
    Pop $R0
!macroend

# Uninstaller sections
Section /o "-un.Desktop Shortcut" UNSEC0004
    Delete /REBOOTOK $DESKTOP\Enchanting.lnk
    DeleteRegValue HKLM "${REGKEY}\Components" "Desktop Shortcut"
SectionEnd

Section /o "-un.Startmenu Shortcut" UNSEC0003
    Delete /REBOOTOK $SMPROGRAMS\$StartMenuGroup\Enchanting.lnk
    DeleteRegValue HKLM "${REGKEY}\Components" "Startmenu Shortcut"
SectionEnd

Section /o -un.Main UNSEC0002
    RmDir /r /REBOOTOK $INSTDIR
    DeleteRegValue HKLM "${REGKEY}\Components" Main
SectionEnd

Section /o -un.JDK UNSEC0001
    Delete /REBOOTOK $INSTDIR\LegoMindstormsNXTdriver32.msi
    DeleteRegValue HKLM "${REGKEY}\Components" JDK
SectionEnd

Section /o "-un.NXT Driver" UNSEC0000
    Delete /REBOOTOK $INSTDIR\LegoMindstormsNXTdriver32.msi
    DeleteRegValue HKLM "${REGKEY}\Components" "NXT Driver"
SectionEnd

Section -un.post UNSEC0005
    DeleteRegKey HKLM "SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\$(^Name)"
    Delete /REBOOTOK "$SMPROGRAMS\$StartMenuGroup\$(^UninstallLink).lnk"
    Delete /REBOOTOK $INSTDIR\uninstall.exe
    DeleteRegValue HKLM "${REGKEY}" StartMenuGroup
    DeleteRegValue HKLM "${REGKEY}" Path
    DeleteRegKey /IfEmpty HKLM "${REGKEY}\Components"
    DeleteRegKey /IfEmpty HKLM "${REGKEY}"
    RmDir /REBOOTOK $SMPROGRAMS\$StartMenuGroup
    RmDir /REBOOTOK $INSTDIR
SectionEnd

# Installer functions
Function .onInit
    InitPluginsDir
    !insertmacro MUI_LANGDLL_DISPLAY
    !insertmacro MULTIUSER_INIT
    LogSet On
    Call CheckForPreRequisites
FunctionEnd

# Uninstaller functions
Function un.onInit
    !insertmacro MUI_STARTMENU_GETFOLDER Application $StartMenuGroup
    !insertmacro MUI_UNGETLANGUAGE
    !insertmacro MULTIUSER_UNINIT
    !insertmacro SELECT_UNSECTION "NXT Driver" ${UNSEC0000}
    !insertmacro SELECT_UNSECTION JDK ${UNSEC0001}
    !insertmacro SELECT_UNSECTION Main ${UNSEC0002}
    !insertmacro SELECT_UNSECTION "Startmenu Shortcut" ${UNSEC0003}
    !insertmacro SELECT_UNSECTION "Desktop Shortcut" ${UNSEC0004}
FunctionEnd

# Section Descriptions
!insertmacro MUI_FUNCTION_DESCRIPTION_BEGIN
!insertmacro MUI_DESCRIPTION_TEXT ${SECGRP0000} $(SECGRP0000_DESC)
!insertmacro MUI_DESCRIPTION_TEXT ${SEC0000} $(SEC0000_DESC)
!insertmacro MUI_DESCRIPTION_TEXT ${SEC0001} $(SEC0001_DESC)
!insertmacro MUI_FUNCTION_DESCRIPTION_END

!include "Translations.nsh"

