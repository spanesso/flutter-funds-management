import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

import 'package:investment_funds_app/app/theme/app_theme.dart';
import 'package:investment_funds_app/features/funds/domain/entities/fund.dart';
import 'package:investment_funds_app/features/funds/presentation/controllers/funds_controller.dart';
import 'package:investment_funds_app/features/funds/presentation/pages/funds_list_page.dart';
import 'package:investment_funds_app/features/portfolio/presentation/providers/portfolio_provider.dart';

const _testFunds = [
  Fund(id: 1, name: 'FPV_PACTUAL_RECAUDADORA', category: FundCategory.fpv, minimumAmount: 75000),
  Fund(id: 2, name: 'FPV_PACTUAL_ECOPETROL', category: FundCategory.fpv, minimumAmount: 125000),
  Fund(id: 3, name: 'DEUDAPRIVADA', category: FundCategory.fic, minimumAmount: 50000),
  Fund(id: 4, name: 'FDO_ACCIONES', category: FundCategory.fic, minimumAmount: 250000),
  Fund(id: 5, name: 'FPV_PACTUAL_DINAMICA', category: FundCategory.fpv, minimumAmount: 100000),
];

Widget _buildPage(FundsState state) {
  final router = GoRouter(routes: [
    GoRoute(path: '/', builder: (_, __) => const FundsListPage()),
    GoRoute(path: '/funds/:fundId', builder: (_, __) => const Scaffold()),
  ]);

  return ProviderScope(
    overrides: [
      fundsControllerProvider.overrideWith(
        (ref) => FundsController(ref)..state = state,
      ),
      activeSubscriptionFundIdsProvider.overrideWith(
        (ref) => Future.value(<int>{}),
      ),
    ],
    child: MaterialApp.router(
      theme: AppTheme.light,
      routerConfig: router,
    ),
  );
}

void main() {
  testWidgets('FundsListPage renders all 5 funds when state is success',
      (tester) async {
    await tester.pumpWidget(_buildPage(const FundsSuccess(_testFunds)));
    await tester.pumpAndSettle();

    for (final fund in _testFunds) {
      expect(find.text(fund.name), findsOneWidget);
    }
  });

  testWidgets('FundsListPage shows CircularProgressIndicator when loading',
      (tester) async {
    await tester.pumpWidget(_buildPage(const FundsLoading()));
    await tester.pump();
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('FundsListPage shows retry button on error', (tester) async {
    await tester.pumpWidget(
      _buildPage(const FundsError('Error de conexión. Intenta de nuevo.')),
    );
    await tester.pumpAndSettle();
    expect(find.text('Reintentar'), findsOneWidget);
    expect(find.text('Algo salió mal'), findsOneWidget);
  });

  testWidgets('FundsListPage shows "Suscribirse" button for non-subscribed funds',
      (tester) async {
    await tester.pumpWidget(_buildPage(const FundsSuccess(_testFunds)));
    await tester.pumpAndSettle();
    expect(find.text('Suscribirse'), findsNWidgets(_testFunds.length));
  });
}
