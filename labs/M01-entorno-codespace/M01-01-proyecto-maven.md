# M01-01 — Proyecto Maven

[← Página anterior](README.md) · [Siguiente página →](M01-02-config-y-humo.md)

> El concepto está en el [README del módulo](README.md). Aquí lo montas tú.

### Objetivo

Vas a montar un proyecto Maven que ejecute un `.feature` de Karate. Al final de este lab, `mvn test` estará verde **con un feature que has escrito tú**.

### Prerrequisitos

- Cuenta GitHub y permiso para Codespaces (2 vCPU basta).

### En qué consiste

Vas a abrir el Codespace en `main`, escribir el `pom.xml` por piezas, el runner JUnit y tu primer feature (sin HTTP).

### 1 — Fork y Codespace en `main`

**Acción:** Fork de `my-it-labs/karate-api-101`. En **tu fork**: **Code → Codespaces → Create codespace on main**.

```bash
java -version
mvn -version
ls pom.xml src/test/java/runners src/test/java/features
```

**Por qué:** En el Codespace de `main` tienes Java y Maven; Karate aún no. El pom lo escribes tú en los siguientes pasos.

**Resultado esperado:** Java 17, Maven 3.9.x. **No** existe `pom.xml`. `mock/` sí existe. `features/` y `runners/` no (o están vacíos).

### 2 — Esqueleto del pom

**Acción:** Crea `pom.xml` en la **raíz** del repo, solo con coordenadas:

```xml
<?xml version="1.0" encoding="UTF-8"?>
<project xmlns="http://maven.apache.org/POM/4.0.0"
         xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
         xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 https://maven.apache.org/xsd/maven-4.0.0.xsd">
    <modelVersion>4.0.0</modelVersion>
    <groupId>com.myitlabs</groupId>
    <artifactId>karate-api-101</artifactId>
    <version>1.0.0</version>
    <packaging>jar</packaging>
</project>
```

```bash
mvn -q validate
```

**Por qué:** Maven ya reconoce el proyecto. Todavía **no** hay Karate.

**Resultado esperado:** `validate` sin error. `mvn test` no corre escenarios de Karate (aún no hay dependencias ni tests).

### 3 — Propiedades y dependencia Karate

**Acción:** Dentro de `<project>`, **antes** de `</project>`, pega esto:

```xml
    <properties>
        <project.build.sourceEncoding>UTF-8</project.build.sourceEncoding>
        <java.version>17</java.version>
        <maven.compiler.release>17</maven.compiler.release>
        <karate.version>1.4.1</karate.version>
    </properties>

    <dependencies>
        <dependency>
            <groupId>com.intuit.karate</groupId>
            <artifactId>karate-junit5</artifactId>
            <version>${karate.version}</version>
            <scope>test</scope>
        </dependency>
    </dependencies>
```

`karate.version` fija la 1.4.1. La dependencia es `karate-junit5`, en scope `test`.

```bash
mvn -q dependency:resolve
```

**Por qué:** Aquí Maven **descarga** Karate. Scope `test` porque no hay código de producción. La versión 1.4.1 es la del curso (no subas a 1.5 sin cambiar el `groupId`).

**Resultado esperado:** en el log aparece `karate-junit5-1.4.1`. En `~/.m2/repository/com/intuit/karate/` hay jars.

### 4 — testResources, compiler y Surefire

**Acción:** Justo antes de `</project>`, pega este `<build>`:

```xml
    <build>
        <testResources>
            <testResource>
                <directory>src/test/java</directory>
                <excludes>
                    <exclude>**/*.java</exclude>
                </excludes>
            </testResource>
        </testResources>
        <plugins>
            <plugin>
                <groupId>org.apache.maven.plugins</groupId>
                <artifactId>maven-compiler-plugin</artifactId>
                <version>3.13.0</version>
                <configuration>
                    <release>${java.version}</release>
                    <encoding>UTF-8</encoding>
                </configuration>
            </plugin>
            <plugin>
                <groupId>org.apache.maven.plugins</groupId>
                <artifactId>maven-surefire-plugin</artifactId>
                <version>3.2.5</version>
                <configuration>
                    <argLine>-Dfile.encoding=UTF-8</argLine>
                    <systemPropertyVariables>
                        <karate.options>${karate.options}</karate.options>
                    </systemPropertyVariables>
                </configuration>
            </plugin>
        </plugins>
    </build>
```

`testResources` copia los `.feature` al classpath y deja fuera los `.java`. Sin ese bloque, Karate no ve los features. `karate.options` es el hueco por el que luego pasan los `--tags`.

```bash
mvn -q test-compile
```

**Por qué:** Compilas el árbol de test (todavía vacío) y dejas Surefire listo para el runner.

**Resultado esperado:** `BUILD SUCCESS`. Si `testResources` está mal, el siguiente `mvn test` dirá que no hay features.

### 5 — Runner

**Acción:** Crea `src/test/java/runners/KarateTest.java` y pega esto:

```java
package runners;

import com.intuit.karate.junit5.Karate;

class KarateTest {

    @Karate.Test
    Karate testLabs() {
        return Karate.run("classpath:features");
    }
}
```

`Karate.run("classpath:features")` es la línea que lanza tus `.feature`. El resto es la clase que Surefire necesita para encontrarla.

**Por qué:** Surefire necesita una clase JUnit. Ese `run` es el único Java que escribes en el curso.

**Resultado esperado:** el fichero existe. `mvn test` **falla** con `no features or scenarios found: [classpath:features]` — es lo correcto: aún no hay `.feature`.

### 6 — Primer feature

**Acción:** Crea `src/test/java/features/hola.feature` y pega esto:

```gherkin
@m01
Feature: primer feature

  Scenario: un string
    * def mensaje = 'hola'
    * match mensaje == 'hola'
```

`@m01` es el tag. `def` deja la variable. `match` comprueba que vale exactamente `'hola'`. No hay HTTP.

```bash
mvn test
```

**Por qué:** El ciclo del resto del curso es este: escribes Gherkin → Maven → informe.

**Resultado esperado:** `BUILD SUCCESS`, `failed: 0`, 1 escenario. Informe en `target/karate-reports/karate-summary.html` (Live Preview).

## Comprueba tu entendimiento

**Tags**

`mvn test -Dkarate.options="--tags @m01"` → el hola. `--tags @no-existe` → 0 escenarios (no debe romper el pom).

**Classpath**

`mvn test -Dkarate.options="classpath:features/hola.feature"` → el mismo escenario.

## Reto

### 1 — Un segundo match de tipo

En el mismo Scenario, `match mensaje == '#string'`. Relanza `mvn test`.

<details>
<summary>Ver solución</summary>

`'#string'` es marcador de tipo, no el texto de la palabra. Si el pom o el runner se atascan, contrasta con la rama `example` (`pom.xml` y `KarateTest.java`). El `hola.feature` lo dejas como lo hayas escrito tú.

</details>

## Errores frecuentes

| Síntoma | Causa probable | Cómo arreglarlo |
|---------|----------------|-----------------|
| Ya hay un `pom.xml` completo y los features del curso | Codespace creado desde `example` | Recrea el Codespace desde **`main`** |
| `no features found` con el hola creado | Falta `testResources` o el feature no está bajo `features/` | Paso 4; path `src/test/java/features/hola.feature` |
| `mvn test` 0 tests y no aparece Karate | Falta el runner o Surefire no lo ve | `package runners;` y ruta `src/test/java/runners/KarateTest.java` |
| Karate 1.5 / otro `groupId` | Copiaste internet | `com.intuit.karate` 1.4.1 |
| `release version 17 not supported` | El JDK del Codespace no es 17 | Recrea el Codespace; `java -version` |
| **Run** del editor pide PLUS / sign-in | El play del `.feature` es IDE Plus (de pago) | Lanza con `mvn test`; [infra/extension-karate.md](../../infra/extension-karate.md) |
