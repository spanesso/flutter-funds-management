import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../core/constants/app_constants.dart';
import '../core/errors/exceptions.dart';
import '../features/funds/domain/entities/fund.dart';
import '../features/subscription/domain/entities/subscription.dart';
import '../features/transactions/domain/entities/transaction.dart';
import '../features/wallet/domain/entities/wallet.dart';

/// In-memory mock datasource with **local persistence** via SharedPreferences.
///
/// Mutable state (wallet, subscriptions, transactions) is written to disk
/// after every mutation so it survives app restarts.
/// The immutable fund catalogue is always loaded from code.
class MockDatasource {
  MockDatasource._() {
    _initFuture = _loadFromStorage();
  }

  static final MockDatasource _instance = MockDatasource._();
  factory MockDatasource() => _instance;

  // Keys used in SharedPreferences
  static const _kWallet = 'ds_wallet';
  static const _kSubscriptions = 'ds_subscriptions';
  static const _kTransactions = 'ds_transactions';

  // Resolved once on first access; all methods await it before touching state.
  late final Future<void> _initFuture;

  // --- In-memory state ---
  final List<Fund> _funds = const [
    Fund(
      id: 1,
      name: 'FPV_PACTUAL_RECAUDADORA',
      category: FundCategory.fpv,
      minimumAmount: 75000,
    ),
    Fund(
      id: 2,
      name: 'FPV_PACTUAL_ECOPETROL',
      category: FundCategory.fpv,
      minimumAmount: 125000,
    ),
    Fund(
      id: 3,
      name: 'DEUDAPRIVADA',
      category: FundCategory.fic,
      minimumAmount: 50000,
    ),
    Fund(
      id: 4,
      name: 'FDO_ACCIONES',
      category: FundCategory.fic,
      minimumAmount: 250000,
    ),
    Fund(
      id: 5,
      name: 'FPV_PACTUAL_DINAMICA',
      category: FundCategory.fpv,
      minimumAmount: 100000,
    ),
  ];

  Wallet _wallet = const Wallet(availableBalance: AppConstants.initialBalance);
  final List<Subscription> _subscriptions = [];
  final List<Transaction> _transactions = [];

  bool _simulateNetworkError = false;

  // --- Control ---
  void enableNetworkError() => _simulateNetworkError = true;
  void disableNetworkError() => _simulateNetworkError = false;

  /// Resets all mutable state and clears persisted data (used in tests).
  Future<void> reset() async {
    _simulateNetworkError = false;
    _wallet = const Wallet(availableBalance: AppConstants.initialBalance);
    _subscriptions.clear();
    _transactions.clear();
    final prefs = await SharedPreferences.getInstance();
    await Future.wait([
      prefs.remove(_kWallet),
      prefs.remove(_kSubscriptions),
      prefs.remove(_kTransactions),
    ]);
  }

  // --- Funds (static, no persistence needed) ---
  Future<List<Fund>> getFunds() async {
    await _initFuture;
    await _delay();
    _checkNetworkError();
    return List.unmodifiable(_funds);
  }

  // --- Wallet ---
  Future<Wallet> getWallet() async {
    await _initFuture;
    await _delay();
    _checkNetworkError();
    return _wallet;
  }

  Future<void> updateWalletBalance(double newBalance) async {
    await _initFuture;
    await _delay();
    _checkNetworkError();
    _wallet = Wallet(availableBalance: newBalance);
    await _persistAll();
  }

  // --- Subscriptions ---
  Future<List<Subscription>> getActiveSubscriptions() async {
    await _initFuture;
    await _delay();
    _checkNetworkError();
    return List.unmodifiable(
      _subscriptions.where((s) => s.isActive).toList(),
    );
  }

  Future<void> createSubscription(Subscription subscription) async {
    await _initFuture;
    await _delay();
    _checkNetworkError();
    _subscriptions.add(subscription);
    await _persistAll();
  }

  Future<void> cancelSubscription(int fundId) async {
    await _initFuture;
    await _delay();
    _checkNetworkError();
    final index = _subscriptions.indexWhere(
      (s) => s.fundId == fundId && s.isActive,
    );
    if (index != -1) {
      _subscriptions[index] = _subscriptions[index].copyWith(isActive: false);
    }
    await _persistAll();
  }

  // --- Transactions ---
  Future<List<Transaction>> getTransactions() async {
    await _initFuture;
    await _delay();
    _checkNetworkError();
    return List.unmodifiable(_transactions);
  }

  Future<void> addTransaction(Transaction transaction) async {
    await _initFuture;
    await _delay();
    _checkNetworkError();
    _transactions.add(transaction);
    await _persistAll();
  }

  // -------------------------------------------------------------------------
  // Storage helpers
  // -------------------------------------------------------------------------

  Future<void> _loadFromStorage() async {
    final prefs = await SharedPreferences.getInstance();

    // Wallet
    final walletStr = prefs.getString(_kWallet);
    if (walletStr != null) {
      try {
        final j = json.decode(walletStr) as Map<String, dynamic>;
        _wallet = Wallet(availableBalance: (j['balance'] as num).toDouble());
      } catch (_) {/* keep default */}
    }

    // Subscriptions
    final subsStr = prefs.getString(_kSubscriptions);
    if (subsStr != null) {
      try {
        final list = json.decode(subsStr) as List<dynamic>;
        _subscriptions.clear();
        for (final item in list) {
          _subscriptions.add(_subFromJson(item as Map<String, dynamic>));
        }
      } catch (_) {/* keep empty */}
    }

    // Transactions
    final txStr = prefs.getString(_kTransactions);
    if (txStr != null) {
      try {
        final list = json.decode(txStr) as List<dynamic>;
        _transactions.clear();
        for (final item in list) {
          _transactions.add(_txFromJson(item as Map<String, dynamic>));
        }
      } catch (_) {/* keep empty */}
    }
  }

  Future<void> _persistAll() async {
    final prefs = await SharedPreferences.getInstance();
    await Future.wait([
      prefs.setString(
        _kWallet,
        json.encode({'balance': _wallet.availableBalance}),
      ),
      prefs.setString(
        _kSubscriptions,
        json.encode(_subscriptions.map(_subToJson).toList()),
      ),
      prefs.setString(
        _kTransactions,
        json.encode(_transactions.map(_txToJson).toList()),
      ),
    ]);
  }

  // -------------------------------------------------------------------------
  // Serialization helpers (entity ↔ JSON, kept private to the datasource)
  // -------------------------------------------------------------------------

  Map<String, dynamic> _subToJson(Subscription s) => {
        'id': s.id,
        'fund_id': s.fundId,
        'fund_name': s.fundName,
        'category': s.category.name,
        'subscribed_amount': s.subscribedAmount,
        'subscribed_at': s.subscribedAt.toIso8601String(),
        'notification_method': s.notificationMethod.name,
        'is_active': s.isActive,
      };

  Subscription _subFromJson(Map<String, dynamic> j) => Subscription(
        id: j['id'] as String,
        fundId: j['fund_id'] as int,
        fundName: j['fund_name'] as String,
        category: FundCategory.values.byName(j['category'] as String),
        subscribedAmount: (j['subscribed_amount'] as num).toDouble(),
        subscribedAt: DateTime.parse(j['subscribed_at'] as String),
        notificationMethod:
            NotificationMethod.values.byName(j['notification_method'] as String),
        isActive: j['is_active'] as bool,
      );

  Map<String, dynamic> _txToJson(Transaction t) => {
        'id': t.id,
        'type': t.type.name,
        'fund_id': t.fundId,
        'fund_name': t.fundName,
        'category': t.category.name,
        'amount': t.amount,
        'created_at': t.createdAt.toIso8601String(),
        'notification_method': t.notificationMethod?.name,
      };

  Transaction _txFromJson(Map<String, dynamic> j) => Transaction(
        id: j['id'] as String,
        type: TransactionType.values.byName(j['type'] as String),
        fundId: j['fund_id'] as int,
        fundName: j['fund_name'] as String,
        category: FundCategory.values.byName(j['category'] as String),
        amount: (j['amount'] as num).toDouble(),
        createdAt: DateTime.parse(j['created_at'] as String),
        notificationMethod: j['notification_method'] != null
            ? NotificationMethod.values
                .byName(j['notification_method'] as String)
            : null,
      );

  // -------------------------------------------------------------------------
  // Private helpers
  // -------------------------------------------------------------------------

  Future<void> _delay() => Future.delayed(AppConstants.mockDelay);

  void _checkNetworkError() {
    if (_simulateNetworkError) {
      throw const NetworkException('Simulated network error');
    }
  }
}

final mockDatasourceProvider = Provider<MockDatasource>(
  (_) => MockDatasource(),
);
