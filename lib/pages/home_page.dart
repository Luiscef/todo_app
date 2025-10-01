import 'package:flutter/material.dart';
import '../models/task.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<Task> _tasks = [];
  final TextEditingController _inputController = TextEditingController();
  final TextEditingController _dialogController = TextEditingController();

  void _addTask() {
    if (_inputController.text.isNotEmpty) {
      setState(() {
        _tasks.add(Task(_inputController.text));
        _inputController.clear();
      });
    }
  }

  void _removeTask(int index) {
    setState(() {
      _tasks.removeAt(index);
    });
  }

  void _toggleTask(int index, bool? value) {
    setState(() {
      _tasks[index].done = value ?? false;
    });
  }

  void _editTask(int index) {
    _dialogController.text = _tasks[index].title;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Editar tarea"),
        content: TextField(
          controller: _dialogController,
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              _dialogController.clear();
            },
            child: const Text("Cancelar"),
          ),
          ElevatedButton(
            onPressed: () {
              if (_dialogController.text.isNotEmpty) {
                setState(() {
                  _tasks[index].title = _dialogController.text;
                });
                _dialogController.clear();
                Navigator.of(context).pop();
              }
            },
            child: const Text("Guardar"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final int pendingTasks = _tasks.where((t) => !t.done).length;

    return Scaffold(
      appBar: AppBar(
        title: Text("Mis Tareas ($pendingTasks pendientes)"),
        centerTitle: true,
      ),
      body: Column(
        children: [
          
          Expanded(
            child: _tasks.isEmpty
                ? const Center(child: Text("No hay tareas agregadas !"))
                : ListView.builder(
                    itemCount: _tasks.length,
                    itemBuilder: (context, index) {
                      return Card(
                        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        child: ListTile(
                          leading: Checkbox(
                            value: _tasks[index].done,
                            onChanged: (value) => _toggleTask(index, value),
                          ),
                          title: Text(
                            _tasks[index].title,
                            style: TextStyle(
                              decoration: _tasks[index].done
                                  ? TextDecoration.lineThrough
                                  : TextDecoration.none,
                            ),
                          ),
                          onTap: () => _editTask(index),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () => _removeTask(index),
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        shape: const CircleBorder(),
        onPressed: () {
          _dialogController.clear();
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text("Nueva tarea"),
              content: TextField(
                controller: _dialogController,
                autofocus: true,
                decoration: const InputDecoration(
                  hintText: "Escribe una tarea...",
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    _dialogController.clear();
                  },
                  child: const Text("Cancelar"),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (_dialogController.text.isNotEmpty) {
                      setState(() {
                        _tasks.add(Task(_dialogController.text));
                      });
                      _dialogController.clear();
                      Navigator.of(context).pop();
                    }
                  },
                  child: const Text("Agregar"),
                ),
              ],
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  @override
  void dispose() {
    _inputController.dispose();
    _dialogController.dispose();
    super.dispose();
  }
}