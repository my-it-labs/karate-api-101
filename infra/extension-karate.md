# Extensión Karate en VS Code

En el Codespace ya tienes la extensión **Karate** (Karate Labs). Al abrir un `.feature` verás **Run** encima del Feature y de cada Scenario. Eso no es Maven: es el plugin del editor.

## Qué es gratis y qué no

El **framework** que instalas con el `pom` es MIT. `mvn test` no pide cuenta ni tarjeta. Eso es el camino de este curso.

La columna **Free $0** de [karatelabs.io/pricing](https://www.karatelabs.io/pricing) es eso (el framework) más **Xplorer**, un cliente de escritorio tipo Postman. No es el play de VS Code.

El **Run del editor** es otro producto: **IDE Plus** (100 $/año). Debug y autocomplete son **IDE Pro**. La propia extensión lo dice: *Running tests requires a PLUS subscription*.

| Qué | Gratis | De pago |
|-----|--------|---------|
| `mvn test` / tags / un feature por classpath | Sí (framework MIT) | |
| Resaltar el `.feature` en el editor | Sí (la extensión se instala sola) | |
| Pulsar **Run** / el play del gutter | | IDE Plus |
| Debug, autocomplete | | IDE Pro |
| Xplorer | App de escritorio aparte (no va en el Codespace) | Premium si lo necesitas |

No hace falta activar ni pagar nada para seguir los labs.

## Qué aporta el Run del editor

Karate es el mismo. El play no enseña otro DSL ni otra forma de asertar: **lanza el escenario que tienes abierto**, sin escribir el comando Maven.

Ahí está el valor, y solo ahí:

- Un clic en **un** Scenario (no toda la suite).
- El resultado vuelve al editor (gutter / Test Explorer), sin ir a la terminal ni abrir el HTML.
- Encajas el ciclo escribir → probar → corregir en la misma pantalla.

Lo que **no** aporta: no sustituye el `pom`, el runner ni `mvn test`. En CI y en este curso el arranque real sigue siendo Maven. El play es comodidad de autoría (Plus). Debug paso a paso en el `.feature` ya es Pro.

## Cómo lanzas tú el mismo feature

En la terminal del Codespace, cuando ya tengas pom y runner (M01-01):

```bash
mvn test
mvn test -Dkarate.options="--tags @m02"
mvn test -Dkarate.options="classpath:features/m02/dsl.feature"
```

El informe queda en `target/karate-reports/karate-summary.html`.

## Si tu equipo ya te da Plus

1. Paleta de comandos (`Ctrl+Shift+P`) → **Karate: Sign In / Manage License**.
2. Inicia sesión y pega el session id que te muestre el navegador.
3. Entonces el **Run** del `.feature` sí ejecuta (suele detectar el `pom` en modo `auto`).

Sin esa licencia, el toast de Plus es el comportamiento esperado. Sigue con Maven.
