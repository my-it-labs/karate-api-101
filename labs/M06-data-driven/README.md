# M06 — Data-driven

[← Página anterior](../M05-reutilizacion/M05-01-call-y-config.md) · [Siguiente página →](M06-01-tablas-csv-json.md)

> [!NOTE]
> Primero ves cómo un Outline recorre filas. En el laboratorio montas tú la tabla, el CSV y el JSON.

## Qué vas a hacer

- Escribir un `Scenario Outline` con `Examples`.
- Cargar las filas desde un CSV y desde un JSON.

## Una fila, un Scenario

El Outline es el **mismo** Scenario repetido. `<id>` se sustituye antes de ejecutar.

| Fuente | Dónde lo pones |
|--------|----------------|
| Tabla embebida | Bajo `Examples:` en el feature |
| CSV | `Examples: \| read('productos.csv') \|` |
| JSON | `Examples: \| read('casos.json') \|` |

Las columnas tienen que llamarse como los placeholders. El CSV y el JSON van **junto** al feature.

Los números van **sin** comillas: `response.precio == <precio>`, no `'<precio>'`.

## Cómo encaja

Un Outline embebido recorrerá los tres productos. Otro leerá `productos.csv` (precios) y `casos.json` (nombres). Si una fila falla, las demás pueden seguir verdes.

## Ahora te toca a ti

| Lab | Título | Qué vas a montar |
|-----|--------|------------------|
| M06-01 | [Tablas, CSV y JSON](M06-01-tablas-csv-json.md) | Outlines y ficheros de datos |

→ Empieza por **[M06-01 — Tablas, CSV y JSON](M06-01-tablas-csv-json.md)**.
