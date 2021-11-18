import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class GraficoBarra extends StatelessWidget {
  final String diaDaSemana;
  final double valor;
  final double percentual;

  GraficoBarra({
    required this.diaDaSemana,
    required this.valor,
    required this.percentual,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (ctx, Constraints) {
        return Column(
          children: [
            Container(
              height: Constraints.maxHeight * 0.15,
              child: FittedBox(
                child: Text('${valor.toStringAsFixed(2)}'),
              ),
            ),
            SizedBox(height: Constraints.maxHeight * 0.05),
            Container(
              height: Constraints.maxHeight * 0.6,
              width: 10,
              // Grafico de barras
              child: Stack(
                alignment: Alignment.bottomCenter,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.grey,
                        width: 1.0,
                      ),
                      color: Color.fromARGB(220, 220, 220, 220),
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                  FractionallySizedBox(
                    heightFactor: percentual,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor,
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                  )
                ],
              ),
            ),
            SizedBox(height: Constraints.maxHeight * 0.05),
            Container(
              height: Constraints.maxHeight * 0.15,
              child: FittedBox(
                child: Text(diaDaSemana),
              ),
            ),
          ],
        );
      },
    );
  }
}
