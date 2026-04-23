# ============================================================
# EGIS Smart Tools - Plugin Loader
# Registers ALL EGIS plugins in the Civil 3D registry.
# Each plugin gets its own unique key → no conflicts.
# Portable: uses $env:APPDATA — no hardcoded username.
# ============================================================

$bundleRoot = "$env:APPDATA\Autodesk\ApplicationPlugins"

$plugins = @(

    @{
        Key    = "EGISTieWithCant"
        Desc   = "EGIS Smart Tools - Tie With Cant"
        DLL    = "$bundleRoot\EGISTieWithCant_Plugin.bundle\Contents\Win64\TieWithCant.dll"
    }
)

$base = "HKCU:\Software\Autodesk\AutoCAD"

Get-ChildItem $base | ForEach-Object {
    $ver = $_
    Get-ChildItem $ver.PSPath | Where-Object { $_.PSChildName -like "ACAD-*" } | ForEach-Object {
        $prod = $_

        foreach ($plugin in $plugins) {
            # Verify DLL exists before registering
            if (-not (Test-Path $plugin.DLL)) {
                Write-Host "  SKIPPED (DLL not found): $($plugin.Key)" -ForegroundColor Yellow
                Write-Host "  Path: $($plugin.DLL)" -ForegroundColor DarkYellow
                continue
            }

            $key = "$($prod.PSPath)\Applications\$($plugin.Key)"
            New-Item -Path $key -Force | Out-Null
            Set-ItemProperty -Path $key -Name "DESCRIPTION" -Value $plugin.Desc
            Set-ItemProperty -Path $key -Name "LOADCTRLS"   -Value 14 -Type DWord
            Set-ItemProperty -Path $key -Name "LOADER"      -Value $plugin.DLL
            Set-ItemProperty -Path $key -Name "MANAGED"     -Value 1  -Type DWord

            Write-Host "  OK: $($plugin.Key) → $($ver.PSChildName)/$($prod.PSChildName)" -ForegroundColor Green
        }
    }
}

Write-Host ""
Write-Host "Done. Restart Civil 3D to load all plugins." -ForegroundColor Cyan
