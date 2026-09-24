# E04 — call con una lista

[← Página anterior](E03-predicados.md) · [Siguiente página →](E05-usuarios-y-tags.md)

> Extensión del temario. El recorrido principal termina en M07. Esto es para cuando ya lo has cerrado.

### Objetivo

Vas a llamar al helper una sola vez con varios `id`, en lugar de un Scenario por producto.

### Prerrequisitos

- M05-01: existe `features/helpers/get-producto.feature` con `@ignore`.

### 1 — Tres ids en un call

**Acción:** Crea `src/test/java/features/m05/call-tabla.feature` y pega esto:

```gherkin
@m05 @call-tabla
Feature: call con una lista de ids

  Scenario: tres productos en una sola llamada
    * def ids = [{ id: 1 }, { id: 2 }, { id: 3 }]
    * def llamados = call read('classpath:features/helpers/get-producto.feature') ids
    * match llamados == '#[3]'
    * match llamados[0].response.nombre == 'Teclado'
    * match llamados[1].response.nombre == 'Monitor'
    * match llamados[2].response.nombre == 'Webcam'
```

`ids` es una lista de objetos. `call` con una lista ejecuta el helper **una vez por fila** y te devuelve una lista. `llamados[0].response` es el JSON del primer GET.

```bash
mvn test -Dkarate.options="--tags @call-tabla"
```

**Resultado esperado:** 1 escenario verde (por dentro, tres GET).

## Reto

### 1 — Solo periféricos no: solo el id 2

Sustituye la lista por `[{ id: 2 }]` y deja un único `match` del nombre `Monitor`. Tiene que seguir verde, con `llamados == '#[1]'`.

## Errores frecuentes

| Síntoma | Causa probable | Cómo arreglarlo |
|---------|----------------|-----------------|
| `id is not defined` | La lista no es de objetos `{ id: n }` | `[{ id: 1 }, { id: 2 }]` |
| El helper sale como test | Le quitaste `@ignore` | Déjalo en el helper |
