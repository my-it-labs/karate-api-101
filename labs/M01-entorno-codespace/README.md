# M01 — Entorno y proyecto Maven

[← Página anterior](../../README.md) · [Siguiente página →](M01-01-proyecto-maven.md)

> [!NOTE]
> Primero ves dónde vive Karate y cómo se arranca. En el laboratorio lo montas tú: pom, runner y el primer feature.

## Qué vas a hacer

- Abrir tu Codespace: ahí tienes JDK 17 y Maven.
- Escribir el `pom.xml` por piezas e instalar `karate-junit5`.
- Escribir el runner JUnit y un primer `.feature` hasta verlo verde.
- Enchufar el mock de tienda con `karate-config.js` y hacer un GET de humo.

## Dónde vive Karate

En el Codespace encontrarás **JDK 17 y Maven**. Karate aún no está: el primer paso será declararlo en el `pom` (`karate-junit5`) y dejar que Maven descargue esa dependencia. Ahí verás dónde vive y cómo se pone en marcha: el runner JUnit llama a `Karate.run("classpath:features")` y Surefire ejecuta esa clase.

| Qué | Para qué lo vas a usar |
|-----|------------------------|
| JDK 17 + Maven (Codespace) | Compilar y bajar dependencias |
| `mock/tienda.feature` | API local; la enchufas en M01-02 |
| `pom.xml` | Declarar Karate 1.4.1 y cómo se copian los `.feature` |
| `KarateTest.java` | El único Java del curso: lanza los features |
| `features/*.feature` | Tus escenarios, módulo a módulo |
| `karate-config.js` | `baseUrl` hacia el mock |

Karate busca los `.feature` en el classpath de test. En el pom tendrás que marcar `src/test/java` como `testResources` (excluyendo `*.java`). Si no, `mvn test` no los verá.

El mock no abre una ventana: cuando exista `karate-config.js`, Karate lo levanta en `localhost` y lo apaga al terminar.

## Cómo encaja (recorrido)

1. En el `pom` vas a fijar `karate.version` 1.4.1, la dependencia en scope `test`, los `testResources` y Surefire (para poder pasar `--tags`).
2. El runner que escribas hará `Karate.run("classpath:features")`.
3. Con `karate-config.js` arrancarás `mock/start.js` y tendrás `baseUrl`. Un GET a `/productos` te confirmará que la tienda responde.
4. `mvn test` te dejará el informe en `target/karate-reports/`.

## Ahora te toca a ti

| Lab | Título | Qué vas a montar |
|-----|--------|------------------|
| M01-01 | [Proyecto Maven](M01-01-proyecto-maven.md) | pom por partes, runner, primer feature, `mvn test` |
| M01-02 | [Config y humo](M01-02-config-y-humo.md) | `karate-config.js` + GET al mock |

→ Empieza por **[M01-01 — Proyecto Maven](M01-01-proyecto-maven.md)**.
