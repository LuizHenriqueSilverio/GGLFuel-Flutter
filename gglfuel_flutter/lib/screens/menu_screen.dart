import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'login_screen.dart';
import 'fuel_history_screen.dart';
import 'comparacao_screen.dart';
import 'gas_price_list_screen.dart';

class MenuScreen extends StatelessWidget {
  const MenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("GGL Supply Control"),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              if (context.mounted) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => const LoginScreen()),
                );
              }
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/images/logo.png', height: 150),
            const SizedBox(height: 30),

            _MenuButton(
              text: "Controle de Abastecimento",
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const FuelHistoryScreen()),
              ),
            ),
            _MenuButton(
              text: "Comparação de Preços",
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ComparacaoScreen()),
              ),
            ),
            _MenuButton(
              text: "Preços de Gasolina (API)",
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const GasPriceListScreen()),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              onPressed: () async {
                await FirebaseAuth.instance.signOut();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => const LoginScreen()),
                );
              },
              child: const Text(
                "LOGOUT",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MenuButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  const _MenuButton({required this.text, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: SizedBox(
        width: 250,
        height: 50,
        child: ElevatedButton(onPressed: onPressed, child: Text(text)),
      ),
    );
  }
}
