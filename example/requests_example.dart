// ignore_for_file: avoid_print

import 'dart:convert';

import 'package:http/http.dart';
import 'package:requests/requests.dart';

class TODO {
  final int userId;

  final int id;

  final String title;

  final bool completed;

  const TODO(this.userId, this.id, this.title, this.completed);

  factory TODO.fromJson(Map<String, dynamic> json) => TODO(
        json['userId'] as int,
        json['id'] as int,
        json['title'] as String,
        json['completed'] as bool,
      );

  @override
  String toString() {
    return '$runtimeType($userId, $id, "$title", $completed)';
  }
}

class SerializableTODOList extends Serializable<List<TODO>> {
  @override
  List<TODO> read(Response source) => (json.decode(source.body) as List)
      .map((element) => TODO.fromJson(element))
      .toList();
}

void main() async {
  client.registerSerializable(SerializableTODOList());

  final todos = await client.get<List<TODO>>(
    Uri.https('jsonplaceholder.typicode.com', '/todos'),
  );

  print(todos.value);
}
