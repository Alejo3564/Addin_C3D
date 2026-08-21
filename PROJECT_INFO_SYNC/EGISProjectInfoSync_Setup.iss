; ============================================================================
; EGIS Project Info Sync — Inno Setup Script
; Civil 3D 2026 Plugin | EGIS Smart Tools Suite
; No administrator privileges required — per-user installation
; ============================================================================

#define AppName        "EGIS Project Info Sync"
#define AppVersion     "1.0.0"
#define AppPublisher   "EGIS Colombia"
#define AppURL         "https://www.egis.com.co"
#define AppDescription "Drawing Properties manager for Civil 3D 2026"
#define BundleName     "EGISProjectInfoSync.bundle"
#define DllName        "EGISProjectInfoSync.dll"
#define RegAppName     "EGISProjectInfoSync"

; Source bundle root (all plugin files already structured here)
#define BundleSource   "D:\2_ALEJO\APP_BIM\CIVIL 3D\EGISProjectInfoSync\Installer\EGISProjectInfoSync.bundle"

[Setup]
AppId                    = {{B7C3D491-2E5F-4A8B-9C0D-PROJINFOSYNC}
AppName                  = {#AppName}
AppVersion               = {#AppVersion}
AppPublisher             = {#AppPublisher}
AppPublisherURL          = {#AppURL}
AppSupportURL            = {#AppURL}
AppUpdatesURL            = {#AppURL}
AppComments              = {#AppDescription}

; ── Per-user install — NO admin required ────────────────────────────────────
PrivilegesRequired       = lowest
PrivilegesRequiredOverridesAllowed = commandline

; ── Install destination: %APPDATA%\Autodesk\ApplicationPlugins ──────────────
DefaultDirName           = {userappdata}\Autodesk\ApplicationPlugins\{#BundleName}
DirExistsWarning         = no
DisableDirPage           = yes

; ── Uninstall ────────────────────────────────────────────────────────────────
UninstallDisplayName     = {#AppName} {#AppVersion}
CreateUninstallRegKey    = yes
Uninstallable            = yes

; ── Output ───────────────────────────────────────────────────────────────────
OutputDir                = D:\2_ALEJO\APP_BIM\CIVIL 3D\EGISProjectInfoSync\Installer\Output
OutputBaseFilename       = EGISProjectInfoSync_v{#AppVersion}_Setup
SetupIconFile            =
; No icon — intentionally omitted

; ── UI language and settings ─────────────────────────────────────────────────
DefaultGroupName         = EGIS Smart Tools
DisableProgramGroupPage  = yes
ShowLanguageDialog       = no
LanguageDetectionMethod  = none

; ── Compression ──────────────────────────────────────────────────────────────
Compression              = lzma2/ultra64
SolidCompression         = yes
InternalCompressLevel    = ultra64

; ── Wizard style ─────────────────────────────────────────────────────────────
WizardStyle              = modern
WizardResizable          = no

[Languages]
Name: "english"; MessagesFile: "compiler:Default.isl"

[Messages]
; ── Custom English messages ───────────────────────────────────────────────────
WelcomeLabel1=Welcome to the [name] Setup Wizard
WelcomeLabel2=This will install [name/ver] on your computer.%n%nThis plugin integrates with AutoCAD Civil 3D 2026 and adds the Project Info Sync panel to the EGIS Smart Tools ribbon tab.%n%nClick Next to continue.
FinishedHeadingLabel=Installation complete
FinishedLabel=The [name] plugin has been installed successfully.%n%nRestart AutoCAD Civil 3D 2026 for the changes to take effect.%n%nYou can find the plugin under: EGIS Smart Tools ribbon tab → Parameter Sync panel.
FinishedRestartLabel=

[Types]
Name: "full";    Description: "Full installation (recommended)"
Name: "custom";  Description: "Custom installation"; Flags: iscustom

[Components]
Name: "plugin";   Description: "Plugin DLL and dependencies";        Types: full custom; Flags: fixed
Name: "registry"; Description: "AutoCAD registry entries (recommended for auto-loading)"; Types: full custom

[Files]
; ── Bundle root ──────────────────────────────────────────────────────────────
Source: "{#BundleSource}\PackageContents.xml";           DestDir: "{app}";                    Components: plugin; Flags: ignoreversion

; ── Contents\Win64 — DLL and dependencies ────────────────────────────────────
Source: "{#BundleSource}\Contents\Win64\{#DllName}";                                   DestDir: "{app}\Contents\Win64"; Components: plugin; Flags: ignoreversion
Source: "{#BundleSource}\Contents\Win64\ClosedXML.dll";                                DestDir: "{app}\Contents\Win64"; Components: plugin; Flags: ignoreversion skipifsourcedoesntexist
Source: "{#BundleSource}\Contents\Win64\DocumentFormat.OpenXml.dll";                   DestDir: "{app}\Contents\Win64"; Components: plugin; Flags: ignoreversion skipifsourcedoesntexist
Source: "{#BundleSource}\Contents\Win64\DocumentFormat.OpenXml.Framework.dll";         DestDir: "{app}\Contents\Win64"; Components: plugin; Flags: ignoreversion skipifsourcedoesntexist
Source: "{#BundleSource}\Contents\Win64\ExcelNumberFormat.dll";                        DestDir: "{app}\Contents\Win64"; Components: plugin; Flags: ignoreversion skipifsourcedoesntexist
Source: "{#BundleSource}\Contents\Win64\*.dll";                                        DestDir: "{app}\Contents\Win64"; Components: plugin; Flags: ignoreversion skipifsourcedoesntexist

; ── Icons (optional — plugin works without them) ─────────────────────────────
Source: "{#BundleSource}\Contents\Win64\Icons\*";        DestDir: "{app}\Contents\Win64\Icons"; Components: plugin; Flags: ignoreversion skipifsourcedoesntexist recursesubdirs

[Registry]
; ── AutoCAD 2026 (R26.0) — registry-based loading for reliability ────────────
; These entries ensure the plugin loads even if the bundle loader has issues.
; Civil 3D 2026 key: HKCU\Software\Autodesk\AutoCAD\R26.0\<product-key>\Applications

; AutoCAD 2026 vanilla
Root: HKCU; Subkey: "Software\Autodesk\AutoCAD\R26.0\ACAD-9001:409\Applications\{#RegAppName}"; ValueType: string;  ValueName: "DESCRIPTION"; ValueData: "{#AppDescription}";                             Components: registry; Flags: uninsdeletekey
Root: HKCU; Subkey: "Software\Autodesk\AutoCAD\R26.0\ACAD-9001:409\Applications\{#RegAppName}"; ValueType: string;  ValueName: "LOADER";      ValueData: "{app}\Contents\Win64\{#DllName}";                Components: registry; Flags: uninsdeletekey
Root: HKCU; Subkey: "Software\Autodesk\AutoCAD\R26.0\ACAD-9001:409\Applications\{#RegAppName}"; ValueType: dword;   ValueName: "LOADCTRLS";   ValueData: "14";                                             Components: registry
Root: HKCU; Subkey: "Software\Autodesk\AutoCAD\R26.0\ACAD-9001:409\Applications\{#RegAppName}"; ValueType: dword;   ValueName: "MANAGED";     ValueData: "1";                                              Components: registry

; Civil 3D 2026 (most common product key suffix)
Root: HKCU; Subkey: "Software\Autodesk\AutoCAD\R26.0\ACAD-9000:409\Applications\{#RegAppName}"; ValueType: string;  ValueName: "DESCRIPTION"; ValueData: "{#AppDescription}";                             Components: registry; Flags: uninsdeletekey
Root: HKCU; Subkey: "Software\Autodesk\AutoCAD\R26.0\ACAD-9000:409\Applications\{#RegAppName}"; ValueType: string;  ValueName: "LOADER";      ValueData: "{app}\Contents\Win64\{#DllName}";                Components: registry; Flags: uninsdeletekey
Root: HKCU; Subkey: "Software\Autodesk\AutoCAD\R26.0\ACAD-9000:409\Applications\{#RegAppName}"; ValueType: dword;   ValueName: "LOADCTRLS";   ValueData: "14";                                             Components: registry
Root: HKCU; Subkey: "Software\Autodesk\AutoCAD\R26.0\ACAD-9000:409\Applications\{#RegAppName}"; ValueType: dword;   ValueName: "MANAGED";     ValueData: "1";                                              Components: registry

; AutoCAD 2025 (R25.x) — backward compatibility
Root: HKCU; Subkey: "Software\Autodesk\AutoCAD\R25.1\ACAD-9001:409\Applications\{#RegAppName}"; ValueType: string;  ValueName: "DESCRIPTION"; ValueData: "{#AppDescription}";                             Components: registry; Flags: uninsdeletekey
Root: HKCU; Subkey: "Software\Autodesk\AutoCAD\R25.1\ACAD-9001:409\Applications\{#RegAppName}"; ValueType: string;  ValueName: "LOADER";      ValueData: "{app}\Contents\Win64\{#DllName}";                Components: registry; Flags: uninsdeletekey
Root: HKCU; Subkey: "Software\Autodesk\AutoCAD\R25.1\ACAD-9001:409\Applications\{#RegAppName}"; ValueType: dword;   ValueName: "LOADCTRLS";   ValueData: "14";                                             Components: registry
Root: HKCU; Subkey: "Software\Autodesk\AutoCAD\R25.1\ACAD-9001:409\Applications\{#RegAppName}"; ValueType: dword;   ValueName: "MANAGED";     ValueData: "1";                                              Components: registry

[Code]
// ── Auto-detect installed AutoCAD/Civil 3D versions and write registry ───────
// Scans HKCU\Software\Autodesk\AutoCAD for all installed R-versions and
// writes the plugin registry entry under each product key found.

procedure WriteRegistryForAllVersions();
var
  AcadRoot, VersionKey, ProductKey, AppKey: String;
  Versions: TArrayOfString;
  Products: TArrayOfString;
  DllPath:  String;
  i, j:     Integer;
begin
  AcadRoot := 'Software\Autodesk\AutoCAD';
  DllPath  := ExpandConstant('{app}\Contents\Win64\{#DllName}');

  // Enumerate R-version keys (R25.x, R26.x, etc.)
  if RegGetSubkeyNames(HKCU, AcadRoot, Versions) then
  begin
    for i := 0 to GetArrayLength(Versions) - 1 do
    begin
      VersionKey := AcadRoot + '\' + Versions[i];

      // Enumerate product keys under each version (ACAD-9000:409, etc.)
      if RegGetSubkeyNames(HKCU, VersionKey, Products) then
      begin
        for j := 0 to GetArrayLength(Products) - 1 do
        begin
          // Only target English (409) product keys
          if Pos('409', Products[j]) > 0 then
          begin
            AppKey := VersionKey + '\' + Products[j] + '\Applications\{#RegAppName}';

            RegWriteStringValue(HKCU, AppKey, 'DESCRIPTION', '{#AppDescription}');
            RegWriteStringValue(HKCU, AppKey, 'LOADER',      DllPath);
            RegWriteDWordValue (HKCU, AppKey, 'LOADCTRLS',   14);
            RegWriteDWordValue (HKCU, AppKey, 'MANAGED',     1);
          end;
        end;
      end;
    end;
  end;
end;

procedure RemoveRegistryForAllVersions();
var
  AcadRoot, VersionKey, ProductKey: String;
  Versions: TArrayOfString;
  Products: TArrayOfString;
  i, j:     Integer;
begin
  AcadRoot := 'Software\Autodesk\AutoCAD';

  if RegGetSubkeyNames(HKCU, AcadRoot, Versions) then
  begin
    for i := 0 to GetArrayLength(Versions) - 1 do
    begin
      VersionKey := AcadRoot + '\' + Versions[i];
      if RegGetSubkeyNames(HKCU, VersionKey, Products) then
      begin
        for j := 0 to GetArrayLength(Products) - 1 do
        begin
          if Pos('409', Products[j]) > 0 then
          begin
            ProductKey := VersionKey + '\' + Products[j] +
                          '\Applications\{#RegAppName}';
            RegDeleteKeyIncludingSubkeys(HKCU, ProductKey);
          end;
        end;
      end;
    end;
  end;
end;

// Called after all files and static registry entries are written
procedure CurStepChanged(CurStep: TSetupStep);
begin
  if CurStep = ssPostInstall then
    WriteRegistryForAllVersions();
end;

// Called during uninstall
procedure CurUninstallStepChanged(CurUninstallStep: TUninstallStep);
begin
  if CurUninstallStep = usPostUninstall then
    RemoveRegistryForAllVersions();
end;

[UninstallDelete]
; Remove the entire bundle folder on uninstall
Type: filesandordirs; Name: "{app}"

[CustomMessages]
english.LaunchAfterInstall=Restart AutoCAD Civil 3D 2026 to activate the plugin.

