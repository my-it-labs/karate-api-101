@casos @inventario
Feature: Inventario de la tienda Norte

  Background:
    Given url baseUrl

  Scenario: El catalogo tiene tres productos
    And path 'productos'
    When method get
    Then status 200
    And match response == '#[3]'
    And match response[0].nombre == 'Teclado'

  Scenario: Perifericos
    And path 'productos'
    And param categoria = 'periferico'
    When method get
    Then status 200
    And match response == '#[2]'
    And match each response contains { categoria: 'periferico' }

  Scenario: Precio maximo 50
    And path 'productos'
    And param precioMax = 50
    When method get
    Then status 200
    And match response == '#[2]'
    And match response[*].nombre contains 'Teclado'
    And match response[*].nombre contains 'Webcam'
    And match response[*].nombre !contains 'Monitor'

  Scenario: Cifras del almacen
    And path 'resumen'
    When method get
    Then status 200
    And match response == { productos: 3, unidades: 22, perifericos: 2 }
