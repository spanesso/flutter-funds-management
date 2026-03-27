/// Single source of truth for every user-visible string in the app.
///
/// UI widgets import this class instead of embedding literals so that
/// copy changes and future localisation only require editing one file.
class AppStrings {
  const AppStrings._();

  // -------------------------------------------------------------------------
  // App
  // -------------------------------------------------------------------------
  static const appTitle = 'Investment Funds';

  // -------------------------------------------------------------------------
  // Bottom navigation
  // -------------------------------------------------------------------------
  static const navHome = 'Inicio';
  static const navFunds = 'Fondos';
  static const navPortfolio = 'Portafolio';
  static const navHistory = 'Historial';

  // -------------------------------------------------------------------------
  // Dashboard
  // -------------------------------------------------------------------------
  static const dashboardTitle = 'Inicio';
  static const dashboardLoading = 'Cargando información...';
  static const dashboardBalanceLabel = 'Saldo disponible';
  static const dashboardBalanceCurrency = 'Pesos colombianos';
  static const dashboardActiveFundsLabel = 'Fondos activos';
  static const dashboardTotalInvestedLabel = 'Total invertido';
  static const dashboardActionFunds = 'Ver Fondos';
  static const dashboardActionHistory = 'Ver Historial';

  // -------------------------------------------------------------------------
  // Funds list
  // -------------------------------------------------------------------------
  static const fundsTitle = 'Fondos de inversión';
  static const fundsLoading = 'Cargando fondos...';
  static const fundsEmptyTitle = 'Sin fondos disponibles';
  static const fundsEmptySubtitle = 'No hay fondos disponibles en este momento.';
  static const fundCategoryFpv = 'FPV';
  static const fundCategoryFic = 'FIC';
  static const fundMinimumPrefix = 'Mínimo: ';
  static const fundStatusActive = 'Activo';
  static const fundStatusAvailable = 'Disponible';
  static const fundSubscribeButton = 'Suscribirse';
  static const fundCancelButton = 'Cancelar suscripción';

  // -------------------------------------------------------------------------
  // Portfolio
  // -------------------------------------------------------------------------
  static const portfolioTitle = 'Mi portafolio';
  static const portfolioLoading = 'Cargando portafolio...';
  static const portfolioEmptyTitle = 'Sin fondos activos';
  static const portfolioEmptySubtitle =
      'Aún no tienes fondos activos. ¡Empieza a invertir!';
  static const portfolioEmptyAction = 'Ver fondos disponibles';
  static const portfolioCardAmountLabel = 'Monto invertido';
  static const portfolioCardDateLabel = 'Fecha';
  static const portfolioCardNotificationLabel = 'Notificación';
  static const portfolioCancelButton = 'Cancelar suscripción';

  // -------------------------------------------------------------------------
  // Cancel dialog (shared by Funds and Portfolio)
  // -------------------------------------------------------------------------
  static const cancelDialogTitle = 'Cancelar suscripción';
  static const cancelDialogNegative = 'No, mantener';
  static const cancelDialogPositive = 'Sí, cancelar';

  static String cancelDialogBodyFunds(String fundName) =>
      '¿Estás seguro de que deseas cancelar tu participación en $fundName? '
      'El monto invertido será reintegrado a tu saldo.';

  static String cancelDialogBodyPortfolio(String fundName) =>
      '¿Confirmas la cancelación de tu participación en $fundName? '
      'El monto será reintegrado a tu saldo.';

  static const cancelSuccessFunds = 'Suscripción cancelada correctamente.';
  static const cancelSuccessPortfolio = 'Suscripción cancelada. Monto reintegrado.';

  // -------------------------------------------------------------------------
  // Subscription page
  // -------------------------------------------------------------------------
  static const subscriptionPageTitle = 'Suscribirse al fondo';
  static const subscriptionPageTitleFallback = 'Suscribirse';
  static const subscriptionLoading = 'Cargando fondo...';
  static const subscriptionFundNotFound = 'Fondo no encontrado.';
  static const subscriptionBalancePrefix = 'Saldo disponible: ';
  static const subscriptionConfirmButton = 'Confirmar inversión';
  static const subscriptionNotificationRequiredError =
      'Selecciona un método de notificación';

  static String subscriptionSuccess(String fundName) =>
      '¡Inversión realizada con éxito en $fundName!';

  // -------------------------------------------------------------------------
  // Amount input field
  // -------------------------------------------------------------------------
  static const amountLabel = 'Monto a invertir';
  static const amountHint = 'Ej: 100000';
  static const amountCurrencyPrefix = 'COP ';
  static const amountErrorZero = 'El monto debe ser mayor a cero.';

  static String amountErrorMinimum(String min) => 'Mínimo: $min';
  static String amountErrorBalance(String available) =>
      'Saldo insuficiente. Disponible: $available';
  static String amountHelperMinimum(String min) => 'Mínimo $min';

  // -------------------------------------------------------------------------
  // Notification selector
  // -------------------------------------------------------------------------
  static const notificationLabel = 'Método de notificación *';
  static const notificationDescription =
      'Selecciona cómo deseas recibir confirmaciones';
  static const notificationRequiredError =
      'Debes seleccionar un método de notificación.';
  static const notificationEmail = 'Email';
  static const notificationSms = 'SMS';

  // -------------------------------------------------------------------------
  // Transactions / History
  // -------------------------------------------------------------------------
  static const transactionsTitle = 'Historial';
  static const transactionsLoading = 'Cargando historial...';
  static const transactionsEmptyTitle = 'Sin transacciones';
  static const transactionsEmptySubtitle =
      'No tienes transacciones aún. ¡Empieza a invertir!';
  static const transactionTypeSubscription = 'Suscripción';
  static const transactionTypeCancellation = 'Cancelación';

  // -------------------------------------------------------------------------
  // Shared widgets
  // -------------------------------------------------------------------------
  static const errorWidgetTitle = 'Algo salió mal';
  static const errorWidgetRetry = 'Reintentar';

  // -------------------------------------------------------------------------
  // Business error messages
  // -------------------------------------------------------------------------
  static const errInsufficientBalance =
      'Saldo insuficiente para realizar esta inversión.';
  static const errAmountBelowMinimum =
      'El monto es inferior al mínimo requerido por el fondo.';
  static const errInvalidAmount = 'Ingresa un monto válido mayor a cero.';
  static const errNotificationRequired =
      'Debes seleccionar un método de notificación.';
  static const errFundNotFound = 'El fondo seleccionado no existe.';
  static const errSubscriptionNotFound =
      'No tienes una participación activa en este fondo.';
  static const errDuplicateSubscription =
      'Ya tienes una participación activa en este fondo.';
  static const errTransactionRejected =
      'La transacción fue rechazada por razones de seguridad.';

  // -------------------------------------------------------------------------
  // Technical error messages
  // -------------------------------------------------------------------------
  static const errNetwork = 'Error de conexión. Intenta de nuevo.';
  static const errParsing = 'Error al procesar los datos. Intenta de nuevo.';
  static const errStorage = 'Error de almacenamiento. Intenta de nuevo.';
  static const errUnknown = 'Ocurrió un error inesperado. Intenta de nuevo.';
}
