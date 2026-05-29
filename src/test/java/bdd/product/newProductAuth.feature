@productos
Feature: Casos de prueba productos

  Background:
    * def reusableToken = call read('classpath:bdd/auth/loginAuth.feature@TokenLogin')
    * print reusableToken
    * def authToken = reusableToken.authToken
    * print authToken
    * url 'https://api.qateamperu.com'
    * def requests = read('classpath:resources/json/auth/requests.json')
    * def schemas = read('classpath:resources/json/auth/schemas.json')

  @crearProducto01
  Scenario Outline: CP01-Crear producto
    Given path '/api/v1/producto'
    And header Authorization = 'Bearer ' + authToken
      # 1. Creamos una función JS que genera un número aleatorio de 4 dígitos
    * def generarNumero = function(){ return Math.floor(1000 + Math.random() * 9000) }
      # 2. Reemplazamos el código del JSON por 'CP' + los 4 dígitos aleatorios
    * set requests.createProductRequest.codigo = 'CP' + generarNumero()
    And request requests.createProductRequest
    * print requests.createProductRequest
    When method post
    Then status 200
    And match response.codigo == requests.createProductRequest.codigo
    And match response.id == '#notnull'
    And match response.nombre == requests.createProductRequest.nombre
    And match response.descripcion == requests.createProductRequest.descripcion
    And match response.precio == requests.createProductRequest.precio
    * def idProducto = response.codigo
    # Imprime el código del producto creado ejemplo: CP1234
    * print 'ID del producto creado:', idProducto
    * def id = response.id
    # Imprime el ID del producto creado ejemplo: 123
    * print 'ID del producto creado:', id

    Examples:
      | read('classpath:resources/csv/auth/dataProduct.csv') |


  @crearProducto02
  Scenario Outline: CP02-Crear producto con validación del response completo
    Given path '/api/v1/producto'
    And header Authorization = 'Bearer ' + authToken
    And request requests.createProductRequest
    * print requests.createProductRequest
    When method post
    Then status 200
    And match response.codigo == requests.createProductRequest.codigo
    And match response == schemas.productResponseSchema
    * def idProducto = response.codigo
    * print 'ID del producto creado:', idProducto

    Examples:
      | read('classpath:resources/csv/auth/dataProduct.csv') |


