@example @m03
Feature: Cabeceras en GET

  Background:
    Given url baseUrl

  Scenario: Un header suelto
    And path 'productos', 1
    And header X-Curso = 'karate-101'
    When method get
    Then status 200
    And match response.nombre == 'Teclado'

  Scenario: Varios headers juntos
    And path 'productos'
    And headers { Accept: 'application/json', 'X-Curso': 'karate-101' }
    When method get
    Then status 200
    And match response == '#[3]'
