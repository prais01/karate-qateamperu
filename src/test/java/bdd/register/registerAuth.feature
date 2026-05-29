Feature: Casos de prueba registro de usuario

  Background:
    * url 'https://api.qateamperu.com'
    * def requests = read('classpath:resources/json/auth/requests.json')

  @RegistroUsuario
  Scenario Outline: CP01 - Registro de usuario con datos de JSON
    Given path '/api/register'
    And request requests.registerRequest
    * print requests.registerRequest
    When method post
    Then status 200
    And match response.data.id == '#notnull'
    And match response.data.nombre == requests.registerRequest.nombre
    And match response.access_token == '#notnull'
    * def authToken = response.access_token
    * print 'Token obtenido:', authToken

    Examples:
      | user                   | password | name   | userTypeId | estado |
      | jose@gmail.com | 12345678 | Carlos | 1          | 1      |

  @RegistroUsuarioExistente
  Scenario Outline: CP01 - Registro de usuario existente con datos de JSON
    Given path '/api/register'
    And request requests.registerRequest
    * print requests.registerRequest
    When method post
    Then status 500
    And match response.email[0] == 'The email has already been taken.'

    Examples:
      | user           | password | name   | userTypeId | estado |
      | pier@gmail.com | 12345678 | Carlos | 1          | 1      |

