import 'package:flutter/material.dart';
import '../models/transacao.dart';
import 'package:intl/intl.dart';
import 'grafico_barra.dart';

class Grafico extends StatelessWidget {
  final List<Transacao> transacaoRecente;

  Grafico(this.transacaoRecente);

  List<Map<String, dynamic>> get grupotransacao {
    return List.generate(7, (index) {
      final diaSemana = DateTime.now().subtract(
        Duration(days: index),
      );

      double somatotal = 0.00;
      for (var i = 0; i < transacaoRecente.length; i++) {
        bool mesmoDia = transacaoRecente[i].data.day == diaSemana.day;
        bool mesmoMes = transacaoRecente[i].data.month == diaSemana.month;
        bool mesmoAno = transacaoRecente[i].data.year == diaSemana.year;

        if (mesmoDia && mesmoMes && mesmoAno) {
          somatotal += transacaoRecente[i].valor;
        }
      }

      print(DateFormat.E().format(diaSemana)[0]);
      print(somatotal);

      return {
        'dia': DateFormat.E().format(diaSemana)[0],
        'valor': somatotal,
      };
    }).reversed.toList();
  }

  double get _valorTotalSemana {
    return grupotransacao.fold(0.0, (sum, tr) {
      return sum + tr['valor'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 6,
      margin: EdgeInsets.all(20),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: grupotransacao.map((tr) {
            //Retorno Grafico
            return Flexible(
              fit: FlexFit.tight,
              child: GraficoBarra(
                diaDaSemana: tr['dia'],
                valor: tr['valor'],
                percentual: _valorTotalSemana == 0
                    ? 0
                    : tr['valor'] / _valorTotalSemana,
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
