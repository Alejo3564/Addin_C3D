; ============================================================
;  EGIS Smart Tools - PDF Sheet Exporter
;  Inno Setup Script v1.0
;
;  Place this .iss file inside the Installer\ folder:
;
;  Installer\
;  ├── EGISPdfExporter_Setup.iss   <- this file
;  └── EGISPdfExporter.bundle\
;      ├── PackageContents.xml
;      └── Contents\
;          └── Win64\
;              ├── EGISPdfExporter.dll
;              └── Resources\
;                  ├── icon_32.png
;                  └── icon_16.png
;
;  No administrator rights required.
;  No registry entries needed (bundle auto-loaded by Civil 3D).
; ============================================================

#define AppName      "EGIS PDF Sheet Exporter"
#define AppVersion   "1.0.0"
#define AppPublisher "EGIS Colombia"
#define AppURL       "https://www.egis.com.co"
#define BundleName   "EGISPdfExporter.bundle"

[Setup]
AppId={{B3F1A2C4-E7D5-4F90-BC12-9A8E3D56F701}
AppName={#AppName}
AppVersion={#AppVersion}
AppPublisher={#AppPublisher}
AppPublisherURL={#AppURL}
AppSupportURL={#AppURL}
AppUpdatesURL={#AppURL}
PrivilegesRequired=lowest
DefaultDirName={userappdata}\Autodesk\ApplicationPlugins\{#BundleName}
DisableDirPage=yes
OutputDir=Output
OutputBaseFilename=EGIS_PdfSheetExporter_v{#AppVersion}_Setup
SetupIconFile=
Compression=lzma2/ultra64
SolidCompression=yes
WizardStyle=modern
WizardResizable=no
DisableReadyPage=no
ShowLanguageDialog=no
LanguageDetectionMethod=none

[Languages]
Name: "english"; MessagesFile: "compiler:Default.isl"

[Messages]
WelcomeLabel1=Welcome to the {#AppName} Setup Wizard
WelcomeLabel2=This wizard will install {#AppName} v{#AppVersion} for Civil 3D 2026.%n%nThis installation does not require administrator rights.%n%nClick Next to continue, or Cancel to exit.
FinishedHeadingLabel=Setup Complete
FinishedLabel={#AppName} has been successfully installed.%n%nStart Civil 3D 2026. The plugin will load automatically.%n%nLook for the ribbon tab:%n[EGIS Smart Tools]  ->  [Sheets && Print]  ->  [PDF Export]
ClickFinish=Click Finish to close this wizard.

[Files]
; Copy the entire bundle folder recursively in one line
Source: "{#BundleName}\*"; \
    DestDir: "{app}"; \
    Flags: ignoreversion recursesubdirs createallsubdirs

[UninstallDelete]
Type: filesandordirs; Name: "{app}"

[Code]
function InitializeSetup(): Boolean;
begin
  Result := True;
  if CheckForMutexes('Acad_mutex') then
  begin
    MsgBox(
      'Civil 3D / AutoCAD is currently running.' + #13#10 +
      'Please close it before continuing the installation.',
      mbError, MB_OK);
    Result := False;
  end;
end;

function InitializeUninstall(): Boolean;
begin
  Result := True;
  if CheckForMutexes('Acad_mutex') then
  begin
    MsgBox(
      'Civil 3D / AutoCAD is currently running.' + #13#10 +
      'Please close it before uninstalling the plugin.',
      mbError, MB_OK);
    Result := False;
  end;
end;
