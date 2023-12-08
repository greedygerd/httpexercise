import 'dart:convert';
import 'package:animated_background/animated_background.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Projektarbeit (HTTP-Anwendung)",
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with TickerProviderStateMixin {
  // Controller für den Textfeld, um den eingegebenen Namen zu verwalten
  final TextEditingController nameController = TextEditingController();

  // Variable zur Speicherung des geschätzten Alters
  int age = 0;

  // Fehlermeldung, falls etwas schief geht
  String error = "";

  // Funktion, um das geschätzte Alter von der API abzurufen
  Future<void> getAge(String name) async {
    try {
      // HTTP-GET-Anfrage an die Agify API mit dem eingegebenen Namen
      final response =
          await http.get(Uri.parse("https://api.agify.io/?name=$name"));

      // Überprüfen, ob die Anfrage erfolgreich war (Statuscode 200)
      if (response.statusCode == 200) {
        // JSON-Daten aus der Antwort extrahieren
        final data = json.decode(response.body);

        // Zustand aktualisieren, um das Alter anzuzeigen und Fehler zu löschen
        setState(() {
          age = data["age"] ?? 0;
          error = "";
        });
      } else {
        // Fehler werfen, falls die Anfrage nicht erfolgreich war
        throw Exception("Fehler beim Abrufen des Alters.");
      }
    } catch (e) {
      // Fehler behandeln und Fehlermeldung aktualisieren
      setState(() {
        error = "Fehler beim Abrufen des Alters.";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: const Text("ᕙ( ͡° ͜ʖ ͡°)ᕗ"),
      ),
      body: AnimatedBackground(
        behaviour: RandomParticleBehaviour(
          options: const ParticleOptions(
            spawnMaxRadius: 50,
            spawnMinSpeed: 10.00,
            particleCount: 68,
            spawnMaxSpeed: 50,
            minOpacity: 0.3,
            spawnOpacity: 0.4,
            image: Image(image: AssetImage("assets/images/jancontainer.png")),
          ),
        ),
        // vsync für Animation
        vsync: this,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                controller: nameController,
                decoration: InputDecoration(
                  labelText: "Gib einen Namen ein",
                  labelStyle: const TextStyle(fontWeight: FontWeight.bold),
                  hintText: "z.B. Jan",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  prefixIcon: const Icon(Icons.person),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: () {
                      // Löscht den eingegebenen Namen und setzt das Alter zurück
                      nameController.clear();
                      setState(() {
                        age = 0;
                      });
                      // Fokus entfernen, um die Tastatur zu minimieren
                      FocusScope.of(context).unfocus();
                    },
                  ),
                ),
              ),
              const SizedBox(height: 16.0),
              // Button zum Absenden des Namens und Anzeigen des Alters
              ElevatedButton(
                onPressed: () {
                  // Eingegebenen Namen abrufen, wenn nicht leer
                  final name = nameController.text.trim();
                  if (name.isNotEmpty) {
                    getAge(name);
                  }
                },
                child: const Text(
                  "Senden",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 16.0),
              // Anzeige des geschätzten Alters oder Fehlermeldung
              Text(
                nameController.text.trim().isEmpty
                    ? "Noch kein Name eingegeben."
                    : "Das geschätzte Alter von ${nameController.text.trim()} ist $age.",
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16.0),
              // Button zum Zurücksetzen des Namens und Alters
              IconButton(
                iconSize: 50,
                onPressed: () {
                  // Löscht den eingegebenen Namen und setzt das Alter zurück
                  nameController.clear();
                  setState(() {
                    age = 0;
                  });
                },
                icon: const Icon(Icons.refresh),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
