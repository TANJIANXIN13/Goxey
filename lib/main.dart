import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/theme.dart';
import 'core/app_state.dart';
import 'core/budget_provider.dart';
import 'core/pocket_provider.dart';
import 'pages/dashboard_page.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AppState()),
        ChangeNotifierProvider(create: (context) => BudgetProvider()),
        ChangeNotifierProvider(create: (context) => PocketProvider()),
      ],
      child: const GoXeyApp(),
    ),
  );
}

class GoXeyApp extends StatelessWidget {
  const GoXeyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return Consumer<AppState>(
      builder: (context, appState, child) {
        return MaterialApp(
          title: 'GoXey',
          debugShowCheckedModeBanner: false,
          theme: GoXeyTheme.darkTheme,
          home: const DashboardPage(),
        );
      },
    );
  }
}
