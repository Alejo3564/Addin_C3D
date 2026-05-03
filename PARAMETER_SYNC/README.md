# EGIS Parameter Sync – Civil 3D 2026
### EGIS Smart Tools | BIM Manager Toolset

---

## ¿Qué hace este plugin?

Permite **exportar e importar los valores de Property Sets** de objetos de Civil 3D 2026
(bloques, sólidos 3D, tuberías, alineamientos, corredores, etc.) hacia/desde Excel,
usando el **Handle** de la entidad como identificador único para el match.

Flujo principal:
```
Civil 3D Objetos  ──[Exportar]──►  Excel (.xlsx)
                                      │ (editar en Excel)
Civil 3D Objetos  ◄──[Importar]──  Excel modificado
```

---

## Prerrequisitos

| Requisito | Versión |
|-----------|---------|
| Autodesk Civil 3D | **2026** (AutoCAD 2026 interno) |
| .NET Runtime | **8.0** (incluido en Civil 3D 2026) |
| Windows | 10/11 x64 |
| Visual Studio | 2022+ (para compilar) |

### DLLs de Civil 3D necesarias
Las referencias del proyecto apuntan a la variable de entorno `$(ACAD2026)`.
Configúrala apuntando a tu instalación:
```
ACAD2026 = C:\Program Files\Autodesk\AutoCAD 2026
```
O ajusta las rutas `<HintPath>` en el `.csproj` directamente.

**DLLs requeridas:**
- `accoremgd.dll`
- `acdbmgd.dll`
- `acmgd.dll`
- `AdWindows.dll`
- `AcWindows.dll`
- `AeccDbMgd.dll`       ← Civil 3D
- `AeccLandDbMgd.dll`   ← Civil 3D Land
- `AecBaseMgd.dll`      ← AEC Base (Property Sets)
- `AecPropDataMgd.dll`  ← Property Data (Property Sets)

---

## Compilación

```bash
# Restaurar paquetes NuGet
dotnet restore

# Compilar en Release x64
dotnet build -c Release -r win-x64

# Output en: bin/Release/net8.0-windows/win-x64/
```

**Paquetes NuGet incluidos:**
- `ClosedXML 0.102.2` – Lectura/escritura Excel sin COM
- `Newtonsoft.Json 13.0.3` – Parseo de JSON

---

## Instalación

### Opción A: Carpeta .bundle (recomendada, auto-carga)

1. Crear la estructura:
```
%APPDATA%\Autodesk\ApplicationPlugins\
  EGISParameterSync_Civil3D.bundle\
    PackageContents.xml
    Contents\
      Win64\
        EGISParameterSync_Civil3D.dll
        ClosedXML.dll
        DocumentFormat.OpenXml.dll
        Newtonsoft.Json.dll
        (demás DLLs de NuGet de la carpeta de output)
```

2. Civil 3D cargará el plugin automáticamente al siguiente inicio.

### Opción B: Carga manual (para desarrollo)

En la línea de comandos de Civil 3D:
```
NETLOAD
→ Seleccionar EGISParameterSync_Civil3D.dll
```

---

## Uso del Plugin

### Pestaña en Ribbon
Al cargar, aparece la pestaña **"EGIS Smart Tools"** con el grupo **"Parameter Sync"**:
- `Abrir Panel` → Abre la ventana dockeable
- `Exportar Parámetros` → Atajo directo
- `Importar Parámetros` → Atajo directo

### Comandos disponibles
| Comando | Descripción |
|---------|-------------|
| `EGIS_OPEN_PANEL` | Abre/muestra el panel dockeable |
| `EGIS_EXPORT`     | Atajo para exportar |
| `EGIS_IMPORT`     | Atajo para importar |
| `EGIS_LIST_PS`    | Lista todos los Property Sets del dibujo en la consola |

---

## Flujo de trabajo paso a paso

### Paso 0 – Crear los Property Sets en Civil 3D
Los Property Sets deben existir en el dibujo **antes de usar el plugin**.

En Civil 3D:
1. `Manage` → `Styles` → `Property Set Definitions`
2. Crear el Property Set `Element` con la propiedad `Name` (tipo: Automatic > Text)
3. Crear los demás Property Sets según el proyecto

### Paso 1 – Cargar configuración JSON
Usa el botón **"📂 Cargar JSON"** para cargar tu archivo de configuración.

El JSON indica qué Property Sets y propiedades leer/escribir.

**Botón "📋 Ejemplo"**: Guarda un JSON de ejemplo que puedes editar.

### Paso 2 – Asignar Property Sets a objetos
1. Selecciona un Property Set de la lista desplegable
2. Clic en **"⚡ Seleccionar objetos y Asignar Property Set"**
3. Selecciona los objetos en el modelo → Enter

### Paso 3 – Exportar
1. (Opcional) Selecciona ruta de exportación con el botón 📁
2. Clic en **"📤 Seleccionar objetos y Exportar"**
3. Selecciona los objetos en el modelo → Enter
4. Se genera el Excel con columnas: `Handle | Layer | ObjectType | PropertySet.Propiedad | ...`

### Paso 4 – Editar en Excel y Importar
1. Edita los valores en el Excel (NO modifiques la columna `Handle`)
2. Clic en **"📥 Importar al Modelo"**
3. Se actualizan los Property Sets en el modelo

---

## Formato del JSON de configuración

```json
{
  "description": "Mi configuración de Property Sets",
  "version": "1.0",
  "propertySets": [
    {
      "propertySetName": "Element",
      "description": "Property Set de identificación",
      "properties": [
        {
          "name": "Name",
          "excelHeader": "Nombre",
          "dataType": "text",
          "readOnly": false,
          "description": "Nombre del elemento"
        }
      ]
    }
  ]
}
```

**Tipos de dato (`dataType`):**
| Valor | Tipo en Civil 3D |
|-------|-----------------|
| `text` | Texto (default) |
| `integer` | Número entero |
| `real` | Número real/decimal |
| `bool` | Booleano |

**`readOnly: true`**: La propiedad se exporta pero no se importa (protegida en Excel con fondo gris).

---

## Identificación de objetos

El plugin usa el **Handle** de AutoCAD como identificador único:
- Formato: cadena hexadecimal (ej: `"2A3F"`)
- Persistente durante la sesión del dibujo
- Columna `Handle` en el Excel → **NO modificar**

Para ver el Handle de un objeto: `PROPERTIES` → campo `Handle`

---

## Objetos compatibles

| Tipo de objeto | Compatibilidad |
|---------------|---------------|
| Sólidos 3D (`Solid3d`) | ✅ |
| Bloques (`BlockReference`) | ✅ |
| Tuberías (`Pipe`) | ✅ |
| Alineamientos (`Alignment`) | ✅ |
| Corredores (`Corridor`) | ✅ |
| Perfiles (`Profile`) | ✅ |
| Líneas / Polilíneas | ✅ |
| Estructuras (`Structure`) | ✅ |
| Cualquier entidad AutoCAD/Civil 3D | ✅ (si tiene Property Set asignado) |

---

## Troubleshooting

**"AecPropDataMgd.dll no encontrada"**
→ Verifica que las rutas de las referencias en el .csproj apuntan a tu instalación de Civil 3D 2026.

**"El Property Set 'X' no existe en el dibujo"**
→ Crea el Property Set Definition en Civil 3D antes de intentar asignarlo.

**"No se encuentran entidades al importar"**
→ Asegúrate de que el Excel fue generado desde el mismo dibujo (los Handles son específicos del dibujo).

**El plugin no aparece en la ribbon**
→ Verifica que el archivo está en la carpeta `.bundle` correcta y reinicia Civil 3D.
→ O usa `NETLOAD` para carga manual.

---

## Arquitectura del proyecto

```
EGISParameterSync_Civil3D/
├── App.cs                          # IExtensionApplication + Ribbon
├── Commands/
│   └── Commands.cs                 # Comandos AutoCAD (EGIS_EXPORT, etc.)
├── Models/
│   └── Models.cs                   # PropertySetConfig, ExportRow, ImportResult
├── Services/
│   ├── PropertySetService.cs       # API de Property Sets (leer/escribir/asignar)
│   └── ExcelService.cs             # Export/Import Excel con ClosedXML
├── UI/
│   ├── ParameterSyncControl.xaml   # Panel WPF principal
│   ├── ParameterSyncControl.xaml.cs
│   └── ParameterSyncPalette.cs     # PaletteSet dockeable (WinForms host)
├── Resources/
│   └── EGIS_PropertySets_Config.json  # JSON de ejemplo
└── PackageContents.xml             # Bundle descriptor para auto-carga
```

---

## Créditos
**EGIS Colombia** – BIM Management Toolset  
Desarrollado para proyectos ferroviarios bajo ISO 19650 y Plan BIM Chile  
Civil 3D 2026 | .NET 8 | ClosedXML | AEC Property Data API
