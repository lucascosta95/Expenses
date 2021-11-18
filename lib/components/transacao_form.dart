// ignore_for_file: unnecessary_null_comparison

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TransacaoForm extends StatefulWidget {
  // Controllers
  final void Function(String, double, DateTime) enviar;
  TransacaoForm(this.enviar);

  @override
  _TransacaoFormState createState() => _TransacaoFormState();
}

class _TransacaoFormState extends State<TransacaoForm> {
  final tituloController = TextEditingController();
  final valorController = TextEditingController();
  var dataSelecionada = DateTime.now();

  _enviarForm() {
    final titulo = tituloController.text;
    final valor = double.tryParse(valorController.text) ?? 0;

    if (titulo.isEmpty || valor <= 0 || dataSelecionada == null) {
      return;
    }

    widget.enviar(titulo, valor, dataSelecionada);
  }

  _showDatePicker() {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2019),
      lastDate: DateTime.now(),
    ).then(
      (pickedDate) {
        if (pickedDate == null) {
          return;
        }

        setState(() {
          dataSelecionada = pickedDate;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    //Formulario de preenchimento
    return SingleChildScrollView(
      child: Card(
        elevation: 5,
        child: Padding(
          padding: EdgeInsets.only(
            top: 10,
            right: 10,
            left: 10,
            bottom: 20 + MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Column(
            children: <Widget>[
              //Titulo
              TextField(
                controller: tituloController,
                onSubmitted: (_) => _enviarForm(),
                decoration: InputDecoration(labelText: 'Titulo'),
              ),
              // Valor
              TextField(
                controller: valorController,
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                onSubmitted: (_) => _enviarForm(),
                decoration: InputDecoration(labelText: 'Valor (R\$)'),
              ),

              // data
              Container(
                height: 70,
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        dataSelecionada == null
                            ? 'Nenhuma data selecionada!'
                            : 'Data Selecionada: ${DateFormat('dd/MM/y').format(dataSelecionada)}',
                      ),
                    ),
                    TextButton(
                      onPressed: _showDatePicker,
                      child: Text(
                        'Selecionar Data',
                        style: TextStyle(
                          color: Colors.purple,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Botão
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton(
                    onPressed: _enviarForm,
                    child: Text(
                      'Nova Transação',
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
