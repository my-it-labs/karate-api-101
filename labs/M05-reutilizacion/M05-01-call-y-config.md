# M05-01 — call y config

[← Página anterior](README.md) · [Siguiente página →](../M06-data-driven/README.md)

> El concepto está en el [README del módulo](README.md). Aquí lo montas tú.

### Objetivo

Vas a reutilizar un GET con `call` sin duplicar `url` / `path`.

### Prerrequisitos

- M04 hecho.

### En qué consiste

Vas a crear el helper y el feature que lo llama.

### 1 — Helper

**Acción:** Crea `src/test/java/features/helpers/get-producto.feature` y pega esto:

```gherkin
@ignore
Feature: Helper — obtener un producto por id

  Scenario:
    Given url baseUrl
    And path 'productos', id
    When method get
    Then status 200
```

`@ignore` evita que el suite lo lance solo. `id` no está escrito aquí: lo recibirá el `call`. Sin `@ignore`, Karate intenta ejecutarlo y `id` no existe.

**Resultado esperado:** el fichero existe. `mvn test` no lo cuenta como test.

### 2 — call.feature

**Acción:** Crea `src/test/java/features/m05/call.feature` y pega esto:

```gherkin
@m05
Feature: Reutilizar un escenario con call

  Scenario: call pasa el id y devuelve la respuesta
    * def llamado = call read('classpath:features/helpers/get-producto.feature') { id: 2 }
    * match llamado.response.nombre == 'Monitor'
    * match llamado.response.id == 2

  Scenario: call otra vez con otro id
    * def llamado = call read('classpath:features/helpers/get-producto.feature') { id: 1 }
    * match llamado.response.nombre == 'Teclado'
```

`call read('...') { id: 2 }` ejecuta el helper y le pasa `id`. `llamado.response` es el JSON que devolvió ese GET.

```bash
mvn test -Dkarate.options="--tags @m05"
```

**Resultado esperado:** 2 verdes. El helper no sale como feature independiente en el summary.

### 3 — Helper de usuario

**Acción:** Crea `src/test/java/features/helpers/get-usuario.feature` y pega esto:

```gherkin
@ignore
Feature: Helper — obtener un usuario por id

  Scenario:
    Given url baseUrl
    And path 'usuarios', id
    When method get
    Then status 200
```

En `call.feature`, pega este Scenario al final:

```gherkin
  Scenario: call de usuaria
    * def llamado = call read('classpath:features/helpers/get-usuario.feature') { id: 1 }
    * match llamado.response.nombre == 'Ana'
```

**Resultado esperado:** 3 verdes.

## Comprueba tu entendimiento

Si `callSingle` del mock en `karate-config.js` fallara, todos los features HTTP se caen. M02 no usa `baseUrl`.

## Reto

### 1 — GET 404 reutilizado

El helper de producto exige `status 200`. Para el 999 no lo uses. Pega este Scenario en `call.feature`:

```gherkin
  Scenario: producto que no existe, sin helper
    Given url baseUrl
    And path 'productos', 999
    When method get
    Then status 404
    And match response.mensaje == 'Producto no encontrado'
```

## Errores frecuentes

| Síntoma | Causa probable | Cómo arreglarlo |
|---------|----------------|-----------------|
| `id is not defined` | Helper sin `@ignore` / sin `call` | `@ignore` + `{ id: n }` |
| `read` no encuentra el fichero | Path relativo mal | `classpath:features/helpers/get-producto.feature` |
