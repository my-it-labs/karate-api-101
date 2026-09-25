@casos @personas
Feature: Directorio de la tienda Norte

  Background:
    Given url baseUrl

  Scenario: El directorio
    And path 'usuarios'
    When method get
    Then status 200
    And match response == '#[2]'
    And match response[0].nombre == 'Ana'
    And match response[1].nombre == 'Luis'

  Scenario: Ana
    And path 'usuarios', 1
    When method get
    Then status 200
    And match response == { id: 1, nombre: 'Ana', rol: 'ops', activo: true }

  Scenario: Luis
    And path 'usuarios', 2
    When method get
    Then status 200
    And match response.rol == 'dev'
    And match response.activo == false

  Scenario: No hay usuario 9
    And path 'usuarios', 9
    When method get
    Then status 404
    And match response.mensaje == 'Usuario no encontrado'

  Scenario: Categoria audio
    And path 'productos'
    And param categoria = 'audio'
    When method get
    Then status 200
    And match response == '#[0]'
