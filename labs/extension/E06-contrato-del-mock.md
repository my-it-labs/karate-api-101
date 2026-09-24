# E06 — El mock también valida

[← Página anterior](E05-usuarios-y-tags.md) · [Siguiente página →](../../README.md)

> Extensión del temario. El recorrido principal termina en M07. Esto es para cuando ya lo has cerrado.

### Objetivo

Vas a hacer que el mock de pedidos rechace un POST incompleto, y vas a cubrir esa respuesta con un Scenario.

### Prerrequisitos

- M07-01: existen `mock/pedidos.feature` y `features/m07/pedidos.feature`.

### 1 — 400 si falta cantidad

**Acción:** En `src/test/java/mock/pedidos.feature`, sustituye el Scenario del POST por este. Tiene que seguir **antes** del `Scenario:` vacío del 404:

```gherkin
  Scenario: pathMatches('/pedidos') && methodIs('post')
    * def responseStatus = request.cantidad ? 201 : 400
    * def response = responseStatus == 201 ? { id: '88', estado: 'creado' } : { mensaje: 'cantidad obligatoria' }
```

Si el cuerpo trae `cantidad`, responde 201. Si no, 400 y un mensaje. El catch-all no debe adelantarse a este Scenario.

### 2 — El test del 400

**Acción:** En `features/m07/pedidos.feature`, pega este Scenario al final:

```gherkin
  Scenario: POST sin cantidad
    Given path 'pedidos'
    And request { productoId: 1 }
    When method post
    Then status 400
    And match response.mensaje == 'cantidad obligatoria'
```

El `request` no lleva `cantidad`. El Scenario de M07-01 que sí la lleva tiene que seguir en 201.

```bash
mvn test -Dkarate.options="--tags @m07"
```

**Resultado esperado:** el POST bueno sigue verde y este nuevo también. El 400 es el resultado que esperas.

## Reto

### 1 — cantidad 0 también es válida

`request.cantidad ? 201 : 400` trata el `0` como vacío. Si quieres aceptar cantidad 0, la condición pasa a comprobar que el campo existe:

```gherkin
    * def responseStatus = karate.get('request.cantidad') != null ? 201 : 400
```

No hace falta dejarlo así para cerrar el lab. Con la versión del paso 1, `{ cantidad: 2 }` sigue en 201 y sin el campo sigue en 400.

## Errores frecuentes

| Síntoma | Causa probable | Cómo arreglarlo |
|---------|----------------|-----------------|
| El POST bueno ahora es 400 | El Scenario nuevo sustituyó al de 201, o la condición está al revés | El POST con `cantidad` tiene que evaluar a 201 |
| Sigues en 201 sin cantidad | El Scenario viejo del POST sigue encima y casa antes | Un solo Scenario `methodIs('post')` |
| 404 en vez de 400 | El catch-all está antes del POST | `Scenario:` vacío, el último |
