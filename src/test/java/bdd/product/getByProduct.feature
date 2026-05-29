Feature: Casos de prueba consulta de productos

  Background:
    * def reusableToken = call read('classpath:bdd/auth/loginAuth.feature@TokenLogin')
    * print reusableToken
    * def authToken = reusableToken.authToken
    * print authToken
    * url 'https://api.qateamperu.com'
    * def requests = read('classpath:resources/json/auth/requests.json')
    * def schemas = read('classpath:resources/json/auth/schemas.json')


@obtenerProducto
Scenario: CP03 - Obtener producto
* def reusableIdProducto = call read('classpath:bdd/product/newProductAuth.feature@crearProducto01')
* print 'Contenido de reusableIdProducto:', reusableIdProducto
* def idProducto = reusableIdProducto.id
* print reusableIdProducto.id
Given path '/api/v1/producto/' + idProducto
And header Authorization = 'Bearer ' + authToken
When method get
Then status 200
And match response.id == idProducto
And match response.codigo == schemas.productResponseSchema.codigo
And match response.nombre == schemas.productResponseSchema.nombre
* def idProductoObtenido = response.id
* print 'ID del producto obtenido:', idProductoObtenido

@obtenerProductoIncorrecto
Scenario: CP04 - Producto no encontrado
Given path '/api/v1/producto/CP1234'
And header Authorization = 'Bearer ' + authToken
When method get
Then status 404
And match response.error == 'Producto no encontrado'

@consultarProductos
Scenario: CP05-Consultar todos los productos
Given path '/api/v1/producto'
And header Authorization = 'Bearer ' + authToken
When method get
Then status 200
And match response.data[0].id == '#notnull'
And match response.data[0].codigo == '#notnull'
And match response.data[0].nombre == schemas.consultarProductosResponseSchema.data[0].nombre
And match response.data[0].descripcion == schemas.consultarProductosResponseSchema.data[0].descripcion
And match response.data[0].precio == schemas.consultarProductosResponseSchema.data[0].precio