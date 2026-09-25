# C01 — Inventario y cifras

[← Página anterior](README.md) · [Siguiente página →](C02-ficha.md)

Almacén quiere ver el catálogo, los periféricos, lo que cuesta como mucho 50, y las cifras del resumen. Vas a dejar un feature y a ir añadiendo un Scenario cada vez.

### 1 — El fichero y el catálogo

Crea `src/test/java/features/casos/inventario.feature`. Empieza por el esqueleto y un solo Scenario: `GET /productos`, 200, tres elementos, el primero se llama Teclado.

<details>
<summary>Ver solución</summary>

```gherkin
@casos @inventario
Feature: Inventario de la tienda Norte

  Background:
    Given url baseUrl

  Scenario: El catalogo tiene tres productos
    And path 'productos'
    When method get
    Then status 200
    And match response == '#[3]'
    And match response[0].nombre == 'Teclado'
```

`url baseUrl` sale de tu `karate-config.js`. `'#[3]'` es «lista de tres».

</details>

```bash
mvn test -Dkarate.options="--tags @inventario"
```

Tiene que salir 1 escenario verde.

### 2 — Solo periféricos

Añade otro Scenario. El filtro es un `param` **antes** del GET: categoría `periferico`. Tienen que volver 2, y los dos con esa categoría.

<details>
<summary>Ver solución</summary>

```gherkin
  Scenario: Perifericos
    And path 'productos'
    And param categoria = 'periferico'
    When method get
    Then status 200
    And match response == '#[2]'
    And match each response contains { categoria: 'periferico' }
```

</details>

Relanza `@inventario`. Ahora son 2 verdes.

### 3 — Precio máximo 50

Otro Scenario. El param se llama `precioMax` y vale `50`. Entran Teclado (25) y Webcam (45). El Monitor (180) no.

<details>
<summary>Ver solución</summary>

```gherkin
  Scenario: Precio maximo 50
    And path 'productos'
    And param precioMax = 50
    When method get
    Then status 200
    And match response == '#[2]'
    And match response[*].nombre contains 'Teclado'
    And match response[*].nombre contains 'Webcam'
    And match response[*].nombre !contains 'Monitor'
```

`response[*].nombre` saca la lista de nombres. `!contains` dice que el Monitor no está.

</details>

Si este Scenario devuelve 3 productos, el mock es viejo: `git pull` y vuelve a lanzar.

### 4 — Las cifras

Último Scenario de este fichero: `GET /resumen`. El negocio quiere exactamente 3 productos, 22 unidades y 2 periféricos.

<details>
<summary>Ver solución</summary>

```gherkin
  Scenario: Cifras del almacen
    And path 'resumen'
    When method get
    Then status 200
    And match response == { productos: 3, unidades: 22, perifericos: 2 }
```

22 es 10 + 4 + 8. Los periféricos son Teclado y Webcam.

</details>

```bash
mvn test -Dkarate.options="--tags @inventario"
```

4 escenarios verdes. Si `/resumen` da 404, `git pull`.
