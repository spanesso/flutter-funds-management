import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:investment_funds_app/app/theme/app_theme.dart';
import 'package:investment_funds_app/features/funds/domain/entities/fund.dart';
import 'package:investment_funds_app/features/funds/domain/repositories/fund_repository.dart';
import 'package:investment_funds_app/features/funds/domain/usecases/get_available_funds.dart';
import 'package:investment_funds_app/features/funds/presentation/providers/funds_provider.dart';
import 'package:investment_funds_app/features/portfolio/presentation/providers/portfolio_provider.dart';
import 'package:investment_funds_app/features/subscription/presentation/controllers/subscription_controller.dart';
import 'package:investment_funds_app/features/subscription/presentation/pages/subscription_page.dart';
import 'package:investment_funds_app/features/wallet/domain/entities/wallet.dart';
import 'package:investment_funds_app/features/wallet/domain/repositories/wallet_repository.dart';
import 'package:investment_funds_app/features/wallet/domain/usecases/get_wallet_balance.dart';
import 'package:investment_funds_app/features/wallet/presentation/providers/wallet_provider.dart';

class MockFundRepository extends Mock implements FundRepository {}
class MockWalletRepository extends Mock implements WalletRepository {}

void main() {
  late MockFundRepository fundRepo;
  late MockWalletRepository walletRepo;

  const testFund = Fund(
    id: 1,
    name: 'FPV_PACTUAL_RECAUDADORA',
    category: FundCategory.fpv,
    minimumAmount: 75000,
  );

  setUp(() {
    fundRepo = MockFundRepository();
    walletRepo = MockWalletRepository();

    when(() => fundRepo.getAvailableFunds())
        .thenAnswer((_) async => [testFund]);
    when(() => walletRepo.getWallet())
        .thenAnswer((_) async => const Wallet(availableBalance: 500000));
  });

  Widget buildPage({SubmitState? submitOverride}) {
    final overrides = [
      getAvailableFundsProvider.overrideWithValue(GetAvailableFunds(fundRepo)),
      getWalletBalanceProvider.overrideWithValue(GetWalletBalance(walletRepo)),
      activeSubscriptionFundIdsProvider
          .overrideWith((ref) => Future.value(<int>{})),
      if (submitOverride != null)
        subscriptionControllerProvider(1).overrideWith(
          (ref) => SubscriptionController(ref)..state = submitOverride,
        ),
    ];

    return ProviderScope(
      overrides: overrides,
      child: MaterialApp(
        theme: AppTheme.light,
        home: const SubscriptionPage(fundId: 1),
      ),
    );
  }

  testWidgets(
      'Confirm button is disabled when form is empty (no amount, no notification)',
      (tester) async {
    await tester.pumpWidget(buildPage());
    await tester.pumpAndSettle();

    final button = tester.widget<ElevatedButton>(
      find.widgetWithText(ElevatedButton, 'Confirmar inversión'),
    );
    expect(button.onPressed, isNull);
  });

  testWidgets(
      'Shows helper text when amount is below minimum',
      (tester) async {
    await tester.pumpWidget(buildPage());
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextFormField), '10000');
    await tester.pump();

    // Helper / error text contains 'Mínimo'
    expect(find.textContaining('Mínimo'), findsWidgets);
  });

  testWidgets(
      'Shows notification error label when not selected',
      (tester) async {
    await tester.pumpWidget(buildPage());
    await tester.pumpAndSettle();

    // The notification selector shows required label
    expect(find.textContaining('método de notificación'), findsWidgets);
  });

  testWidgets(
      'Shows CircularProgressIndicator during submission',
      (tester) async {
    await tester.pumpWidget(buildPage(submitOverride: const SubmitSubmitting()));
    await tester.pumpAndSettle();

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('Shows fund name and minimum amount', (tester) async {
    await tester.pumpWidget(buildPage());
    await tester.pumpAndSettle();

    expect(find.text('FPV_PACTUAL_RECAUDADORA'), findsWidgets);
    // Minimum 75.000 shown somewhere
    expect(find.textContaining('75'), findsWidgets);
  });
}
