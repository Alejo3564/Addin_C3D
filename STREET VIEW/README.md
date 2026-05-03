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

*EGIS Smart Tools Suite — EGIS Colombia*
