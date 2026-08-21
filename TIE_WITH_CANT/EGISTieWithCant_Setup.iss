; ============================================================
;  EGIS Smart Tools — Tie With Cant
;  Inno Setup Script v2.0
;  Civil 3D 2026 Plugin Installer
;
;  - Per-user install: NO administrator rights required
;  - Installs bundle to %APPDATA%\Autodesk\ApplicationPlugins\
;  - Optionally registers in HKCU AutoCAD registry (fallback)
;  - Full uninstaller included
; ============================================================

#define AppName      "EGIS Tie With Cant"
#define AppVersion   "2.0.0"
#define AppPublisher "EGIS Colombia"
#define AppURL       "https://www.egis.com.co"
#define BundleName   "EGISTieWithCant.bundle"
#define BundleSource "D:\2_ALEJO\APP_BIM\CIVIL 3D\TieWithCant_Plugin\2026\Installer\EGISTieWithCant.bundle"
#define DLLRelPath   "Contents\Win64\TieWithCant.dll"
#define RegAppKey    "EGISTieWithCant"

[Setup]
AppId={{B3F2A1C4-7D8E-4F2B-9A3C-1E5D6F8B2C4A}
AppName={#AppName}
AppVersion={#AppVersion}
AppPublisher={#AppPublisher}
AppPublisherURL={#AppURL}
AppSupportURL={#AppURL}
AppUpdatesURL={#AppURL}
AppComments=EGIS Smart Tools plugin for Autodesk Civil 3D 2026

; ── Per-user install — NO admin rights required ──────────────
PrivilegesRequired=lowest
PrivilegesRequiredOverridesAllowed=commandline

; ── Install destination ──────────────────────────────────────
; Civil 3D auto-detects bundles in %APPDATA%\Autodesk\ApplicationPlugins
DefaultDirName={userappdata}\Autodesk\ApplicationPlugins\{#BundleName}
DirExistsWarning=no
DisableDirPage=yes

; ── Start menu ───────────────────────────────────────────────
DefaultGroupName=EGIS Smart Tools
DisableProgramGroupPage=yes

; ── Output ───────────────────────────────────────────────────
OutputDir=D:\2_ALEJO\APP_BIM\CIVIL 3D\TieWithCant_Plugin\2026\Installer\Output
OutputBaseFilename=EGISTieWithCant_v2.0_Setup
SetupIconFile=
Compression=lzma2/ultra64
SolidCompression=yes

; ── UI settings ──────────────────────────────────────────────
WizardStyle=modern
WizardResizable=no
ShowLanguageDialog=no
UsePreviousAppDir=no

; ── Version info ─────────────────────────────────────────────
VersionInfoVersion={#AppVersion}
VersionInfoCompany={#AppPublisher}
VersionInfoDescription={#AppName} Installer
VersionInfoCopyright=Copyright © 2025 EGIS Colombia

; ── Uninstall ────────────────────────────────────────────────
UninstallDisplayName={#AppName}
UninstallDisplayIcon={app}\Contents\Win64\TieWithCant.dll
CreateUninstallRegKey=yes

[Languages]
Name: "english"; MessagesFile: "compiler:Default.isl"

[Types]
Name: "full";   Description: "Full installation (recommended)"
Name: "custom"; Description: "Custom installation";  Flags: iscustom

[Components]
Name: "plugin";   Description: "Tie With Cant Plugin (Civil 3D 2026)";  Types: full custom; Flags: fixed
Name: "registry"; Description: "Register plugin in AutoCAD registry (fallback loader — recommended)"; Types: full custom

[Messages]
WelcomeLabel1=Welcome to the [name] Setup Wizard
WelcomeLabel2=This will install [name/ver] on your computer.%n%nThis plugin inserts block references along a Civil 3D alignment with superelevation (cant) rotation applied at each station.%n%nNo administrator rights are required.
FinishedHeadingLabel=Installation Complete
FinishedLabel=EGIS Tie With Cant has been installed.%n%nRestart Civil 3D 2026 to load the plugin.%n%nCommand: TIEINSERT
ClickFinish=Click Finish to close this wizard.

[Dirs]
Name: "{app}";                          Components: plugin
Name: "{app}\Contents";                 Components: plugin
Name: "{app}\Contents\Win64";           Components: plugin
Name: "{app}\Contents\Win64\Icons";     Components: plugin

[Files]
; ── PackageContents.xml ──────────────────────────────────────
Source: "{#BundleSource}\PackageContents.xml"; \
    DestDir: "{app}"; \
    Flags: ignoreversion; \
    Components: plugin

; ── Main DLL ─────────────────────────────────────────────────
Source: "{#BundleSource}\Contents\Win64\TieWithCant.dll"; \
    DestDir: "{app}\Contents\Win64"; \
    Flags: ignoreversion; \
    Components: plugin

; ── Icons ────────────────────────────────────────────────────
Source: "{#BundleSource}\Contents\Win64\Icons\TieWithCant_32.png"; \
    DestDir: "{app}\Contents\Win64\Icons"; \
    Flags: ignoreversion; \
    Components: plugin

Source: "{#BundleSource}\Contents\Win64\Icons\TieWithCant_16.png"; \
    DestDir: "{app}\Contents\Win64\Icons"; \
    Flags: ignoreversion; \
    Components: plugin

[Registry]
; ════════════════════════════════════════════════════════════════
; Registry registration is written by the [Code] section below
; because the AutoCAD version key (R25.1, ACAD-9100:409) varies
; per installation. The static [Registry] section is not used for
; the AutoCAD keys — it only handles uninstall tracking.
; ════════════════════════════════════════════════════════════════

; Track installation in HKCU for the uninstaller
Root: HKCU; Subkey: "Software\EGISSmartTools\TieWithCant"; \
    ValueType: string; ValueName: "InstallPath"; ValueData: "{app}"; \
    Flags: uninsdeletekey; \
    Components: plugin

[Code]
// ════════════════════════════════════════════════════════════════
// Dynamic AutoCAD registry registration
// Enumerates HKCU\Software\Autodesk\AutoCAD\{ver}\{prod}
// and registers the plugin under each AutoCAD product found.
// Mirrors the PowerShell script used for manual registration.
// ════════════════════════════════════════════════════════════════

const
  ACAD_BASE    = 'Software\Autodesk\AutoCAD';
  APP_KEY_NAME = 'EGISTieWithCant';

// ── Helper: check if a string starts with a prefix ──────────────
function StartsWith(S, Prefix: string): Boolean;
begin
  Result := (Length(S) >= Length(Prefix)) and
            (Copy(S, 1, Length(Prefix)) = Prefix);
end;

// ── Register plugin under one AutoCAD product key ───────────────
procedure RegisterUnderProduct(ProdPath, DLLPath: string);
var
  AppKeyPath: string;
begin
  AppKeyPath := ProdPath + '\Applications\' + APP_KEY_NAME;
  RegWriteStringValue(HKCU, AppKeyPath, 'DESCRIPTION',
    'EGIS Smart Tools - Tie With Cant');
  RegWriteDWordValue (HKCU, AppKeyPath, 'LOADCTRLS', 14);
  RegWriteStringValue(HKCU, AppKeyPath, 'LOADER', DLLPath);
  RegWriteDWordValue (HKCU, AppKeyPath, 'MANAGED', 1);
end;

// ── Unregister plugin from one AutoCAD product key ──────────────
procedure UnregisterUnderProduct(ProdPath: string);
begin
  RegDeleteKeyIncludingSubkeys(HKCU,
    ProdPath + '\Applications\' + APP_KEY_NAME);
end;

// ── Enumerate all AutoCAD versions and products ──────────────────
procedure EnumerateAcadProducts(DoRegister: Boolean; DLLPath: string);
var
  VerNames, ProdNames: TArrayOfString;
  i, j:   Integer;
  VerKey, ProdKey: string;
begin
  // Level 1: version keys under HKCU\Software\Autodesk\AutoCAD
  if not RegGetSubkeyNames(HKCU, ACAD_BASE, VerNames) then Exit;

  for i := 0 to GetArrayLength(VerNames) - 1 do
  begin
    VerKey := ACAD_BASE + '\' + VerNames[i];

    // Level 2: product keys (e.g. ACAD-9100:409)
    if not RegGetSubkeyNames(HKCU, VerKey, ProdNames) then Continue;

    for j := 0 to GetArrayLength(ProdNames) - 1 do
    begin
      if StartsWith(ProdNames[j], 'ACAD-') then
      begin
        ProdKey := VerKey + '\' + ProdNames[j];
        if DoRegister then
          RegisterUnderProduct(ProdKey, DLLPath)
        else
          UnregisterUnderProduct(ProdKey);
      end;
    end;
  end;
end;

// ── Called after files are installed ────────────────────────────
procedure CurStepChanged(CurStep: TSetupStep);
var
  DLLPath: string;
begin
  if CurStep = ssPostInstall then
  begin
    if IsComponentSelected('registry') then
    begin
      DLLPath := ExpandConstant('{app}\Contents\Win64\TieWithCant.dll');
      EnumerateAcadProducts(True, DLLPath);
    end;
  end;
end;

// ── Called during uninstall ──────────────────────────────────────
procedure CurUninstallStepChanged(CurUninstallStep: TUninstallStep);
begin
  if CurUninstallStep = usPostUninstall then
    EnumerateAcadProducts(False, '');
end;

// ── Pre-install check: verify Civil 3D DLLs are present ─────────
function InitializeSetup(): Boolean;
var
  CivilDLL: string;
begin
  CivilDLL := 'C:\Program Files\Autodesk\AutoCAD 2026\C3D\AeccDbMgd.dll';
  if not FileExists(CivilDLL) then
  begin
    if MsgBox('Civil 3D 2026 was not detected on this computer.' + #13#10 +
              '(Expected: C:\Program Files\Autodesk\AutoCAD 2026\C3D\AeccDbMgd.dll)' + #13#10#13#10 +
              'The plugin requires Civil 3D 2026 to run.' + #13#10 +
              'Continue installation anyway?',
              mbConfirmation, MB_YESNO) = IDNO then
    begin
      Result := False;
      Exit;
    end;
  end;
  Result := True;
end;
