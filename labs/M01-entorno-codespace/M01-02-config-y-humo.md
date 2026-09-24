# M01-02 — Config y humo

[← Página anterior](M01-01-proyecto-maven.md) · [Siguiente página →](../M02-introduccion-karate/README.md)

> El concepto está en el [README del módulo](README.md). Aquí lo montas tú.

### Objetivo

Vas a enchufar el mock de tienda (ya está en `mock/`) con `karate-config.js` y pasar un GET de humo.

### Prerrequisitos

- M01-01: `mvn test` verde con `hola.feature`.

### En qué consiste

Vas a pegar `karate-config.js` (Karate lo carga solo) y `smoke.feature`.

### 1 — Qué hay en `mock/`

**Acción:** Abre `src/test/java/mock/start.js`. La línea que arranca la tienda es esta:

```javascript
var mock = karate.start('classpath:mock/tienda.feature');
```

En `mock/tienda.feature` las rutas que vas a llamar son `/productos` y `/usuarios`. No reescribes ese fichero.

**Resultado esperado:** ves productos Teclado, Monitor, Webcam. `start.js` devuelve el objeto del mock (con `.port`).

### 2 — karate-config.js

**Acción:** Crea `src/test/java/karate-config.js` (junto a la carpeta `mock/`, no dentro de `features/`) y pega esto:

```javascript
function fn() {
  var env = karate.env;
  if (!env) {
    env = 'dev';
  }

  var mock = karate.callSingle('classpath:mock/start.js');
  var config = {
    env: env,
    baseUrl: 'http://localhost:' + mock.port
  };
  return config;
}
```

`karate.env` es el entorno; si viene vacío, queda `'dev'`. `callSingle` arranca el mock **una** vez para todo el `mvn test`. `baseUrl` usa el puerto que devuelve ese mock: no lo escribes a mano. `return config` es obligatorio; si falta, el resto de features no ve `baseUrl`.

```bash
mvn test
```

**Resultado esperado:** `hola.feature` sigue verde (no usa `baseUrl`). En el log aparece `mock tienda escuchando en http://localhost:<puerto>`.

### 3 — smoke.feature

**Acción:** Crea `src/test/java/features/smoke.feature` y pega esto:

```gherkin
@smoke @m01
Feature: Humo del laboratorio

  Scenario: La API de tienda responde el catálogo
    Given url baseUrl
    And path 'productos'
    When method get
    Then status 200
    And match response == '#[3]'
    And match response[0].nombre == 'Teclado'
```

`url baseUrl` es la dirección que te dejó el config. `path 'productos'` (sin `/` delante) pide el catálogo. `'#[3]'` exige una lista de 3. `response[0].nombre` es el primer producto, Teclado.

```bash
mvn test -Dkarate.options="--tags @smoke"
```

**Resultado esperado:** 1 escenario verde. En el informe ves el JSON de tres productos. `mvn test` (sin tags) corre hola + smoke.

## Comprueba tu entendimiento

**Puerto fijo**

Si en el smoke cambias `url baseUrl` por `url 'http://localhost:8080'`…

→ *connection refused* (el puerto es aleatorio). Vuelve a dejar `url baseUrl`.

## Reto

### 1 — Humo de usuaria

En `smoke.feature`, debajo del Scenario del catálogo, pega este otro:

```gherkin
  Scenario: La usuaria 1 es Ana
    Given url baseUrl
    And path 'usuarios', 1
    When method get
    Then status 200
    And match response.nombre == 'Ana'
```

`path 'usuarios', 1` arma la ruta `/usuarios/1`.

```bash
mvn test -Dkarate.options="--tags @smoke"
```

**Resultado esperado:** 2 escenarios verdes.

## Errores frecuentes

| Síntoma | Causa probable | Cómo arreglarlo |
|---------|----------------|-----------------|
| `baseUrl` is not defined | El js no se llama `karate-config.js` o no está en `src/test/java` | Nombre y carpeta exactos |
| Mock no arranca | `callSingle` mal / `start.js` no está | `classpath:mock/start.js` |
| `404 Ruta no mockeada` | `path '/productos'` | `path 'productos'` |
| El hola ahora falla | Error de sintaxis en el config (se carga siempre) | `fn()` debe `return config` |
