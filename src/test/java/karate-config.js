function fn() {
  var env = karate.env;

  var config = {
    env: env,
    urlBase: 'https://api.qateamperu.com'
  };

  karate.configure('connectTimeout', 10000); // Max 5 segundos para conectar
  karate.configure('readTimeout', 10000);    // Max 5 segundos para recibir datos
  return config;

}
