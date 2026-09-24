@m07
Feature: Arrancar un mock propio con karate.start

  Background:
    * def mock = karate.start('classpath:mock/pedidos.feature')
    * url 'http://localhost:' + mock.port

  Scenario: Consultar un pedido mockeado
    Given path 'pedidos', 77
    When method get
    Then status 200
    And match response.id == '77'
    And match response.estado == 'enviado'
    And match response.items == 2

  Scenario: Crear un pedido mockeado
    Given path 'pedidos'
    And request { productoId: 1, cantidad: 2 }
    When method post
    Then status 201
    And match response.id == '88'
    And match response.estado == 'creado'

  Scenario: POST sin cantidad
    Given path 'pedidos'
    And request { productoId: 1 }
    When method post
    Then status 400
    And match response.mensaje == 'cantidad obligatoria'
