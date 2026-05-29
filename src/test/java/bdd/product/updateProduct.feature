
Feature: Casos de prueba de actualización de productos

  Background:
    * def reusableToken = call read('classpath:bdd/auth/loginAuth.feature@TokenLogin')
    * print reusableToken
    * def authToken = reusableToken.authToken
    * print authToken
    * url 'https://api.qateamperu.com'
    * def requests = read('classpath:resources/json/auth/requests.json')
    * def schemas = read('classpath:resources/json/auth/schemas.json')


@actualizarProducto
Scenario Outline: CP01 - Actualizar producto
* def reusableId = call read('classpath:bdd/product/newProductAuth.feature@crearProducto01')
* def codigoProducto = reusableId.id
    # Imprime el código del producto creado ejemplo: 1234
* print 'Código del producto creado:', reusableId.id
    #* def reusableIdProducto = call read('@crearProducto01')
    #* def idProducto = reusableIdProducto.idProducto
    # Imprime el ID del producto creado ejemplo: CP1234
    #* print 'ID del producto creado:', reusableIdProducto.idProducto
Given path '/api/v1/producto/' + codigoProducto
And header Authorization = 'Bearer ' + authToken
And request
"""{
      codigo: '<codigo>',
      nombre: '<nombre>',
      medida: '<medida>',
      marca: '<marca>',
      categoria: '<categoria>',
      precio: <precio>,
      stock: <stock>,
      estado: <estado>,
      descripcion: '<descripcion>'
    }"""
When method put
Then status 200
And match response.id == codigoProducto
And match response.codigo == schemas.productResponseSchema.codigo
And match response.nombre == schemas.productResponseSchema.nombre

Examples:
| codigo | nombre             | medida | marca    | categoria | precio  | stock | estado | descripcion                  |
| CP0010 | Smartphone Samsung | UND    | Generico | Repuestos | 5000.00 | 200   | 3      | Pantalla AMOLED 6.5 pulgadas |