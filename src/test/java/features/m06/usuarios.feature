@m06 @ddt-usuarios
Feature: Outline sobre usuarios

  Background:
    Given url baseUrl

  Scenario Outline: Usuarios conocidos
    And path 'usuarios', <id>
    When method get
    Then status 200
    And match response.nombre == '<nombre>'
    And match response.rol == '<rol>'
    And match response.activo == <activo>

    Examples:
      | id | nombre | rol | activo |
      | 1  | Ana    | ops | true   |
      | 2  | Luis   | dev | false  |
