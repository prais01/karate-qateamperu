# Proyecto Karate QA Team - Automatización de Pruebas API

## 📋 Descripción del Proyecto

Este es un proyecto de automatización de pruebas API utilizando **Karate** (framework declarativo basado en Gherkin/BDD para testing de APIs) integrado con **Maven** y **JUnit 5**. El proyecto está diseñado para realizar pruebas E2E (End-to-End) en la API de QA Team Perú.

**API Base:** `https://api.qateamperu.com`

---

## 🏗️ Estructura del Proyecto

```
proyecto-karate-qa-team/
│
├── pom.xml                           # Configuración de Maven y dependencias
│
├── src/test/java/
│   ├── bdd/                          # Directorio principal de pruebas BDD
│   │   ├── ConfigTest.java           # Test runner paralelo (ejecuta todos los tests)
│   │   ├── TestRunner.java           # Test runner individual para features específicos
│   │   ├── karate-config.js          # Configuración global de Karate
│   │   │
│   │   ├── auth/                     # Módulo de autenticación
│   │   │   └── loginAuth.feature     # Escenarios de login (~2 escenarios)
│   │   │
│   │   ├── product/                  # Módulo de gestión de productos
│   │   │   ├── newProductAuth.feature    # Crear productos (~2 escenarios)
│   │   │   ├── getByProduct.feature      # Consultar productos (~3 escenarios)
│   │   │   ├── updateProduct.feature     # Actualizar productos (~1 escenario)
│   │   │   └── addProduct.feature        # Ejemplo práctico (~1 escenario)
│   │   │
│   │   └── register/                 # Módulo de registro de usuarios
│   │       └── registerAuth.feature  # Escenarios de registro (~2 escenarios)
│   │
│   └── resources/                    # Archivos de recursos para pruebas
│       ├── json/
│       │   └── auth/
│       │       ├── requests.json      # Payloads de solicitudes
│       │       ├── schemas.json       # Esquemas de validación de respuestas
│       │       └── bodyLogin.json     # Body para login
│       │
│       └── csv/
│           └── auth/
│               └── dataProduct.csv     # Datos de prueba (CSV)
│
├── logback-test.xml                  # Configuración de logs (SLF4J)
│
└── target/
    ├── karate.log                    # Logs de ejecución
    └── karate-reports_*/             # Reportes HTML de ejecuciones anteriores

```

---

## 📦 Requisitos Previos

- **Java 8 o superior** (proyecto configurado para Java 1.8)
- **Maven 3.6.0 o superior**
- **Git** (opcional, para clonar el repositorio)
- Acceso a la API: `https://api.qateamperu.com`

### Validar instalación

```powershell
# Verificar Java
java -version

# Verificar Maven
mvn -version
```

---

## 🚀 Instalación y Configuración

### 1. Clonar o descargar el proyecto

```powershell
git clone <repository-url>
cd proyecto-karate-qa-team
```

### 2. Instalar dependencias

```powershell
mvn clean install
```

### 3. Reparar tu IDE (si es necesario)

Si usas IntelliJ IDEA o Eclipse:
- Abre el proyecto
- IDE detectará automáticamente Maven y descargará dependencias
- Reconstruye el proyecto (Rebuild Project)

---

## 🎯 Ejecución de Pruebas

### ✅ Ejecuciones por Tags

El proyecto implementa tags en los archivos `.feature` para ejecutar pruebas de forma selectiva.

#### 1. **Ejecutar TODAS las pruebas**

```powershell
mvn test
```

O usando la clase `ConfigTest` (ejecución paralela con 5 threads):

```powershell
mvn test -Dtest=ConfigTest
```

---

#### 2. **Ejecutar pruebas por Tags específicos**

El comando general es:

```powershell
mvn test -Dkarate.options="--tags @NombreDelTag"
```

---

### 📍 Tags Disponibles

| Tag | Descripción | Archivo |
|-----|-------------|---------|
| `@TokenLogin` | Login exitoso con credenciales correctas (devuelve token) | `auth/loginAuth.feature` |
| `@TokenLoginIcorrecto` | Login fallido con credenciales incorrectas (401) | `auth/loginAuth.feature` |
| `@RegistroUsuario` | Registro de nuevo usuario exitoso | `register/registerAuth.feature` |
| `@RegistroUsuarioExistente` | Registro de usuario ya existente (falla esperada) | `register/registerAuth.feature` |
| `@crearProducto01` | Crear producto con número aleatorio | `product/newProductAuth.feature` |
| `@crearProducto02` | Crear producto con validación de esquema completo | `product/newProductAuth.feature` |
| `@obtenerProducto` | Obtener un producto por ID | `product/getByProduct.feature` |
| `@obtenerProductoIncorrecto` | Intentar obtener producto inexistente (404) | `product/getByProduct.feature` |
| `@consultarProductos` | Consultar lista completa de productos | `product/getByProduct.feature` |
| `@actualizarProducto` | Actualizar datos de un producto existente | `product/updateProduct.feature` |
| `@CP07` | Crear un post con docString en variable (ejemplo práctico) | `product/addProduct.feature` |

---

### 📌 Ejemplos de Ejecución por Tags

#### Ejecutar todos los tests de Login

```powershell
mvn test -Dkarate.options="--tags @TokenLogin"
```

#### Ejecutar todos los tests de Productos

```powershell
mvn test -Dkarate.options="--tags @productos"
```

#### Ejecutar tests de Registro

```powershell
mvn test -Dkarate.options="--tags @RegistroUsuario"
```

#### Ejecutar múltiples tags (OR lógico)

```powershell
mvn test -Dkarate.options="--tags @TokenLogin,@RegistroUsuario"
```

#### Ejecutar excluyendo tags específicos

```powershell
mvn test -Dkarate.options="--tags ~@TokenLoginIcorrecto"
```

#### Ejecutar desde una carpeta específica

```powershell
mvn test -Dkarate.options="classpath:bdd/product --tags @crearProducto01"
```

---

## 🔐 Autenticación y Credenciales

### Credenciales de Prueba

| Usuario | Contraseña | Caso de Uso |
|---------|-----------|-----------|
| `carlosqateam@gmail.com` | `carlos123` | Login exitoso |
| `karate123@gmail.com` | `12345678` | Login fallido (intencionalmente) |

### Información del Token

El proyecto utiliza un **sistema de reutilización de tokens**:

1. El feature `loginAuth.feature` está marcado con `@TokenLogin`
2. Otros escenarios llaman al login y reutilizan el token:
   ```gherkin
   * def reusableToken = call read('classpath:bdd/auth/loginAuth.feature@TokenLogin')
   * def authToken = reusableToken.authToken
   ```

---

## 📊 Estructura de los Feature Files

### Formato General de un Escenario

```gherkin
Feature: Descripción de la funcionalidad

  Background:
    # Configuración común para todos los escenarios
    * def reusableToken = call read('classpath:bdd/auth/loginAuth.feature@TokenLogin')
    * def authToken = reusableToken.authToken
    * url 'https://api.qateamperu.com'

  @TagEscenario
  Scenario Outline: Descripción del escenario
    Given path '/api/v1/endpoint'
    And header Authorization = 'Bearer ' + authToken
    And request <body>
    When method post
    Then status <statusCode>
    And match response.campo == '#notnull'
    
    Examples:
      | body | statusCode |
      | ... | 200 |
```

---

## 🛠️ Configuración de Karate

### Archivo: `karate-config.js`

```javascript
function fn() {
  var env = karate.env;
  
  var config = {
    env: env,
    urlBase: 'https://api.qateamperu.com'
  }
  
  return config;
}
```

**Variables disponibles globalmente:**
- `env`: Ambiente actual (desarrollo, testing, producción)
- `urlBase`: URL base de la API

---

## 📝 Recursos y Datos de Prueba

### Archivos de Solicitudes (`resources/json/auth/requests.json`)

Contiene los payloads reutilizables:
- `loginRequest`: Datos para login
- `registerRequest`: Datos para registro
- `createProductRequest`: Datos para crear producto

### Esquemas (`resources/json/auth/schemas.json`)

Define la estructura esperada de las respuestas:
- `productResponseSchema`: Estructura de respuesta de producto
- `consultarProductosResponseSchema`: Estructura de lista de productos

### Datos CSV (`resources/csv/auth/dataProduct.csv`)

Proporciona datos parametrizados para ejecutar escenarios múltiples veces con diferentes valores.

---

## 🧪 Ejemplos de Uso Avanzado

### Generar número aleatorio en Karate

```gherkin
* def generarNumero = function() { return Math.floor(1000 + Math.random() * 9000) }
* set requests.createProductRequest.codigo = 'CP' + generarNumero()
```

### Reutilizar escenarios (Scenario Reuse)

```gherkin
* def reusableIdProducto = call read('classpath:bdd/product/newProductAuth.feature@crearProducto01')
* def idProducto = reusableIdProducto.id
```

### Validar estructura completa con matches

```gherkin
And match response == schemas.productResponseSchema
```

### Validar campos no nulos

```gherkin
And match response.id == '#notnull'
```

---

## 📊 Reportes

Los reportes se generan automáticamente en el directorio `target/karate-reports_*/`.

### Ver reporte más reciente

```powershell
# Ver directorios de reportes
Get-ChildItem target/karate-reports_* | Sort-Object LastWriteTime -Descending | Select-Object -First 1
```

### Elementos del reporte

- ✅ **Escenarios exitosos/fallidos**: Conteo y detalles
- 📈 **Gráficos de ejecución**: Visualización de resultados
- 📋 **Detalles de cada paso**: Solicitudes, respuestas, validaciones
- ⏱️ **Tiempos de ejecución**: Por escenario y total

---

## 🚦 Ejecución Paralela

### Usar `ConfigTest` para ejecución paralela

```powershell
mvn test -Dtest=ConfigTest
```

**Configuración actual:** 5 threads paralelos

Para cambiar el número de threads, edita `ConfigTest.java`:

```java
.parallel(5)  // Cambiar el número aquí
```

---

## 🔧 Solución de Problemas

### Error: "No tests were executed"

**Solución:**
```powershell
mvn clean test
```

### Error: "Cannot find feature file"

**Solución:**
- Verificar que los archivos `.feature` están en `src/test/java/bdd/`
- Las rutas deben ser "classpath:bdd/..."

### Error: "Connection refused" o timeout

**Solución:**
- Verificar que la API `https://api.qateamperu.com` es accesible
- Revisar credenciales en los datos de prueba
- Verificar conectividad de red

### Tests fallando con autenticación

**Solución:**
- Verificar que las credenciales en `requests.json` son válidas
- Comprobar que el token no ha expirado
- Revisar los logs en `target/karate.log`

---

## 📚 Dependencias del Proyecto

```xml
<dependency>
    <groupId>com.intuit.karate</groupId>
    <artifactId>karate-junit5</artifactId>
    <version>1.3.1</version>
    <scope>test</scope>
</dependency>
```

**Plugins Maven:**
- `maven-compiler-plugin`: Compilación Java (v3.8.1)
- `maven-surefire-plugin`: Ejecución de tests (v2.22.2)

---

## 📖 Documentación Oficial

- [Karate Framework Docs](https://karatelabs.github.io/karate/)
- [Maven Documentation](https://maven.apache.org/guides/)
- [JUnit 5 Documentation](https://junit.org/junit5/docs/current/user-guide/)

---

## 👥 Información del Proyecto

| Propiedad | Valor |
|-----------|-------|
| **GroupId** | `com.qateam` |
| **ArtifactId** | `template-karate-qa-team` |
| **Versión** | `1.0-SNAPSHOT` |
| **Encoding** | `UTF-8` |
| **Java Version** | `1.8` |

---

## ✨ Resumen de Tags por Módulo

### 🔐 Autenticación (`auth/`)
- `@TokenLogin` - Login con credenciales válidas
- `@TokenLoginIcorrecto` - Login con credenciales inválidas

### 📝 Registro (`register/`)
- `@RegistroUsuario` - Registro exitoso
- `@RegistroUsuarioExistente` - Registro de usuario duplicado

### 📦 Productos (`product/`)
- `@crearProducto01` - Crear producto (v1)
- `@crearProducto02` - Crear producto (v2 con esquema completo)
- `@obtenerProducto` - Obtener producto
- `@obtenerProductoIncorrecto` - Obtener producto no encontrado
- `@consultarProductos` - Listar productos
- `@actualizarProducto` - Actualizar producto
- `@CP07` - Ejemplo práctico

---

## 📋 Checklist de Uso

- [ ] Instalar Java 8+
- [ ] Instalar Maven 3.6+
- [ ] Clonar el proyecto
- [ ] Ejecutar `mvn clean install`
- [ ] Verificar credenciales en `requests.json`
- [ ] Ejecutar `mvn test` para prueba inicial
- [ ] Explorar tags con `mvn test -Dkarate.options="--tags @NombreTag"`
- [ ] Revisar reportes en `target/karate-reports_*/`

---

**Última actualización:** 2026-05-28  
**Versión del Framework:** Karate 1.3.1  
**Estado:** ✅ Activo y funcional

