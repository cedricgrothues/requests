import 'package:meta/meta.dart' show immutable;

///
@immutable
abstract class Serializable<T> {
  ///
  final Type type = T;

  ///
  T read(String source);
}
