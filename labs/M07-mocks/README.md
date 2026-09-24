# M07 — Mocks

[← Página anterior](../M06-data-driven/M06-01-tablas-csv-json.md) · [Siguiente página →](M07-01-karate-start.md)

> [!NOTE]
> Primero ves que un mock es otro feature. En el laboratorio escribes tú el de pedidos y el test que lo arranca.

## Qué vas a hacer

- Definir rutas con `pathMatches` / `methodIs`.
- Arrancar el mock con `karate.start('...feature')` y usar su `port`.
- Distinguir la tienda (ya la tienes) de un mock de pedidos que montas aquí.

## Un mock es un feature

Hasta ahora tus tests hablan con la tienda que arranca `karate-config.js`. Aquí levantas **otro** servidor, dentro del propio feature, para una API de pedidos que no está en la tienda.

| | Tienda | Pedidos (este módulo) |
|--|--------|------------------------|
| Cuándo arranca | `callSingle` en el config | El `Background` de **tu** feature |
| Cómo la llamas | `baseUrl` | `url 'http://localhost:' + mock.port` |
| Quién lo escribe | Ya está en `mock/tienda.feature` | Tú |

En el mock la condición no es Given/When/Then de negocio: es `pathMatches('/pedidos/{id}') && methodIs('get')`. La respuesta la asignas a `response`.

`pathParams.id` llega como **string**: `match response.id == '77'` (con comillas), o `parseInt` en el mock.

El catch-all (`Scenario:` sin condición) va **el último**.

## Cómo encaja

En el mock declararás GET `/pedidos/{id}`, POST `/pedidos` y un 404 por defecto. En el feature de test harás `karate.start`, GET al id 77 y un POST.

## Ahora te toca a ti

| Lab | Título | Qué vas a montar |
|-----|--------|------------------|
| M07-01 | [karate.start](M07-01-karate-start.md) | Mock de pedidos + feature cliente |

→ Empieza por **[M07-01 — karate.start](M07-01-karate-start.md)**.
