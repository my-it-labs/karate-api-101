@example @m07
Feature: Catch-all del mock de pedidos

  Background:
    * def mock = karate.start('classpath:mock/pedidos.feature')
    * url 'http://localhost:' + mock.port

  Scenario: Ruta que el mock no define
    Given path 'foo'
    When method get
    Then status 404
    And match response.mensaje == 'Pedido no mockeado'
