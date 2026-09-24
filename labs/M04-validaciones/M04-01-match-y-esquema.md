# M04-01 — match y esquema

[← Página anterior](README.md) · [Siguiente página →](M04-02-listas-jsonpath.md)

> El concepto está en el [README del módulo](README.md). Aquí lo montas tú.

### Objetivo

Vas a validar un JSON con igualdad, `contains` y un esquema de tipos.

### Prerrequisitos

- M03 hecho.

### En qué consiste

Vas a crear `features/m04/match.feature`.

### 1 — Background y igualdad

**Acción:** Crea `src/test/java/features/m04/match.feature` y pega esto:

```gherkin
@m04 @validaciones
Feature: match sobre un producto

  Background:
    Given url baseUrl
    And path 'productos', 1
    When method get
    Then status 200

  Scenario: Igualdad estricta de campos conocidos
    And match response.nombre == 'Teclado'
    And match response.precio == 25
    And match response.id == '#number'
```

El Background deja en `response` el Teclado. `'#number'` comprueba el tipo de `id`, no un valor concreto.

```bash
mvn test -Dkarate.options="--tags @validaciones"
```

**Resultado esperado:** 1 verde.

### 2 — contains y esquema

**Acción:** Debajo, pega estos dos Scenario:

```gherkin
  Scenario: Contiene un subconjunto de campos
    And match response contains { id: 1, categoria: 'periferico' }

  Scenario: El documento completo respeta el esquema
    And match response ==
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

`contains` mira solo esas dos claves e ignora el resto. `== { ... }` exige **exactamente** esas cinco claves. Si el mock añade un campo, este Scenario se pone rojo.

**Resultado esperado:** 3 verdes.

### 3 — Romper el esquema

**Acción:** Dentro del objeto del esquema, añade esta línea y relanza:

```gherkin
        color: '#string',
```

Falla porque el Teclado no tiene `color`. Quítala y vuelve a lanzar.

**Resultado esperado:** rojo y otra vez verde.

### 4 — Esquema de usuaria

**Acción:** El Background se quedó en `/productos/1`. En un Scenario nuevo tienes que volver a pedir la URL. Pega esto:

```gherkin
  Scenario: Esquema de la usuaria
    Given url baseUrl
    And path 'usuarios', 1
    When method get
    Then status 200
    And match response ==
      """
      {
        id: '#number',
        nombre: '#string',
        rol: '#string',
        activo: '#boolean'
      }
      """
```

`Given url baseUrl` aquí dentro sustituye el path del Background para este Scenario.

**Resultado esperado:** 4 verdes.

## Comprueba tu entendimiento

`contains` ignora claves de más. `==` con el objeto del esquema no las ignora: tienen que ser exactamente esas.

## Reto

### 1 — Precio positivo

Dentro del Scenario de igualdad, pega estas dos líneas:

```gherkin
    And match response.precio == '#number'
    And assert response.precio > 0
```

`assert` es una condición JavaScript. El precio del Teclado es 25, así que pasa.

## Errores frecuentes

| Síntoma | Causa probable | Cómo arreglarlo |
|---------|----------------|-----------------|
| `precio` como `'#string'` | Marcador equivocado | `'#number'` |
| El GET de usuario sigue yendo a productos | El path del Background se queda | `Given url baseUrl` y `path 'usuarios', 1` en ese Scenario |
