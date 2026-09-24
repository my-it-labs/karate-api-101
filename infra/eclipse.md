# Eclipse (opcional)

El camino del curso es **Codespace + VS Code**. Usa esta página solo si tu equipo te pide Eclipse.

Escribe primero el `pom.xml` y el runner (M01-01) y **después** importa.

## Qué necesitas

- Eclipse IDE for Java Developers (2023-12 o posterior)
- JDK **17**
- Maven 3.9+ o el embebido de Eclipse

## Importar

1. Con el `pom.xml` ya escrito: **File → Import → Maven → Existing Maven Projects**.
2. Root Directory: la carpeta del repo.
3. Si `karate-junit5` sigue en rojo: Maven Update (Force Update).

El compiler tiene que quedar en **17**.

## Ejecutar

1. Abre `src/test/java/runners/KarateTest.java` (lo escribes en M01-01).
2. Clic derecho → **Run As → JUnit Test**.

Para filtrar tags, en **Run Configurations → JUnit → Arguments → VM arguments**:

```text
-Dkarate.options=--tags @smoke
```

## Si algo falla

| Síntoma | Qué mirar |
|---------|-----------|
| No hay proyecto Maven | Todavía no existe `pom.xml` — M01-01 |
| Compiler 1.8 / 11 | Java Compiler → 17; en el pom, `maven.compiler.release` 17 |
| Los features no se ejecutan | En el pom, `testResources` apuntando a `src/test/java` (sin `*.java`) — lo añades en M01-01 |
