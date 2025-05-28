import 'package:flutter/material.dart';
import 'package:future_builder_task/src/app.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  TextEditingController? _plzController;

  Future<String>? _cityFuture;

  @override
  void initState() {
    super.initState();
    _plzController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Suche PLZ'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: Column(
            spacing: 32,
            children: [
              TextFormField(
                controller: _plzController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Postleitzahl",
                ),
              ),
              OutlinedButton(
                onPressed: () {
                  setState(() {
                    _cityFuture = getCityFromZip(_plzController!.text);
                  });
                },
                child: const Text("Suche"),
              ),
              _cityFuture == null
                  ? Text(
                      "Ergebnis: Noch keine PLZ gesucht",
                      style: Theme.of(context).textTheme.labelLarge,
                    )
                  : FutureBuilder<String>(
                      future: _cityFuture,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return CircularProgressIndicator();
                        } else if (snapshot.hasError) {
                          return Text('Error: ${snapshot.error}');
                        } else if (snapshot.hasData) {
                          return Text('Stadt: ${snapshot.data}');
                        } else {
                          return Text('Keine Daten Gefunden');
                        }
                      },
                    ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _plzController?.dispose();
    super.dispose();
  }

  Future<String> getCityFromZip(String zip) async {
    // simuliere Dauer der Datenbank-Anfrage
    await Future.delayed(const Duration(seconds: 3));

    switch (zip) {
      case "10115":
        return 'Berlin';
      case "20095":
        return 'Hamburg';
      case "80331":
        return 'München';
      case "50667":
        return 'Köln';
      case "60311":
      case "60313":
        return 'Frankfurt am Main';
      default:
        return 'Unbekannte Stadt';
    }
  }
}
