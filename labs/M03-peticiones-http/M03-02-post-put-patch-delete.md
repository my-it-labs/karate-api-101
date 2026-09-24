# M03-02 — POST PUT PATCH DELETE

[← Página anterior](M03-01-get-path-params.md) · [Siguiente página →](../M04-validaciones/README.md)

> El concepto está en el [README del módulo](README.md). Aquí lo montas tú.

### Objetivo

Vas a escribir los cuatro verbos de escritura y comprobar que el mock **no persiste**.

### Prerrequisitos

- M03-01 hecho.

### En qué consiste

Vas a crear `features/m03/write.feature`.

### 1 — POST

**Acción:** Crea `src/test/java/features/m03/write.feature` y pega esto:

```gherkin
@m03 @http-write
Feature: POST PUT PATCH DELETE contra la tienda

  Background:
    Given url baseUrl
    And header Content-Type = 'application/json'

  Scenario: Crear un producto
    And path 'productos'
    And request { nombre: 'Dock USB', precio: 60, categoria: 'periferico', stock: 5 }
    When method post
    Then status 201
    And match response.id == 99
    And match response.nombre == 'Dock USB'
```

`request { ... }` es el cuerpo JSON. El mock siempre responde `id` 99. Compruebas esa respuesta, no un GET posterior.

```bash
mvn test -Dkarate.options="--tags @http-write"
```

**Resultado esperado:** 1 verde.

### 2 — PUT, PATCH, DELETE

**Acción:** Debajo del POST, pega estos tres Scenario:

```gherkin
  Scenario: Reemplazar un producto
    And path 'productos', 1
    And request { nombre: 'Teclado mecanico', precio: 90, categoria: 'periferico', stock: 3 }
    When method put
    Then status 200
    And match response.nombre == 'Teclado mecanico'
    And match response.id == 1

  Scenario: Actualizar solo el stock
    And path 'productos', 3
    And request { stock: 1 }
    When method patch
    Then status 200
    And match response.stock == 1
    And match response.id == 3

  Scenario: Borrar un producto
    And path 'productos', 2
    When method delete
    Then status 204
```

PUT manda el producto entero. PATCH manda solo `{ stock: 1 }`. DELETE en esta tienda responde **204**, sin cuerpo.

**Resultado esperado:** 4 escenarios verdes.

### 3 — El catálogo no cambió

**Acción:** Sin tocar `write.feature`, lanza otra vez los GET:

```bash
mvn test -Dkarate.options="--tags @http-get"
```

El mock recarga Teclado, Monitor y Webcam en cada petición. El POST no deja un cuarto producto.

**Resultado esperado:** el listado sigue teniendo 3 productos.

## Comprueba tu entendimiento

**Header**

Quita del Background la línea `And header Content-Type = 'application/json'`, lanza `@http-write`, y vuélvela a poner.

→ En este mock suele colar. En APIs reales, no.

## Reto

### 1 — POST sin `precio`

Pega este Scenario:

```gherkin
  Scenario: Crear sin precio
    And path 'productos'
    And request { nombre: 'Cable', categoria: 'periferico', stock: 20 }
    When method post
    Then status 201
    And match response.precio == '#null'
```

`'#null'` es el marcador de «este campo viene vacío». El cuerpo no trae `precio`, así que la respuesta tampoco.

## Errores frecuentes

| Síntoma | Causa probable | Cómo arreglarlo |
|---------|----------------|-----------------|
| Esperabas 4 productos tras el POST | El mock no guarda estado | Asera el response del POST |
| DELETE con 200 | Este mock responde 204 | `status 204` |
