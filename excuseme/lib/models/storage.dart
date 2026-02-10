import "package:flutter_secure_storage/flutter_secure_storage.dart";

// dataclasses
class UserTokens {
  const UserTokens(this.access, this.refresh);

  final String access;
  final String refresh;
}

class Credentials {
  const Credentials(this.username, this.password);

  final String username;
  final String password;
}

// Storage Manager
class StorageManager {
  // ctor
  StorageManager() {
    _initializeFlutterSecureStorage();
    readAll();
  }

  dynamic tokens;
  dynamic credentials;
  late final FlutterSecureStorage storage;

  void _initializeFlutterSecureStorage() {
    storage = FlutterSecureStorage(
      // add platform-specific options here
      // https://pub.dev/packages/flutter_secure_storage/example
    );
  }

  Future<void> readAll() async {
    try {
      final data = await storage.readAll();

      final bool tokensSaved =
          data.isNotEmpty &&
          data.containsKey("access") &&
          data.containsKey("refresh");

      final bool credentialsSaved =
          data.isNotEmpty &&
          data.containsKey("username") &&
          data.containsKey("password");

      if (tokensSaved) {
        final String? accessToken = await storage.read(key: "access");
        final String? refreshToken = await storage.read(key: "refresh");
        final bool notNull = (accessToken != null && refreshToken != null);

        if (notNull) tokens = UserTokens(accessToken, refreshToken);
      }

      if (credentialsSaved) {
        final String? username = await storage.read(key: "username");
        final String? password = await storage.read(key: "password");
        final bool notNull = (username != null && password != null);

        if (notNull) credentials = Credentials(username, password);
      }
    } catch (e) {
      // _handleInitializationError(e);
      rethrow;
    }
  }

  Future<void> writeAll() async {
    await storage.write(key: "username", value: credentials.username);
    await storage.write(key: "password", value: credentials.password);
    await storage.write(key: "access", value: tokens.access);
    await storage.write(key: "refresh", value: tokens.refresh);
  }

  // delete() and deleteAll already exist
}
