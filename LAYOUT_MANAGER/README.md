# EGIS Layout Manager — Civil 3D 2026

**EGIS Smart Tools ribbon tab → Layouts & Sheets panel**


---

## Install

### Step 1 — Install_EGISLayoutManager.bat
```
Doble click on Install_EGISLayoutManager.bat
```
Restart Civil 3D.

### Step 2 — Registry injection 
```
Open Register_EGISLayoutManager.ps1 in Note Pad or anytext editor
Copy all information
Open Windows PowerShell an paste text > press enter when register finishes
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
