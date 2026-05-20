#import "@preview/abbr:0.3.0"
#show: abbr.show-rule
#abbr.load("../abbreviations.csv", delimiter: ",")

= Implementierung

== Implementierung des Backends //F
#figure(
  image("../resources/drf_api_root.png"),
  caption: [@DRF:s API-Root]
  // author = {Jan Schubert},
  // date = {19.05.2026}
)

// weitere Abbildungen (drf_*) sind auch da und unbenutzt, falls du sie brauchst...

=== Datenbankmodell
(siehe @Datenbank-Schema)

=== Skalierbarkeit 
Redis, Traefik(?)

=== CRUD
(siehe @API_Kapitel API)

=== Authentifizierung

=== Autorisierung

// === Signatur 
// maybe...

== Implementierung des Frontends // J

=== Entrypoint
In `main.dart` startet die Ausführung der ExcuseMe App. Hier befindet sich an erster Stelle der Entrypoint, der für die Initialisierung der App auf allen Plattfomen zuständig ist. 

```dart
void main() {
  runApp(const MyApp());
}
```

Darunter befindet sich das Stateless Widget `MyApp`, was die root, also das unterste Widget der Applikation ist. Mit dem Key `title` legt `MyApp` den Namen der App bzw. die Benennung des Fensters fest. Auch das grundlegende Design, die `theme` und `darkTheme`, sowie die Weiterleitung zur Homepage, `home`, wird hier festgelegt. Da der Zugriff auf die Daten aber nur mit gültigen Zugangsdaten gestattet ist, finden sich Nutzer beim Start der App auf der Login Page wieder.

```dart
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ExcuseMe',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Color(0x000066FF),
          primary: Colors.deepOrange,
          secondary: Color(0x001a0201),
          brightness: Brightness.light,
        ),
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Color(0x000066FF),
          primary: Colors.deepOrange,
          secondary: Color(0x001a0201),
          brightness: Brightness.dark,
        ),
      ),
      themeMode: ThemeMode.system,
      home: LoginPage(),
    );
  }
}

```

=== Authentifizierung
Die Login Page überprüft beim Aufruf zuerst, ob bereits Daten bei einer früheren Anmeldung gespeichert wurden. Falls ja, werden diese gleich weiterverwendet und an die @API geschickt, um einen frischen Token zu erhalten. Der Nutzer wird dabei sofort auf die Homepage weitergeleitet. 
Anderenfalls wird die Login Page angezeigt, bis sich der Nutzer erfolgreich angemeldet hat. 

```dart
@override
Widget build(BuildContext context) {
  updateTokens();
  if (_stayAuthenticatedStorage) Skeleton();
  if (_isAuthenticated) {
    return Skeleton(); // Homepage
  } else {
    return Scaffold(); // Login Page
```

Beim Markieren der "Remember Me" Checkbox kann umgeschaltet werden, ob man angemeldet bleiben möchte oder nicht, um zukünftige Anmeldungen zu erleichtern. Dabei werden die Nutzerdaten mithilfe der `flutter-secure-storage` Bibliothek auf dem Endgerät des Nutzers verschlüsselt gespeichert,  Eine vereinfachte Darstellung ist im nachfolgenden Code-Block zu sehen.

```dart
// UI
CheckboxMenuButton(
  value: _stayAuthenticated,
  onChanged: (value) => setState(() {
    _stayAuthenticated = !_stayAuthenticated;
  }),
  child: Text("Remember Me"),
);
```

```dart
// logic
final StorageManager sm = StorageManager();

if (_stayAuthenticated) {
  await sm.storage.write(key: "username", value: username);
  await sm.storage.write(key: "password", value: password);
}
```

Für 

```dart
_isAuthenticated = await authenticate(
  _usernameController.text,
  _passwordController.text,
);
```

=== Responsive Layer
Der Responsive Layer bildet die eigentliche Basis der Homepage.

(siehe @Responsive-Design Responsive Design)

=== Homepage
Entschuldigungen einsehen und hochladen

=== Webuntis


== Systemintegration //F
Integration und Gesamtablauf des Systems

Demonstration des erfolgreichen Datenflusses vom UI bis in die Datenbank -> Integrationstest

== Testverfahren //F
=== Unit Tests
Beschreibung durchgeführter Tests

=== Integration Tests
siehe 5.1 Diskussion der Ergebnisse

=== E2E Tests
@E2E Tests
siehe 5.1 Diskussion der Ergebnisse