@example @m04
Feature: Predicados sobre numeros

  Background:
    Given url baseUrl
    And path 'productos', 2
    When method get
    Then status 200

  Scenario: precio positivo y stock no negativo
    And match response.precio == '#number'
    And match response.precio == '#? _ > 0'
    And match response.stock == '#? _ >= 0'
