# E07 — GitHub Actions y el informe en Pages

[← Página anterior](E06-contrato-del-mock.md) · [Siguiente página →](casos/README.md)

> Extensión del temario. El recorrido principal termina en M07. Esto es para cuando ya lo has cerrado.

### Objetivo

Vas a hacer que **tu fork** ejecute `mvn test` solo, en GitHub, y publique el informe HTML en una página.

### Prerrequisitos

- En local, `mvn test` acaba en `BUILD SUCCESS`.
- Tienes `pom.xml`, `src/test/java/runners/KarateTest.java` y al menos un `.feature`.
- Trabajas en **tu fork**. Este workflow no va en `my-it-labs/karate-api-101`.

### 1 — Comprueba el remoto

**Acción:** En la terminal del Codespace:

```bash
git remote -v
mvn -B test
```

`git remote -v` tiene que mostrar **tu** usuario de GitHub, no solo `my-it-labs`. `mvn -B test` tiene que acabar en `BUILD SUCCESS`. El `-B` es el modo que usará Actions: sin preguntas.

**Resultado esperado:** tests verdes. El informe ya existe en `target/karate-reports/karate-summary.html`.

### 2 — Activa GitHub Pages

**Acción:** En el navegador, abre **tu fork**. Entra en **Settings → Pages**.

En **Build and deployment → Source** elige **GitHub Actions**. Guarda si te deja un botón.

Si el fork es **privado**, Pages no publica en una cuenta gratuita. Déjalo público: **Settings → General → Danger zone** no hace falta tocarlo si ya pone Public.

**Resultado esperado:** Pages dice que el origen es GitHub Actions. Todavía no hay URL: la crea el primer deploy.

### 3 — Crea el fichero

**Acción:** En la raíz del repo (junto al `pom.xml`), crea la carpeta y el fichero vacío:

```bash
mkdir -p .github/workflows
```

Abre `.github/workflows/karate.yml`. Lo vas a rellenar en tres pegados, uno debajo de otro.

### 4 — Nombre, cuándo corre y permisos

**Acción:** Pega esto al principio del fichero:

```yaml
name: karate

on:
  push:
    branches: [main]

permissions:
  contents: read
  pages: write
  id-token: write

concurrency:
  group: pages
  cancel-in-progress: true
```

`name` es el título que verás en la pestaña Actions. `on.push.branches: [main]` lanza el workflow solo cuando subes a `main`. `contents: read` deja leer el repo. `pages: write` y `id-token: write` son los permisos para publicar la web. `concurrency` evita dos publicaciones a la vez: si haces otro push, cancela la anterior.

### 5 — El job que lanza los tests

**Acción:** Debajo, sin borrar lo anterior, pega esto. La clave `jobs:` va en la columna 0, igual que `name:`:

```yaml
jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4

      - uses: actions/setup-java@v4
        with:
          distribution: temurin
          java-version: "17"
          cache: maven

      - name: tests
        run: mvn -B test

      - name: portada del informe
        run: cp target/karate-reports/karate-summary.html target/karate-reports/index.html

      - uses: actions/upload-pages-artifact@v3
        with:
          path: target/karate-reports
```

`checkout` baja tu repo. `setup-java` instala el JDK 17 (el mismo del Codespace) y cachea Maven. `mvn -B test` escribe el informe en `target/karate-reports/`. El `cp` copia `karate-summary.html` a `index.html`: Pages abre la raíz del sitio, y sin ese nombre la URL sale en blanco. `upload-pages-artifact` empaqueta esa carpeta para el job siguiente.

### 6 — El job que publica

**Acción:** Al final del fichero, pega esto. Sigue dentro de `jobs:`, al mismo nivel que `test:` (dos espacios):

```yaml
  deploy:
    needs: test
    runs-on: ubuntu-latest
    environment:
      name: github-pages
      url: ${{ steps.deployment.outputs.page_url }}
    steps:
      - name: publicar
        id: deployment
        uses: actions/deploy-pages@v4
```

`needs: test` espera a que Maven haya acabado bien. Si los tests fallan, este job no se ejecuta y no se publica un informe roto. `environment.name: github-pages` es el entorno que crea Pages. `id: deployment` es el nombre del paso del que sale la URL.

El fichero completo tiene que quedar así:

```yaml
name: karate

on:
  push:
    branches: [main]

permissions:
  contents: read
  pages: write
  id-token: write

concurrency:
  group: pages
  cancel-in-progress: true

jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4

      - uses: actions/setup-java@v4
        with:
          distribution: temurin
          java-version: "17"
          cache: maven

      - name: tests
        run: mvn -B test

      - name: portada del informe
        run: cp target/karate-reports/karate-summary.html target/karate-reports/index.html

      - uses: actions/upload-pages-artifact@v3
        with:
          path: target/karate-reports

  deploy:
    needs: test
    runs-on: ubuntu-latest
    environment:
      name: github-pages
      url: ${{ steps.deployment.outputs.page_url }}
    steps:
      - name: publicar
        id: deployment
        uses: actions/deploy-pages@v4
```

### 7 — Súbelo a tu main

**Acción:**

```bash
git add .github/workflows/karate.yml
git status
git commit -m "Publica el informe de Karate en GitHub Pages"
git push origin main
```

`git status` tiene que listar solo `.github/workflows/karate.yml` (y lo que tú tuvieras pendiente de los labs). El push es a **tu** `origin`, rama `main`.

**Resultado esperado:** el push no da error de permiso. En GitHub, la pestaña **Actions** muestra un workflow **karate** en amarillo (en curso) y luego en verde.

### 8 — Mira la ejecución

**Acción:** Abre **Actions → karate →** el run de arriba.

1. Entra en el job **test**. Tiene que verse `BUILD SUCCESS`.
2. Entra en el job **deploy**. Al terminar, arriba del todo aparece **github-pages** con una URL `https://<tu-usuario>.github.io/<nombre-del-repo>/`.

La primera vez puede tardar unos minutos: Maven se baja Karate en el runner de GitHub. Si **deploy** se queda en **Waiting** / **Review pending**, abre el aviso y pulsa **Approve and deploy**. Solo pasa en el primer despliegue.

**Resultado esperado:** `test` verde, `deploy` verde, y la URL abre el resumen de Karate (los mismos escenarios que en local).

## Comprueba tu entendimiento

Haz otro cambio pequeño en un `.feature` (un comentario basta), commit y `git push origin main`.

Actions lanza otra vez los dos jobs. La página se actualiza con el informe nuevo. Si dejas un `match` en rojo, `test` falla y `deploy` no llega a ejecutarse: la web se queda con el informe anterior.

## Errores frecuentes

| Síntoma | Causa probable | Cómo arreglarlo |
|---------|----------------|-----------------|
| El workflow no aparece en Actions | El fichero no está en `main` o la ruta no es `.github/workflows/karate.yml` | `git push origin main` desde tu fork |
| `test` rojo: `pom.xml` no existe | El push no lleva el proyecto de M01 | Haz commit del `pom.xml`, el runner y los `.feature` |
| `test` rojo: `no features or scenarios` | Falta `testResources` en el pom o no hay `.feature` | Revisa M01-01, pasos 4 y 6 |
| `deploy` en rojo: permisos | Falta `pages: write` o `id-token: write` | El bloque `permissions` del paso 4 |
| Actions verde y la web no existe | Pages no está en GitHub Actions | Settings → Pages → Source: GitHub Actions |
| La URL abre en blanco o 404 | No se copió `index.html` | El `cp` del paso 5, dentro de `target/karate-reports/` |
| **Waiting** y no sigue | El entorno pide aprobación la primera vez | Approve and deploy |
