import 'package:flutter/material.dart';
import '../db/database_helper.dart';
import '../models/fuel_register.dart';
import 'fuel_register_screen.dart';

class FuelHistoryScreen extends StatefulWidget {
  const FuelHistoryScreen({super.key});

  @override
  State<FuelHistoryScreen> createState() => _FuelHistoryScreenState();
}

class _FuelHistoryScreenState extends State<FuelHistoryScreen> {
  late Future<List<FuelRegister>> _fuelList;

  @override
  void initState() {
    super.initState();
    _refreshList();
  }

  void _refreshList() {
    setState(() {
      _fuelList = DatabaseHelper.instance.readAllRegisters();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Histórico de Abastecimento")),
      body: FutureBuilder<List<FuelRegister>>(
        future: _fuelList,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.data!.isEmpty) {
            return const Center(child: Text("Nenhum registro encontrado."));
          }

          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              final register = snapshot.data![index];
              return ListTile(
                title: Text(register.toString()),
                onTap: () async {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          FuelRegisterScreen(fuelRegister: register),
                    ),
                  );
                  _refreshList();
                },
                trailing: IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () async {
                    await DatabaseHelper.instance.delete(register.id!);
                    _refreshList();
                    if (mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Registro excluído com sucesso!'),
                        ),
                      );
                    }
                  },
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const FuelRegisterScreen()),
          );
          _refreshList();
        },
      ),
    );
  }
}
