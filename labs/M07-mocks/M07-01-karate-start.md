# M07-01 — karate.start

[← Página anterior](README.md) · [Siguiente página →](../extension/README.md)

> El concepto está en el [README del módulo](README.md). Aquí lo montas tú.

### Objetivo

Vas a escribir un mock propio y un feature que lo arranca. No uses `baseUrl` de la tienda.

### Prerrequisitos

- M06 hecho.

### En qué consiste

Vas a crear `mock/pedidos.feature` y `features/m07/pedidos.feature`.

### 1 — El mock

**Acción:** Crea `src/test/java/mock/pedidos.feature` (junto a `tienda.feature`, **no** bajo `features/`) y pega esto:

```gherkin
Feature: Mock mínimo de pedidos

  Background:
    * configure cors = true

  Scenario: pathMatches('/pedidos/{id}') && methodIs('get')
    * def response =
      """
      {
        id: '#(pathParams.id)',
        estado: 'enviado',
        items: 2
      }
      """

  Scenario: pathMatches('/pedidos') && methodIs('post')
    * def responseStatus = 201
    * def response = { id: '88', estado: 'creado' }

  Scenario:
    * def responseStatus = 404
    * def response = { mensaje: 'Pedido no mockeado' }
```

La primera línea de cada Scenario (`pathMatches` …) es la ruta, no un paso de test. `'#(pathParams.id)'` copia el id de la URL. El último `Scenario:` no tiene condición: es el 404 de cualquier otra ruta, y tiene que ir **el último**.

**Por qué:** Si este fichero vive bajo `features/`, el runner lo ejecuta como test.

**Resultado esperado:** el fichero está en `mock/`. Todavía no hay test cliente.

### 2 — El feature cliente

**Acción:** Crea `src/test/java/features/m07/pedidos.feature` y pega esto:

```gherkin
@m07
Feature: Arrancar un mock propio con karate.start

  Background:
    * def mock = karate.start('classpath:mock/pedidos.feature')
    * url 'http://localhost:' + mock.port

  Scenario: Consultar un pedido mockeado
    Given path 'pedidos', 77
    When method get
    Then status 200
    And match response.id == '77'
    And match response.estado == 'enviado'

  Scenario: Crear un pedido mockeado
    Given path 'pedidos'
    And request { productoId: 1, cantidad: 2 }
    When method post
    Then status 201
    And match response.estado == 'creado'
```

`karate.start` levanta **este** mock, distinto de la tienda. La URL usa `mock.port`, no `baseUrl`. `response.id` es el texto `'77'`, con comillas.

```bash
mvn test -Dkarate.options="--tags @m07"
```

**Resultado esperado:** 2 verdes.

### 3 — Suite completa

**Acción:**

```bash
mvn test
```

**Resultado esperado:** 0 failed. Cierre del laboratorio.

## Comprueba tu entendimiento

En `pedidos.feature` (el de test), pega este Scenario, lánzalo y déjalo:

```gherkin
  Scenario: Ruta que el mock no define
    Given path 'foo'
    When method get
    Then status 404
    And match response.mensaje == 'Pedido no mockeado'
```

`/foo` no casa con `/pedidos` ni con `/pedidos/{id}`, así que cae en el último Scenario del mock.

## Reto

### 1 — GET con id no es catch-all

`pathMatches('/pedidos/{id}')` casa **cualquier** id, también el `0`. Para un 404 de un pedido concreto, en el mock, **sustituye** el Scenario del GET por este:

```gherkin
  Scenario: pathMatches('/pedidos/{id}') && methodIs('get')
    * def responseStatus = pathParams.id == '0' ? 404 : 200
    * def response = responseStatus == 404 ? { mensaje: 'Pedido no encontrado' } : { id: '#(pathParams.id)', estado: 'enviado', items: 2 }
```

Y en el feature de test, pega este Scenario:

```gherkin
  Scenario: Pedido 0 no existe
    Given path 'pedidos', 0
    When method get
    Then status 404
    And match response.mensaje == 'Pedido no encontrado'
```

El catch-all sigue cubriendo rutas como `/foo`. El id `0` ya no cae ahí: lo ramifica el GET.

## Errores frecuentes

| Síntoma | Causa probable | Cómo arreglarlo |
|---------|----------------|-----------------|
| `match id == 77` falla | El mock devuelve string `'77'` | `== '77'` |
| Connection refused | Usaste `baseUrl` de la tienda | `url 'http://localhost:' + mock.port` |
| El POST cae en 404 | Catch-all antes del POST | El `Scenario:` vacío, el último |
| El mock se ejecuta como test | Está bajo `features/` | Déjalo en `mock/` |
