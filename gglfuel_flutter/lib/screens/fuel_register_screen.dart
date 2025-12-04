import 'package:flutter/material.dart';
import '../db/database_helper.dart';
import '../models/fuel_register.dart';

class FuelRegisterScreen extends StatefulWidget {
  final FuelRegister? fuelRegister;

  const FuelRegisterScreen({super.key, this.fuelRegister});

  @override
  State<FuelRegisterScreen> createState() => _FuelRegisterScreenState();
}

class _FuelRegisterScreenState extends State<FuelRegisterScreen> {
  final _qtyController = TextEditingController();
  final _priceController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.fuelRegister != null) {
      _qtyController.text = widget.fuelRegister!.fuelQty.toString();
      _priceController.text = widget.fuelRegister!.fuelPrice.toString();
    }
  }

  Future<void> _saveRegister() async {
    if (_qtyController.text.isEmpty || _priceController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Preencha todos os campos!')),
      );
      return;
    }

    final qty = double.parse(_qtyController.text);
    final price = double.parse(_priceController.text);

    // Cria o objeto
    final register = FuelRegister(
      id: widget.fuelRegister?.id,
      fuelQty: qty,
      fuelPrice: price,
    );

    if (widget.fuelRegister == null) {
      // Criação
      await DatabaseHelper.instance.create(register);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Registro salvo com sucesso!')),
        );
      }
    } else {
      // Edição
      await DatabaseHelper.instance.update(register);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Registro atualizado com sucesso!')),
        );
      }
    }

    if (mounted) Navigator.pop(context); // Fecha a tela
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.fuelRegister == null
              ? "Cadastro de Abastecimento"
              : "Editar Abastecimento",
        ),
        actions: [
          IconButton(icon: const Icon(Icons.save), onPressed: _saveRegister),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _qtyController,
              decoration: const InputDecoration(
                labelText: "Qtd. combustível (em litros)",
              ),
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _priceController,
              decoration: const InputDecoration(
                labelText: "Valor pago (ex.: 50.00)",
              ),
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
