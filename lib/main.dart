import 'package:flutter/material.dart';
import 'package:phluowise/contants/app_theme.dart';
import 'package:phluowise/controllers/appwrite_controller.dart';
import 'package:phluowise/controllers/theme_controller.dart';
import 'package:phluowise/services/preferences_service.dart';
import 'package:phluowise/splash.dart';
import 'package:provider/provider.dart';
import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart' as models;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await PreferenceService.init();
  Client client = Client()
      .setEndpoint("https://nyc.cloud.appwrite.io/v1")
      .setProject("68b17582003582da69c8");
  Account account = Account(client);
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeController()),
        ChangeNotifierProvider(create: (_) => AppwriteAuthProvider()),
      ],
      child: MainApp(account: account),
    ),
  );
}

class MainApp extends StatelessWidget {
  final Account account;

  const MainApp({super.key, required this.account});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeController>(context);

    return MaterialApp(
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeProvider.isDarkMode ? ThemeMode.dark : ThemeMode.light,
      home: Splash(),
    );
  }
}
