# E02 — Cabeceras y encadenar

[← Página anterior](E01-expresiones.md) · [Siguiente página →](E03-predicados.md)

> Extensión del temario. El recorrido principal termina en M07. Esto es para cuando ya lo has cerrado.

### Objetivo

Vas a mandar cabeceras y vas a usar un campo de una respuesta en la petición siguiente.

### Prerrequisitos

- M03-02 verde. Si no ves la ruta `/eco`, haz `git pull`: el mock la trae a partir de hoy.

### 1 — Una cabecera

**Acción:** Crea `src/test/java/features/m03/cabeceras.feature` y pega esto:

```gherkin
@m03 @cabeceras
Feature: Cabeceras y encadenado

  Background:
    Given url baseUrl

  Scenario: El mock devuelve la cabecera que enviaste
    And path 'eco'
    And header X-Curso = 'karate-101'
    When method get
    Then status 200
    And match response.eco == 'karate-101'
```

`header X-Curso = 'karate-101'` va en la petición. `/eco` te la devuelve en `response.eco`. Así compruebas que salió, no solo que el GET fue 200.

```bash
mvn test -Dkarate.options="--tags @cabeceras"
```

**Resultado esperado:** 1 verde.

### 2 — Varias cabeceras

**Acción:** Pega este Scenario:

```gherkin
  Scenario: Varios headers juntos
    And path 'eco'
    And headers { Accept: 'application/json', 'X-Curso': 'karate-101' }
    When method get
    Then status 200
    And match response.eco == 'karate-101'
```

`headers { ... }` manda el mapa entero. `X-Curso` va entre comillas porque el nombre tiene un guion.

**Resultado esperado:** 2 verdes.

### 3 — Encadenar dos GET

**Acción:** Pega este Scenario. El segundo `path` usa el `id` que devolvió el primero:

```gherkin
  Scenario: Del listado al detalle
    And path 'productos'
    When method get
    Then status 200
    * def id = response[0].id
    * def nombre = response[0].nombre
    Given path 'productos', id
    When method get
    Then status 200
    And match response.nombre == nombre
    And match response.id == id
```

`def id = response[0].id` guarda el 1 (Teclado). El `Given path` de después **no** repite `url`: sigue valiendo `baseUrl` del Background, y sustituye el path.

**Resultado esperado:** 3 verdes.

## Reto

### 1 — Encadena el segundo producto

Copia el Scenario anterior y cambia `response[0]` por `response[1]`. El nombre tiene que salir `Monitor`.

## Errores frecuentes

| Síntoma | Causa probable | Cómo arreglarlo |
|---------|----------------|-----------------|
| `response.eco` vacío | La cabecera va después del `method get` | `header` antes de `method` |
| `404` en `/eco` | El mock es el de antes del pull | `git pull` y relanza |
| El segundo GET repite el listado | No pusiste otro `path` | `Given path 'productos', id` |
