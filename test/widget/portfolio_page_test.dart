import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:investment_funds_app/app/theme/app_theme.dart';
import 'package:investment_funds_app/features/portfolio/presentation/controllers/portfolio_controller.dart';
import 'package:investment_funds_app/features/portfolio/presentation/pages/portfolio_page.dart';
import 'package:investment_funds_app/shared/widgets/empty_state_widget.dart';

void main() {
  testWidgets('PortfolioPage shows empty state when no active subscriptions',
      (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          portfolioControllerProvider.overrideWith(
            (ref) => PortfolioController(ref)..state = const PortfolioEmpty(),
          ),
        ],
        child: MaterialApp(
          theme: AppTheme.light,
          home: const PortfolioPage(),
        ),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.byType(EmptyStateWidget), findsOneWidget);
    expect(find.textContaining('Sin fondos activos'), findsOneWidget);
  });

  testWidgets('PortfolioPage shows loading indicator while loading',
      (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          portfolioControllerProvider.overrideWith(
            (ref) =>
                PortfolioController(ref)..state = const PortfolioLoading(),
          ),
        ],
        child: MaterialApp(
          theme: AppTheme.light,
          home: const PortfolioPage(),
        ),
      ),
    );

    await tester.pump();
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });
}
