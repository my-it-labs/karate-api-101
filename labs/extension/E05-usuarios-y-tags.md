# E05 — Outline de usuarios y tags

[← Página anterior](E04-call-tabla.md) · [Siguiente página →](E06-contrato-del-mock.md)

> Extensión del temario. El recorrido principal termina en M07. Esto es para cuando ya lo has cerrado.

### Objetivo

Vas a repetir el Outline sobre `/usuarios` y vas a lanzar solo una parte del módulo con tags.

### Prerrequisitos

- M06-01 verde (`@ddt-tabla` y `@ddt-ficheros`).

### 1 — Outline de usuarios

**Acción:** Crea `src/test/java/features/m06/usuarios.feature` y pega esto:

```gherkin
@m06 @ddt-usuarios
Feature: Outline sobre usuarios

  Background:
    Given url baseUrl

  Scenario Outline: Usuarios conocidos
    And path 'usuarios', <id>
    When method get
    Then status 200
    And match response.nombre == '<nombre>'
    And match response.rol == '<rol>'
    And match response.activo == <activo>

    Examples:
      | id | nombre | rol | activo |
      | 1  | Ana    | ops | true   |
      | 2  | Luis   | dev | false  |
```

`<activo>` va sin comillas: en la tabla es `true` o `false`, no un texto. Ana está activa; Luis no.

```bash
mvn test -Dkarate.options="--tags @ddt-usuarios"
```

**Resultado esperado:** 2 filas verdes.

### 2 — Combinar tags

**Acción:** Lanza solo la tabla de productos, no los CSV ni los usuarios:

```bash
mvn test -Dkarate.options="--tags @m06 and @ddt-tabla"
```

`and` exige los dos tags. `@m06 and not @ddt-usuarios` corre el módulo menos este fichero.

**Resultado esperado:** 3 filas (Teclado, Monitor, Webcam) y nada de usuarios.

## Reto

### 1 — Fila con rol mal

En la tabla, cambia el rol de Ana de `ops` a `admin`, lanza `@ddt-usuarios` y restaura `ops`.

Solo la fila de Ana se pone roja. La de Luis sigue verde.

## Errores frecuentes

| Síntoma | Causa probable | Cómo arreglarlo |
|---------|----------------|-----------------|
| `activo` falla siendo true | Lo comparaste como texto | `== <activo>` sin comillas |
| `and` no lanza nada | Un tag no está en el feature | `@m06` y `@ddt-tabla` en `tabla.feature` |
