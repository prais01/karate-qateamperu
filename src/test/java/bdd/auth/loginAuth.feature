Feature: Casos de prueba login

  @TokenLogin
  Scenario Outline: CP01 - Usuario con datos correctos - 200
    * url 'https://api.qateamperu.com'
    * def loginBody = read('classpath:resources/json/auth/requests.json')
    Given path '/api/login'
    And form fields loginBody.loginRequest
    * print loginBody.loginRequest
    When method post
    Then status 200
    And match response.access_token == '#notnull'
    And match response.token_type == 'Bearer'
    * def authToken = response.access_token
    * print 'Token obtenido:', authToken

    Examples:
      | user                   | password   |
      | carlosqateam@gmail.com | carlos123  |

  @TokenLoginIcorrecto
  Scenario Outline: CP02 - usuario con datos incorrectos - 401
    * url 'https://api.qateamperu.com'
    * def loginBody = read('classpath:resources/json/auth/requests.json')
    Given path '/api/login'
    And form fields loginBody.loginRequest
    When method post
    Then status 401
    And match response.message == 'Datos incorrectos'

    Examples:
      | user                   | password   |
      | karate123@gmail.com | 12345678  |