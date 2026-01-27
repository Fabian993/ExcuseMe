import "package:flutter_secure_storage/flutter_secure_storage.dart";

// dataclasses
class UserTokens {
  const UserTokens(this.access, this.refresh);

  final String access;
  final String refresh;
}

class Credentials {
  const Credentials(this.username, this.password, this.tokens);

  final String username;
  final String password;
  final UserTokens tokens;
}

// Storage Manager
class StorageManager {
  // ctor
  StorageManager() {
    _initializeFlutterSecureStorage();
    _readAll();
  }

  late UserTokens tokens;
  late Credentials credentials;
  late final FlutterSecureStorage storage;

  void _initializeFlutterSecureStorage() {
    storage = FlutterSecureStorage(
      // add platform-specific options here
      // https://pub.dev/packages/flutter_secure_storage/example
    );
  }

  Future<void> _readAll() async {
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

        if (notNull) credentials = Credentials(username, password, tokens);
      }
    } catch (e) {
      // _handleInitializationError(e);
      rethrow;
    }
  }
}
