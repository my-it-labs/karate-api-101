@m05 @call-tabla
Feature: call con una lista de ids

  Scenario: tres productos en una sola llamada
    * def ids = [{ id: 1 }, { id: 2 }, { id: 3 }]
    * def llamados = call read('classpath:features/helpers/get-producto.feature') ids
    * match llamados == '#[3]'
    * match llamados[0].response.nombre == 'Teclado'
    * match llamados[1].response.nombre == 'Monitor'
    * match llamados[2].response.nombre == 'Webcam'
