# Examples (rama `example`)

Si quieres mirar más allá de lo que escribes en `main`, aquí hay escenarios extra. El proyecto de cada lab, ya cerrado, está en `src/test/java/features/`.

Tu trabajo está en **`main`**. El Codespace del curso lo creas desde ahí.

| Fichero | Qué vas a ver |
|---------|---------------|
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
