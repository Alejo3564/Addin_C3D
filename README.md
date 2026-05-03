# EGIS PDF Sheet Exporter — Civil 3D 2026 Plugin

Exports Civil 3D / AutoCAD layouts to individual PDF files with custom naming
rules built from Drawing Properties (Custom tab) and Layout Name fields.

---

## Prerequisites

| Requirement           | Version         |
|-----------------------|-----------------|
| Visual Studio         | 2022 (any edition) |
| .NET Framework        | 4.8             |
| Civil 3D / AutoCAD    | 2026            |
| Target platform       | x64             |

---

## Build Steps

1. **Open the solution** in Visual Studio 2022:
   ```
   File → Open → Project/Solution → EGISPdfExporter.csproj
   ```

2. **Verify AutoCAD DLL references** in `EGISPdfExporter.csproj`.
   Default path is:
   ```
   C:\Program Files\Autodesk\AutoCAD 2026\
   ```
   If Civil 3D is installed in a different location, update the `<HintPath>`
   values in the `.csproj` file for:
   - `accoremgd.dll`
   - `acmgd.dll`
   - `AcWindows.dll`
   - `AdWindows.dll`
   - `acdbmgd.dll`

3. **Set platform to x64** (should already be configured):
   ```
   Build → Configuration Manager → Platform: x64
   ```

4. **Build the solution**:
   ```
   Build → Build Solution  (Ctrl+Shift+B)
   ```
   Output: `bin\x64\Debug\EGISPdfExporter.dll`

---

## Deploy to Civil 3D 2026

### Option A — NETLOAD (manual, for testing)

1. Copy `EGISPdfExporter.dll` to a local folder, e.g.:
   ```
   C:\EGIS\Plugins\EGISPdfExporter\
   ```
2. Open Civil 3D 2026.
3. Type `NETLOAD` in the command line.
4. Browse to `EGISPdfExporter.dll` and click **Open**.
5. The **EGIS Smart Tools** ribbon tab will appear with the
   **Sheets & Print** panel.

### Option B — Startup Suite (permanent)

1. Type `APPLOAD` in Civil 3D.
2. Click **Contents…** under *Startup Suite*.
3. Add `EGISPdfExporter.dll`.
4. Click **Close**. The plugin loads automatically on every session.

### Option C — .bundle (recommended for distribution)

Create the folder structure:
```
EGISPdfExporter.bundle/
  PackageContents.xml
  Contents/
    Win64/
      EGISPdfExporter.dll
```

`PackageContents.xml`:
```xml
<?xml version="1.0" encoding="utf-8"?>
<ApplicationPackage SchemaVersion="1.0"
                    ProductType="Application"
                    Name="EGISPdfExporter"
                    Description="EGIS PDF Sheet Exporter for Civil 3D 2026"
                    Author="EGIS Colombia">
  <CompanyDetails Name="EGIS Colombia"/>
  <RuntimeRequirements OS="Win64" Platform="AutoCAD" SeriesMin="R25" SeriesMax="R25"/>
  <Components>
    <RuntimeRequirements OS="Win64" Platform="AutoCAD"/>
    <ComponentEntry ModuleName="./Contents/Win64/EGISPdfExporter.dll"
                    AppName="EGISPdfExporter"
                    LoadOnCommandInvocation="false"
                    LoadOnAutoCADStartup="true"/>
  </Components>
</ApplicationPackage>
```

Place the `.bundle` folder in:
```
%APPDATA%\Autodesk\ApplicationPlugins\
```
Civil 3D loads it automatically.

---

## Usage

1. Open a DWG file with paper space layouts.
2. Add **custom properties** via:
   `File → Drawing Properties → Custom` tab.
3. Click the **PDF Export** button in:
   `EGIS Smart Tools → Sheets & Print`
   (or type `EGIS_PDFEXPORT` in the command line).
4. In the dialog:
   - Select/deselect layouts using checkboxes.
   - Click **⚙ Naming Rules** to configure the file name.
   - In *Setup Naming Rules*, choose **Project Information** to see
     your custom Drawing Properties, or **Layout** for the layout name.
   - Add fields, set Prefix / Suffix / Separator as needed.
   - Set the **Output Folder**.
   - Click **Export PDFs**.

---

## Notes

- Each layout is exported using its **existing plot configuration**
  (plotter, paper size, plot area, scale).
- The plugin reads `DatabaseSummaryInfo.CustomProperties` for Drawing
  Properties → Custom fields.
- Layouts are listed in tab order (excluding the Model tab).
- File names are sanitized (invalid characters replaced with `_`).
