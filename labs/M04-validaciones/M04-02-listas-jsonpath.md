# M04-02 — Listas y JSONPath

[← Página anterior](M04-01-match-y-esquema.md) · [Siguiente página →](../M05-reutilizacion/README.md)

> El concepto está en el [README del módulo](README.md). Aquí lo montas tú.

### Objetivo

Vas a validar un array con `match each` y localizar un valor con JSONPath.

### Prerrequisitos

- M04-01 hecho.

### En qué consiste

Vas a crear `features/m04/listas.feature`.

### 1 — Tamaño y esquema de cada elemento

**Acción:** Crea `src/test/java/features/m04/listas.feature` y pega esto:

```gherkin
@m04 @listas
Feature: Validar listas y cada elemento

  Background:
    Given url baseUrl
    And path 'productos'
    When method get
    Then status 200

  Scenario: Tamaño y primer elemento
    And match response == '#[3]'
    And match response[0].nombre == 'Teclado'

  Scenario: Cada producto tiene la misma forma
    And match each response ==
      """
      {
        id: '#number',
        nombre: '#string',
        precio: '#number',
        categoria: '#string',
        stock: '#number'
      }
      """
```

`'#[3]'` es «array de 3». `response[0]` es el primero. `match each` aplica el esquema a **cada** elemento de la lista.

```bash
mvn test -Dkarate.options="--tags @listas"
```

**Resultado esperado:** 2 verdes.

### 2 — JSONPath

**Acción:** Pega este Scenario al final:

```gherkin
  Scenario: JSONPath sobre la lista
    And match response[*].id contains 2
    And match response[*].categoria contains 'pantalla'
    And match response[*].nombre contains 'Webcam'
```

`response[*].id` saca la lista de ids. `contains 2` comprueba que el 2 está en esa lista.

**Resultado esperado:** 3 verdes.

## Comprueba tu entendimiento

Cambia `'#[3]'` por `'#[4]'` → rojo. Restaura `'#[3]'`.

## Reto

### 1 — Cada stock es número positivo

Dentro del Scenario de JSONPath, pega estas dos líneas:

```gherkin
    And match each response[*].stock == '#number'
    And match each response[*].stock == '#? _ > 0'
```

`#? _ > 0` es un predicado: cada `stock` tiene que ser mayor que 0.

## Errores frecuentes

| Síntoma | Causa probable | Cómo arreglarlo |
|---------|----------------|-----------------|
| `match each` sobre un objeto | Lo aplicaste a `/productos/1` | `each` es para arrays |
| JSONPath vacío | `response.id[*]` | `response[*].id` |
