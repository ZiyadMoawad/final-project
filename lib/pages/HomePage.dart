import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final SupabaseClient supabase = Supabase.instance.client;
  List tasks = [];

  @override
  void initState() {
    super.initState();
    fetchTasks();
  }

  Future<void> fetchTasks() async {
    final response = await supabase.from('tasks').select('*');
    if (response.error == null) {
      setState(() {
        tasks = response.data as List<dynamic>;
      });
      print('Tasks fetched: $tasks');
    } else {
      print('Error fetching tasks: ${response.error?.message}');
    }
  }

  Future<void> addTask(String title) async {
    final response = await supabase
        .from('tasks')
        .insert({'title': title, 'is_completed': false});

    if (response.error == null) {
      setState(() {
        tasks = [
          ...tasks,
          {'id': response.data[0]['id'], 'title': title, 'is_completed': false}
        ];
      });
      print('Task added: ${response.data}');
    } else {
      print('Error adding task: ${response.error?.message}');
    }
  }

  Future<void> toggleTask(int id, bool isCompleted) async {
    final response = await supabase
        .from('tasks')
        .update({'is_completed': !isCompleted})
        .eq('id', id);

    if (response.error == null) {
      setState(() {
        tasks = tasks.map((task) {
          if (task['id'] == id) {
            return {
              'id': task['id'],
              'title': task['title'],
              'is_completed': !isCompleted
            };
          }
          return task;
        }).toList();
      });
      print('Task updated: $id');
    } else {
      print('Error updating task: ${response.error?.message}');
    }
  }

  @override
  Widget build(BuildContext context) {
    final TextEditingController taskController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'To-Do List',
          style: TextStyle(fontWeight: FontWeight.bold, color:Colors.white ),
        ),
        centerTitle: true,
        backgroundColor: Colors.black, 
      ),
      body: Stack(
        children: [
          // صورة الخلفية
          Positioned.fill(
            child: Image.network(
              'https://s.widget-club.com/images/YyiR86zpwIMIfrCZoSs4ulVD9RF3/02198d11b4e244a969ccd7e058732f53/7440e3873a9c437720d23e034d442db0.jpg?q=70&w=500',
              fit: BoxFit.cover,
            ),
          ),
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: taskController,
                        decoration: InputDecoration(
                          hintText: 'Add a new task',
                          filled: true,
                          fillColor: Colors.white.withOpacity(0.8),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12.0),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.add, color: Colors.white),
                      onPressed: () {
                        if (taskController.text.isNotEmpty) {
                          addTask(taskController.text);
                          taskController.clear();
                        }
                      },
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: tasks.length,
                  itemBuilder: (context, index) {
                    final task = tasks[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8.0, vertical: 4.0),
                      child: Card(
                        color: Colors.white.withOpacity(0.8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        child: ListTile(
                          leading: Checkbox(
                            value: task['is_completed'],
                            onChanged: (value) =>
                                toggleTask(task['id'], task['is_completed']),
                          ),
                          title: Text(
                            task['title'],
                            style: TextStyle(
                              color: task['is_completed']
                                  ? Colors.green
                                  : Colors.black,
                              decoration: task['is_completed']
                                  ? TextDecoration.lineThrough
                                  : TextDecoration.none,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
