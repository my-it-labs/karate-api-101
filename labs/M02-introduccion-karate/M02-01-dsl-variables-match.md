# M02-01 — DSL, variables y match

[← Página anterior](README.md) · [Siguiente página →](../M03-peticiones-http/README.md)

> El concepto está en el [README del módulo](README.md). Aquí lo montas tú.

### Objetivo

Vas a crear un feature sin HTTP, ejecutarlo por tag y distinguir un `match` de valor de un `match` de tipo.

### Prerrequisitos

- M01 hecho (`hola.feature` y `@smoke` en verde).

### En qué consiste

Vas a crear `features/m02/dsl.feature`, lanzarlo, provocar un fallo a propósito y añadir un escenario.

### 1 — Crear el fichero

**Acción:** Crea la carpeta `src/test/java/features/m02/` y el fichero `dsl.feature`. Pega esto (todavía sin Scenario):

```gherkin
@m02
Feature: DSL de Karate sin HTTP

  Background:
    * def iva = 0.21
    * def conIva = function(precio){ return precio * (1 + iva) }
```

`@m02` es el tag con el que lo vas a lanzar. El `Background` se ejecuta antes de cada Scenario: deja `iva` y la función `conIva`.

**Resultado esperado:** el fichero existe y no tiene Scenario. `mvn test -Dkarate.options="--tags @m02"` puede decir 0 escenarios.

### 2 — Scenario de variables

**Acción:** Debajo del Background, pega este Scenario:

```gherkin
  Scenario: Variables, tipos y match
    Given def nombre = 'Teclado'
    And def precio = 25
    And def etiquetas = ['periferico', 'usb']
    And def producto = { nombre: 'Teclado', precio: 25, stock: 10 }
    Then match nombre == 'Teclado'
    And match precio == 25
    And match etiquetas == '#array'
    And match etiquetas == '#[2]'
    And match producto == '#object'
    And match producto.stock == '#number'
```

`def` declara la variable. `== 'Teclado'` y `== 25` comparan el valor. `'#array'`, `'#[2]'`, `'#object'` y `'#number'` comprueban el tipo, no el texto.

```bash
mvn test -Dkarate.options="--tags @m02"
```

**Resultado esperado:** `failed: 0` con 1 escenario.

### 3 — Ver un match fallar

**Acción:** En el Scenario, cambia esta línea:

```gherkin
    Then match nombre == 'Teclado'
```

por esta:

```gherkin
    Then match nombre == 'Raton'
```

Lanza otra vez `@m02`. En el informe verás actual `Teclado` y esperado `Raton`. Restaura `'Teclado'`.

**Resultado esperado:** `BUILD FAILURE` y, al restaurar, otra vez verde.

### 4 — Marcadores de tipo de más

**Acción:** Al final del mismo Scenario, pega estas dos líneas:

```gherkin
    And match producto.nombre == '#string'
    And match etiquetas[0] == '#string'
```

`'#string'` no es la palabra string: es el marcador de «esto es un texto».

```bash
mvn test -Dkarate.options="--tags @m02"
```

**Resultado esperado:** sigue verde.

## Comprueba tu entendimiento

**Classpath**

`mvn test -Dkarate.options="classpath:features/m02/dsl.feature"`

→ Equivale a `--tags @m02` mientras solo tengas este feature en m02.

## Reto

### 1 — Función `conIva(25)`

Debajo del Scenario anterior, pega este:

```gherkin
  Scenario: IVA de un teclado
    When def resultado = conIva(25)
    Then match resultado == 30.25
```

`conIva` es la función del Background. `25 * 1.21` es `30.25`.

```bash
mvn test -Dkarate.options="--tags @m02"
```

**Resultado esperado:** 2 escenarios verdes.

## Errores frecuentes

| Síntoma | Causa probable | Cómo arreglarlo |
|---------|----------------|-----------------|
| El fichero ya existía completo | Codespace desde `example` | Recrea el Codespace desde `main` |
| `match` trata `'#string'` como texto vs `Teclado` | Faltan comillas del marcador o usaste `=` | `match x == '#string'` |
| `@m02` no corre nada | El feature no está bajo `features/` | `src/test/java/features/m02/dsl.feature` |
