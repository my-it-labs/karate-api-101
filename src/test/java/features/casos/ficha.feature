@casos @ficha
Feature: Ficha de producto

  Background:
    Given url baseUrl

  Scenario: Ficha del Monitor
    And path 'productos', 2
    When method get
    Then status 200
    And match response.id == 2
    And match response.nombre == 'Monitor'
    And match response.precio == 180
    And match response.categoria == 'pantalla'
    And match response.stock == '#? _ > 0'

  Scenario: El id 999 no esta en catalogo
    And path 'productos', 999
    When method get
    Then status 404
    And match response.mensaje == 'Producto no encontrado'

  Scenario: Del listado se abre la ficha del primero
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
