# EGIS Street View — Civil 3D 2026 Add-in

## Overview

**EGIS Street View** is a Civil 3D 2026 add-in that lets you click any point in
a geolocated model and instantly view **Google Street View** at that real-world
location — either embedded directly inside Civil 3D (via WebView2) or in the
system browser as a fallback.

It follows the same architecture, branding, and patterns as **EGIS Parameter Sync**
and lives under the **EGIS Smart Tools** ribbon tab.

---

## Features

| Feature | Detail |
|---------|--------|
| **One-click workflow** | Single "Pick Point in Model" button → select point → Street View loads |
| **Coordinate transformation** | Reads the drawing's coordinate system via Civil 3D/AutoCAD GeoData API and transforms to WGS84 automatically |
| **Geolocation check** | Warns the user if the drawing has no coordinate system assigned |
| **Embedded viewer** | Uses Microsoft WebView2 (Chromium) to show Street View inside Civil 3D |
| **Browser fallback** | If WebView2 Runtime is not installed, opens Street View in the default browser |
| **EGIS branding** | Midnight Blue header, Azure Blue accents, Vert Egis CTA button — matches EGIS Parameter Sync |
| **Dockable palette** | Same `PaletteSet` mechanism as EGIS Parameter Sync — can dock left/right or float |
| **Ribbon integration** | Appears in "EGIS Smart Tools" tab → "Transport & Railway Tools" panel |

---

## Architecture

```
EGISStreetView/
├── EGISStreetView.csproj     # net8.0-windows, WPF, WebView2, ProjNet
├── StreetViewApp.cs           # IExtensionApplication — ribbon + palette bootstrap
├── StreetViewCommands.cs      # [CommandMethod] handlers (PICK, OPEN, BROWSER)
├── StreetViewPalette.cs       # PaletteSet + WPF control (UI built in pure C#)
├── CoordinateTransformer.cs   # WGS84 transformation via Civil 3D GeoData API
├── Install.ps1                # Registry-based installer (machine-agnostic)
├── build.bat                  # Build + deploy script
├── create_icons.py            # Generates placeholder PNG icons
├── Resources/
│   ├── StreetView32.png
│   ├── StreetView16.png
│   └── EgisLogo.png
└── Bundle/
    └── EGISStreetView.bundle/
        └── PackageContents.xml
```

### Command flow

```
Ribbon button click
    │
    └─► SendStringToExecute("EGIS_STREETVIEW_OPEN ")
            │
            └─► [CommandMethod("EGIS_STREETVIEW_OPEN")]
                    Opens / activates the dockable palette

User clicks "Pick Point in Model"
    │
    └─► Palette fires PickPointRequested event
            │
            └─► SendStringToExecute("EGIS_STREETVIEW_PICK ")
                    │
                    └─► [CommandMethod("EGIS_STREETVIEW_PICK")]  (main thread)
                            ├── Check geolocation → warn if missing
                            ├── ed.GetPoint() — user picks in viewport
                            ├── CoordinateTransformer.TryModelToWgs84()
                            └─► palette.LoadStreetView(lat, lon)
                                    ├── WebView2 available? → load HTML with Google Maps embed
                                    └── WebView2 missing?  → show fallback + "Open in Browser"
```

---

## Coordinate Transformation

The plugin reads the geographic coordinate system directly from:

1. **Civil 3D DrawingSettings** — `UnitZoneSettings.ZoneName` / `.ZoneGroup`
2. **AutoCAD GeoData object** (`ACDB_GEODATA` in NamedObjectsDictionary)
   — calls `TransformModelToLonLat(Point3d)` which internally uses
   the CS assigned via `GEOGRAPHICLOCATION`.

**No manual CRS configuration is needed.** The drawing's assigned coordinate
system (e.g., "UTM Zone 18N", "MAGNA-SIRGAS / Colombia Bogota zone") is used
automatically. Civil 3D supports all EPSG/ESRI codes.

### Requirements for coordinate transformation

- The drawing must have a geographic location set:
  - `GEOGRAPHICLOCATION` command  **or**
  - Civil 3D: Drawing Settings → Units & Zone → coordinate system

If not configured, the plugin displays a clear warning panel.

---

## Street View Display

### Option A — Embedded in Civil 3D (preferred)

Uses **Microsoft WebView2** (Chromium-based). Loads a Google Maps Embed iframe
showing Street View at the selected coordinates.

> **Note on Google Maps Embed API:**
> The basic Maps Embed URL works without an API key for personal/internal use.
> For production deployment with heavy usage, obtain a free **Google Maps
> Embed API key** from [console.cloud.google.com](https://console.cloud.google.com)
> and replace `YOUR_API_KEY` in `StreetViewPalette.cs → BuildStreetViewHtml()`.
> The Embed API has a free tier of 28,000 requests/month.

**WebView2 Runtime install:**
```
https://developer.microsoft.com/en-us/microsoft-edge/webview2/
```
(~120 MB, installs silently, persists across updates)

### Option B — System browser (automatic fallback)

If WebView2 is not installed, the plugin opens:
```
https://www.google.com/maps/@?api=1&map_action=pano&viewpoint={lat},{lon}
```
This URL opens Street View in the default browser at the selected location.

---

## Build Prerequisites

| Requirement | Version |
|-------------|---------|
| .NET SDK | 8.0+ |
| AutoCAD Civil 3D | 2026 (R25.1) |
| Visual Studio | 2022+ (or `dotnet build`) |
| WebView2 Runtime | Latest (optional, for embedded viewer) |

### Build

```batch
# Edit AcadDir in build.bat to match your Civil 3D installation path, then:
build.bat
```

Or with dotnet CLI:
```batch
set AcadDir=C:\Program Files\Autodesk\AutoCAD 2026\
dotnet build EGISStreetView.csproj -c Release -p:AcadDir="%AcadDir%"
```

### Install

```powershell
# Run after build:
.\Install.ps1 -DllPath "path\to\EGISStreetView.dll"

# Uninstall:
.\Install.ps1 -Uninstall
```

---

## NuGet Dependencies

| Package | Purpose |
|---------|---------|
| `Microsoft.Web.WebView2` | Embedded Chromium browser (Street View viewer) |
| `ProjNet` | Coordinate reference system transformations (fallback) |

---

## Usage

1. Open a geolocated Civil 3D drawing
2. Click **Street View** button in: **EGIS Smart Tools** → **Transport & Railway Tools**
3. The palette opens on the right side
4. Click **📍 Pick Point in Model**
5. Click any point in the Civil 3D viewport
6. Street View loads at that location

---

## Known Limitations

| Limitation | Workaround |
|------------|------------|
| Street View requires internet connection | N/A |
| Google Maps Embed shows nearest pano, not guaranteed to be at exact point | Normal Street View behavior |
| WebView2 needs separate runtime install | Plugin detects and offers browser fallback |
| Very remote locations may not have Street View coverage | Plugin loads map view as fallback |

---

## EGIS Brand Reference

| Element | Color | Hex |
|---------|-------|-----|
| Header background | Midnight Blue | `#08212C` |
| Primary buttons (Azure) | Azure Blue 500 | `#0099A5` |
| CTA button (Pick Point) | Vert Egis 800 | `#ABC022` |
| Accent bar | Azure Blue 400 | `#2EABB5` |
| Page background | Light gray | `#F5F7F8` |

---

*EGIS Smart Tools Suite — EGIS Colombia*
