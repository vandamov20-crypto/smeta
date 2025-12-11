import 'package:flutter/material.dart';

void main() {
  runApp(const SmetaApp());
}

/// Простая модель проекта
class Project {
  final String name;
  final String clientName;
  final String address;
  final double? totalAmount;

  Project({
    required this.name,
    required this.clientName,
    required this.address,
    this.totalAmount,
  });
}

/// Корневой виджет приложения
class SmetaApp extends StatelessWidget {
  const SmetaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Смета PRO',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
        fontFamily: 'Roboto',
      ),
      home: const ProjectsPage(),
    );
  }
}

/// Страница со списком проектов
class ProjectsPage extends StatefulWidget {
  const ProjectsPage({super.key});

  @override
  State<ProjectsPage> createState() => _ProjectsPageState();
}

class _ProjectsPageState extends State<ProjectsPage> {
  final List<Project> _projects = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Мои проекты'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final Project? newProject = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const NewProjectPage(),
            ),
          );

          if (newProject != null) {
            setState(() {
              _projects.add(newProject);
            });
          }
        },
        child: const Icon(Icons.add),
      ),
      body: _projects.isEmpty
          ? const Center(
              child: Text(
                'Пока нет проектов.\nНажмите + чтобы добавить.',
                textAlign: TextAlign.center,
              ),
            )
          : ListView.separated(
              itemCount: _projects.length,
              separatorBuilder: (_, __) => const Divider(height: 1),
              itemBuilder: (context, index) {
                final project = _projects[index];
                return ListTile(
                  title: Text(project.name),
                  subtitle: Text(
                    'Клиент: ${project.clientName}\nАдрес: ${project.address}',
                  ),
                  isThreeLine: true,
                  trailing: project.totalAmount != null
                      ? Text(
                          '${project.totalAmount!.toStringAsFixed(0)} ₽',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        )
                      : const Text('Нет суммы'),
                );
              },
            ),
    );
  }
}

/// Страница создания нового проекта
class NewProjectPage extends StatefulWidget {
  const NewProjectPage({super.key});

  @override
  State<NewProjectPage> createState() => _NewProjectPageState();
}

class _NewProjectPageState extends State<NewProjectPage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _clientNameController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _clientNameController.dispose();
    _addressController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  void _saveProject() {
    if (_formKey.currentState?.validate() != true) return;

    final double? amount = _amountController.text.trim().isEmpty
        ? null
        : double.tryParse(_amountController.text.replaceAll(' ', ''));

    final project = Project(
      name: _nameController.text.trim(),
      clientName: _clientNameController.text.trim(),
      address: _addressController.text.trim(),
      totalAmount: amount,
    );

    Navigator.pop(context, project);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Новый проект'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Название объекта',
                  hintText: 'Квартира 45 м², ПИК',
                ),
                validator: (value) =>
                    value == null || value.trim().isEmpty ? 'Введите название' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _clientNameController,
                decoration: const InputDecoration(
                  labelText: 'Имя клиента',
                ),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _addressController,
                decoration: const InputDecoration(
                  labelText: 'Адрес объекта',
                ),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _amountController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Сумма сметы (₽)',
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _saveProject,
                child: const Text('Сохранить'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
