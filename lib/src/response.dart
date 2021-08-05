import 'package:http/http.dart';
import 'package:meta/meta.dart';

/// An extension to [BaseResponse] that adds a `value` property to the response.
@immutable
class SerializedResponse<T> extends BaseResponse {
  /// The serialized value of the response.
  final T value;

  /// Creates a new [SerializedResponse].
  @internal
  SerializedResponse(
    this.value,
    int statusCode, {
    int? contentLength,
    BaseRequest? request,
    Map<String, String> headers = const {},
    bool isRedirect = false,
    bool persistentConnection = true,
    String? reasonPhrase,
  }) : super(
          statusCode,
          contentLength: contentLength,
          request: request,
          headers: headers,
          isRedirect: isRedirect,
          persistentConnection: persistentConnection,
          reasonPhrase: reasonPhrase,
        );
}
