; ============================================================
;  EGIS Parameter Sync for Civil 3D
;  Inno Setup Script v1.0.0  —  EGIS Colombia 2026
;
;  Place this .iss file in:
;    D:\2_ALEJO\APP_BIM\CIVIL 3D\EGISParameterSync\2026\Installer\
;  Bundle folder must be alongside this file:
;    .\EGISParameterSync_Plugin.bundle\
; ============================================================

#define AppName      "EGIS Parameter Sync for Civil 3D"
#define AppVersion   "1.0.0"
#define AppPublisher "EGIS Colombia"
#define AppURL       "https://www.egis.com.co"
#define BundleSrc    "EGISParameterSync_Plugin.bundle"
#define BundleDst    "EGISParameterSync_Civil3D.bundle"
#define DLLName      "EGISParameterSync_Civil3D.dll"

; ============================================================
[Setup]
AppId={{B3C4D5E6-F7A8-9012-BCDE-F12345678901}
AppName={#AppName}
AppVersion={#AppVersion}
AppVerName={#AppName} {#AppVersion}
AppPublisher={#AppPublisher}
AppPublisherURL={#AppURL}
AppSupportURL={#AppURL}
AppUpdatesURL={#AppURL}

DefaultDirName={userappdata}\Autodesk\ApplicationPlugins\{#BundleDst}
DisableDirPage=yes
DisableProgramGroupPage=yes

PrivilegesRequired=lowest
PrivilegesRequiredOverridesAllowed=commandline

OutputDir=Output
OutputBaseFilename=EGIS_ParameterSync_Civil3D_v{#AppVersion}_Setup
SetupMutex=EGISParameterSyncCivil3DSetupMutex

Compression=lzma2/ultra64
SolidCompression=yes
WizardStyle=modern
WizardSizePercent=110
DisableWelcomePage=no

UninstallDisplayName={#AppName}
CreateUninstallRegKey=yes

VersionInfoVersion=1.0.0.0
VersionInfoCompany={#AppPublisher}
VersionInfoDescription={#AppName} Installer
VersionInfoProductName={#AppName}
VersionInfoProductVersion={#AppVersion}

; ============================================================
[Languages]
Name: "english"; MessagesFile: "compiler:Default.isl"

; ============================================================
[Messages]
WelcomeLabel1=Welcome to the {#AppName} Setup Wizard
WelcomeLabel2=This wizard will install {#AppName} version {#AppVersion} on your computer.%n%nSupported versions:%n  - Autodesk Civil 3D 2024%n  - Autodesk Civil 3D 2025%n  - Autodesk Civil 3D 2026%n%nNo administrator rights are required.%n%nClick Next to continue or Cancel to exit.
ReadyLabel1=Setup is ready to install {#AppName} on your computer.
ReadyLabel2a=Click Install to proceed.
FinishedHeadingLabel=Installation Complete
FinishedLabel={#AppName} has been successfully installed.%n%nPlease restart Civil 3D to activate the plugin.%n%nThe [bold]EGIS Smart Tools[/bold] tab will appear automatically in the ribbon.
ClickFinish=Click Finish to exit the installer.

; ============================================================
[Files]
Source: "{#BundleSrc}\PackageContents.xml"; DestDir: "{app}"; Flags: ignoreversion
Source: "{#BundleSrc}\Contents\Win64\*"; DestDir: "{app}\Contents\Win64"; Flags: ignoreversion recursesubdirs createallsubdirs

; ============================================================
[Code]

const
  ACAD_BASE   = 'Software\Autodesk\AutoCAD';
  PLUGIN_KEY  = 'EGISParameterSync';
  PLUGIN_DESC = 'EGIS Parameter Sync Civil 3D';

{ Helper: returns a newline string without using # literals }
function NL: string;
begin
  Result := Chr(13) + Chr(10);
end;

function GetDLLPath: string;
begin
  Result := ExpandConstant(
    '{userappdata}\Autodesk\ApplicationPlugins\{#BundleDst}\Contents\Win64\{#DLLName}');
end;

function RegisterPlugin(DLLPath: string): Integer;
var
  VersionNames, ProductNames: TArrayOfString;
  i, j, Count: Integer;
  VersionKey, ProductKey, AppKey: string;
begin
  Count := 0;
  if not RegGetSubkeyNames(HKCU, ACAD_BASE, VersionNames) then
  begin
    Log('RegisterPlugin: AutoCAD key not found.');
    Result := 0;
    Exit;
  end;
  for i := 0 to GetArrayLength(VersionNames) - 1 do
  begin
    VersionKey := ACAD_BASE + '\' + VersionNames[i];
    if RegGetSubkeyNames(HKCU, VersionKey, ProductNames) then
    begin
      for j := 0 to GetArrayLength(ProductNames) - 1 do
      begin
        if Pos('ACAD-', ProductNames[j]) = 1 then
        begin
          ProductKey := VersionKey + '\' + ProductNames[j];
          AppKey     := ProductKey + '\Applications\' + PLUGIN_KEY;
          RegWriteStringValue(HKCU, AppKey, 'DESCRIPTION', PLUGIN_DESC);
          RegWriteDWordValue (HKCU, AppKey, 'LOADCTRLS',   14);
          RegWriteStringValue(HKCU, AppKey, 'LOADER',      DLLPath);
          RegWriteDWordValue (HKCU, AppKey, 'MANAGED',     1);
          Inc(Count);
          Log('Registered: HKCU\' + AppKey);
        end;
      end;
    end;
  end;
  Result := Count;
end;

procedure UnregisterPlugin;
var
  VersionNames, ProductNames: TArrayOfString;
  i, j: Integer;
  VersionKey, ProductKey, AppKey: string;
begin
  if not RegGetSubkeyNames(HKCU, ACAD_BASE, VersionNames) then Exit;
  for i := 0 to GetArrayLength(VersionNames) - 1 do
  begin
    VersionKey := ACAD_BASE + '\' + VersionNames[i];
    if RegGetSubkeyNames(HKCU, VersionKey, ProductNames) then
    begin
      for j := 0 to GetArrayLength(ProductNames) - 1 do
      begin
        if Pos('ACAD-', ProductNames[j]) = 1 then
        begin
          ProductKey := VersionKey + '\' + ProductNames[j];
          AppKey     := ProductKey + '\Applications\' + PLUGIN_KEY;
          if RegKeyExists(HKCU, AppKey) then
          begin
            RegDeleteKeyIncludingSubkeys(HKCU, AppKey);
            Log('Unregistered: HKCU\' + AppKey);
          end;
        end;
      end;
    end;
  end;
end;

function InitializeSetup: Boolean;
var
  VersionNames: TArrayOfString;
  Msg: string;
begin
  Result := True;
  if not RegGetSubkeyNames(HKCU, ACAD_BASE, VersionNames) then
  begin
    Msg :=
      'Warning: No AutoCAD or Civil 3D installation was detected on this computer.' +
      NL + NL +
      'EGIS Parameter Sync requires Civil 3D 2024, 2025 or 2026.' +
      NL + NL +
      'If Civil 3D is installed but has never been launched,' +
      ' start it once before installing this plugin.' +
      NL + NL +
      'Do you want to continue anyway?';
    if MsgBox(Msg, mbConfirmation, MB_YESNO) = IDNO then
      Result := False;
  end;
end;

procedure CurStepChanged(CurStep: TSetupStep);
var
  DLLPath: string;
  Count: Integer;
  Msg: string;
begin
  if CurStep = ssPostInstall then
  begin
    DLLPath := GetDLLPath;
    Log('Post-install: registering plugin. DLL = ' + DLLPath);
    Count := RegisterPlugin(DLLPath);
    if Count = 0 then
    begin
      Msg :=
        'Plugin files were installed successfully.' +
        NL + NL +
        'However, no AutoCAD/Civil 3D installation was found in the registry.' +
        NL +
        'The plugin could not be auto-registered.' +
        NL + NL +
        'To fix this, launch Civil 3D at least once, then run this installer again.';
      MsgBox(Msg, mbInformation, MB_OK);
    end
    else
      Log(Format('Plugin registered in %d AutoCAD version(s).', [Count]));
  end;
end;

procedure CurUninstallStepChanged(CurUninstallStep: TUninstallStep);
begin
  if CurUninstallStep = usPostUninstall then
  begin
    Log('Post-uninstall: removing plugin registry entries.');
    UnregisterPlugin;
  end;
end;

