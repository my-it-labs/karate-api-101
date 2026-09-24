# M02 — Introducción a Karate

[← Página anterior](../M01-entorno-codespace/M01-02-config-y-humo.md) · [Siguiente página →](M02-01-dsl-variables-match.md)

> [!NOTE]
> Primero ves el DSL (variables y `match`). En el laboratorio creas tú el feature, sin HTTP.

## Qué vas a hacer

- Escribir un `.feature` con `Feature`, `Background` y `Scenario`.
- Usar `def`, JSON embebido y `match`.
- Ejecutar solo este módulo con un tag.

## El DSL

Karate usa Gherkin, pero **no es Cucumber clásico**: no implementas los pasos en Java. El motor entiende `def`, `match`, `url`, `method`.

| Lo que escribes | Qué hace |
|-----------------|----------|
| `Feature` | El fichero de escenarios |
| `Background` | Se ejecuta antes de **cada** Scenario de ese fichero |
| `def` | Deja una variable lista |
| `match` | Aserción (valor, tipo, `contains`) |
| tag `@m02` | Filtro: `mvn test -Dkarate.options="--tags @m02"` |

`match x == '#string'` no busca el texto `"#string"`: es un **marcador de tipo**. `'#[2]'` quiere decir «array de dos elementos».

Aquí **no hay HTTP**. Primero coges el lenguaje; los GET vienen en M03.

## Cómo encaja

En tu feature, el `Background` dejará `iva` y una función `conIva`. Un Scenario declarará string, número, array y objeto y los comprobará con `match`. Otro llamará a `conIva(100)` y esperará `121`. Con `--tags @m02` solo correrá este fichero.

## Ahora te toca a ti

| Lab | Título | Qué vas a montar |
|-----|--------|------------------|
| M02-01 | [DSL, variables y match](M02-01-dsl-variables-match.md) | Crear `dsl.feature` desde cero |

→ Empieza por **[M02-01 — DSL, variables y match](M02-01-dsl-variables-match.md)**.
