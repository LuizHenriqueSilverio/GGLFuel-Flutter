import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/gasoline_price.dart';

class GasPriceListScreen extends StatefulWidget {
  const GasPriceListScreen({super.key});

  @override
  State<GasPriceListScreen> createState() => _GasPriceListScreenState();
}

class _GasPriceListScreenState extends State<GasPriceListScreen> {
  late Future<List<GasolinePrice>> _futurePrices;

  @override
  void initState() {
    super.initState();
    _futurePrices = fetchGasPrices();
  }

  Future<List<GasolinePrice>> fetchGasPrices() async {
    const url = 'https://api.collectapi.com/gasPrice/otherCountriesGasoline';
    const apiKey = 'apikey 7mGGIzhO8Jz8epAdGmJTwf:2Ti4eBbmx2VeSnC4a3m1XT';

    final response = await http.get(
      Uri.parse(url),
      headers: {'authorization': apiKey, 'content-type': 'application/json'},
    );

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      if (jsonResponse['success'] == true) {
        final List results = jsonResponse['results'];
        return results.map((e) => GasolinePrice.fromJson(e)).toList();
      } else {
        throw Exception('API retornou sucesso falso');
      }
    } else {
      throw Exception('Falha ao carregar preços');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Preços Internacionais")),
      body: FutureBuilder<List<GasolinePrice>>(
        future: _futurePrices,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Erro: ${snapshot.error}"));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("Nenhum dado disponível."));
          }

          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              final price = snapshot.data![index];
              return ListTile(
                title: Text(
                  price.country,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text("Preço: ${price.price} ${price.currency}"),
              );
            },
          );
        },
      ),
    );
  }
}
