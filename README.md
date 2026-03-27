# Investment Funds Management App

Aplicación móvil desarrollada en **Flutter** para la gestión de fondos de inversión, orientada a un escenario de usuario único con operaciones sobre saldo disponible, suscripciones a fondos, cancelaciones de participaciones e historial transaccional.

Este proyecto está construido siguiendo una **Clean Architecture** bien definida, con separación estricta de responsabilidades entre presentación, dominio, datos y fuente de datos, además de un núcleo compartido para errores, utilidades y objetos de valor.

---

## Tabla de contenido

- [Descripción general](#descripción-general)
- [Objetivo del proyecto](#objetivo-del-proyecto)
- [Características principales](#características-principales)
- [Arquitectura](#arquitectura)
- [Capas del proyecto](#capas-del-proyecto)
- [Estructura funcional por features](#estructura-funcional-por-features)
- [Flujo de datos](#flujo-de-datos)
- [Pantallas y navegación](#pantallas-y-navegación)
- [Reglas de negocio implementadas](#reglas-de-negocio-implementadas)
- [Persistencia y fuente de datos](#persistencia-y-fuente-de-datos)
- [Seguridad transaccional](#seguridad-transaccional)
- [Gestión de estado](#gestión-de-estado)

---

## Descripción general

La aplicación permite gestionar un portafolio de fondos de inversión de forma simple y controlada. El sistema parte de un saldo inicial en pesos colombianos y ofrece una lista fija de fondos disponibles para invertir. Cada operación actualiza el estado persistido localmente y registra una transacción para consulta posterior.

### Datos base del sistema

- **Saldo inicial:** `COP 500.000`
- **Fondos disponibles:** `5 fondos hardcoded`
- **Persistencia local:** `SharedPreferences`
- **Latencia simulada:** `800 ms` por operación
- **Contexto funcional:** suscripción, cancelación, consulta de portafolio e historial

---

## Objetivo del proyecto

El propósito principal de este proyecto es servir como una implementación de referencia de una app Flutter con:

- separación arquitectónica clara,
- lógica de negocio independiente de la UI,
- manejo de errores controlado,
- persistencia local transparente,
- flujo transaccional validado,
- y base preparada para evolucionar a un backend real sin romper dominio ni presentación.

---

## Características principales

- Visualización de fondos de inversión disponibles.
- Consulta de saldo actual.
- Suscripción a fondos con validaciones financieras.
- Cancelación de suscripciones activas.
- Registro de historial de transacciones.
- Selección de método de notificación (`email` o `sms`) al suscribirse.
- Persistencia local del estado del usuario.
- Protección contra transacciones inválidas o duplicadas.
- Gestión reactiva del estado con Riverpod.

---

## Arquitectura

El proyecto implementa **Clean Architecture** con **4 capas explícitas** y una **capa adicional de datasource**.

### Principios arquitectónicos aplicados

- **Separación estricta de capas**
- **Inversión de dependencias**
- **Dominio desacoplado de Flutter**
- **Repositorios abstractos en dominio**
- **Implementaciones concretas en data**
- **UI reactiva desacoplada de la lógica de negocio**
- **Patrón Result para control funcional de errores**
- **Patrón Decorator en seguridad transaccional**

### Vista conceptual

```text
PRESENTATION
  ├── Pages
  ├── Controllers / StateNotifiers
  └── Providers

DOMAIN
  ├── Entities
  ├── UseCases
  ├── Repository Contracts
  └── Security Services

DATA
  ├── Models / DTOs
  ├── Mappers
  ├── Repository Implementations
  └── Decorators

DATASOURCE
  └── MockDatasource + SharedPreferences

CORE
  ├── Errors
  ├── Result<T>
  ├── Constants
  ├── Utils
  └── Value Objects
```

---

## Capas del proyecto

## 1) Core

La capa `core` contiene elementos transversales reutilizables por el resto del sistema. No concentra lógica de UI ni reglas de negocio de un feature específico.

### Responsabilidades principales

- manejo uniforme de errores,
- contrato de resultados con `Result<T>`,
- constantes globales,
- utilidades de formato,
- extensiones comunes,
- objetos de valor.

### Elementos destacados

#### `core/result/result.dart`
Implementa un tipo sellado `Result<T>` con variantes como:

- `Success<T>`
- `Failure<T>`

Esto permite propagar resultados entre capas sin depender de excepciones no controladas.

#### `core/errors/app_error.dart`
Clase base abstracta para errores de aplicación con un `userMessage`.

#### `core/errors/business_errors.dart`
Agrupa errores de negocio, por ejemplo:

- saldo insuficiente,
- fondo no encontrado,
- monto inválido,
- suscripción duplicada,
- monto por debajo del mínimo.

#### `core/errors/technical_errors.dart`
Contiene errores técnicos como:

- `NetworkError`
- `StorageError`
- `UnknownError`
- `ParsingError`

#### `core/errors/exceptions.dart`
Define excepciones crudas provenientes del datasource.

#### `core/domain/money.dart`
Objeto de valor `Money` que protege la invariante de no permitir valores negativos.

#### `core/constants/app_strings.dart`
Fuente única de verdad para textos mostrados al usuario.

#### `core/constants/app_constants.dart`
Constantes clave del sistema como:

- `initialBalance`
- `mockDelay`
- `currencySymbol`

#### `core/utils/currency_formatter.dart`
Formatea montos para visualización monetaria.

#### `core/utils/date_formatter.dart`
Formatea fechas para interfaz.

#### `core/extensions/context_extensions.dart`
Extensiones del contexto para mostrar snackbars de éxito o error.

---

## 2) Datasource

La capa `datasource` es la fuente efectiva de acceso a datos. En este proyecto se implementa como un **mock local persistido**, útil para pruebas funcionales, demostración o desarrollo desacoplado del backend.

### Implementación principal

#### `MockDatasource`
Características:

- Singleton
- Inicialización asíncrona lazy
- Persistencia mediante `SharedPreferences`
- Estado en memoria + serialización JSON
- Fondos disponibles hardcoded
- Simulación de latencia
- Simulación opcional de error de red

### Claves de persistencia usadas

- `ds_wallet`
- `ds_subscriptions`
- `ds_transactions`

### Comportamiento importante

El constructor dispara una carga inicial desde almacenamiento, y todas las operaciones esperan a que la inicialización termine antes de ejecutarse. Tras cada modificación, se persiste el estado completo.

---

## 3) Domain

La capa `domain` es el corazón del sistema. No depende de Flutter ni de frameworks externos. Aquí vive la lógica de negocio real.

### Responsabilidades

- definición de entidades,
- contratos de repositorio,
- casos de uso,
- reglas transaccionales,
- seguridad de negocio.

### Por qué esta capa es importante

La UI no decide reglas.  
La fuente de datos no decide reglas.  
El dominio concentra la lógica que define cómo debe comportarse el sistema.

---

## 4) Data

La capa `data` traduce el dominio hacia la infraestructura concreta.

### Responsabilidades

- DTOs / modelos de almacenamiento
- mappers entre modelo y entidad
- implementación de repositorios
- decoradores técnicos o de seguridad

### Patrón usado

Cada feature sigue un patrón consistente:

- `model`
- `mapper`
- `repository_impl`

Esto permite cambiar la persistencia sin afectar al dominio.

---

## 5) Presentation

La capa `presentation` contiene:

- pantallas,
- widgets de UI,
- controladores,
- providers,
- navegación,
- estados reactivos.

### Responsabilidades

- renderizar información,
- recibir interacción del usuario,
- invocar casos de uso,
- reflejar estados como loading, éxito, vacío o error.

La lógica de presentación está desacoplada de la lógica de negocio.

---

## Estructura funcional por features

El sistema se organiza por funcionalidades de negocio.

### Funds

Administra la consulta de fondos disponibles.

#### Dominio

- `entities/fund.dart`
- `repositories/fund_repository.dart`
- `usecases/get_available_funds.dart`

#### Responsabilidad
Obtener la lista de fondos disponibles para inversión.

---

### Wallet

Administra el saldo del usuario.

#### Dominio

- `entities/wallet.dart`
- `repositories/wallet_repository.dart`
- `usecases/get_wallet_balance.dart`

#### Responsabilidad
Consultar y actualizar el saldo disponible.

---

### Subscription

Administra suscripciones a fondos.

#### Dominio

- `entities/subscription.dart`
- `repositories/subscription_repository.dart`
- `usecases/subscribe_to_fund.dart`
- `usecases/cancel_fund_subscription.dart`
- `usecases/get_active_subscriptions.dart`

#### Responsabilidad
Crear suscripciones, cancelarlas y consultar las activas.

#### Punto importante
El caso de uso `SubscribeToFund` es uno de los más complejos porque orquesta múltiples validaciones y escrituras.

---

### Transactions

Administra el historial de movimientos.

#### Dominio

- `entities/transaction.dart`
- `repositories/transaction_repository.dart`
- `usecases/get_transactions_history.dart`

#### Seguridad adicional

- `security/transaction_guard.dart`
- `security/transaction_audit_log.dart`
- `security/audit_entry.dart`

#### Responsabilidad
Registrar y consultar transacciones, validando integridad y evitando duplicados.

---

## Flujo de datos

A continuación se resume el flujo completo de una suscripción:

```text
UI
 └── SubscriptionController.subscribe()

Presentation
 └── Invoca caso de uso SubscribeToFund

Domain
 ├── Valida monto > 0
 ├── Valida que el fondo exista
 ├── Valida monto mínimo
 ├── Valida saldo suficiente
 ├── Valida que no exista suscripción duplicada
 ├── Crea suscripción
 ├── Debita saldo
 └── Registra transacción

Data
 ├── Repositorios concretos
 └── Decorador de seguridad para transacciones

Datasource
 └── Persistencia en SharedPreferences
```

### Resultado final del flujo

- Se actualiza la suscripción
- Se actualiza la billetera
- Se registra la transacción
- La UI recibe estado de éxito
- Se refrescan providers afectados
- La pantalla retorna al flujo anterior

---

## Pantallas y navegación

La navegación está implementada con **GoRouter**.

## Pantallas principales

### Dashboard (`/`)
Muestra:

- saldo disponible,
- fondos activos,
- total invertido,
- accesos rápidos.

### Fondos (`/funds`)
Muestra:

- lista de fondos,
- categoría,
- monto mínimo,
- estado de disponibilidad o actividad.

Permite:

- iniciar suscripción,
- cancelar suscripción,
- refrescar listado.

### Suscripción (`/funds/:fundId`)
Pantalla de formulario para invertir en un fondo específico.

Permite:

- ingresar monto,
- validar monto,
- elegir método de notificación,
- confirmar inversión.

### Portafolio (`/portfolio`)
Muestra suscripciones activas con detalles como:

- monto invertido,
- fecha,
- método de notificación.

### Historial (`/transactions`)
Muestra el historial transaccional ordenado de más reciente a más antiguo.

---

## ShellRoute y comportamiento de navegación

Las rutas principales comparten una navegación inferior. La ruta de suscripción está fuera del shell para ocultar la barra inferior durante el formulario.

### Reglas

- `context.go()` para navegación principal
- `context.push()` para navegación al detalle/formulario
- `context.pop()` para regresar
- el tab activo se deriva del `matchedLocation`, no de estado local manual

Esto garantiza sincronización consistente del estado de navegación.

---

## Reglas de negocio implementadas

El proyecto implementa reglas claras y explícitas.

### Suscripción

- El monto debe ser mayor a cero.
- El fondo debe existir.
- El monto debe cumplir el mínimo del fondo.
- El usuario debe tener saldo suficiente.
- No puede existir una suscripción activa duplicada al mismo fondo.

### Cancelación

- Debe existir una suscripción activa para cancelar.
- Al cancelar, el saldo se reintegra inmediatamente.
- Debe registrarse una transacción de cancelación.

### Transacciones

- Toda transacción debe tener monto válido.
- No se aceptan duplicados por ID.
- Cada intento puede quedar auditado.

---

## Persistencia y fuente de datos

La persistencia actual está diseñada para ser simple pero consistente.

### Qué se persiste

- billetera,
- suscripciones,
- historial de transacciones.

### Qué no se persiste

- la lista de fondos, ya que está hardcoded.

### Ventajas del enfoque actual

- sencillo de probar,
- rápido de ejecutar,
- sin necesidad de backend,
- adecuado para demo técnica o prueba funcional.

### Limitación

No es un reemplazo de un backend real ni de una base de datos robusta para producción.

---

## Seguridad transaccional

Una parte interesante del diseño es la protección transaccional.

### `TransactionGuard`
Valida que la transacción sea segura antes de persistirse.

### `TransactionAuditLog`
Registra intentos de operación en un esquema append-only.

### `SecureTransactionRepository`
Aplica el patrón **Decorator** para interceptar el registro de transacciones y validar antes de delegar.

### Beneficio

La seguridad se agrega sin contaminar el resto del dominio ni acoplarse a la UI.

---

## Gestión de estado

El estado reactivo se construye con **Riverpod** y `StateNotifier`.

### Controllers identificados

- `FundsController`
- `SubscriptionController`
- `PortfolioController`
- `TransactionsController`
- `DashboardController`

### Patrón de estado

Cada controller maneja estados sellados como:

- inicial,
- cargando,
- éxito,
- vacío,
- error.

Esto hace que la UI sea predecible y que el compilador ayude a cubrir todos los escenarios.

---
