# M03 — Peticiones HTTP

[← Página anterior](../M02-introduccion-karate/M02-01-dsl-variables-match.md) · [Siguiente página →](M03-01-get-path-params.md)

> [!NOTE]
> Primero ves cómo se arma un GET/POST. En el laboratorio escribes tú los features contra la tienda.

## Qué vas a hacer

- Encadenar `url`, `path`, `param` y `header`.
- Lanzar GET, POST, PUT, PATCH y DELETE.
- Mandar un `request` JSON y asertar el `status`.
- Evitar la barra inicial en `path` (rompe la URL).

## Cómo se arma una petición

En el Background pondrás `Given url baseUrl`. Ese `baseUrl` te lo deja `karate-config.js` (el mock de tienda).

| Paso | Qué consigues |
|------|----------------|
| `url baseUrl` | Host y puerto del mock |
| `path 'productos', 2` | `/productos/2` |
| `param categoria = 'periferico'` | `?categoria=periferico` |
| `request { ... }` | Cuerpo JSON |
| `method post` | Dispara la petición |
| `status 201` | Comprueba el código |

> [!WARNING]
> `path '/productos'` (con `/` al inicio) te descuadra la URL. Usa `path 'productos'`.

GET no lleva `request`. DELETE en esta tienda responde **204** y cuerpo vacío. El mock **no guarda estado**: un POST no cambia el GET de después.

Catálogo: id 1 Teclado (periferico, 25), id 2 Monitor (pantalla, 180), id 3 Webcam (periferico, 45). Usuarias: id 1 Ana (ops), id 2 Luis (dev).

## Cómo encaja

Vas a escribir un feature de GET: listar `/productos`, pedir el id 2, filtrar por `categoria` y asertar el 404 del id 999. En el siguiente, POST (id 99 fijo), PUT, PATCH de stock y DELETE.

## Ahora te toca a ti

| Lab | Título | Qué vas a montar |
|-----|--------|------------------|
| M03-01 | [GET, path y params](M03-01-get-path-params.md) | `get.feature` |
| M03-02 | [POST PUT PATCH DELETE](M03-02-post-put-patch-delete.md) | `write.feature` |

→ Empieza por **[M03-01 — GET, path y params](M03-01-get-path-params.md)**.
