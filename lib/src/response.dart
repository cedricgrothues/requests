import 'package:http/http.dart';
import 'package:meta/meta.dart';

///
@immutable
class SerializedResponse<T> extends BaseResponse {
  ///
  final T value;

  ///
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
