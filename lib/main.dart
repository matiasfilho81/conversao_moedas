import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

import 'package:url_launcher/url_launcher.dart';

const request = "https://api.hgbrasil.com/finance?format=json&key=49e7344b";

void main() async {
  print(await getData());

  runApp(MaterialApp(
    home: Home(),
    theme: ThemeData(
        hintColor: Colors.blueAccent,
        primaryColor: Colors.white
    ),
  ));
}
_launchURLGLO() async {
  const url = 'https://goo.gl/maps/Xc9qmkuajt9dUqtG9';
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}

_launchURLWAZE() async {
  const url = 'https://www.waze.com/ul?ll=-22.81962133%2C-47.06834793&navigate=yes&zoom=14';
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}

_launchURLUBER() async {
  const url = 'https://www.waze.com/ul?ll=-22.81962133%2C-47.06834793&navigate=yes&zoom=14';
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}

Future<Map> getData() async {
  http.Response response = await http.get(request);
  return json.decode(response.body);
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  final realController = TextEditingController();
    final dolarController = TextEditingController();
  final euroController = TextEditingController();


  double dolar;
  double euro;

   void _clearAll(){
    realController.text = "";
    dolarController.text = "";
    euroController.text = "";
  }

  void _realChanged(String text){

    if(text.isEmpty) {
      _clearAll();
      return;
    }

      double real = double.parse(text);
      dolarController.text = (real / dolar).toStringAsFixed(2);
      euroController.text = (real / euro).toStringAsFixed(2);
  }

  void _dolarChanged(String text){


    if(text.isEmpty) {
      _clearAll();
      return;
    }

      double dolar = double.parse(text);
      realController.text = (dolar * this.dolar).toStringAsFixed(2);
      euroController.text = (dolar * this.dolar / euro).toStringAsFixed(2);
  }

  void _euroChanged(String text){

    if(text.isEmpty) {
      _clearAll();
      return;
    }

    double euro = double.parse(text);
    realController.text = (euro * this.euro).toStringAsFixed(2);
    dolarController.text = (euro * this.euro / dolar).toStringAsFixed(2);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          title: Text("Developement"),
          backgroundColor: Colors.blueAccent,
          centerTitle: true,
        ),
        body: FutureBuilder<Map>(
            future: getData(),
            builder: (context, snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.none:
                case ConnectionState.waiting:
                  return Center(
                      child: Text(
                    "Loading...",
                    style: TextStyle(color: Colors.blueAccent, fontSize: 20.0),
                    textAlign: TextAlign.center,
                  ));
                default:
                  if (snapshot.hasError) {
                    return Center(
                        child: Text(
                      "Error loading data :( ",
                      style: TextStyle(color: Colors.blueAccent, fontSize: 20.0),
                      textAlign: TextAlign.center,
                    ));
                  } else {
                    dolar =
                        snapshot.data["results"]["currencies"]["USD"]["buy"];
                    euro = snapshot.data["results"]["currencies"]["EUR"]["buy"];
                    return SingleChildScrollView(
                      padding: EdgeInsets.all(10.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          Icon(Icons.monetization_on,
                              size: 115.0, color: Colors.blueAccent),
                          buildTextField("Reais", "R\$", realController, _realChanged),
                          Divider(),
                          buildTextField("Dólares", "US\$", dolarController, _dolarChanged),
                          Divider(),
                          buildTextField("Euros", "€\$", euroController, _euroChanged),
                          Divider(),
                          //
                          RaisedButton(
                            onPressed: _launchURLGLO,
                            child: Text('Google'),
                            //  onPressed: null,
                            shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0))
                          ),
                          Divider(),
                          RaisedButton(
                            onPressed: _launchURLWAZE,
                            child: Text('Waze'),
                            //  onPressed: null,
                            shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0))
                          ),
                          Divider(),
                          floatingActionButton: FloatingActionButton(
                            child: Icon(Icons.add),
                            onPressed: () {},
                          )
                          //
                        ],
                      ),
                    );
                  }
              }
            }));
  }
}

Widget buildTextField(String label, String prefix, TextEditingController c, Function f) {
  return TextField(
    controller: c,
    decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Colors.blueAccent),
        border: OutlineInputBorder(),
        prefixText: prefix,
    ),
    style: TextStyle(
        color: Colors.blueAccent,
        fontSize: 20.0
    ),
    onChanged: f,
    keyboardType: TextInputType.number,
  );
}
