library requests;

import 'package:requests/src/client.dart';

export 'src/client.dart';
export 'src/error.dart';

export 'src/serializable/serializable.dart';

final client = SerializableClient();
