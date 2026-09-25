Feature: Mock de la API de tienda (laboratorio local)

  Background:
    * configure cors = true
    * def productos =
      """
      [
        { "id": 1, "nombre": "Teclado", "precio": 25, "categoria": "periferico", "stock": 10 },
        { "id": 2, "nombre": "Monitor", "precio": 180, "categoria": "pantalla", "stock": 4 },
        { "id": 3, "nombre": "Webcam", "precio": 45, "categoria": "periferico", "stock": 8 }
      ]
      """
    * def usuarios =
      """
      [
        { "id": 1, "nombre": "Ana", "rol": "ops", "activo": true },
        { "id": 2, "nombre": "Luis", "rol": "dev", "activo": false }
      ]
      """

  Scenario: pathMatches('/productos') && methodIs('get') && !paramExists('categoria') && !paramExists('precioMax')
    * def response = productos

  Scenario: pathMatches('/productos') && methodIs('get') && paramExists('categoria')
    * def cat = paramValue('categoria')
    * def response = karate.filter(productos, function(x){ return x.categoria == cat })

  Scenario: pathMatches('/productos') && methodIs('get') && paramExists('precioMax')
    * def max = parseInt(paramValue('precioMax'))
    * def response = karate.filter(productos, function(x){ return x.precio <= max })

  Scenario: pathMatches('/productos/{id}') && methodIs('get')
    * def id = parseInt(pathParams.id)
    * def matches = karate.filter(productos, function(x){ return x.id == id })
    * def found = matches.length == 0 ? null : matches[0]
    * def responseStatus = found ? 200 : 404
    * def response = found ? found : { mensaje: 'Producto no encontrado' }

  Scenario: pathMatches('/productos') && methodIs('post')
    * def body = request
    * def responseStatus = 201
    * def response =
      """
      {
        id: 99,
        nombre: '#(body.nombre)',
        precio: #(body.precio),
        categoria: '#(body.categoria)',
        stock: #(body.stock)
      }
      """

  Scenario: pathMatches('/productos/{id}') && methodIs('put')
    * def id = parseInt(pathParams.id)
    * def body = request
    * def response =
      """
      {
        id: #(id),
        nombre: '#(body.nombre)',
        precio: #(body.precio),
        categoria: '#(body.categoria)',
        stock: #(body.stock)
      }
      """

  Scenario: pathMatches('/productos/{id}') && methodIs('patch')
    * def id = parseInt(pathParams.id)
    * def body = request
    * def response = { id: '#(id)', stock: '#(body.stock)' }

  Scenario: pathMatches('/productos/{id}') && methodIs('delete')
    * def responseStatus = 204
    * def response = ''

  Scenario: pathMatches('/eco') && methodIs('get')
    * def curso = requestHeaders['x-curso'] ? requestHeaders['x-curso'][0] : ''
    * def response = { eco: '#(curso)' }

  Scenario: pathMatches('/usuarios') && methodIs('get')
    * def response = usuarios

  Scenario: pathMatches('/resumen') && methodIs('get')
    * def response = { productos: 3, unidades: 22, perifericos: 2 }

  Scenario: pathMatches('/usuarios/{id}') && methodIs('get')
    * def id = parseInt(pathParams.id)
    * def matches = karate.filter(usuarios, function(x){ return x.id == id })
    * def found = matches.length == 0 ? null : matches[0]
    * def responseStatus = found ? 200 : 404
    * def response = found ? found : { mensaje: 'Usuario no encontrado' }

  Scenario:
    * def responseStatus = 404
    * def response = { mensaje: 'Ruta no mockeada' }
