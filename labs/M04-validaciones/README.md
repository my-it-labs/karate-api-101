# M04 — Validaciones

[← Página anterior](../M03-peticiones-http/M03-02-post-put-patch-delete.md) · [Siguiente página →](M04-01-match-y-esquema.md)

> [!NOTE]
> Primero ves cómo `match` describe la **forma** del JSON. En el laboratorio lo escribes tú sobre productos y listas.

## Qué vas a hacer

- Combinar igualdad, `contains` y marcadores `#string` / `#number`.
- Validar un objeto entero y cada elemento de una lista (`match each`).
- Usar JSONPath corto: `response[*].id`.

## `match` con forma, no solo un campo

Hasta ahora comprobabas un valor. En una API real te interesa el **contrato**: tipos y claves.

| Expresión | Qué compruebas |
|-----------|----------------|
| `match response.nombre == 'Teclado'` | Valor exacto |
| `match response contains { id: 1 }` | Un subconjunto de campos |
| `match response == { id: '#number', nombre: '#string', ... }` | Esquema del objeto |
| `match each response == { ... }` | El mismo esquema en **cada** elemento |
| `match response == '#[3]'` | Array de longitud 3 |
| `match response[*].id contains 2` | En la lista de ids aparece 2 |

`contains` ignora el resto de claves. El esquema con `== { ... }` exige **exactamente** esas claves.

## Cómo encaja

Un GET a `/productos/1` en el Background te dejará el Teclado. Sobre esa respuesta harás igualdad, `contains` y el esquema de cinco campos. Sobre el listado, `match each` y `response[*].categoria`.

## Ahora te toca a ti

| Lab | Título | Qué vas a montar |
|-----|--------|------------------|
| M04-01 | [match y esquema](M04-01-match-y-esquema.md) | `match.feature` |
| M04-02 | [Listas y JSONPath](M04-02-listas-jsonpath.md) | `listas.feature` |

→ Empieza por **[M04-01 — match y esquema](M04-01-match-y-esquema.md)**.
