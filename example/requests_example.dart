import 'dart:convert';

import 'package:requests/requests.dart';
import 'package:requests/src/serializable/list.dart';
import 'package:requests/src/serializable/serializable.dart';

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

class TODOListDecoder extends Serializable<List<TODO>> {
  @override
  List<TODO> read(String source) => (json.decode(source) as List)
      .map((element) => TODO.fromJson(element))
      .toList();
}

void main() async {
  client
    ..registerSerializable(TODOListDecoder())
    ..registerSerializable(SerializableList<String>());

  final user = await client.get<List<TODO?>>(
    Uri.http('[::]:8000', '/todos.json'),
  );

  print(user.value);
}