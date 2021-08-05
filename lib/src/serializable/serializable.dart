import 'package:http/http.dart';
import 'package:meta/meta.dart' show immutable, internal;

///
@immutable
abstract class Serializable<T> {
  ///
  @internal
  final type = T;

  ///
  T read(Response source);
}
