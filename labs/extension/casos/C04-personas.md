# C04 — Directorio de personas

[← Página anterior](C03-altas.md) · [Siguiente página →](C05-pedido.md)

Ana está activa y es de ops. Luis es de dev y no está activo. Un id que no existe es 404. Una categoría de producto que no existe no es 404: es una lista vacía.

### 1 — Las dos personas

Crea `src/test/java/features/casos/personas.feature`. El primer Scenario pide `GET /usuarios` (sin id): Ana y Luis, en ese orden.

<details>
<summary>Ver solución</summary>

```gherkin
@casos @personas
Feature: Directorio de la tienda Norte

  Background:
    Given url baseUrl

  Scenario: El directorio
    And path 'usuarios'
    When method get
    Then status 200
    And match response == '#[2]'
    And match response[0].nombre == 'Ana'
    And match response[1].nombre == 'Luis'
```

</details>

Si este GET da 404, el mock no tiene el listado: `git pull`.

```bash
mvn test -Dkarate.options="--tags @personas"
```

### 2 — La ficha de Ana

`path 'usuarios', 1`. El objeto entero es id 1, nombre Ana, rol ops, activo true.

<details>
<summary>Ver solución</summary>

```gherkin
  Scenario: Ana
    And path 'usuarios', 1
    When method get
    Then status 200
    And match response == { id: 1, nombre: 'Ana', rol: 'ops', activo: true }
```

</details>

### 3 — Luis no está activo

Misma ficha con id 2. Basta con mirar `rol` y `activo`. `false` va **sin** comillas.

<details>
<summary>Ver solución</summary>

```gherkin
  Scenario: Luis
    And path 'usuarios', 2
    When method get
    Then status 200
    And match response.rol == 'dev'
    And match response.activo == false
```

</details>

### 4 — Dos «no existe» distintos

Añade dos Scenario. El usuario 9 responde 404 y `Usuario no encontrado`. La categoría `audio` responde **200** y una lista de longitud 0 (`'#[0]'`).

<details>
<summary>Ver solución</summary>

```gherkin
  Scenario: No hay usuario 9
    And path 'usuarios', 9
    When method get
    Then status 404
    And match response.mensaje == 'Usuario no encontrado'

  Scenario: Categoria audio
    And path 'productos'
    And param categoria = 'audio'
    When method get
    Then status 200
    And match response == '#[0]'
```

El 404 del usuario es «esa ficha no está». El 200 de `audio` es «el filtro no encontró filas».

</details>

```bash
mvn test -Dkarate.options="--tags @personas"
```

5 verdes.
