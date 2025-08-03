import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  get actualDate => DateTime.timestamp();
  get limitDate => DateTime.parse("1900-01-01");
  String? selectedGender;

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text("Forms Básico"),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              spacing: 16.0,
              children: [
                TextFormField(
                  decoration: InputDecoration(
                    labelText: "Nome Completo",
                    suffixIcon: Icon(Icons.person),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Nome é obrigatório";
                    }
                    return null;
                  },
                ),
                TextFormField(
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(8),
                    ],
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: "Data de Nascimento",
                      suffixIcon: Icon(Icons.date_range),
                      hintText: "DD/MM/AAAA",
                    ),
                    validator: (value) {
                      return dateValidator(value);
                    }
                ),
                DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                    labelText: "Gênero",
                    suffixIcon: Icon(Icons.wc),
                  ),
                  value: selectedGender,
                  items: [
                    DropdownMenuItem(
                      value: "masculino",
                      child: Text("Masculino"),
                    ),
                    DropdownMenuItem(
                      value: "feminino",
                      child: Text("Feminino"),
                    ),
                  ],
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedGender = newValue;
                    });
                  },
                  validator: (value) {
                    if (value == null) {
                      return "Selecione um gênero";
                    }
                    return null;
                  },
                ),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text("Sucesso!"),
                            content: Text("Todas as operações foram realizadas com sucesso!"),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: Text("OK"),
                              ),
                            ],
                          );
                        },
                      );
                    }
                  },
                  child: Text("Enviar"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String? dateValidator(String? value) {
    if (value == null || value.isEmpty) {
      return "Data de nascimento é obrigatória";
    }
    var dataInserida = DateTime.parse(value);
    var dataAtual = DateTime.now();

    var idade = dataAtual.year - dataInserida.year;

    if (idade < 18) {
      return "Não permitido menores de 18 anos";
    }

    return null;
  }
}