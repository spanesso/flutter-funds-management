import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/constants/app_strings.dart';

import '../../dashboard/presentation/pages/dashboard_page.dart';
import '../../features/funds/presentation/pages/funds_list_page.dart';
import '../../features/portfolio/presentation/pages/portfolio_page.dart';
import '../../features/subscription/presentation/pages/subscription_page.dart';
import '../../features/transactions/presentation/pages/transactions_page.dart';

final appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    ShellRoute(
      builder: (context, state, child) => _AppShell(child: child),
      routes: [
        GoRoute(
          path: '/',
          pageBuilder: (context, state) => const NoTransitionPage(
            child: DashboardPage(),
          ),
        ),
        GoRoute(
          path: '/funds',
          pageBuilder: (context, state) => const NoTransitionPage(
            child: FundsListPage(),
          ),
        ),
        GoRoute(
          path: '/portfolio',
          pageBuilder: (context, state) => const NoTransitionPage(
            child: PortfolioPage(),
          ),
        ),
        GoRoute(
          path: '/transactions',
          pageBuilder: (context, state) => const NoTransitionPage(
            child: TransactionsPage(),
          ),
        ),
      ],
    ),
    GoRoute(
      path: '/funds/:fundId',
      builder: (context, state) {
        final fundIdStr = state.pathParameters['fundId'] ?? '';
        final fundId = int.tryParse(fundIdStr) ?? 0;
        return SubscriptionPage(fundId: fundId);
      },
    ),
  ],
);

class _AppShell extends StatefulWidget {
  const _AppShell({required this.child});
  final Widget child;

  @override
  State<_AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<_AppShell> {
  static const _routes = ['/', '/funds', '/portfolio', '/transactions'];

  int _indexForLocation(String location) {
    if (location.startsWith('/funds')) return 1;
    if (location.startsWith('/portfolio')) return 2;
    if (location.startsWith('/transactions')) return 3;
    return 0;
  }

  void _onItemTapped(int index) => context.go(_routes[index]);

  @override
  Widget build(BuildContext context) {
    final location = GoRouterState.of(context).matchedLocation;
    final selectedIndex = _indexForLocation(location);
    return Scaffold(
      body: widget.child,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: selectedIndex,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home_rounded),
            label: AppStrings.navHome,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_balance_outlined),
            activeIcon: Icon(Icons.account_balance_rounded),
            label: AppStrings.navFunds,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.pie_chart_outline_rounded),
            activeIcon: Icon(Icons.pie_chart_rounded),
            label: AppStrings.navPortfolio,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.receipt_long_outlined),
            activeIcon: Icon(Icons.receipt_long_rounded),
            label: AppStrings.navHistory,
          ),
        ],
      ),
    );
  }
}
