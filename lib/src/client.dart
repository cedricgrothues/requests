import 'dart:convert';
import 'dart:typed_data';

import 'package:http/http.dart' show Client, Response;
import 'package:logging/logging.dart';
import 'package:meta/meta.dart';

import 'package:requests/src/response.dart';
import 'package:requests/src/serializable/serializable.dart';
import 'package:requests/src/serializable/list.dart';
import 'package:requests/src/serializable/map.dart';
import 'package:requests/src/error.dart';

/// An HTTP client that decodes responses to the specified type.
@immutable
class SerializableClient {
  final Client _client;

  final List<Serializable> _serializables;

  late final _logger = Logger('$runtimeType');

  /// Creates a [SerializableClient] with decoders for `Map<String, dynamic>`
  /// and `List<dynamic>`.
  SerializableClient([Client? client])
      : _client = client ?? Client(),
        _serializables = [
          SerializableMap<String, dynamic>(),
          SerializableList<dynamic>(),
        ];

  /// Tries to register a [Serializable].
  ///
  /// If another [Serializable] with the same type has already been registered,
  /// and [override] is set to `false`, a [RequestsError] will be thrown.
  void registerSerializable<T>(Serializable<T> serializable,
      {bool override = false}) {
    final exists =
        _serializables.any((element) => element.type == serializable.type);

    if (exists) {
      if (!override) {
        throw RequestsError('A serializable for type $T already exists.');
      }

      _logger
          .warning('Overriding decoder of type ${serializable.runtimeType}.');

      _serializables
          .removeWhere((element) => element.type == serializable.type);
    }

    _serializables.add(serializable);
  }

  SerializedResponse<T> _serialize<T>(Response response) {
    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw Exception('Invalid status code: ${response.statusCode}');
    }

    try {
      final value = _serializables
          .singleWhere((element) => element.type == T)
          .read(response);

      return SerializedResponse<T>(
        value,
        response.statusCode,
        contentLength: response.contentLength,
        headers: response.headers,
        isRedirect: response.isRedirect,
        persistentConnection: response.persistentConnection,
        reasonPhrase: response.reasonPhrase,
        request: response.request,
      );
    } on StateError {
      throw RequestsError(
        'Cannot find a serializable for type $T. '
        'Did you forget to call registerSerializable?',
      );
    }
  }

  /// Sends an HTTP GET request with the given headers to the given URL.
  ///
  /// For more fine-grained control over the request, use [send] instead.
  Future<SerializedResponse<T>> get<T>(Uri url,
          {Map<String, String>? headers}) =>
      _client.get(url, headers: headers).then(_serialize);

  /// Sends an HTTP DELETE request with the given headers to the given URL.
  ///
  /// For more fine-grained control over the request, use [send] instead.
  Future<SerializedResponse<T>> delete<T>(Uri url,
          {Map<String, String>? headers, Object? body, Encoding? encoding}) =>
      _client.delete(url, headers: headers).then(_serialize);

  /// Sends an HTTP HEAD request with the given headers to the given URL.
  ///
  /// For more fine-grained control over the request, use [send] instead.
  Future<SerializedResponse<T>> head<T>(Uri url,
          {Map<String, String>? headers}) =>
      _client.get(url, headers: headers).then(_serialize);

  /// Sends an HTTP PATCH request with the given headers and body to the given
  /// URL.
  ///
  /// [body] sets the body of the request. It can be a [String], a [List<int>]
  /// or a [Map<String, String>]. If it's a String, it's encoded using
  /// [encoding] and used as the body of the request. The content-type of the
  /// request will default to "text/plain".
  ///
  /// If [body] is a List, it's used as a list of bytes for the body of the
  /// request.
  ///
  /// If [body] is a Map, it's encoded as form fields using [encoding]. The
  /// content-type of the request will be set to
  /// `"application/x-www-form-urlencoded"`; this cannot be overridden.
  ///
  /// [encoding] defaults to [utf8].
  ///
  /// For more fine-grained control over the request, use [send] instead.
  Future<SerializedResponse<T>> patch<T>(Uri url,
          {Map<String, String>? headers, Object? body, Encoding? encoding}) =>
      _client.get(url, headers: headers).then(_serialize);

  /// Sends an HTTP POST request with the given headers and body to the given
  /// URL.
  ///
  /// [body] sets the body of the request. It can be a [String], a [List<int>]
  /// or a [Map<String, String>]. If it's a String, it's encoded using
  /// [encoding] and used as the body of the request. The content-type of the
  /// request will default to "text/plain".
  ///
  /// If [body] is a List, it's used as a list of bytes for the body of the
  /// request.
  ///
  /// If [body] is a Map, it's encoded as form fields using [encoding]. The
  /// content-type of the request will be set to
  /// `"application/x-www-form-urlencoded"`; this cannot be overridden.
  ///
  /// [encoding] defaults to [utf8].
  ///
  /// For more fine-grained control over the request, use [send] instead.
  Future<SerializedResponse<T>> post<T>(Uri url,
          {Map<String, String>? headers, Object? body, Encoding? encoding}) =>
      _client.get(url, headers: headers).then(_serialize);

  /// Sends an HTTP PUT request with the given headers and body to the given
  /// URL.
  ///
  /// [body] sets the body of the request. It can be a [String], a [List<int>]
  /// or a [Map<String, String>]. If it's a String, it's encoded using
  /// [encoding] and used as the body of the request. The content-type of the
  /// request will default to "text/plain".
  ///
  /// If [body] is a List, it's used as a list of bytes for the body of the
  /// request.
  ///
  /// If [body] is a Map, it's encoded as form fields using [encoding]. The
  /// content-type of the request will be set to
  /// `"application/x-www-form-urlencoded"`; this cannot be overridden.
  ///
  /// [encoding] defaults to [utf8].
  ///
  /// For more fine-grained control over the request, use [send] instead.
  Future<SerializedResponse<T>> put<T>(Uri url,
          {Map<String, String>? headers, Object? body, Encoding? encoding}) =>
      _client.get(url, headers: headers).then(_serialize);

  /// Sends an HTTP GET request with the given headers to the given URL and
  /// returns a Future that completes to the body of the response as a String.
  ///
  /// The Future will emit a [ClientException] if the response doesn't have a
  /// success status code.
  ///
  /// For more fine-grained control over the request and response, use [send] or
  /// [get] instead.
  Future<String> read(Uri url, {Map<String, String>? headers}) =>
      _client.read(url, headers: headers);

  /// Sends an HTTP GET request with the given headers to the given URL and
  /// returns a Future that completes to the body of the response as a list of
  /// bytes.
  ///
  /// The Future will emit a [ClientException] if the response doesn't have a
  /// success status code.
  ///
  /// For more fine-grained control over the request and response, use [send] or
  /// [get] instead.
  Future<Uint8List> readBytes(Uri url, {Map<String, String>? headers}) =>
      _client.readBytes(url, headers: headers);
}
