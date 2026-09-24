@m02 @expr
Feature: Expresiones extra del DSL

  Scenario: regex y assert
    * def nombre = 'Teclado'
    * match nombre == '#regex T.*'
    * def precio = 25
    * assert precio * 2 == 50

  Scenario: funcion JS en bloque
    * def etiqueta =
      """
      function(texto) {
        return texto.toLowerCase()
      }
      """
    * match etiqueta('Monitor') == 'monitor'
