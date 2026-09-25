# C03 — Alta, cambio y baja

[← Página anterior](C02-ficha.md) · [Siguiente página →](C04-personas.md)

El mock no guarda nada. Cada verbo se comprueba en **su** respuesta. Al final miras el catálogo y tiene que seguir igual.

### 1 — Cabecera y alta

Crea `src/test/java/features/casos/altas.feature`. En el Background, además de `url baseUrl`, manda `Content-Type` `application/json`. El primer Scenario es un POST de un Dock USB. La tienda siempre contesta `id` 99.

<details>
<summary>Ver solución</summary>

```gherkin
@casos @altas
Feature: Alta cambio y baja

  Background:
    Given url baseUrl
    And header Content-Type = 'application/json'

  Scenario: Alta de un Dock
    And path 'productos'
    And request { nombre: 'Dock USB', precio: 60, categoria: 'periferico', stock: 5 }
    When method post
    Then status 201
    And match response.id == 99
    And match response.nombre == 'Dock USB'
    And match response.precio == 60
```

`request` es el cuerpo. No hagas un GET después para «ver si se guardó»: no se guarda.

</details>

```bash
mvn test -Dkarate.options="--tags @altas"
```

### 2 — Sustituir y tocar el stock

Añade dos Scenario. El PUT reemplaza el producto 1 por un teclado mecánico (precio 90, stock 3). El PATCH del producto 3 manda solo `{ stock: 1 }`.

<details>
<summary>Ver solución</summary>

```gherkin
  Scenario: Sustituir el producto 1
    And path 'productos', 1
    And request { nombre: 'Teclado mecanico', precio: 90, categoria: 'periferico', stock: 3 }
    When method put
    Then status 200
    And match response.id == 1
    And match response.nombre == 'Teclado mecanico'

  Scenario: La Webcam queda con una unidad
    And path 'productos', 3
    And request { stock: 1 }
    When method patch
    Then status 200
    And match response.id == 3
    And match response.stock == 1
```

</details>

### 3 — La baja

DELETE del producto 2. En esta tienda el código es **204**, no 200.

<details>
<summary>Ver solución</summary>

```gherkin
  Scenario: Baja del Monitor
    And path 'productos', 2
    When method delete
    Then status 204
```

</details>

### 4 — El catálogo no cambió

Un último GET a `/productos`. Siguen siendo tres: Teclado, Monitor, Webcam. El Dock del POST no está.

<details>
<summary>Ver solución</summary>

```gherkin
  Scenario: El catalogo no guardo el alta
    And path 'productos'
    When method get
    Then status 200
    And match response == '#[3]'
    And match response[0].nombre == 'Teclado'
    And match response[1].nombre == 'Monitor'
    And match response[2].nombre == 'Webcam'
```

</details>

```bash
mvn test -Dkarate.options="--tags @altas"
```

5 verdes.
