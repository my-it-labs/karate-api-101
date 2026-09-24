@m03 @cabeceras
Feature: Cabeceras y encadenado

  Background:
    Given url baseUrl

  Scenario: El mock devuelve la cabecera que enviaste
    And path 'eco'
    And header X-Curso = 'karate-101'
    When method get
    Then status 200
    And match response.eco == 'karate-101'

  Scenario: Varios headers juntos
    And path 'eco'
    And headers { Accept: 'application/json', 'X-Curso': 'karate-101' }
    When method get
    Then status 200
    And match response.eco == 'karate-101'

  Scenario: Del listado al detalle
    And path 'productos'
    When method get
    Then status 200
    * def id = response[0].id
    * def nombre = response[0].nombre
    Given path 'productos', id
    When method get
    Then status 200
    And match response.nombre == nombre
    And match response.id == id
