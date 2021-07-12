import 'package:meta/meta.dart' show immutable, internal, nonVirtual;

///
@immutable
abstract class Serializable<T> {
  ///
  @internal
  @nonVirtual
  final Type type = T;

  ///
  T read(String source);
}
