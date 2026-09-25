# C02 — Ficha de producto

[← Página anterior](C01-inventario.md) · [Siguiente página →](C03-altas.md)

La ficha es `GET /productos/{id}`. Vas a pedir el Monitor, luego un id que no existe, y al final abrir la ficha usando el id que devolvió el listado.

### 1 — Ficha del Monitor

Crea `src/test/java/features/casos/ficha.feature`. El path lleva dos trozos: `'productos'` y `2`. Comprueba id, nombre, precio, categoría, y que el stock sea mayor que 0.

<details>
<summary>Ver solución</summary>

```gherkin
@casos @ficha
Feature: Ficha de producto

  Background:
    Given url baseUrl

  Scenario: Ficha del Monitor
    And path 'productos', 2
    When method get
    Then status 200
    And match response.id == 2
    And match response.nombre == 'Monitor'
    And match response.precio == 180
    And match response.categoria == 'pantalla'
    And match response.stock == '#? _ > 0'
```

`path 'productos', 2` arma `/productos/2`. `'#? _ > 0'` mira el número: `_` es el stock.

</details>

```bash
mvn test -Dkarate.options="--tags @ficha"
```

### 2 — Un id que no está

Añade un Scenario para el id `999`. El negocio no quiere un 200 vacío: quiere 404 y el mensaje `Producto no encontrado`. Ese 404 es el resultado correcto del test.

<details>
<summary>Ver solución</summary>

```gherkin
  Scenario: El id 999 no esta en catalogo
    And path 'productos', 999
    When method get
    Then status 404
    And match response.mensaje == 'Producto no encontrado'
```

</details>

### 3 — Del listado a la ficha

No escribas el id a mano. Primero pide el catálogo, guarda `response[0].id` y `response[0].nombre`, y con un segundo GET abre esa ficha. El `url baseUrl` del Background sigue valiendo: solo cambias el path.

<details>
<summary>Ver solución</summary>

```gherkin
  Scenario: Del listado se abre la ficha del primero
    And path 'productos'
    When method get
    Then status 200
    * def id = response[0].id
    * def nombre = response[0].nombre
    Given path 'productos', id
    When method get
    Then status 200
    And match response.nombre == nombre
    And match response.id == id
```

El primero es el Teclado, id 1.

</details>

```bash
mvn test -Dkarate.options="--tags @ficha"
```

3 verdes.
