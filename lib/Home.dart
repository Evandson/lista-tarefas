import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
            "Lista de Tarefas"
        ),
      ),
      body: Text("Tarefas"),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      floatingActionButton: FloatingActionButton(
          elevation: 6,
          child: Icon(Icons.add),
          onPressed:(){
          }
      ),
      bottomNavigationBar: BottomAppBar(
        shape: CircularNotchedRectangle(),
        child: Row(
          children: <Widget>[
            IconButton(
              onPressed: (){},
              icon: Icon(Icons.menu),
            )
          ],
        ),
      ),
    );
  }
}
