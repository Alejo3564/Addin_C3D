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


```

---

## Créditos
**EGIS Colombia** – BIM Management Toolset  
Desarrollado para proyectos ferroviarios  
Civil 3D 2026 | .NET 8 | ClosedXML | AEC Property Data API
