import 'package:expenses/core/router/app_routes.dart';
import 'package:expenses/presentation/add_expense/page/add_expense_page.dart';
import 'package:expenses/presentation/dashboard/page/dashboard_page.dart';
import 'package:go_router/go_router.dart';

class AppRouter {
  static final GoRouter routes = GoRouter(
    initialLocation: Routes.dashboard,
    routes: [
      GoRoute(
        name: Routes.dashboard,
        path: Routes.dashboard,
        builder: (context, state) => DashboardPage(),
      ),
      GoRoute(
        name: Routes.addExpense,
        path: Routes.addExpense,
        builder: (context, state) => AddExpensePage(),
      ),
    ],
  );
}
