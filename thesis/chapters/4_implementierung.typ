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

=== Datenbankmodell
(siehe @Datenbank-Schema)

=== Skalierbarkeit 
Programmier-Paradigmen wie @OOP bzw. Sprachen, die @OOP ermöglichen, wie Python, Dart, ...

Technologien wie Redis, Traefik(?), 

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
Die folgenden Code-Blocks dienen der vereinfachten Darstellung der Authentifizierungslogik und zeigen ausschließlich die für das Verständnis relevanten Kernschritte.

Die Login Page überprüft beim Aufruf zuerst, ob bereits ein Refresh-Token bei einer früheren Anmeldung gespeichert wurde. Falls ja, wird dieser gleich weiterverwendet und an die @API geschickt, um einen frischen Access-Token zu erhalten. Der Nutzer wird dabei sofort auf die Homepage weitergeleitet. 

```dart
Future<bool> authenticate(String username, String password) async {
  try {
    await dotenv.load(fileName: ".env");
    String? backendAddress = dotenv.env['BACKEND_SERVER'];

    final response = await dio.post(
      'https://$backendAddress/api/token/',
      data: {"username": username, "password": password},
      options: Options(headers: {'Content-Type': 'application/json'}),
    );
    if (response.statusCode == 200) {
      return true; 
    }
    return false;
  } catch (error) {
    return false;
  }
}
```

Anderenfalls wird die Login Page angezeigt, bis sich der Nutzer erfolgreich angemeldet hat, was in folgendem Code sichtbar ist. 

```dart
@override
Widget build(BuildContext context) {
  if (_stayAuthenticatedStorage) Skeleton();
  if (_isAuthenticated) {
    return Skeleton(); // Homepage
  } else {
    return Scaffold(); // Loginpage
```

Beim Markieren der "Remember Me" Checkbox kann umgeschaltet werden, ob man angemeldet bleiben möchte oder nicht, um zukünftige Anmeldungen zu erleichtern, was im nachfolgenden Code-Block zu sehen ist.

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

Dabei werden die Nutzerdaten mithilfe der `flutter-secure-storage` Bibliothek auf dem Endgerät des Nutzers verschlüsselt gespeichert.

```dart
// logic
final StorageManager sm = StorageManager();

if (_stayAuthenticated) {
  await sm.storage.write(key: "access", value: response.data["access"]);
  await sm.storage.write(key: "refresh", value: response.data["refresh"]);
}
```

=== Responsive Layer
Um die Nutzung der App auf unterschiedlichsten Plattformen und Bildschirmgrößen zu erleichtern, steuert eine responsive Schicht die Anzeige der Seite und die Position der Navigationsleiste bestimmen (siehe @Responsive-Design Responsive Design).

Der nachstehende, gekürzte Code-Block zeigt, wie der Responsive Layer, im folgenden als Skelett bezeichnet, die Grundlage der Home-Seite bildet. \
Ein LayoutBuilder baut die vom Nutzer ausgewählte Seite. Dabei wird auf die aktuelle Breite der Applikation geschaut. Unterschreitet sie dabei einen bestimmten Wert, wird die Navigationsleiste unterhalb der Seite dargestellt, andernfalls auf der rechten Seite. 

```dart
// Responsive Layer
class Skeleton extends StatefulWidget {
  const Skeleton({super.key});

  @override
  State<Skeleton> createState() => _SkeletonState();
}

class _SkeletonState extends State<Skeleton> {
  int _pageIndex = 0;
  final List<dynamic> _pages = [HomePage(), ExcusesPage(), SettingsPage()];

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isMobile = constraints.maxWidth < 650;

        if (isMobile) { 
          return Scaffold(  
            // Design with BottomNavigationBar()
          );
        }  else { 
          return Scaffold(
            // Design with NavigationRail()
          ); 
        }
```


=== Homepage
Während der Nutzer auf die `Home` Seite weitergeleitet wird, wird im Hintergrund eine Authentifizierunganfrage an die Webuntis-Server gesendet, um aktuelle Tokens und die `studentId` des Nutzers zu erhalten. Die ID wird in der nachfolgenden Abfrage für den Abruf der Fehlstunden benötigt, wie der folgende, vereinfachte Code zeigt.

```dart
Future<List<dynamic>> getAbsences() async {
  String? untisServer = dotenv.env['UNTIS_SERVER'];
  String? untisSchool = dotenv.env['UNTIS_SCHOOL'];

  final StorageManager sm = StorageManager();
  final Dio dio = Dio();

  final cookieJar = CookieJar();
  dio.interceptors.add(CookieManager(cookieJar));

  // login
  await dio.post(
    "https://$untisServer/WebUntis/j_spring_security_check",
    data: {
      "j_username": username!,
      "j_password": password!,
      "school": untisSchool,
      "token": "",
    },
    options: Options(
      contentType: Headers.formUrlEncodedContentType,
      followRedirects: false, // disable for web
      validateStatus: (status) => true, // Accept 302
    ),
  );

  String studentId = await getStudentId(username, password);

  // get absences
  final response = await dio.get(
    "https://$untisServer/WebUntis/api/classreg/absences/students",
    queryParameters: {
      "startDate": "20250908",
      "endDate": "20260712",
      "studentId": int.parse(studentId),
      "excuseStatusId": -1,
    },
    options: Options(headers: {"Accept": "application/json"}),
  );
  
  List<dynamic> absences = response.data['data']['absences'];

  return absences;
}
```

== Systemintegration //F
// ich kann hier noch ein Mermaid Flowchart erstellen, obwohl bereits eins
Integration und Gesamtablauf des Systems

Demonstration des erfolgreichen Datenflusses vom UI bis in die Datenbank -> Integrationstest

== Testverfahren //F
=== Unit Tests
Beschreibung durchgeführter Tests

=== Integration Tests
(siehe @Diskussion-der-Ergebnisse Diskussion der Ergebnisse)

=== E2E Tests
@E2E Tests

(siehe @Diskussion-der-Ergebnisse Diskussion der Ergebnisse)