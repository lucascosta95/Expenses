import 'package:expenses/components/grafico.dart';
import 'package:expenses/components/transacao_form.dart';
import 'package:expenses/models/transacao.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'dart:math';
import 'dart:io';
import './components/transacao_form.dart';
import './components/transacao_list.dart';
import './models/transacao.dart';
import 'components/grafico.dart';

main(List<String> args) => runApp(ExpensesApp());

class ExpensesApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyHomePage(),
      theme: ThemeData(
        primarySwatch: Colors.purple,
        // ignore: deprecated_member_use
        accentColor: Colors.amber,
        fontFamily: 'RobotoMono',
        textTheme: ThemeData.light().textTheme.copyWith(
              headline6: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
              button: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
        appBarTheme: AppBarTheme(
          // ignore: deprecated_member_use
          textTheme: ThemeData.light().textTheme.copyWith(
                headline6: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                ),
              ),
        ),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final List<Transacao> _transacao = [];

  // Exibição do grafico de acordo com a rotação da tela
  bool _exibirGrafico = false;

  List<Transacao> get _transacoesRecentes {
    return _transacao.where((tr) {
      return tr.data.isAfter(DateTime.now().subtract(
        Duration(days: 7),
      ));
    }).toList();
  }

// Adicionar transação
  _addTransacao(String titulo, double valor, DateTime data) {
    final newTransacao = Transacao(
      id: Random().nextDouble().toString(),
      titulo: titulo,
      valor: valor,
      data: data,
    );

    setState(() {
      _transacao.add(newTransacao);
    });

    Navigator.of(context).pop();
  }

// Deletar a transação (Excluir)
  _deletetartransacao(String id) {
    setState(
      () {
        _transacao.removeWhere(
          (tr) {
            return tr.id == id;
          },
        );
      },
    );
  }

  // Abrir Modal
  _abrirtransacaomodal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (_) {
        return TransacaoForm(_addTransacao);
      },
    );
  }

// Definir botão e Função AppBar
  Widget _getIconButton(IconData icon, Function() fn) {
    return Platform.isIOS
        ? GestureDetector(
            onTap: fn,
            child: Icon(icon),
          )
        : IconButton(icon: Icon(icon), onPressed: fn);
  }

  @override
  Widget build(BuildContext context) {
    // Constante de Media Query
    final mediaQuery = MediaQuery.of(context);

    //Orientação da tela
    bool modoPaisagem = mediaQuery.orientation == Orientation.landscape;

    // Icones adaptativos Plataforma
    final iconeLista = Platform.isIOS ? CupertinoIcons.list_bullet : Icons.list;

    final iconeGrafico = Platform.isIOS
        ? CupertinoIcons.chart_pie_fill
        : Icons.pie_chart_rounded;

    // Ações
    final acoes = [
      _getIconButton(
        Platform.isIOS ? CupertinoIcons.add : Icons.add,
        () => _abrirtransacaomodal(context),
      ),

      // Alternar aplicação em modo paisagem
      if (modoPaisagem)
        _getIconButton(_exibirGrafico ? iconeLista : iconeGrafico, () {
          setState(() {
            _exibirGrafico = !_exibirGrafico;
          });
        }),
    ];

    // AppBar
    final PreferredSizeWidget appBar = AppBar(
      title: Text('Despesas Pessoais'),
      actions: acoes,
    );

    // Espaço disponivel em tela
    final avaliarAltura = mediaQuery.size.height -
        appBar.preferredSize.height -
        mediaQuery.padding.top;

    // Corpo da Pagina
    final corpoPagina = SafeArea(
        child: SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          if (_exibirGrafico || !modoPaisagem)

            // Grafico
            Container(
              height: avaliarAltura * (modoPaisagem ? 0.7 : 0.25),
              child: Grafico(_transacoesRecentes),
            ),
          if (!_exibirGrafico || !modoPaisagem)

            // Transação ( Lista)
            Container(
              height: avaliarAltura * (modoPaisagem ? 1 : 0.7),
              child: TransacaoLista(_transacao, _deletetartransacao),
            ),
        ],
      ),
    ));

// AppBar iOS e Android
    return Platform.isIOS
        ? CupertinoPageScaffold(
            navigationBar: CupertinoNavigationBar(
              middle: Text('Despesas Pessoais'),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: acoes,
              ),
            ),
            child: corpoPagina,
          )
        : Scaffold(
            appBar: appBar,
            body: corpoPagina,
            // Botão de adicionar transação
            floatingActionButton: Platform.isIOS
                ? Container()
                : FloatingActionButton(
                    onPressed: () => _abrirtransacaomodal(context),
                    child: Icon(Icons.add),
                  ),
            floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,

            // Rodapé
            bottomSheet: Container(
              width: double.infinity,
              child: Text(
                'by Lucas Costa',
                textAlign: TextAlign.center,
              ),
            ),
          );
  }
}
