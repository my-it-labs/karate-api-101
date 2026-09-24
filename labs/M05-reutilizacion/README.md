# M05 — Reutilización (`call`)

[← Página anterior](../M04-validaciones/M04-02-listas-jsonpath.md) · [Siguiente página →](M05-01-call-y-config.md)

> [!NOTE]
> Primero ves cómo extraer un GET a un helper. En el laboratorio lo escribes tú y lo llamas con `call`.

## Qué vas a hacer

- Sacar un Scenario repetido a un feature helper.
- Llamarlo con `call read('...') { id: 2 }` y leer `llamado.response`.
- Poner `@ignore` para que el helper no se ejecute solo.
- Distinguir eso de `karate-config.js` (el `baseUrl` que ya usas).

## `call` vs config

Si copias el mismo GET en tres sitios, el helper es un `.feature` que recibe variables. `call` lo ejecuta y te devuelve `response`.

| Pieza | Para qué |
|-------|----------|
| Helper GET `/productos/{id}` | Camino 200 reutilizable |
| `@ignore` | El suite no lo lanza por su cuenta |
| `call read('classpath:features/helpers/get-producto.feature') { id: 2 }` | Le pasas el `id` |
| `karate-config.js` | Config de **todo** el run (`baseUrl`); no sustituye a `call` |

## Cómo encaja

El helper usará `baseUrl` y `path 'productos', id`. Tu feature lo llamará dos veces (ids 2 y 1) y hará `match` sobre el nombre. Sin `@ignore`, Karate intentaría ejecutar el helper y `id` no existiría.

## Ahora te toca a ti

| Lab | Título | Qué vas a montar |
|-----|--------|------------------|
| M05-01 | [call y config](M05-01-call-y-config.md) | Helper + `call.feature` |

→ Empieza por **[M05-01 — call y config](M05-01-call-y-config.md)**.
