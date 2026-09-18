# Examples (rama `example`)

Esta rama es la del **formador**. Tiene:

- `src/test/java/features/` — lo que el alumno construye en `main` (ya terminado, en verde)
- `src/test/java/examples/` — material extra para la demostración guiada, si el grupo va rápido o hay que mostrar un matiz

No es la rama del fork del alumno. El Codespace de clase se crea desde **`main`**.

| Fichero | Qué enseña |
|---------|------------|
| `m02-expresiones.feature` | `#regex`, `assert`, funciones JS de más de una línea |
| `m03-cabeceras.feature` | `header` / `headers` en un GET |
| `m04-predicados.feature` | `#? _ > 0` sobre números |
| `m05-call-tabla.feature` | `call` con una lista de ids |
| `m06-usuarios-outline.feature` | Outline sobre `/usuarios` |
| `m07-catch-all.feature` | GET a una ruta que el mock no define (404) |

```bash
mvn test
mvn test -Dkarate.options="classpath:examples"
```
