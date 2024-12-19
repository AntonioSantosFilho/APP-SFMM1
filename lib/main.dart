import 'package:flutter/material.dart';
import 'package:graficosmmi/input_screen.dart';
import 'package:intro_screen_onboarding_flutter/intro_app.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SF M/M/1',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        // backgroundColor: Color.fromARGB(255, 36, 34, 34),
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: TestScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class TestScreen extends StatelessWidget {
  final List<Introduction> list = [
    Introduction(
      title: 'Bem-vindo ao SF M/M/1!',
      subTitle: 'Entenda o funcionamento e simule um sistemas de filas.',
      imageUrl: 'assets/mm1.png',
    ),
    Introduction(
      title: 'O que é M/M/1?',
      subTitle:
          'M/M/1 é um modelo matemático usado para analisar filas. Ele descreve sistemas com uma única fila e um único servidor.',
      imageUrl: 'assets/mm1d.png',
    ),
    Introduction(
      title: 'O que faz este aplicativo?',
      subTitle:
          'Visualize métricas importantes como tempo médio na fila, número de clientes e utilização do servidor.',
      imageUrl: 'assets/grafico.png',
    ),
    Introduction(
      title: 'Desenvolvimento',
      subTitle:
          'Aplicativo desenvolvido por: Antonio Filho (UNIVASF) e Brauliro Leal (UNIVASF).',
      imageUrl: 'assets/univasf.png',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return IntroScreenOnboarding(
      introductionList: list,
      onTapSkipButton: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => InputScreen(),
          ), //MaterialPageRoute
        );
      },
      // foregroundColor: Colors.red,
    );
  }
}
