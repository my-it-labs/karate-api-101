# E01 — Regex, assert y funciones

[← Página anterior](README.md) · [Siguiente página →](E02-cabeceras-y-cadena.md)

> Extensión del temario. El recorrido principal termina en M07. Esto es para cuando ya lo has cerrado.

### Objetivo

Vas a afinar un `match` con `#regex` y `assert`, y vas a escribir una función de varias líneas.

### Prerrequisitos

- M02-01 verde.

### 1 — regex y assert

**Acción:** Crea `src/test/java/features/m02/expresiones.feature` y pega esto:

```gherkin
@m02 @expr
Feature: Expresiones extra del DSL

  Scenario: regex y assert
    * def nombre = 'Teclado'
    * match nombre == '#regex T.*'
    * def precio = 25
    * assert precio * 2 == 50
```

`'#regex T.*'` exige que el texto empiece por T. `assert` es una condición JavaScript: aquí 25 por 2 es 50.

```bash
mvn test -Dkarate.options="--tags @expr"
```

**Resultado esperado:** 1 escenario verde.

### 2 — Función en varias líneas

**Acción:** Debajo, pega este Scenario:

```gherkin
  Scenario: funcion JS en bloque
    * def etiqueta =
      """
      function(texto) {
        return texto.toLowerCase()
      }
      """
    * match etiqueta('Monitor') == 'monitor'
```

Las tres comillas dejan escribir la función en varias líneas. `etiqueta('Monitor')` la llama y devuelve `monitor`.

**Resultado esperado:** 2 verdes.

## Reto

### 1 — Regex que no cuadra

Cambia `'#regex T.*'` por `'#regex ^M.*'`, lanza `@expr` y mira el rojo. Restaura `'#regex T.*'`.

`^M` pide que empiece por M. `Teclado` no empieza por M.

## Errores frecuentes

| Síntoma | Causa probable | Cómo arreglarlo |
|---------|----------------|-----------------|
| `#regex` compara el texto `#regex T.*` | Faltan las comillas del marcador | `match nombre == '#regex T.*'` |
| `assert` no falla cuando debería | Usaste `match` con una suma entre comillas | `assert precio * 2 == 50` |
