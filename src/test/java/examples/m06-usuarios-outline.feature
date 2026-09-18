@example @m06
Feature: Outline sobre usuarios

  Background:
    Given url baseUrl

  Scenario Outline: Usuarios conocidos
    And path 'usuarios', <id>
    When method get
    Then status 200
    And match response.nombre == '<nombre>'
    And match response.rol == '<rol>'

    Examples:
      | id | nombre | rol |
      | 1  | Ana    | ops |
      | 2  | Luis   | dev |
