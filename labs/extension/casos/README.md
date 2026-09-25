# Casos de negocio — API de la tienda

[← Página anterior](../E07-github-actions-pages.md) · [Siguiente página →](C01-inventario.md)

El recorrido del curso acaba en M07. Aquí practicas con un supuesto: la tienda **Norte**. Cada caso te lleva de la mano. El código llega **por partes**. Si te atascas, abre **Ver solución** y pega ese bloque.

La API ya está en `src/test/java/mock/tienda.feature`. No la reescribes. Si no ves `/resumen` o `precioMax`, haz `git pull`.

## Datos que vas a encontrar

| id | nombre | precio | categoria | stock |
|----|--------|--------|-----------|-------|
| 1 | Teclado | 25 | periferico | 10 |
| 2 | Monitor | 180 | pantalla | 4 |
| 3 | Webcam | 45 | periferico | 8 |

| id | nombre | rol | activo |
|----|--------|-----|--------|
| 1 | Ana | ops | true |
| 2 | Luis | dev | false |

Unidades: 10 + 4 + 8 = **22**. Periféricos: **2**. El mock no guarda lo que das de alta.

## API

`url baseUrl`. El `path` va sin barra inicial.

| Petición | Respuesta |
|----------|-----------|
| `GET /productos` | 200, 3 productos |
| `GET /productos?categoria=periferico` | 200, 2. `audio` → 200 y lista vacía |
| `GET /productos?precioMax=50` | 200, Teclado y Webcam |
| `GET /productos/2` | 200, Monitor. Id 999 → 404 |
| `POST /productos` | 201, `id` 99 |
| `PUT /productos/1` | 200, el cuerpo, con ese id |
| `PATCH /productos/3` `{ stock: 1 }` | 200 |
| `DELETE /productos/2` | 204 |
| `GET /usuarios` | 200, Ana y Luis |
| `GET /usuarios/1` | 200, Ana. Id 9 → 404 |
| `GET /resumen` | `{ productos: 3, unidades: 22, perifericos: 2 }` |

Los pedidos se prueban con el mock de M07, no con `baseUrl`.

| Caso | Qué vas a ir montando |
|------|------------------------|
| C01 | [Inventario y cifras](C01-inventario.md) |
| C02 | [Ficha](C02-ficha.md) |
| C03 | [Alta, cambio y baja](C03-altas.md) |
| C04 | [Personas](C04-personas.md) |
| C05 | [Pedido](C05-pedido.md) |

→ Empieza por **[C01 — Inventario y cifras](C01-inventario.md)**.
