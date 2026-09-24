# M06-01 — Tablas, CSV y JSON

[← Página anterior](README.md) · [Siguiente página →](../M07-mocks/README.md)

> El concepto está en el [README del módulo](README.md). Aquí lo montas tú.

### Objetivo

Vas a repetir el mismo GET con tres fuentes: tabla, CSV y JSON.

### Prerrequisitos

- M05 hecho.

### En qué consiste

Vas a crear `features/m06/` con dos features y dos ficheros de datos.

### 1 — Tabla embebida

**Acción:** Crea `src/test/java/features/m06/tabla.feature` y pega esto:

```gherkin
@m06 @ddt-tabla
Feature: Data-driven con tabla embebida

  Background:
    Given url baseUrl

  Scenario Outline: Productos conocidos por id
    And path 'productos', <id>
    When method get
    Then status 200
    And match response.nombre == '<nombre>'
    And match response.categoria == '<categoria>'

    Examples:
      | id | nombre  | categoria  |
      | 1  | Teclado | periferico |
      | 2  | Monitor | pantalla   |
      | 3  | Webcam  | periferico |
```

El Outline es el mismo Scenario tres veces. `<id>`, `<nombre>` y `<categoria>` se sustituyen con cada fila. Los nombres van entre comillas en el `match` (`'<nombre>'`) porque son texto. El `id` del `path` va sin comillas.

```bash
mvn test -Dkarate.options="--tags @ddt-tabla"
```

**Resultado esperado:** 3 filas verdes.

### 2 — CSV y JSON

**Acción:** Crea `src/test/java/features/m06/productos.csv` (junto al feature) y pega esto:

```csv
id,nombre,precio
1,Teclado,25
2,Monitor,180
3,Webcam,45
```

Crea `src/test/java/features/m06/casos.json` y pega esto:

```json
[
  { "id": 1, "nombre": "Teclado" },
  { "id": 2, "nombre": "Monitor" }
]
```

Crea `src/test/java/features/m06/ficheros.feature` y pega esto:

```gherkin
@m06 @ddt-ficheros
Feature: Data-driven con CSV y JSON

  Background:
    Given url baseUrl

  Scenario Outline: Precios leídos de un CSV
    And path 'productos', <id>
    When method get
    Then status 200
    And match response.nombre == '<nombre>'
    And match response.precio == <precio>

    Examples:
      | read('productos.csv') |

  Scenario Outline: Nombres leídos de un JSON
    And path 'productos', <id>
    When method get
    Then status 200
    And match response.nombre == '<nombre>'

    Examples:
      | read('casos.json') |
```

`read('productos.csv')` sustituye la tabla. `<precio>` va **sin** comillas: en el CSV es un número. El JSON tiene que ser un array.

```bash
mvn test -Dkarate.options="--tags @ddt-ficheros"
```

**Resultado esperado:** 3 filas del CSV y 2 del JSON, verdes.

### 3 — Romper una fila

**Acción:** En `productos.csv`, cambia el precio del Monitor de `180` a `1`. Relanza `@ddt-ficheros`. Solo esa fila se pone roja. Restaura `180`.

**Resultado esperado:** el resto de filas siguen verdes.

## Comprueba tu entendimiento

Si escribes `match response.precio == '<precio>'` (con comillas), Karate compara el texto `"25"` con el número `25` y falla. El precio se deja así: `== <precio>`.

## Reto

### 1 — Fila id 4

Añade esta línea al final de `productos.csv`, lanza `@ddt-ficheros` y quítala:

```csv
4,Ratón,10
```

El Outline espera 200. El id 4 no existe y el mock responde 404, así que esa fila falla. Las otras siguen verdes.

## Errores frecuentes

| Síntoma | Causa probable | Cómo arreglarlo |
|---------|----------------|-----------------|
| `read` no encuentra el CSV | Otra carpeta | Junto a `ficheros.feature` |
| Todas las filas fallan | Cabecera ≠ placeholders | `id,nombre,precio` |
| JSON no expande | No es un array | `[ {...}, {...} ]` |
