import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:investment_funds_app/app/theme/app_theme.dart';
import 'package:investment_funds_app/features/transactions/presentation/controllers/transactions_controller.dart';
import 'package:investment_funds_app/features/transactions/presentation/pages/transactions_page.dart';
import 'package:investment_funds_app/shared/widgets/empty_state_widget.dart';

void main() {
  testWidgets('TransactionsPage shows empty state when no transactions',
      (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          transactionsControllerProvider.overrideWith(
            (ref) => TransactionsController(ref)
              ..state = const TransactionsEmpty(),
          ),
        ],
        child: MaterialApp(
          theme: AppTheme.light,
          home: const TransactionsPage(),
        ),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.byType(EmptyStateWidget), findsOneWidget);
    expect(find.textContaining('Sin transacciones'), findsOneWidget);
  });

  testWidgets('TransactionsPage shows loading indicator while loading',
      (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          transactionsControllerProvider.overrideWith(
            (ref) => TransactionsController(ref)
              ..state = const TransactionsLoading(),
          ),
        ],
        child: MaterialApp(
          theme: AppTheme.light,
          home: const TransactionsPage(),
        ),
      ),
    );

    await tester.pump();
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });
}
