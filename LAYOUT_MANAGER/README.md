# EGIS Layout Manager — Civil 3D 2026

**EGIS Smart Tools ribbon tab → Layouts & Sheets panel**

---

## Features

| # | Feature |
|---|---------|
| 1 | **List all paper-space layouts** with checkboxes (Select All / Deselect All) |
| 2 | **Inline single rename** — click the layout name in the list and type a new name |
| 3 | **Batch rename** selected layouts with Prefix / Suffix / Start Number / Increment / Padding |
| 4 | **Load title block attributes** from the first block-with-attributes in each selected layout |
| 5 | **Edit attributes** in an editable grid and **save to all selected layouts** at once |
| 6 | EGIS brand palette (Midnight Blue / Azure / Vert Egis) — matches EGIS Parameter Sync |

---

## Project Structure

```
EGISLayoutManager/
├── EGISLayoutManager.csproj
├── Plugin.cs                   ← IExtensionApplication + ribbon + [CommandMethod]
├── Commands/                   ← (commands embedded in Plugin.cs)
├── Models/
│   └── LayoutItem.cs           ← LayoutItem, AttributeItem (INotifyPropertyChanged)
├── Services/
│   └── DrawingService.cs       ← All DB read/write (layouts + attributes)
├── UI/
│   ├── LayoutManagerPanel.cs   ← Pure C# WPF UserControl (no XAML)
│   └── PaletteHost.cs          ← PaletteSet singleton host
├── Resources/
│   ├── layout_manager_32.png
│   └── layout_manager_16.png
├── PackageContents.xml         ← Bundle manifest
├── Install-Bundle.bat          ← Copies .bundle to %APPDATA%\Autodesk\ApplicationPlugins
└── Install-Registry.ps1        ← Registry injection (reliable fallback)
```

---

## Build

1. Open a Developer Command Prompt or VS 2022.
2. Ensure AutoCAD 2026 is installed at the default path.
3. `dotnet build -c Release`
4. Output: `bin\Release\net8.0-windows\EGISLayoutManager.dll`

---

## Deployment

### Option A — Bundle (preferred)
```
Install-Bundle.bat
```
Creates `%APPDATA%\Autodesk\ApplicationPlugins\EGISLayoutManager.bundle\`  
Restart Civil 3D.

### Option B — Registry injection (fallback if bundle R-number mismatch)
```powershell
.\Install-Registry.ps1 -DllPath "path\to\EGISLayoutManager.dll"
```
Auto-detects all AutoCAD profiles under HKCU.  
Restart Civil 3D.

---

## Usage

1. Civil 3D opens → **EGIS Smart Tools** tab appears in the ribbon.
2. Click **Layout Manager** button (Layouts & Sheets panel).
3. The dockable palette opens on the left side.

### Workflow

```
[Refresh]  ──►  Select layouts  ──►  Inline rename  OR  Batch rename
                                ──►  [Load Attributes]
                                      Edit values in grid
                                      [Save Attributes to Selected Layouts]
```

---

## Architecture Notes

- **`net8.0-windows`** with `UseWPF` — required for AutoCAD 2026.
- **No XAML files** — all UI built in pure C# to avoid `FindName()` / MC-series SDK conflicts.
- **`CommandMethod`** `EGIS_LAYOUTMANAGER` — palette is shown via command for thread safety.
- **`doc.LockDocument()`** wraps all write operations.
- Attributes are matched by **Tag name** (case-insensitive) across layouts.

---

## Customization

| Need | Where to change |
|---|---|
| Different block name filter | `DrawingService.GetAttributesFromLayout()` — add `bref.Name == "YOUR_BLOCK"` check |
| More rename patterns | `DrawingService.BatchRenameLayouts()` |
| Panel size / dock side | `PaletteHost.ShowOrActivate()` |
| Additional ribbon buttons | `Plugin.RegisterRibbon()` |
