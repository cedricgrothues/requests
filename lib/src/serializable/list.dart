import 'dart:convert';

import 'package:requests/src/serializable/serializable.dart';

///
class SerializableList<T> extends Serializable<List<T>> {
  @override
  List<T> read(String source) => List.castFrom<dynamic, T>(json.decode(source));
}
