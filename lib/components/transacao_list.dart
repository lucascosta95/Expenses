import 'package:expenses/models/transacao.dart';
import 'package:flutter/material.dart';
import '../models/transacao.dart';
import 'package:intl/intl.dart';

class TransacaoLista extends StatelessWidget {
  final List<Transacao> transacoes;
  final void Function(String) remover;

  TransacaoLista(this.transacoes, this.remover);

  @override
  Widget build(BuildContext context) {
    // Apresentação do valor
    return transacoes.isEmpty
        ? LayoutBuilder(
            builder: (ctx, constraints) {
              return Column(
                children: [
                  // Espaçamento
                  SizedBox(height: 20),
                  Text(
                    'Nenhuma transação cadastrada!',
                    style: Theme.of(context).textTheme.headline6,
                  ),

                  // Espaçamento entre o texto e a imagem
                  SizedBox(
                    height: 40,
                  ),
                  Container(
                    height: constraints.maxHeight * 0.6,
                    child: Image.asset(
                      'assets/images/waiting.png',
                      fit: BoxFit.cover,
                    ),
                  )
                ],
              );
            },
          )
        : ListView.builder(
            // Quantidade de itens
            itemCount: transacoes.length,

            // informa contexto e o indice atual da lista
            itemBuilder: (ctx, index) {
              //Constante tr
              final tr = transacoes[index];

              // Lista de transações
              return Card(
                elevation: 5,
                margin: EdgeInsets.symmetric(
                  vertical: 8,
                  horizontal: 5,
                ),
                child: ListTile(
                  leading: CircleAvatar(
                    radius: 30,
                    child: Padding(
                      padding: const EdgeInsets.all(6),
                      child: FittedBox(
                          child: Text('R\$${tr.valor.toStringAsFixed(2)}')),
                    ),
                  ),
                  title: Text(
                    tr.titulo,
                    style: Theme.of(context).textTheme.headline6,
                  ),
                  subtitle: Text(
                    DateFormat('d  MMM y').format(tr.data),
                    style: TextStyle(
                      color: Colors.grey,
                    ),
                  ),
                  trailing: MediaQuery.of(context).size.width > 480
                      ? TextButton.icon(
                          onPressed: () => remover(tr.id),
                          icon: Icon(Icons.delete),
                          label: Text('Excluir'),
                        )
                      : IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () => remover(tr.id),
                          color: Theme.of(context).errorColor,
                        ),
                ),
              );
            },
          );
  }
}
