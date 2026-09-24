# E07 — GitHub Actions y el informe en Pages

[← Página anterior](E06-contrato-del-mock.md) · [Siguiente página →](../../README.md)

> Extensión del temario. El recorrido principal termina en M07. Esto es para cuando ya lo has cerrado.

### Objetivo

Vas a lanzar `mvn test` en GitHub Actions, en **tu fork**, y a publicar el informe HTML en GitHub Pages.

### Prerrequisitos

- El `pom.xml`, el runner y al menos un `.feature` que pase en local (`mvn test`).
- El repo es **tu fork**, no `my-it-labs/karate-api-101`.

### 1 — Activar Pages

**Acción:** En tu fork, **Settings → Pages → Build and deployment → Source: GitHub Actions**.

Sin ese origen, el workflow puede ir verde y la web no se publica.

### 2 — El workflow

**Acción:** Crea `.github/workflows/karate.yml` en la raíz del repo y pega esto:

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

`mvn -B test` es el mismo ciclo que en el Codespace. `index.html` es una copia de `karate-summary.html`, para que la raíz de Pages abra el informe. `deploy` solo corre si `test` ha acabado bien.

### 3 — Subir y mirar

**Acción:**

```bash
git add .github/workflows/karate.yml
git commit -m "Publica el informe de Karate en GitHub Pages"
git push origin main
```

En el fork: pestaña **Actions**. El job `test` ejecuta Maven. El job `deploy` deja la URL en el resumen (algo como `https://<tu-usuario>.github.io/<tu-repo>/`).

**Resultado esperado:** los dos jobs en verde. Al abrir esa URL ves el resumen de Karate, el mismo HTML que en `target/karate-reports/`.

## Comprueba tu entendimiento

Un push a `main` vuelve a lanzar la cadena. Si rompes un `match` a propósito, `test` se pone rojo y `deploy` no publica un informe nuevo.

## Errores frecuentes

| Síntoma | Causa probable | Cómo arreglarlo |
|---------|----------------|-----------------|
| `test` rojo: no hay `pom.xml` | El workflow está en un repo sin el proyecto | Hazlo en tu fork, con el pom de M01 |
| Actions verde y no hay web | Pages no está en modo GitHub Actions | Settings → Pages → Source: GitHub Actions |
| La URL abre en blanco | Falta `index.html` | El `cp` del workflow, a `target/karate-reports/` |
| `deploy` pide permiso | El `permissions` de Pages no está | El bloque `pages: write` y `id-token: write` de arriba |
