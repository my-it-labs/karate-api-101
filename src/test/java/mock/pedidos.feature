Feature: Mock mínimo de pedidos

  Background:
    * configure cors = true

  Scenario: pathMatches('/pedidos/{id}') && methodIs('get')
    * def response =
      """
      {
        id: '#(pathParams.id)',
        estado: 'enviado',
        items: 2
      }
      """

  Scenario: pathMatches('/pedidos') && methodIs('post')
    * def responseStatus = request.cantidad ? 201 : 400
    * def response = responseStatus == 201 ? { id: '88', estado: 'creado' } : { mensaje: 'cantidad obligatoria' }

  Scenario:
    * def responseStatus = 404
    * def response = { mensaje: 'Pedido no mockeado' }
