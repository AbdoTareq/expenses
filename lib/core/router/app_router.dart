import 'package:expenses/core/router/app_routes.dart';
import 'package:expenses/presentation/page/dashboard_page.dart';
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
    ],
  );
}
