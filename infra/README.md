# Infraestructura de laboratorio

En el Codespace tienes **JDK 17** y **Maven 3.9**. Karate no está instalado todavía: lo bajarás cuando escribas el `pom.xml` (M01-01). El mock de tienda sí está: `src/test/java/mock/`.

## Arranque

1. Haz fork de este repo.
2. En **tu fork**: **Code → Codespaces → Create codespace on `main`**.
3. Cuando arranque, comprueba que Java y Maven responden:

```bash
java -version
mvn -version
ls pom.xml   # todavía no existe: lo creas en M01-01
```

## Cuando ya tengas pom y runner

| Qué quieres | Comando |
|-------------|---------|
| Todo lo que hayas escrito | `mvn test` |
| Solo el humo | `mvn test -Dkarate.options="--tags @smoke"` |
| Un módulo | `mvn test -Dkarate.options="--tags @m03"` |
| Un feature | `mvn test -Dkarate.options="classpath:features/m03/get.feature"` |

El informe HTML queda en `target/karate-reports/karate-summary.html`. Ábrelo con Live Preview.

El **Run** que aparece encima del Feature es la extensión de Karate Labs (**IDE Plus**, de pago). El framework que usas con Maven es gratis. Detalle: [extension-karate.md](extension-karate.md).

Si contrastas con un proyecto ya cerrado, está en la rama [`example`](https://github.com/my-it-labs/karate-api-101/tree/example).

## Puertos

No vas a abrir una aplicación en el navegador. El mock de tienda escucha en `localhost` **dentro** del Codespace, en un puerto aleatorio. La pestaña **Ports** puede mostrar algo: no es un paso del lab.

## Qué hay al clonar `main`

```text
.devcontainer/           # JDK 17 + Maven
labs/                    # estos guiones
src/test/java/mock/      # API de tienda (la enchufas en M01-02)
```

El `pom.xml`, el runner, `karate-config.js` y los `.feature` los creas tú.

## Sin Codespace

JDK 17 y Maven 3.9+ en tu máquina, y el mismo M01.
