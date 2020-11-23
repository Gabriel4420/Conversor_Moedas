import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

const request =
    "https://api.hgbrasil.com/finance?format=json-cors&key=741016bf";
void main() async {
  runApp(MaterialApp(
    home: Home(),
    theme: ThemeData(
        primarySwatch: Colors.amber,
        brightness: Brightness.light,
        hintColor: Colors.white,
        inputDecorationTheme: InputDecorationTheme(
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: Colors.amber[900],
              ),
            ),
            focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
              color: Colors.amber[900],
            )),
            hintStyle: TextStyle(color: Colors.amber[900])),
        backgroundColor: Colors.black),
    debugShowCheckedModeBanner: false,
  ));
}

// requisitando dados do servidor
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

  void _clear() {
    realController.text = "";
    dolarController.text = "";
    euroController.text = "";
  }

  void _realChanged(String text) {
    if (text.isEmpty) {
      _clear();
      return;
    }
    double real = double.parse(text);
    dolarController.text = (real / dolar).toStringAsFixed(2);
    euroController.text = (real / euro).toStringAsFixed(2);
  }

  void _dolarChanged(String text) {
    if (text.isEmpty) {
      _clear();
      return;
    }

    double dolar = double.parse(text);
    realController.text = (dolar * this.dolar).toStringAsFixed(2);
    euroController.text = (dolar * this.dolar / euro).toStringAsFixed(2);
  }

  void _euroChanged(String text) {
    if (text.isEmpty) {
      _clear();
      return;
    }

    double euro = double.parse(text);
    realController.text = (euro * this.euro).toStringAsFixed(2);
    dolarController.text = (euro * this.euro / dolar).toStringAsFixed(2);
  }

  var colorx = Colors.amber[300];

  void defaultColor() {
    setState(() {
      colorx = Colors.amber[300];
    });
  }

  void _changeColor() {
    setState(() {
      colorx = Colors.black87;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: colorx,
        appBar: AppBar(
          title: Text('\$ Conversor de moedas \$',
              style: TextStyle(color: Colors.amber[900])),
          backgroundColor: Colors.amber,
          centerTitle: true,
          actions: [
            GestureDetector(
              child: IconButton(
                icon: Icon(Icons.nights_stay),
                onPressed: () {
                  _changeColor();
                },
              ),
              onTap: _changeColor,
              onDoubleTap: defaultColor,
            )
          ],
        ),
        body: FutureBuilder<Map>(
            future: getData(),
            builder: (context, snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.none:
                case ConnectionState.waiting:
                  return Center(
                      child: CircularProgressIndicator(
                    backgroundColor: Colors.amber[900],
                  ));
                  break;
                default:
                  if (snapshot.hasError) {
                    return Center(
                        child: Text(
                      "Deu Pau no Excel :(",
                      style: TextStyle(
                        color: Colors.amber[900],
                        fontSize: 20.0,
                      ),
                      textAlign: TextAlign.center,
                    ));
                  } else {
                    dolar =
                        snapshot.data["results"]["currencies"]["USD"]["buy"];
                    euro = snapshot.data["results"]["currencies"]["EUR"]["buy"];

                    return SingleChildScrollView(
                      padding: EdgeInsets.all(15),
                      child: Padding(
                        padding: EdgeInsets.all(10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Icon(Icons.monetization_on,
                                size: 100, color: Colors.amber[700]),
                            SizedBox(
                              height: 10,
                            ),
                            buildTextField(
                                'Reais', 'R\$', realController, _realChanged),
                            Divider(),
                            buildTextField('Dolar', 'US\$', dolarController,
                                _dolarChanged),
                            Divider(),
                            buildTextField(
                                'Euro', '€', euroController, _euroChanged),
                          ],
                        ),
                      ),
                    );
                  }
                  break;
              }
            }));
  }
}

Widget buildTextField(
    String label, String prefix, TextEditingController c, Function f) {
  return TextField(
    controller: c,
    decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Colors.amber[900]),
        prefixText: prefix,
        hintStyle: TextStyle(color: Colors.amber[900])),
    onChanged: f,
    style: TextStyle(color: Colors.amber[900]),
    keyboardAppearance: Brightness.dark,
    keyboardType: TextInputType.number,
  );
}
