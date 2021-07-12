import 'dart:convert';

import 'package:requests/src/serializable/serializable.dart';

///
class SerializableMap<K, V> extends Serializable<Map<K, V>> {
  @override
  Map<K, V> read(String source) =>
      Map.castFrom<dynamic, dynamic, K, V>(json.decode(source));
}
