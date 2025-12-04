import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';

class ComparacaoScreen extends StatefulWidget {
  const ComparacaoScreen({super.key});

  @override
  State<ComparacaoScreen> createState() => _ComparacaoScreenState();
}

class _ComparacaoScreenState extends State<ComparacaoScreen> {
  final _etanolController = TextEditingController();
  final _gasController = TextEditingController();
  final _kmDestinoController = TextEditingController();
  final _kmPorLitroController = TextEditingController();

  String _resultado = "";
  String _imageAsset = "assets/images/gas_pump_icon.png";
  bool _showResult = false;

  void _calcular() {
    double? etanol = double.tryParse(_etanolController.text);
    double? gas = double.tryParse(_gasController.text);
    double? kmDestino = double.tryParse(_kmDestinoController.text);
    double? kmPorLitro = double.tryParse(_kmPorLitroController.text);

    if (etanol == null ||
        gas == null ||
        kmDestino == null ||
        kmPorLitro == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor, preencha todos os campos corretamente.'),
        ),
      );
      return;
    }

    double litrosNecessarios = kmDestino / kmPorLitro;
    String litrosStr = litrosNecessarios.toStringAsFixed(2);

    setState(() {
      _showResult = true;
      if ((etanol / gas) < 0.7) {
        _imageAsset = "assets/images/ethanol.png";
        _resultado = "Melhor usar Etanol. Você precisará de $litrosStr L.";
      } else {
        _imageAsset = "assets/images/gas.png";
        _resultado = "Melhor usar Gasolina. Você precisará de $litrosStr L.";
      }
    });
  }

  void _compartilhar() {
    if (_showResult) {
      Share.share(_resultado);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Comparação de Preços")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _etanolController,
              decoration: const InputDecoration(labelText: "Preço Etanol"),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: _gasController,
              decoration: const InputDecoration(labelText: "Preço Gasolina"),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: _kmDestinoController,
              decoration: const InputDecoration(labelText: "Distância (KM)"),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: _kmPorLitroController,
              decoration: const InputDecoration(labelText: "Autonomia (KM/L)"),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 20),
            ElevatedButton(onPressed: _calcular, child: const Text("Calcular")),
            if (_showResult) ...[
              const SizedBox(height: 30),
              Image.asset(_imageAsset, height: 100),
              const SizedBox(height: 10),
              Text(
                _resultado,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              IconButton(
                icon: const Icon(Icons.share),
                onPressed: _compartilhar,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
