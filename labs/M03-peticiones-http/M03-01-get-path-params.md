# M03-01 — GET, path y params

[← Página anterior](README.md) · [Siguiente página →](M03-02-post-put-patch-delete.md)

> El concepto está en el [README del módulo](README.md). Aquí lo montas tú.

### Objetivo

Vas a escribir GET contra la tienda con `path` y `param`, y cubrir 200 y 404.

### Prerrequisitos

- M01 y M02 hechos.

### En qué consiste

Vas a crear `features/m03/get.feature` y ir pegando escenarios.

### 1 — Listar productos

**Acción:** Crea `src/test/java/features/m03/get.feature` y pega esto:

```gherkin
@m03 @http-get
Feature: Peticiones GET contra la tienda

  Background:
    Given url baseUrl

  Scenario: Listar todos los productos
    And path 'productos'
    When method get
    Then status 200
    And match response == '#[3]'
    And match response[0].id == 1
```

`url baseUrl` sale de `karate-config.js`. `path 'productos'` (sin barra delante) pide el listado. `'#[3]'` exige 3 elementos.

```bash
mvn test -Dkarate.options="--tags @http-get"
```

**Resultado esperado:** 1 escenario verde.

### 2 — Path y query

**Acción:** Debajo del Scenario anterior, pega estos dos:

```gherkin
  Scenario: Obtener un producto por path
    And path 'productos', 2
    When method get
    Then status 200
    And match response.nombre == 'Monitor'
    And match response.categoria == 'pantalla'

  Scenario: Filtrar por query param
    And path 'productos'
    And param categoria = 'periferico'
    When method get
    Then status 200
    And match response == '#[2]'
    And match each response contains { categoria: 'periferico' }
```

`path 'productos', 2` arma `/productos/2`. `param categoria = 'periferico'` va a la query (`?categoria=periferico`) y tiene que ir **antes** de `method get`. `match each` recorre los dos resultados.

**Resultado esperado:** 3 escenarios verdes.

### 3 — 404

**Acción:** Pega este Scenario al final:

```gherkin
  Scenario: Producto que no existe
    And path 'productos', 999
    When method get
    Then status 404
    And match response.mensaje == 'Producto no encontrado'
```

El 404 aquí es el resultado que esperas, no un fallo del test.

**Resultado esperado:** 4 escenarios verdes. En el informe, el path 2 muestra el JSON del Monitor.

### 4 — Usuario

**Acción:** Pega este Scenario al final:

```gherkin
  Scenario: Usuaria por id
    And path 'usuarios', 1
    When method get
    Then status 200
    And match response.nombre == 'Ana'
```

**Resultado esperado:** 5 escenarios verdes.

## Comprueba tu entendimiento

**404 de usuario**

Pega este Scenario, lánzalo y déjalo:

```gherkin
  Scenario: Usuario que no existe
    And path 'usuarios', 9
    When method get
    Then status 404
    And match response.mensaje == 'Usuario no encontrado'
```

## Reto

### 1 — Filtro vacío

Pega este Scenario:

```gherkin
  Scenario: Categoria que no existe
    And path 'productos'
    And param categoria = 'audio'
    When method get
    Then status 200
    And match response == '#[0]'
```

`'#[0]'` es una lista vacía. El mock filtra; no hay categoría `audio`, y responde 200, no 404.

**Resultado esperado:** el Scenario queda verde.

## Errores frecuentes

| Síntoma | Causa probable | Cómo arreglarlo |
|---------|----------------|-----------------|
| `404 Ruta no mockeada` | `path '/productos'` | `path 'productos'` |
| Connection refused | Host escrito a mano | `url baseUrl` |
| El filtro devuelve 3 | El param va después del GET | `param` antes de `method get` |
