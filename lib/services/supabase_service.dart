import 'package:finle_project/models/task.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseService {
  final SupabaseClient client;

  SupabaseService() : client = Supabase.instance.client;





  Future<List<Task>> getTasks() async {
    final response = await client.from('tasks').select();

    if (response == null) {
      throw Exception('Failed to fetch tasks: Response is null');
    }

    final data = response as List<dynamic>;
    return data.map((json) => Task.fromJson(json as Map<String, dynamic>)).toList();
  }






  Future<void> addTask(String title, String description) async {
    final response = await client.from('tasks').insert({
      'title': title,
      'description': description,
      'is_completed': false,
    });

    if (response == null) {
      throw Exception('Failed to add task: Response is null');
    }
  }
}
