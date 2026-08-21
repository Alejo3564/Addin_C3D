; =============================================================================
;  EGIS Street View — Inno Setup Script v1.0.0
;  Compatible with Inno Setup 6.x (all versions)
;
;  Install strategy — NO registry, NO admin required:
;    AutoCAD / Civil 3D automatically scans:
;      %APPDATA%\Autodesk\ApplicationPlugins\
;    for *.bundle folders on every startup.
;    The installer simply copies the bundle there.
; =============================================================================

#define AppName        "EGIS Street View"
#define AppVersion     "1.0.0"
#define AppPublisher   "EGIS Colombia"
#define AppURL         "https://www.egis-group.com"
#define BundleName     "EGISStreetView.bundle"
#define SourceBundle   "D:\2_ALEJO\APP_BIM\CIVIL 3D\EGISStreetView\Installer\EGISStreetView.bundle"
#define OutputPath     "D:\2_ALEJO\APP_BIM\CIVIL 3D\EGISStreetView\Installer\Output"

; =============================================================================
[Setup]
AppId                    = {{A4F2C3E1-88B7-4D6A-9F0E-123456789ABC}
AppName                  = {#AppName}
AppVersion               = {#AppVersion}
AppVerName               = {#AppName} {#AppVersion}
AppPublisher             = {#AppPublisher}
AppPublisherURL          = {#AppURL}
AppSupportURL            = {#AppURL}
AppCopyright             = Copyright 2026 EGIS Colombia

; ── NO administrator required — installs per-user only ───────────────────────
PrivilegesRequired       = lowest

; ── Install destination: %APPDATA%\Autodesk\ApplicationPlugins\<bundle> ──────
DefaultDirName           = {userappdata}\Autodesk\ApplicationPlugins\{#BundleName}
DefaultGroupName         = EGIS Smart Tools

; ── Output executable ─────────────────────────────────────────────────────────
OutputDir                = {#OutputPath}
OutputBaseFilename       = EGISStreetView_Setup_v{#AppVersion}

; ── NOTE: SetupIconFile requires a .ico file — leave commented if you       ──
; ── don't have one, or convert StreetView32.png to .ico first              ──
; SetupIconFile          = {#SourceBundle}\Resources\StreetView.ico

; ── Compression ───────────────────────────────────────────────────────────────
Compression              = lzma2/max
SolidCompression         = yes

; ── Wizard ────────────────────────────────────────────────────────────────────
WizardStyle              = modern

; ── Version info ──────────────────────────────────────────────────────────────
VersionInfoVersion       = {#AppVersion}.0
VersionInfoCompany       = {#AppPublisher}
VersionInfoDescription   = {#AppName} for AutoCAD Civil 3D 2026
VersionInfoProductName   = EGIS Smart Tools

; ── Misc ──────────────────────────────────────────────────────────────────────
ShowLanguageDialog       = no
LanguageDetectionMethod  = none
CloseApplications        = no
RestartApplications      = no

; =============================================================================
[Languages]
Name: "english"; MessagesFile: "compiler:Default.isl"

; =============================================================================
[CustomMessages]
NoAutoCAD      = AutoCAD or Civil 3D 2026 does not appear to be installed.%n%nThe plugin requires AutoCAD or Civil 3D 2026 (R25.x).%n%nDo you want to continue anyway?
DotNet8Missing = .NET 8 Desktop Runtime (x64) does not appear to be installed.%n%nThe plugin requires .NET 8.%n%nDownload it from:%n  https://dotnet.microsoft.com/download/dotnet/8.0%n%nContinue anyway?
WebView2Info   = Microsoft WebView2 Runtime is not installed.%n%nWithout it, Street View will open in your browser instead of inside Civil 3D.%n%nYou can install it later from:%n  https://developer.microsoft.com/edge/webview2%n%nThe installation will continue normally.
RestartNote    = Please restart AutoCAD Civil 3D to activate the EGIS Street View plugin.

; =============================================================================
[Messages]
WelcomeLabel1     = Welcome to the [name] Setup Wizard
WelcomeLabel2     = This wizard will install [name/ver] for AutoCAD Civil 3D 2026.%n%nThe plugin adds a Street View button to the EGIS Smart Tools ribbon, allowing you to click any geolocated point in the model and view Google Street View at that real-world location.%n%nClick Next to continue.
FinishedHeadingLabel = [name] installed successfully
FinishedLabel     = EGIS Street View has been installed for the current user.%n%nRestart AutoCAD Civil 3D to see the Street View button in the ribbon under:%n  EGIS Smart Tools > Transport && Railway Tools%n%nNo administrator rights were required.

; =============================================================================
[Files]
; PackageContents.xml — AutoCAD reads this to locate and load the plugin
Source: "{#SourceBundle}\PackageContents.xml"; \
    DestDir: "{app}"; \
    Flags: ignoreversion

; All DLLs and dependencies
Source: "{#SourceBundle}\Contents\*"; \
    DestDir: "{app}\Contents"; \
    Flags: ignoreversion recursesubdirs createallsubdirs

; Icons / resources
Source: "{#SourceBundle}\Resources\*"; \
    DestDir: "{app}\Resources"; \
    Flags: ignoreversion recursesubdirs createallsubdirs

; =============================================================================
[Dirs]
; Ensure the ApplicationPlugins folder exists (it always should, but just in case)
Name: "{userappdata}\Autodesk\ApplicationPlugins"

; =============================================================================
[Icons]
Name: "{group}\Uninstall EGIS Street View"; Filename: "{uninstallexe}"

; =============================================================================
[Run]
; Optional post-install: offer to open WebView2 download page
Filename: "https://developer.microsoft.com/edge/webview2"; \
    Description: "Download WebView2 Runtime (for embedded Street View viewer)"; \
    Flags: shellexec postinstall skipifsilent unchecked

; =============================================================================
; NOTE: [UninstallDelete] is NOT needed here.
; Inno Setup automatically removes all files/folders installed via [Files].
; The bundle directory {app} is cleaned up by the uninstaller natively.

[Code]

// --------------------------------------------------------------------------
//  IsAutoCADInstalled
// --------------------------------------------------------------------------
function IsAutoCADInstalled(): Boolean;
begin
  Result :=
    RegKeyExists(HKCU, 'Software\Autodesk\AutoCAD\R25.0') or
    RegKeyExists(HKCU, 'Software\Autodesk\AutoCAD\R25.1') or
    RegKeyExists(HKLM, 'SOFTWARE\Autodesk\AutoCAD\R25.0') or
    RegKeyExists(HKLM, 'SOFTWARE\Autodesk\AutoCAD\R25.1') or
    RegKeyExists(HKLM, 'SOFTWARE\WOW6432Node\Autodesk\AutoCAD\R25.0') or
    RegKeyExists(HKLM, 'SOFTWARE\WOW6432Node\Autodesk\AutoCAD\R25.1');
end;

// --------------------------------------------------------------------------
//  IsWebView2Installed
// --------------------------------------------------------------------------
function IsWebView2Installed(): Boolean;
var
  V: string;
begin
  Result :=
    RegQueryStringValue(HKLM,
      'SOFTWARE\Microsoft\EdgeUpdate\Clients\{F3017226-FE2A-4295-8BDF-00C3A9A7E4C5}',
      'pv', V) or
    RegQueryStringValue(HKLM,
      'SOFTWARE\WOW6432Node\Microsoft\EdgeUpdate\Clients\{F3017226-FE2A-4295-8BDF-00C3A9A7E4C5}',
      'pv', V) or
    RegQueryStringValue(HKCU,
      'Software\Microsoft\EdgeUpdate\Clients\{F3017226-FE2A-4295-8BDF-00C3A9A7E4C5}',
      'pv', V);
end;

// --------------------------------------------------------------------------
//  IsDotNet8Installed
// --------------------------------------------------------------------------
function IsDotNet8Installed(): Boolean;
var
  FindRec: TFindRec;
begin
  Result := False;
  if FindFirst(
    ExpandConstant('{commonpf64}\dotnet\shared\Microsoft.WindowsDesktop.App\8.*'),
    FindRec) then
  begin
    Result := True;
    FindClose(FindRec);
  end;
end;

// --------------------------------------------------------------------------
//  InitializeSetup — prerequisite checks
// --------------------------------------------------------------------------
function InitializeSetup(): Boolean;
begin
  Result := True;

  // Check AutoCAD 2026
  if not IsAutoCADInstalled() then
  begin
    if MsgBox(CustomMessage('NoAutoCAD'),
              mbConfirmation, MB_YESNO or MB_DEFBUTTON2) = IDNO then
    begin
      Result := False;
      Exit;
    end;
  end;

  // Check .NET 8
  if not IsDotNet8Installed() then
  begin
    if MsgBox(CustomMessage('DotNet8Missing'),
              mbConfirmation, MB_YESNO or MB_DEFBUTTON2) = IDNO then
    begin
      Result := False;
      Exit;
    end;
  end;

  // Inform about WebView2 (non-blocking)
  if not IsWebView2Installed() then
    MsgBox(CustomMessage('WebView2Info'), mbInformation, MB_OK);
end;
