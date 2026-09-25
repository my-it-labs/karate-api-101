# C05 — Pedido

[← Página anterior](C04-personas.md) · [Siguiente página →](../../README.md)

Los pedidos no van contra la tienda. Arrancas el mock de M07 y usas su puerto. Un pedido se consulta, se crea con cantidad, se rechaza si falta la cantidad, y una ruta rara responde 404.

### 1 — El POST incompleto en el mock

Abre `src/test/java/mock/pedidos.feature`. El Scenario del POST tiene que decidir el status según haya `cantidad` o no. Si ya lo hiciste en E06, déjalo.

<details>
<summary>Ver solución</summary>

Sustituye el Scenario `methodIs('post')` por este. Tiene que quedar **antes** del `Scenario:` vacío del 404:

```gherkin
  Scenario: pathMatches('/pedidos') && methodIs('post')
    * def responseStatus = request.cantidad ? 201 : 400
    * def response = responseStatus == 201 ? { id: '88', estado: 'creado' } : { mensaje: 'cantidad obligatoria' }
```

Con `cantidad`, 201. Sin ella, 400.

</details>

### 2 — Arranque

Crea `src/test/java/features/casos/pedido.feature`. En el Background arranca el mock y apunta la URL a su puerto. No pongas `baseUrl`.

<details>
<summary>Ver solución</summary>

```gherkin
@casos @pedido
Feature: Pedido

  Background:
    * def mock = karate.start('classpath:mock/pedidos.feature')
    * url 'http://localhost:' + mock.port
```

</details>

### 3 — Consultar el 77

Un Scenario GET `pedidos`, `77`. El id que vuelve es el texto `'77'`, el estado `enviado` y `items` 2.

<details>
<summary>Ver solución</summary>

```gherkin
  Scenario: Consultar el pedido 77
    Given path 'pedidos', 77
    When method get
    Then status 200
    And match response.id == '77'
    And match response.estado == 'enviado'
    And match response.items == 2
```

</details>

```bash
mvn test -Dkarate.options="--tags @pedido"
```

### 4 — Crear y rechazar

Dos Scenario de POST. El primero manda `productoId` 1 y `cantidad` 2: 201, id `'88'`, estado `creado`. El segundo manda solo `productoId`: 400 y `cantidad obligatoria`.

<details>
<summary>Ver solución</summary>

```gherkin
  Scenario: Crear con cantidad
    Given path 'pedidos'
    And request { productoId: 1, cantidad: 2 }
    When method post
    Then status 201
    And match response.id == '88'
    And match response.estado == 'creado'

  Scenario: Sin cantidad
    Given path 'pedidos'
    And request { productoId: 1 }
    When method post
    Then status 400
    And match response.mensaje == 'cantidad obligatoria'
```

</details>

Si el segundo da 201, el mock sigue con el POST que siempre acepta. Vuelve al paso 1.

### 5 — Una ruta que no es de pedidos

GET `foo`. Cae en el último Scenario del mock: 404 y `Pedido no mockeado`.

<details>
<summary>Ver solución</summary>

```gherkin
  Scenario: Ruta desconocida
    Given path 'foo'
    When method get
    Then status 404
    And match response.mensaje == 'Pedido no mockeado'
```

</details>

```bash
mvn test -Dkarate.options="--tags @casos"
```

`@pedido` son 4 verdes. `@casos` corre este paquete entero.
