@m04 @predicados
Feature: Predicados sobre numeros

  Background:
    Given url baseUrl
    And path 'productos', 2
    When method get
    Then status 200

  Scenario: precio positivo y stock no negativo
    And match response.nombre == '#regex M.*'
    And match response.precio == '#number'
    And match response.precio == '#? _ > 0'
    And match response.stock == '#? _ >= 0'

  Scenario: El producto no trae claves de mas
    And match response contains only
      """
      {
        id: '#number',
        nombre: '#string',
        precio: '#number',
        categoria: '#string',
        stock: '#number'
      }
      """
