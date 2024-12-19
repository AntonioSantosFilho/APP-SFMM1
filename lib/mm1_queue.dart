import 'dart:math';

class MM1Queue {
  double lambda;
  double mu;
  List<Event> events = [];
  List<double> statsSum = [0, 0, 0];
  List<double> statsSumSq = [0, 0, 0];

  MM1Queue({required this.lambda, required this.mu});

  double generateExponential(double rate) {
    return -log(Random().nextDouble()) / rate;
  }

  void reset() {
    events = [];
    statsSum = [0, 0, 0];
    statsSumSq = [0, 0, 0];
    events.add(Event(0, 0, 0, 0));
  }

  void addEvent() {
    Event prev = events.last;
    double cpf = prev.cpf + generateExponential(lambda);
    double eps = max(cpf, prev.sps);
    double sps = eps + generateExponential(mu);

    events.add(Event(cpf, eps, sps, 0));
    _updateStats(events.length - 1);
  }

  void _updateStats(int index) {
    Event event = events[index];
    double ts = event.sps - event.eps;
    double tfs = event.sps - event.cpf;

    // Atualiza número de clientes na fila (nf)
    int nf = 0;
    for (int i = index - 1; i >= 0; i--) {
      if (event.cpf < events[i].eps)
        nf++;
      else
        break;
    }
    event.nf = nf;

    statsSum[0] += ts;
    statsSum[1] += tfs;
    statsSum[2] += nf;

    statsSumSq[0] += ts * ts;
    statsSumSq[1] += tfs * tfs;
    statsSumSq[2] += nf * nf;
  }

  Map<String, double> getStatistics() {
    int n = events.length;
    return {
      "E(tfs)": statsSum[1] / n,
      "E(nf)": statsSum[2] / n,
      "DP(tfs)": sqrt(statsSumSq[1] / n - pow(statsSum[1] / n, 2)),
      "DP(nf)": sqrt(statsSumSq[2] / n - pow(statsSum[2] / n, 2)),
      "U": statsSum[0] / events.last.sps,
    };
  }
}

class Event {
  double cpf;
  double eps;
  double sps;
  int nf;

  Event(this.cpf, this.eps, this.sps, this.nf);
}
