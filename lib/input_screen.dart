import 'package:flutter/material.dart';
import 'simulation_screen.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class InputScreen extends StatelessWidget {
  final TextEditingController _nController =
      TextEditingController(text: "5000");
  final TextEditingController _lambdaController =
      TextEditingController(text: "75.0");
  final TextEditingController _muController =
      TextEditingController(text: "100.0");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/bg6.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Column(
            children: [
              AppBar(
                  title: Text(""),
                  backgroundColor: Colors.transparent,
                  elevation: 0),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      kIsWeb
                          ? Image.asset('assets/titulo.png', height: 200)
                          : Image.asset(
                              'assets/titulo.png',
                            ),
                      TextFormField(
                        controller: _nController,
                        decoration: InputDecoration(
                          labelText: "Número de pacotes n(p)",
                          border: OutlineInputBorder(),
                        ),
                        keyboardType: TextInputType.number,
                      ),
                      SizedBox(height: 16),
                      TextFormField(
                        controller: _lambdaController,
                        decoration: InputDecoration(
                          labelText: "Taxa de chegada λ(p/s)",
                          border: OutlineInputBorder(),
                        ),
                        keyboardType: TextInputType.number,
                      ),
                      SizedBox(height: 16),
                      TextFormField(
                        controller: _muController,
                        decoration: InputDecoration(
                          labelText: "Taxa de serviço μ(p/s)",
                          border: OutlineInputBorder(),
                        ),
                        keyboardType: TextInputType.number,
                      ),
                      SizedBox(height: 32),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SimulationScreen(
                                n: int.parse(_nController.text),
                                lambda: double.parse(_lambdaController.text),
                                mu: double.parse(_muController.text),
                              ),
                            ),
                          );
                        },
                        child: Text("Iniciar Simulação"),
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: Colors.blue,
                          padding: EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 16,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
