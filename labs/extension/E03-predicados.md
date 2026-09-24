# E03 — Predicados y contains only

[← Página anterior](E02-cabeceras-y-cadena.md) · [Siguiente página →](E04-call-tabla.md)

> Extensión del temario. El recorrido principal termina en M07. Esto es para cuando ya lo has cerrado.

### Objetivo

Vas a comprobar reglas sobre un número (`#?`) y vas a exigir que el JSON no traiga claves de más.

### Prerrequisitos

- M04-02 verde.

### 1 — Predicados

**Acción:** Crea `src/test/java/features/m04/predicados.feature` y pega esto:

```gherkin
@m04 @predicados
Feature: Predicados sobre numeros

  Background:
    Given url baseUrl
    And path 'productos', 2
    When method get
    Then status 200

  Scenario: precio positivo y stock no negativo
    And match response.nombre == '#regex M.*'
    And match response.precio == '#number'
    And match response.precio == '#? _ > 0'
    And match response.stock == '#? _ >= 0'
```

`#regex M.*` pide que el nombre empiece por M (Monitor). `#? _ > 0` es una condición sobre el valor: `_` es el número que estás mirando. El precio del Monitor es 180.

```bash
mvn test -Dkarate.options="--tags @predicados"
```

**Resultado esperado:** 1 verde.

### 2 — contains only

**Acción:** Pega este Scenario. `contains only` falla si aparece una clave que no está en la lista:

```gherkin
  Scenario: El producto no trae claves de mas
    And match response contains only
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

`contains` dejaría pasar un campo extra. `contains only` no.

**Resultado esperado:** 2 verdes.

## Reto

### 1 — Predicado que falla

En el primer Scenario cambia `#? _ > 0` por `#? _ > 1000`, lanza `@predicados` y restaura `#? _ > 0`.

180 no es mayor que 1000, así que esa línea se pone roja y el resto del Scenario también.

## Errores frecuentes

| Síntoma | Causa probable | Cómo arreglarlo |
|---------|----------------|-----------------|
| `#?` se lee como texto | Faltan comillas | `'#? _ > 0'` |
| `contains only` falla con el esquema bueno | Sobran o faltan claves respecto al mock | Las cinco del catálogo: id, nombre, precio, categoria, stock |
