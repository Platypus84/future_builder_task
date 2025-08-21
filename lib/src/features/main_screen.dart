import 'package:flutter/material.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final TextEditingController _editingController = TextEditingController();
  Future<String>? _future;

  Future<String>? zipCode(String zip) async {
    return await getCityFromZip(zip);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(
            child: Column(
              spacing: 32,
              children: [
                TextFormField(
                  controller: _editingController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "Postleitzahl",
                  ),
                ),
                OutlinedButton(
                  onPressed: () {
                    setState(() {
                      _future = zipCode(_editingController.text);
                    });
                  },
                  child: const Text("Suche"),
                ),
                Column(
                  children: [
                    FutureBuilder<String>(
                      future: _future,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return CircularProgressIndicator();
                        }
                        if (snapshot.hasError) {
                          return Row(
                            children: [
                              Icon(Icons.error),
                              Text('Fehler aufgetreten: ${snapshot.error}'),
                            ],
                          );
                        }
                        if (snapshot.hasData) {
                          return Text('Ergebnis: ${snapshot.data} ');
                        }

                        return const Text('Noch kein Ergebnis gesucht.');
                      },
                    ),
                  ],
                ),
                // Text(
                //   "Ergebnis: Noch keine PLZ gesucht",
                //   style: Theme.of(context).textTheme.labelLarge,
                // ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _editingController.dispose();
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
      case "04177":
        return 'Leipzig';
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
