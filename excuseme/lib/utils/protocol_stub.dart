import 'package:flutter_dotenv/flutter_dotenv.dart';

String protocol() {
  return dotenv.env['APP_ENV'] == 'prod' ? 'https' : 'http';
}
