import 'package:flutter/material.dart';
import 'package:blockcode/features/auth/screens/login_screen.dart';
import 'package:blockcode/services/auth_service.dart';

import 'proyectos_screen.dart';
import 'usuarios_screen.dart';
import 'inventario_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  void _logout(BuildContext context) async {
    final authService = AuthService();
    await authService.logout();
    if (!context.mounted) return;
    Navigator.of(context).pushReplacement(
      MaterialPageRoute<void>(
        builder: (context) => const LoginScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Panel Principal'),
        leading: IconButton(
          icon: const Icon(Icons.logout),
          onPressed: () => _logout(context),
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                '¿Qué deseas gestionar?',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 48),
              
              
              ElevatedButton.icon(
                icon: const Icon(Icons.apartment),
                label: const Text('PROYECTOS', style: TextStyle(fontSize: 16)),
                style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 16)),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const ProyectosScreen()),
                  );
                },
              ),
              const SizedBox(height: 24),
              
              
              ElevatedButton.icon(
                icon: const Icon(Icons.people),
                label: const Text('USUARIOS', style: TextStyle(fontSize: 16)),
                style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 16)),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const UsuariosScreen()),
                  );
                },
              ),
              const SizedBox(height: 24),

              
              ElevatedButton.icon(
                icon: const Icon(Icons.inventory_2),
                label: const Text('INVENTARIO', style: TextStyle(fontSize: 16)),
                style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 16)),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const InventarioScreen()),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}