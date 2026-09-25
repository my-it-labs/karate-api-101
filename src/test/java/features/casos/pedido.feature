@casos @pedido
Feature: Pedido

  Background:
    * def mock = karate.start('classpath:mock/pedidos.feature')
    * url 'http://localhost:' + mock.port

  Scenario: Consultar el pedido 77
    Given path 'pedidos', 77
    When method get
    Then status 200
    And match response.id == '77'
    And match response.estado == 'enviado'
    And match response.items == 2

  Scenario: Crear con cantidad
    Given path 'pedidos'
    And request { productoId: 1, cantidad: 2 }
    When method post
    Then status 201
    And match response.id == '88'
    And match response.estado == 'creado'

  Scenario: Sin cantidad
    Given path 'pedidos'
    And request { productoId: 1 }
    When method post
    Then status 400
    And match response.mensaje == 'cantidad obligatoria'

  Scenario: Ruta desconocida
    Given path 'foo'
    When method get
    Then status 404
    And match response.mensaje == 'Pedido no mockeado'
