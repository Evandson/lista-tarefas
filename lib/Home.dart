import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'dart:async';
import 'dart:convert';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  List _tarefas = [];
  TextEditingController _controller = TextEditingController();

  Future<File> _getFile() async {

    final diretorio = await getApplicationDocumentsDirectory();
    return File( "${diretorio.path}/data.json" );

  }

  _salvarTarefa(){

    String textoDigitado = _controller.text;

    Map<String, dynamic> tarefa = Map();
    tarefa["titulo"] = textoDigitado;
    tarefa["realizada"] = false;

    setState(() {
      _tarefas.add( tarefa );
    });
    _salvarArquivo();

    _controller.text = "";

  }

  _salvarArquivo() async {

    var arquivo = await _getFile();

    String dados = json.encode( _tarefas );
    arquivo.writeAsString( dados );

  }

  _lerArquivo() async {

    try{

      final arquivo = await _getFile();
      return arquivo.readAsString();

    }catch(e){
      return null;
    }

  }

  @override
  void initState() {
    super.initState();

    _lerArquivo().then( (dados){
      setState(() {
        _tarefas = json.decode(dados);
      });
    } );

  }

  Widget criarItemLista(context, index){

    final item = _tarefas[index]["titulo"];

    return Dismissible(
        key: Key(item),
        direction: DismissDirection.endToStart,
        onDismissed: (direction){

          _tarefas.removeAt(index);
          _salvarArquivo();

        },
        background: Container(
          color: Colors.red,
          padding: EdgeInsets.all(16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Icon(
                Icons.delete,
                color: Colors.white,
              )
            ],
          ),
        ),
        child: CheckboxListTile(
          title: Text( _tarefas[index]['titulo'] ),
          value: _tarefas[index]['realizada'],
          onChanged: (valorAlterado){

            setState(() {
              _tarefas[index]['realizada'] = valorAlterado;
            });

            _salvarArquivo();
          },
        )
    );
  }

  @override
  Widget build(BuildContext context) {

    print("itens: " + _tarefas.toString() );

    return Scaffold(
      appBar: AppBar(
        title: Text("Lista de Tarefas"),
        centerTitle: true,
        backgroundColor: Colors.black,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          backgroundColor: Colors.black,
          onPressed: (){

            showDialog(
                context: context,
                builder: (context){

                  return AlertDialog(
                    title: Text("Nova Tarefa"),
                    content: TextField(
                      controller: _controller,
                      decoration: InputDecoration(
                          labelText: "Digite sua tarefa"
                      ),
                      onChanged: (text){

                      },
                    ),
                    actions: <Widget>[
                      FlatButton(
                        child: Text("Cancelar"),
                        onPressed: () => Navigator.pop(context) ,
                      ),
                      FlatButton(
                        child: Text("Adicionar"),
                        onPressed: (){
                          _salvarTarefa();
                          Navigator.pop(context);
                        },
                      )
                    ],
                  );
                }
            );
          }
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: ListView.builder(
                itemCount: _tarefas.length,
                itemBuilder: criarItemLista
            ),
          )
        ],
      ),
    );
  }
}
