// Importa o pacote principal do Flutter, que contém os widgets e ferramentas básicas.
import 'package:flutter/material.dart';

// A função main() é o ponto de entrada de toda aplicação Flutter.
void main() {
  // runApp() infla o widget passado como argumento e o anexa à tela.
  runApp(const MyApp());
}

// MyApp é o widget raiz da nossa aplicação.
// Ele é um StatelessWidget porque seu conteúdo não mudará ao longo do tempo.
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // O título da sua aplicação, usado pelo sistema operacional.
      title: 'Carrossel de Formulários',
      // Define o tema visual da aplicação.
      theme: ThemeData(
        primarySwatch: Colors.blue,
        // Define um tema mais moderno para os componentes.
        useMaterial3: true,
      ),
      // Remove o banner de "Debug" no canto superior direito.
      debugShowCheckedModeBanner: false,
      // Define a tela inicial da aplicação.
      home: const HorizontalFormCarousel(),
    );
  }
}

// Este é o widget principal que conterá nossa lista horizontal.
// Ele precisa ser um StatefulWidget porque o conteúdo da lista (os dados dos formulários) vai mudar.
class HorizontalFormCarousel extends StatefulWidget {
  const HorizontalFormCarousel({super.key});

  @override
  State<HorizontalFormCarousel> createState() => _HorizontalFormCarouselState();
}

// A classe State é onde a lógica e o estado do nosso widget são mantidos.
class _HorizontalFormCarouselState extends State<HorizontalFormCarousel> {
  // Vamos criar uma lista para armazenar os dados de cada cartão/formulário.
  // Por enquanto, começaremos com um formulário em branco.
  // Usamos um Map para representar cada pessoa, facilitando o acesso aos campos.
  final List<Map<String, dynamic>> _peopleList = [
    {
      'name': '',
      'birthDate': null,
      'gender': null,
    }
  ];

  @override
  Widget build(BuildContext context) {
    // Scaffold é um widget que implementa a estrutura visual básica do Material Design.
    // Ele fornece APIs para mostrar drawers, app bars, snackbars, etc.
    return Scaffold(
      // AppBar é a barra de título no topo da tela.
      appBar: AppBar(
        title: const Text('Carrossel de Micro-Formulários'),
        backgroundColor: Colors.blueAccent,
        foregroundColor: Colors.white,
      ),
      // O corpo do Scaffold é onde o nosso conteúdo principal ficará.
      body: Center(
        // Usamos um SizedBox para definir uma altura fixa para a nossa lista horizontal.
        child: SizedBox(
          height: 350.0, // Altura do carrossel de cartões
          // ListView.builder é a maneira mais eficiente de criar listas.
          // Ele só constrói os itens que estão visíveis na tela.
          child: ListView.builder(
            // Define a direção da rolagem para horizontal. É isso que cria o "carrossel".
            scrollDirection: Axis.horizontal,
            // A quantidade de itens na nossa lista.
            itemCount: _peopleList.length,
            // O itemBuilder é uma função que é chamada para construir cada item da lista.
            // 'context' é a informação sobre a localização do widget na árvore de widgets.
            // 'index' é a posição do item na lista que está sendo construído.
            itemBuilder: (context, index) {
              // Para cada item da lista, retornamos um widget `FormCard`.
              return FormCard(
                // Passamos os dados da pessoa naquela posição específica.
                personData: _peopleList[index],
                // Passamos uma função para atualizar os dados quando o usuário interagir com o formulário.
                onUpdate: (updatedData) {
                  setState(() {
                    _peopleList[index] = updatedData;
                  });
                },
              );
            },
          ),
        ),
      ),
      // FloatingActionButton é o botão flutuante, geralmente usado para ações principais.
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Quando o botão é pressionado, usamos setState para notificar o Flutter que o estado mudou.
          setState(() {
            // Adicionamos um novo mapa em branco à nossa lista, o que criará um novo cartão.
            _peopleList.add({
              'name': '',
              'birthDate': null,
              'gender': null,
            });
          });
        },
        tooltip: 'Adicionar Novo Formulário',
        child: const Icon(Icons.add),
      ),
    );
  }
}

// Este é o widget para cada cartão do nosso carrossel.
class FormCard extends StatefulWidget {
  // Os dados da pessoa para este cartão específico.
  final Map<String, dynamic> personData;
  // Uma função (callback) que será chamada para notificar o widget pai sobre mudanças.
  final Function(Map<String, dynamic>) onUpdate;

  const FormCard({
    super.key,
    required this.personData,
    required this.onUpdate,
  });

  @override
  State<FormCard> createState() => _FormCardState();
}

class _FormCardState extends State<FormCard> {
  // Controladores são usados para ler e modificar o texto em campos de texto.
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();

  // A variável 'selectedGender' armazenará o sexo selecionado no Dropdown.
  String? selectedGender;

  @override
  void initState() {
    super.initState();
    // No initState, inicializamos os controladores com os dados recebidos.
    _nameController.text = widget.personData['name'];

    // Se a data de nascimento não for nula, formatamos e exibimos no campo.
    if (widget.personData['birthDate'] != null) {
      DateTime date = widget.personData['birthDate'];
      _dateController.text = "${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}";
    }

    selectedGender = widget.personData['gender'];
  }

  // É uma boa prática limpar os controladores quando o widget for descartado.
  @override
  void dispose() {
    _nameController.dispose();
    _dateController.dispose();
    super.dispose();
  }

  // Função para lidar com a seleção da data.
  Future<void> _selectDate(BuildContext context) async {
    // showDatePicker é uma função do Flutter que mostra um diálogo de calendário.
    final DateTime? picked = await showDatePicker(
      context: context,
      // A data inicial que o calendário mostrará.
      initialDate: widget.personData['birthDate'] ?? DateTime.now(),
      // A data mais antiga que o usuário pode selecionar.
      firstDate: DateTime(1900),
      // A data mais recente que o usuário pode selecionar.
      lastDate: DateTime.now(),
    );
    // Se o usuário selecionou uma data...
    if (picked != null && picked != widget.personData['birthDate']) {
      // Criamos uma cópia atualizada dos dados.
      final updatedData = Map<String, dynamic>.from(widget.personData);
      updatedData['birthDate'] = picked;
      // Chamamos a função onUpdate para enviar os dados de volta ao widget pai.
      widget.onUpdate(updatedData);

      // Atualizamos o texto do campo de data visualmente.
      setState(() {
        _dateController.text = "${picked.day.toString().padLeft(2, '0')}/${picked.month.toString().padLeft(2, '0')}/${picked.year}";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Usamos um Container para definir a largura do nosso cartão.
    return Container(
      width: 300, // Largura de cada cartão
      // O widget Card fornece a aparência de um cartão do Material Design.
      child: Card(
        // Adiciona uma margem ao redor do cartão para separá-lo dos outros.
        margin: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 8.0),
        // Define a elevação (sombra) do cartão.
        elevation: 5.0,
        // O filho do Card será um Padding para dar espaçamento interno.
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          // Column organiza seus filhos verticalmente.
          child: Column(
            // Alinha os filhos no início (topo) da coluna.
            crossAxisAlignment: CrossAxisAlignment.start,
            // mainAxisSize: MainAxisSize.min faz com que a coluna ocupe o mínimo de espaço vertical.
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              // O campo de texto para o nome completo.
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Nome Completo',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.person),
                ),
                // onChanged é chamado sempre que o texto no campo muda.
                onChanged: (value) {
                  final updatedData = Map<String, dynamic>.from(widget.personData);
                  updatedData['name'] = value;
                  widget.onUpdate(updatedData);
                },
              ),
              // Um espaço vertical entre os campos.
              const SizedBox(height: 20),

              // O campo para a data de nascimento.
              TextFormField(
                controller: _dateController,
                decoration: const InputDecoration(
                  labelText: 'Data de Nascimento',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.calendar_today),
                ),
                // Tornamos o campo somente leitura para forçar o uso do seletor de data.
                readOnly: true,
                // onTap é chamado quando o usuário toca no campo.
                onTap: () {
                  _selectDate(context);
                },
              ),
              const SizedBox(height: 20),

              // O campo de seleção para o sexo.
              DropdownButtonFormField<String>(
                value: selectedGender,
                decoration: const InputDecoration(
                  labelText: 'Sexo',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.wc),
                ),
                // hint é o texto exibido quando nenhuma opção está selecionada.
                hint: const Text('Selecione...'),
                // Itens que aparecerão na lista suspensa.
                items: <String>['Homem', 'Mulher']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                // onChanged é chamado quando o usuário seleciona uma nova opção.
                onChanged: (String? newValue) {
                  final updatedData = Map<String, dynamic>.from(widget.personData);
                  updatedData['gender'] = newValue;
                  widget.onUpdate(updatedData);

                  // Atualizamos o estado local para refletir a nova seleção visualmente.
                  setState(() {
                    selectedGender = newValue;
                  });
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}