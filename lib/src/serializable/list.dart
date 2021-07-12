import 'dart:convert';

import 'package:http/http.dart';
import 'package:requests/src/serializable/serializable.dart';

///
class SerializableList<T> extends Serializable<List<T>> {
  @override
  List<T> read(Response source) =>
      List.castFrom<dynamic, T>(json.decode(source.body));
}
