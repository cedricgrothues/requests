import 'dart:convert';

import 'package:http/http.dart';
import 'package:requests/src/serializable/serializable.dart';

///
class SerializableMap<K, V> extends Serializable<Map<K, V>> {
  @override
  Map<K, V> read(Response source) =>
      Map.castFrom<dynamic, dynamic, K, V>(json.decode(source.body));
}
