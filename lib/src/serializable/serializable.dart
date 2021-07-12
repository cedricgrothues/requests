import 'package:meta/meta.dart' show immutable;

///
@immutable
abstract class Serializable<T> {
  ///
  T read(String source);
}
