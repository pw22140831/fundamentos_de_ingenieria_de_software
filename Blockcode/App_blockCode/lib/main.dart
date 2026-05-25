import 'package:flutter/material.dart';
import 'package:blockcode/features/auth/screens/login_screen.dart';
import 'package:blockcode/presentation/screens/home_screen.dart';
import 'package:blockcode/services/auth_service.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Color palette: white, blue #122646, green #23633C
    const primaryBlue = Color(0xFF122646);
    const accentGreen = Color(0xFF23633C);

    final colorScheme = ColorScheme.fromSeed(
      seedColor: primaryBlue,
      primary: primaryBlue,
      secondary: accentGreen,
      brightness: Brightness.light,
    );

    return MaterialApp(
      title: 'Blockcode App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: colorScheme,
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: const AppBarTheme(
          backgroundColor: primaryBlue,
          foregroundColor: Colors.white,
          elevation: 2,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: primaryBlue,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            textStyle: const TextStyle(fontWeight: FontWeight.w600),
          ),
        ),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: accentGreen,
          foregroundColor: Colors.white,
        ),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(foregroundColor: accentGreen),
        ),
        switchTheme: SwitchThemeData(
          thumbColor: MaterialStateProperty.resolveWith((states) => accentGreen),
          trackColor: MaterialStateProperty.resolveWith((states) => accentGreen.withOpacity(0.5)),
        ),
        checkboxTheme: CheckboxThemeData(
          fillColor: MaterialStateProperty.resolveWith((states) => accentGreen),
        ),
        snackBarTheme: const SnackBarThemeData(
          backgroundColor: Color(0xFF23633C),
          contentTextStyle: TextStyle(color: Colors.white),
        ),
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: primaryBlue, width: 2),
          ),
          floatingLabelStyle: const TextStyle(color: primaryBlue),
          prefixIconColor: primaryBlue,
        ),
        // Use cardColor for wider SDK compatibility
        cardColor: Colors.white,
        iconTheme: const IconThemeData(color: primaryBlue),
        listTileTheme: const ListTileThemeData(
          iconColor: primaryBlue,
        ),
        textTheme: TextTheme(
          titleLarge: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: primaryBlue),
          bodyMedium: const TextStyle(fontSize: 14, color: Colors.black87),
        ),
      ),

      home: const SplashScreen(),
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkAuth();
  }

  Future<void> _checkAuth() async {
    // Debug trace
    debugPrint('Splash: _checkAuth started');
    await Future.delayed(const Duration(milliseconds: 500));
    final authService = AuthService();
    debugPrint('Splash: calling isLoggedIn');
    final isLoggedIn = await authService.isLoggedIn();
    debugPrint('Splash: isLoggedIn result = $isLoggedIn');

    if (!mounted) return;

    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) =>
            isLoggedIn ? const HomeScreen() : const LoginScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'blockcode',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                letterSpacing: 2.0,
              ),
            ),
            const SizedBox(height: 24),
            const CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}