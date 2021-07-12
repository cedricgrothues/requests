import 'package:meta/meta.dart';

///
@immutable
class RequestsError extends Error {
  ///
  final String message;

  ///
  @internal
  RequestsError(this.message);

  @override
  String toString() {
    return '$runtimeType: $message';
  }
}
