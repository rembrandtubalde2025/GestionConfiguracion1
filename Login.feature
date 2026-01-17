Feature: Autenticación de usuarios - Login

  Como usuario del sistema
  Quiero iniciar sesión con mis credenciales
  Para acceder de forma segura a la aplicación

  Background:
    Given el sistema está disponible
    And el usuario se encuentra en la página de Login

  # -------------------------------
  # ESCENARIOS POSITIVOS
  # -------------------------------

  Scenario: Login exitoso con credenciales válidas y 2da verificacion
    Given existe un usuario válido con estado activo
    When el usuario ingresa un nombre de usuario válido
    And ingresa una contraseña válida
    And ingresa el codigo de doble factor
    And presiona el botón "Iniciar sesión"
    Then el sistema permite el acceso
    And redirige al dashboard principal

  # -------------------------------
  # ESCENARIOS NEGATIVOS
  # -------------------------------

  Scenario: Login fallido por contraseña incorrecta
    Given existe un usuario válido
    When el usuario ingresa un nombre de usuario válido
    And ingresa una contraseña incorrecta
    And presiona el botón "Iniciar sesión"
    Then el sistema deniega el acceso
    And muestra el mensaje "Credenciales incorrectas"

  Scenario: Login fallido por usuario inexistente
    Given el usuario no se encuentra registrado en el sistema
    When el usuario ingresa un nombre de usuario inexistente
    And ingresa cualquier contraseña
    And presiona el botón "Iniciar sesión"
    Then el sistema deniega el acceso
    And muestra un mensaje de error genérico

  Scenario: Intento de login con campos obligatorios vacíos
    When el usuario deja los campos usuario y contraseña vacíos
    And presiona el botón "Iniciar sesión"
    Then el sistema muestra mensajes de validación
    And no envía la solicitud de autenticación

  # -------------------------------
  # ESCENARIOS DE SEGURIDAD
  # -------------------------------

  Scenario: Intento de login con usuario bloqueado
    Given existe un usuario con estado bloqueado
    When el usuario ingresa su nombre de usuario
    And ingresa una contraseña válida
    And presiona el botón "Iniciar sesión"
    Then el sistema deniega el acceso
    And muestra el mensaje "Usuario bloqueado, contacte al administrador"

  Scenario: Login con contraseña expirada
    Given existe un usuario con contraseña expirada
    When el usuario ingresa su nombre de usuario
    And ingresa una contraseña correcta
    And presiona el botón "Iniciar sesión"
    Then el sistema redirige a la pantalla de cambio de contraseña

  # -------------------------------
  # ESCENARIOS DE USABILIDAD
  # -------------------------------

  Scenario: Sensibilidad a mayúsculas en el nombre de usuario
    Given el sistema define reglas de sensibilidad a mayúsculas
    When el usuario ingresa su nombre de usuario en mayúsculas
    And ingresa una contraseña válida
    And presiona el botón "Iniciar sesión"
    Then el sistema evalúa las credenciales según las reglas definidas
    And el comportamiento es consistente

  # -------------------------------
  # ESCENARIOS DE SEGURIDAD AVANZADA
  # -------------------------------

  Scenario: Intento de login con caracteres especiales
    When el usuario ingresa caracteres especiales en el campo usuario
    And ingresa cualquier contraseña
    And presiona el botón "Iniciar sesión"
    Then el sistema rechaza el acceso
    And no presenta errores internos
    And registra el intento como evento de seguridad
