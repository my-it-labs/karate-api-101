@casos @altas
Feature: Alta cambio y baja

  Background:
    Given url baseUrl
    And header Content-Type = 'application/json'

  Scenario: Alta de un Dock
    And path 'productos'
    And request { nombre: 'Dock USB', precio: 60, categoria: 'periferico', stock: 5 }
    When method post
    Then status 201
    And match response.id == 99
    And match response.nombre == 'Dock USB'
    And match response.precio == 60

  Scenario: Sustituir el producto 1
    And path 'productos', 1
    And request { nombre: 'Teclado mecanico', precio: 90, categoria: 'periferico', stock: 3 }
    When method put
    Then status 200
    And match response.id == 1
    And match response.nombre == 'Teclado mecanico'

  Scenario: La Webcam queda con una unidad
    And path 'productos', 3
    And request { stock: 1 }
    When method patch
    Then status 200
    And match response.id == 3
    And match response.stock == 1

  Scenario: Baja del Monitor
    And path 'productos', 2
    When method delete
    Then status 204

  Scenario: El catalogo no guardo el alta
    And path 'productos'
    When method get
    Then status 200
    And match response == '#[3]'
    And match response[0].nombre == 'Teclado'
    And match response[1].nombre == 'Monitor'
    And match response[2].nombre == 'Webcam'
