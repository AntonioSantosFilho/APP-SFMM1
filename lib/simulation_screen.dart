import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'mm1_queue.dart';

class SimulationScreen extends StatefulWidget {
  final int n;
  final double lambda;
  final double mu;

  SimulationScreen({required this.n, required this.lambda, required this.mu});

  @override
  _SimulationScreenState createState() => _SimulationScreenState();
}

class _SimulationScreenState extends State<SimulationScreen> {
  final MM1Queue simulation = MM1Queue(lambda: 0, mu: 0);

  // Listas para armazenar os pontos das métricas
  List<FlSpot> eTfsSpots = [];
  List<FlSpot> eNfSpots = [];
  List<FlSpot> dpTfsSpots = [];
  List<FlSpot> dpNfSpots = [];
  List<FlSpot> uSpots = [];

  // Controle de visibilidade das linhas
  Map<String, bool> visibility = {
    "E(tfs)": true,
    "E(nf)": true,
    "DP(tfs)": true,
    "DP(nf)": true,
    "U": true,
  };

  @override
  void initState() {
    super.initState();
    runSimulation();
  }

  void runSimulation() async {
    simulation.lambda = widget.lambda;
    simulation.mu = widget.mu;
    simulation.reset();

    for (int i = 1; i <= widget.n; i++) {
      simulation.addEvent();

      if (i % 50 == 0 || i == widget.n) {
        setState(() {
          final stats = simulation.getStatistics();
          eTfsSpots.add(FlSpot(i.toDouble(), stats["E(tfs)"]!));
          eNfSpots.add(FlSpot(i.toDouble(), stats["E(nf)"]!));
          dpTfsSpots.add(FlSpot(i.toDouble(), stats["DP(tfs)"]!));
          dpNfSpots.add(FlSpot(i.toDouble(), stats["DP(nf)"]!));
          uSpots.add(FlSpot(i.toDouble(), stats["U"]!));
        });
        await Future.delayed(
            Duration(milliseconds: 50)); // Ajuste para animação mais lenta
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Resultados")),
      body: Column(
        children: [
          // Legenda interativa
          Wrap(
            spacing: 10,
            children: [
              _buildLegendItem("E(tfs)", Colors.blue),
              _buildLegendItem("E(nf)", Colors.green),
              _buildLegendItem("DP(tfs)", Colors.pink),
              _buildLegendItem("DP(nf)", Colors.purple),
              _buildLegendItem("U", Colors.red),
            ],
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: LineChart(
                LineChartData(
                  lineBarsData: [
                    if (visibility["E(tfs)"]!)
                      LineChartBarData(
                        spots: eTfsSpots,
                        isCurved: true,
                        color: Colors.blue,
                        barWidth: 3,
                        belowBarData: BarAreaData(show: false),
                        dotData: const FlDotData(show: false),
                      ),
                    if (visibility["E(nf)"]!)
                      LineChartBarData(
                        spots: eNfSpots,
                        isCurved: true,
                        color: Colors.green,
                        barWidth: 3,
                        belowBarData: BarAreaData(show: false),
                        dotData: const FlDotData(show: false),
                      ),
                    if (visibility["DP(tfs)"]!)
                      LineChartBarData(
                        spots: dpTfsSpots,
                        isCurved: true,
                        color: Colors.pink,
                        barWidth: 3,
                        belowBarData: BarAreaData(show: false),
                        dotData: const FlDotData(show: false),
                      ),
                    if (visibility["DP(nf)"]!)
                      LineChartBarData(
                        spots: dpNfSpots,
                        isCurved: true,
                        color: Colors.purple,
                        barWidth: 3,
                        belowBarData: BarAreaData(show: false),
                        dotData: const FlDotData(show: false),
                      ),
                    if (visibility["U"]!)
                      LineChartBarData(
                        spots: uSpots,
                        isCurved: true,
                        color: Colors.red,
                        barWidth: 3,
                        belowBarData: BarAreaData(show: false),
                        dotData: const FlDotData(show: false),
                      ),
                  ],
                  titlesData: FlTitlesData(
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 40,
                        getTitlesWidget: (value, meta) {
                          // Exibição padrão para o eixo Y
                          return Text(value.toStringAsFixed(
                              1)); // Ajuste o formato dos números
                        },
                      ),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 40,
                        getTitlesWidget: (value, meta) {
                          // Determina os limites do eixo X
                          double minX = eTfsSpots.first.x;
                          double maxX = eTfsSpots.last.x;

                          // Define o intervalo (múltiplo) para os rótulos
                          double interval = (maxX - minX) /
                              5; // Ajusta dinamicamente para 10 rótulos no máximo
                          interval = interval
                              .ceilToDouble(); // Garante que seja um valor inteiro ou arredondado para cima

                          // Verifica se o valor atual é um múltiplo do intervalo
                          if ((value - minX) % interval < interval / 2 ||
                              value == minX ||
                              value == maxX) {
                            return Transform.rotate(
                              angle: -45 *
                                  3.14159265359 /
                                  180, // Rotação de 45 graus
                              child: Text(
                                value.toInt().toString(),
                                style: TextStyle(
                                    fontSize: 12), // Ajuste o tamanho da fonte
                              ),
                            );
                          }

                          // Caso contrário, não exibe o rótulo
                          return const SizedBox();
                        },
                      ),
                    ),
                    rightTitles: AxisTitles(
                      sideTitles: SideTitles(
                          showTitles: false), // Ocultar o eixo direito
                    ),
                    topTitles: AxisTitles(
                      sideTitles: SideTitles(
                          showTitles: false), // Ocultar o eixo superior
                    ),
                  ),
                  borderData: FlBorderData(show: true, border: Border.all()),
                  lineTouchData: LineTouchData(
                    touchTooltipData: LineTouchTooltipData(
                      getTooltipItems: (touchedSpots) {
                        return touchedSpots.map((spot) {
                          return LineTooltipItem(
                            '(${spot.x.toInt()}, ${spot.y.toStringAsFixed(3)})',
                            const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          );
                        }).toList();
                      },
                    ),
                    handleBuiltInTouches: true,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLegendItem(String label, Color color) {
    return GestureDetector(
      onTap: () {
        setState(() {
          visibility[label] = !visibility[label]!;
        });
      },
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            visibility[label]!
                ? Icons.check_box
                : Icons.check_box_outline_blank,
            color: color,
          ),
          SizedBox(width: 5),
          Text(label, style: TextStyle(color: color)),
        ],
      ),
    );
  }
}
