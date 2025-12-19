import 'dart:async';

import 'package:flutter/material.dart';
import 'package:phluowise/contants/app_color.dart';
import 'package:phluowise/controllers/appwrite_controller.dart';
import 'package:phluowise/screens/auth/sign_in.dart';
import 'package:phluowise/screens/onboarding.dart';
import 'package:phluowise/services/preferences_service.dart';
import 'package:phluowise/tabs.dart';
import 'package:provider/provider.dart';

class Wrapper extends StatefulWidget {
  const Wrapper({super.key});

  @override
  State<Wrapper> createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _initApp();
  }

  Future<void> _initApp() async {
    final appWrite = context.read<AppwriteAuthProvider>();
    await appWrite.loadUser(); // ← Wait for real auth check
    if (mounted) {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final appWrite = context.watch<AppwriteAuthProvider>();
    final preferenceService = PreferenceService();

    if (_isLoading || appWrite.isInitializing) {
      return Scaffold(
        body: Center(
          child: CircularProgressIndicator(color: AppColors.primary),
        ),
      );
    }

    if (appWrite.isLoggedIn) {
      return const Tabs();
    } else {
      final isOnboarded = preferenceService.getBool('isOnboarded') ?? false;
      return isOnboarded ? const SignIn() : const Onboarding();
    }
  }
}