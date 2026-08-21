; ============================================================
;  EGIS Layout Manager — Inno Setup Installer Script v1.0
;  No admin rights required — everything goes to %APPDATA%
;  [Code] is LAST section (Pascal compiler requirement)
; ============================================================

#define AppName      "EGIS Layout Manager"
#define AppVersion   "1.0.0"
#define AppPublisher "EGIS Colombia"
#define AppURL       "https://www.egis.com"
#define BundleName   "EGISLayoutManager.bundle"
#define DllName      "EGISLayoutManager.dll"
#define RegAppKey    "EGISLayoutManager"
#define SourceBase   "D:\2_ALEJO\APP_BIM\CIVIL 3D\EGISLayoutManager\Installer"

; ==============================================================================
[Setup]
; ==============================================================================
AppId                    = {{A1B2C3D4-E5F6-7890-ABCD-EF1234567891}
AppName                  = {#AppName}
AppVersion               = {#AppVersion}
AppPublisher             = {#AppPublisher}
AppPublisherURL          = {#AppURL}
AppSupportURL            = {#AppURL}
AppUpdatesURL            = {#AppURL}

; ── No admin required ─────────────────────────────────────────────────────────
PrivilegesRequired                 = lowest
PrivilegesRequiredOverridesAllowed = dialog

; ── Install dir: point to the actual bundle destination (user-writable)
;    CreateAppDir=no means no extra folder is created, but DefaultDirName
;    must still be a user-writable path so uninstall info doesn't touch
;    Program Files (which causes "Access denied – code 5")
; ─────────────────────────────────────────────────────────────────────────────
DefaultDirName           = {userappdata}\Autodesk\ApplicationPlugins\{#BundleName}
CreateAppDir             = no
UsePreviousAppDir        = no

; ── Output ────────────────────────────────────────────────────────────────────
OutputDir                = {#SourceBase}
OutputBaseFilename       = EGISLayoutManager_Setup_v{#AppVersion}
Compression              = lzma2/ultra64
SolidCompression         = yes

; ── Appearance ────────────────────────────────────────────────────────────────
WizardStyle              = modern
DisableWelcomePage       = no
DisableDirPage           = yes
DisableProgramGroupPage  = yes
ShowLanguageDialog       = no

; ── Uninstall ─────────────────────────────────────────────────────────────────
UninstallDisplayName     = {#AppName}
Uninstallable            = yes
CreateUninstallRegKey    = yes

; ── Version info ──────────────────────────────────────────────────────────────
VersionInfoVersion       = {#AppVersion}
VersionInfoCompany       = {#AppPublisher}
VersionInfoDescription   = {#AppName} Installer

; ==============================================================================
[Languages]
; ==============================================================================
Name: "english"; MessagesFile: "compiler:Default.isl"

; ==============================================================================
[Messages]
; ==============================================================================
WelcomeLabel1=Welcome to the [bold]{#AppName}[/bold] Setup Wizard
WelcomeLabel2=This will install [bold]{#AppName} v{#AppVersion}[/bold] on your computer.%n%nPlugin for AutoCAD / Civil 3D 2026.%n%nClick Next to continue.
FinishedHeadingLabel=Installation Complete
FinishedLabel={#AppName} has been installed successfully.%n%nRestart AutoCAD or Civil 3D to activate the plugin.%n%nThe [bold]EGIS Layout Manager[/bold] button will appear in the [bold]EGIS Smart Tools[/bold] ribbon tab under [bold]Layouts %& Sheet[/bold].
ClickFinish=Click [bold]Finish[/bold] to exit Setup.

; ==============================================================================
[Files]
; ==============================================================================

; PackageContents.xml — bundle root
Source: "{#SourceBase}\{#BundleName}\PackageContents.xml"; \
        DestDir: "{userappdata}\Autodesk\ApplicationPlugins\{#BundleName}"; \
        Flags: ignoreversion

; DLL
Source: "{#SourceBase}\{#BundleName}\Contents\{#DllName}"; \
        DestDir: "{userappdata}\Autodesk\ApplicationPlugins\{#BundleName}\Contents"; \
        Flags: ignoreversion

; deps.json
Source: "{#SourceBase}\{#BundleName}\Contents\EGISLayoutManager.deps.json"; \
        DestDir: "{userappdata}\Autodesk\ApplicationPlugins\{#BundleName}\Contents"; \
        Flags: ignoreversion

; pdb (debug symbols — optional)
Source: "{#SourceBase}\{#BundleName}\Contents\EGISLayoutManager.pdb"; \
        DestDir: "{userappdata}\Autodesk\ApplicationPlugins\{#BundleName}\Contents"; \
        Flags: ignoreversion skipifsourcedoesntexist

; Resources folder (icons, etc.)
Source: "{#SourceBase}\{#BundleName}\Contents\Resources\*"; \
        DestDir: "{userappdata}\Autodesk\ApplicationPlugins\{#BundleName}\Contents\Resources"; \
        Flags: ignoreversion recursesubdirs createallsubdirs skipifsourcedoesntexist

; ==============================================================================
[Registry]
; Static entries for the two most common Civil 3D 2026 profile keys.
; [Code] section also writes these dynamically for ALL detected profiles.
; ==============================================================================

; ACAD-9001:409
Root: HKCU; Subkey: "Software\Autodesk\AutoCAD\R25.1\ACAD-9001:409\Applications\{#RegAppKey}"; \
     ValueType: string; ValueName: "DESCRIPTION"; ValueData: "{#AppName}"; \
     Flags: uninsdeletekey createvalueifdoesntexist
Root: HKCU; Subkey: "Software\Autodesk\AutoCAD\R25.1\ACAD-9001:409\Applications\{#RegAppKey}"; \
     ValueType: dword;  ValueName: "LOADCTRLS";   ValueData: "14"; \
     Flags: createvalueifdoesntexist
Root: HKCU; Subkey: "Software\Autodesk\AutoCAD\R25.1\ACAD-9001:409\Applications\{#RegAppKey}"; \
     ValueType: string; ValueName: "LOADER"; \
     ValueData: "{userappdata}\Autodesk\ApplicationPlugins\{#BundleName}\Contents\{#DllName}"; \
     Flags: createvalueifdoesntexist
Root: HKCU; Subkey: "Software\Autodesk\AutoCAD\R25.1\ACAD-9001:409\Applications\{#RegAppKey}"; \
     ValueType: dword;  ValueName: "MANAGED";     ValueData: "1"; \
     Flags: createvalueifdoesntexist

; ACAD-9100:409
Root: HKCU; Subkey: "Software\Autodesk\AutoCAD\R25.1\ACAD-9100:409\Applications\{#RegAppKey}"; \
     ValueType: string; ValueName: "DESCRIPTION"; ValueData: "{#AppName}"; \
     Flags: uninsdeletekey createvalueifdoesntexist
Root: HKCU; Subkey: "Software\Autodesk\AutoCAD\R25.1\ACAD-9100:409\Applications\{#RegAppKey}"; \
     ValueType: dword;  ValueName: "LOADCTRLS";   ValueData: "14"; \
     Flags: createvalueifdoesntexist
Root: HKCU; Subkey: "Software\Autodesk\AutoCAD\R25.1\ACAD-9100:409\Applications\{#RegAppKey}"; \
     ValueType: string; ValueName: "LOADER"; \
     ValueData: "{userappdata}\Autodesk\ApplicationPlugins\{#BundleName}\Contents\{#DllName}"; \
     Flags: createvalueifdoesntexist
Root: HKCU; Subkey: "Software\Autodesk\AutoCAD\R25.1\ACAD-9100:409\Applications\{#RegAppKey}"; \
     ValueType: dword;  ValueName: "MANAGED";     ValueData: "1"; \
     Flags: createvalueifdoesntexist

; ==============================================================================
; [Code] — MUST BE THE LAST SECTION
; Dynamically enumerates all AutoCAD profiles installed on this machine
; and writes/removes the plugin registry entries (mirrors Install-Registry.ps1)
; ==============================================================================
[Code]

const
  ACAD_BASE    = 'Software\Autodesk\AutoCAD';
  APP_KEY      = 'EGISLayoutManager';
  BUNDLE_PATH  = '\Autodesk\ApplicationPlugins\EGISLayoutManager.bundle\Contents\EGISLayoutManager.dll';

function DllPath: String;
begin
  Result := ExpandConstant('{userappdata}') + BUNDLE_PATH;
end;

procedure WriteReg(const ProfileKey: String);
var
  AppKey: String;
begin
  AppKey := ProfileKey + '\Applications\' + APP_KEY;
  RegWriteStringValue(HKCU, AppKey, 'DESCRIPTION', 'EGIS Layout Manager');
  RegWriteDWordValue (HKCU, AppKey, 'LOADCTRLS',   14);
  RegWriteStringValue(HKCU, AppKey, 'LOADER',      DllPath);
  RegWriteDWordValue (HKCU, AppKey, 'MANAGED',     1);
end;

procedure RemoveReg(const ProfileKey: String);
begin
  RegDeleteKeyIncludingSubkeys(HKCU,
    ProfileKey + '\Applications\' + APP_KEY);
end;

procedure ProcessAllProfiles(DoWrite: Boolean);
var
  Versions : TArrayOfString;
  Profiles : TArrayOfString;
  VerKey   : String;
  ProfKey  : String;
  v, p     : Integer;
begin
  if not RegGetSubkeyNames(HKCU, ACAD_BASE, Versions) then
    Exit;

  for v := 0 to GetArrayLength(Versions) - 1 do
  begin
    VerKey := ACAD_BASE + '\' + Versions[v];
    if RegGetSubkeyNames(HKCU, VerKey, Profiles) then
    begin
      for p := 0 to GetArrayLength(Profiles) - 1 do
      begin
        if Pos('ACAD', UpperCase(Profiles[p])) > 0 then
        begin
          ProfKey := VerKey + '\' + Profiles[p];
          if DoWrite then
            WriteReg(ProfKey)
          else
            RemoveReg(ProfKey);
        end;
      end;
    end;
  end;
end;

procedure CurStepChanged(CurStep: TSetupStep);
begin
  if CurStep = ssPostInstall then
    ProcessAllProfiles(True);
end;

procedure CurUninstallStepChanged(CurUninstallStep: TUninstallStep);
begin
  if CurUninstallStep = usPostUninstall then
  begin
    ProcessAllProfiles(False);
    DelTree(
      ExpandConstant('{userappdata}') +
      '\Autodesk\ApplicationPlugins\EGISLayoutManager.bundle',
      True, True, True);
  end;
end;
