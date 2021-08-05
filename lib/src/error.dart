import 'package:meta/meta.dart';

/// A [RequestsError] is thrown when an error occurs
/// while setting up a client.
@immutable
class RequestsError extends Error {
  /// The error message.
  final String message;

  /// Creates a new [RequestsError] with a message.
  @internal
  RequestsError(this.message);

  @override
  String toString() {
    return '$runtimeType: $message';
  }
}
