#import "footer.typ": set_footer_name
#import "@preview/abbr:0.3.0"
#show: abbr.show-rule
#abbr.load("../abbreviations.csv", delimiter: ",")

= Implementierung
#set_footer_name("Fabian Trummer")
== Implementierung des Backends //F
#figure(
  image("../resources/drf_api_root.png", width: 105%),
  caption: [@DRF:s API-Root]
  // author = {Jan Schubert},
  // date = {19.05.2026}
)

=== Datenbankmodell
Die Implementierung der Datenbank findet Grundlegend in der `models.py` statt. Hier werden die Tabellen als Klasse (`class`) definiert, zusammen mit den Spalten, die in der Tabelle sein sollen. Dazu kommen Parameter, die das Datenbankverhalten beeinflussen, wie beispielsweise `on_delete=models.CASCADE` .
Als Beispiel findet man im folgenden Code-Block die Tabelle "Excuse". Diese wurde, wie so ziemlich alle anderen Tabellen auch, mit der Basisklasse `models.Model` erstellt, welche aus der Python-Klasse ein Django-Datenbank-Modell erstellt. Django erstellt daraufhin automatisch eine Datenbanktabelle aus diesem Modell.
```python
class Excuse(models.Model):
  title = models.CharField(max_length=255)
  content = models.CharField(max_length=255)
  created_at = models.DateTimeField(auto_now_add=True)
  uploaded_by_user = models.ForeignKey(
      User,
      related_name="uploaded_excuses",
      on_delete=models.CASCADE,
  )
  student = models.ForeignKey(
      Student,
      related_name="excuses",
      on_delete=models.CASCADE,
  )
  teachers = models.ManyToManyField(
      Teacher,
      through="ExcuseTeacher",
      related_name="assigned_excuses",
  )
  def __str__(self):
      return f"{self.title} ({self.pk})"
```
`title`, `content` und `created_at` werden zu Spalten in der Tabelle. `uploaded_by_user`, `student` und `teachers`, sind Fremdschlüssel (Foreign-Keys), die notwendig sind, um Verbindungen zu anderen Tabellen herzustellen. 
\
Während `uploaded_by_user` und `student`, aus Sicht des Users, als One-to-Many-Beziehung (1:n) funktionieren, wird die Beziehung zu Lehrern über eine Many-to-Many(m:n) Beziehung abgebildet.

#figure(
  table(
    columns: 2,
    align: center,
    
    [One-to-Many (1:n)], [Jede Entschuldigung hat einen Uploader. \ Ein User kann viele Entschuldigungen haben.],
    [Many-to-Many (m:n)], [Eine Entschuldigung kann für viele Lehrer sein. \ Ein Lehrer kann viele Entschuldigungen haben.],
    [ManyToManyField], [Django erstellt automatisch eine Zwischentabelle.],
    [on_delete=models.CASCADE], [Wenn das referenzierte Objekt gelöscht wird, werden auch alle abhängigen Objekte gelöscht.]
  ),
  caption: [Erklärung von Begriffen]
)
/*
```python
class User(AbstractUser):
    school = models.ForeignKey(
        School,
        related_name="users",
        on_delete=models.CASCADE,
        null=True,
        blank=True
    )
    role = models.CharField(
        max_length=20,
        choices=[('teacher', 'Teacher'), 
                ('student', 'Student'), 
                ('parent', 'Parent')
                ],
        default='student'
    )
    klasse = models.ForeignKey(
        Klasse,
        on_delete=models.SET_NULL, 
        null=True, 
        blank=True
    )
    def __str__(self):
        return f"{self.username} ({self.pk})"
```
*/
Die folgende Abbildung zeigt alle Tabellen der aktuellen Datenbank des Projekts:
#figure(
  image("../resources/postgres_railway.png"),
  caption: [DB-Tabellen in Railway dargestellt]
  // author = {Fabian Trummer},
  // date = {29.05.2026}
)
Für Informationen zum Datenbank-Schema siehe @Datenbank-Schema


=== CRUD
CRUD ist ein einfaches Akronym und beschreibt die vier Grundoperationen zur Verwaltung von Daten in Softwaresystemen: `Create`, `Read`, `Update`, `Delete`. Diese gelten als Basis nahezu jeder datenbankgestützten Anwendung. Das @DRF stellt diese Operationen in Form von Methoden innerhalb eines ModelViewSet dar. Dadurch entsteht eine klare Zuordnung zwischen Datenbankoperation, HTTP-Schnittstelle und serverseitiger Implementierung. Dadurch erhält man eine saubere Trennung zwischen Datenhaltung, API-Kommunikation und Anwendungslogik und vereinfacht somit die Entwicklung der Anwendung.

Der Vergleich der Methoden in SQL, HTTP und @DRF:l:
#figure(
  table(
    columns: 4,
    table.header([*Operation*], [*SQL*], [*HTTP*], [*DRF `(ModelViewSet)`*]),
    [Create],[INSERT], [POST], [create()],
    [Read],[SELECT], [GET], [list()/retrieve()],
    [Update],[UPDATE], [PUT/PATCH], [update()/partial_update()],
    [Delete],[DELETE], [DELETE], [destroy()],
  ),
  caption: [CRUD in SQL, HTTP und DRF]
)
Zur Verarbeitung und Darstellung werden zwei Serializer verwendet. Einmal ein Input-Serializer und ein Output-Serializer.
\
Der `ExcuseInputSerializer` dient nur zur Validierung und Verarbeitung eingehender Daten bei Create- oder Update-Operationen. Dieses enthält nur die notwendigen Felder (title, content, student), wodurch der Input bewusst eingeschränkt und kontrolliert wird.
\
Der `ExcuseOutputSerializer` wird für die API-Antworten verwendet und dient zur Erweiterung der Daten um zusätzliche Informationen. Dazu gehören der Benutzer, der die Entschuldigung erstellt hat, sowie der zugehörige Schüler. Dadurch ist es möglich, zusammenhängende Daten in einer Anfrage zu erhalten, ohne zusätzliche API-Aufrufe.

Die Trennung von Input und Output ist wichtig, da sowohl die Sicherheit als auch die Kontrolle der Datenstruktur verbessert wird. Dies führt zu einer flexibleren Gestaltung der API.

*Serializer.py*:
```python
class ExcuseInputSerializer(serializers.ModelSerializer):
    class Meta:
        model = Excuse
        fields = ['title', 'content', 'student']
class ExcuseOutputSerializer(serializers.ModelSerializer):
    uploaded_by_user = UserNestedSerializer(read_only=True)
    student = StudentNestedSerializer(read_only=True)

    class Meta:
        model = Excuse
        fields = ['id', 'title', 'content', 'created_at', 
                  'uploaded_by_user', 'student']
        read_only_fields = ['id', 'created_at']
```
\
Anhand des `ViewSet` der Entschuldigung wird nun nicht nur Code, sondern auch die Logik der ViewSets näher gebracht. Ein `ModelViewSet` fasst die Standardoperationen für CRUD in einer einzigen Klasse zusammen. Mit `get_queryset()` wird eine rollenbasierte Zugriffskontrolle implementiert, die dafür sorgt, dass jeder Benutzer nur die für ihn vorgesehenen Entschuldigungen sehen kann. Nicht authentifizierte Benutzer haben keinen Zugriff auf Daten und Administratoren dürfen alles einsehen. Währenddessen erhalten Lehrer, Eltern und Schüler nur ihre eigenen bzw. ihnen zugeordneten Entschuldigungen. Die Methode `get_serializer_class()` wählt anhand der aktuellen Aktion, den richtigen Serializer aus. Für schreibende Operationen wird der `ExcuseInputSerializer` genutzt, während für lesende Operationen der `ExcuseOutputSerializer` genutzt wird. Mit `perform_create()` wird der Benutzer der die Entschuldigung hochlädt, Serverseitig gesetzt, wodurch die Manipulation durch den Client verhindert wird. Weiters sieht man die benutzerdefinierte Aktion `sign()`, die eine Entschuldigung genehmigt und digital signiert. Diese wurde per `@action`-Decorator als zusätzlicher API-Endpoint definiert. Weitere Informationen zur Signatur im Abschnitt X.X.X. Durch die Methode `get_permissions()` wird schließlich noch sichergestellt, dass nur authentifizierte und berechtigte Benutzer auf die Funktionen zugreifen können. Somit verbindet das `ViewSet` die zentrale Geschäftslogik und Security mit der CRUD-Funktionalität. 

*Views.py*:
```python
class ExcuseViewSet(viewsets.ModelViewSet):
    queryset = Excuse.objects.all()
    #filter_backends = [DjangoFilterBackend]
    #filterset_fields = ['status']

    def get_queryset(self):
        user = self.request.user
        if not user.is_authenticated:
            return Excuse.objects.none()
        elif user.is_superuser:
            return Excuse.objects.all()

        elif hasattr(user, 'student'):
            return Excuse.objects.filter(student=user.student)
        elif hasattr(user, 'teacher'):
            return Excuse.objects.filter(
              student__klasse__in=user.teacher.klassen.all()
            )
        elif hasattr(user, 'parent'):
            return Excuse.objects.filter(student__parents = user.parent)
        return Excuse.objects.none()
    
    def get_serializer_class(self):
        if self.action in ['create', 'update', 'partial_update']:
            return ExcuseInputSerializer
        return ExcuseOutputSerializer
    
    def perform_create(self, serializer):
        custom_user = User.objects.get(pk=self.request.user.pk)
        serializer.save(uploaded_by_user=custom_user)

    @action(detail=True, methods=['patch'], 
        permission_classes=[permissions.IsAuthenticated,
        ExcusePermission])
    def sign(self, request, pk=None):
        excuse = self.get_object()
        excuse.status = Status.objects.get(name='approved')
        excuse.approved_by = request.user
        excuse.approval_timestamp = int(time.time())
        excuse.save()

        strategy_name = request.data.get('strategy', 'django') #django = default
        strategy = changeStrategy(strategy_name, user=request.user)
        confirmation = {
            'excuse_id': excuse.id,
            'status': 'approved',
            'parent_id': request.user.id,
            'timestamp': excuse.approval_timestamp,
        }
        
        signed_json = strategy.signJson(confirmation)
        serializer = ExcuseOutputSerializer(excuse)
        return Response({
            **serializer.data,
            'signed_confirmation': signed_json
        })

    def get_permissions(self):
        return [permissions.IsAuthenticated(), ExcusePermission()]
```

In der `Urls.py` wird das Routing der API definiert. Dabei werden die ViewSets über einen `DefaultRouter` automatisch mit passenden REST-Endpunkten verknüpft. Der Router erzeugt die URL-Struktur für die registrierten Ressourcen und bindet sie unter dem Pfad `api/` ein. Dadurch entsteht eine konsistente und leicht erweiterbare API-Routing-Struktur.

*Urls.py*:
```python
  from django.urls import path, include  # noqa
  from rest_framework.routers import DefaultRouter
  from . import views
  
  #removed basename
  router = DefaultRouter()
  router.register(r"schools", views.SchoolViewSet) 
  router.register(r"users", views.UserViewSet) 
  router.register(r"klasses", views.KlasseViewSet) 
  router.register(r"teachers", views.TeacherViewSet) 
  router.register(r"students", views.StudentViewSet) 
  router.register(r"parents", views.ParentViewSet) 
  router.register(r"status", views.StatusViewSet) 
  router.register(r"excuses", views.ExcuseViewSet) 
  router.register(r"excuseteacher", views.ExcuseTeacherViewSet) 
  
  urlpatterns = [
      path("api/", include(router.urls))
  ] 
```
Für Informationen zu API-Endpoints siehe @API_Kapitel API.

=== Authentifizierung

Während andere Modelle von `models.Model` erben, basiert das Benutzermodell auf der Django-Klasse `AbstractUser`. Der Unterschied zu den models.Model liegt darin, dass `AbstractUser` bereits eine Grundlage zur Benutzerverwaltung und Authentifizierung bereitstellt. Dazu kommen auch Felder wie Benutzname und Password, wodurch zentrale Funktionen nicht selbst implementiert werden müssen. Das Modell wird dabei jedoch um relevante Felder wie `school`, `role` und `klasse` erweitert.

*models.py*:
```python
class User(AbstractUser):
    school = models.ForeignKey(
        School,
        related_name="users",
        on_delete=models.CASCADE,
        null=True,
        blank=True
    )
    role = models.CharField(
        max_length=20,
        choices=[('teacher', 'Teacher'), ('student', 'Student'), ('parent', 'Parent')],
        default='student'
    )
    klasse = models.ForeignKey(
        Klasse,
        on_delete=models.SET_NULL, 
        null=True, 
        blank=True
    )
    def __str__(self):
        return f"{self.username} ({self.pk})"
```

=== Rollenbasierte-Autorisierung
Für die rollenbasierte Autorisierung werden Benutzer zunächst in klar definierte Rollen eingeteilt. Lehrer, Eltern und Schüler bilden die Grundlage für sämtliche Zugriffsentscheidungen. Da nur überprüft wird ob ein Attribut vorhanden ist, lässt sich während der Laufzeit schnell feststellen, welche Rolle ein User hat.

*permissions.py*:
```python
def isTeacher(user):
    return hasattr(user, "teacher")

def isStudent(user):
    return hasattr(user, "student")

def isParent(user):
    return hasattr(user, "parent")
```

Anhand der ExcusePermission, also der Zugangsliste der Entschuldigungen zeigt sich die Implementierung des genannten Attribut vergleichs. Nach der Rollendefinition übernimmt die Klasse `ExcusePermission` die eigentliche Zugriffskontrolle. Dabei wird zwischen `has_permission` und `has_object_permission` unterschieden. Das erstere prüft, ob ein Benutzer überhaupt berechtigt ist, eine CRUD-Operation durchzuführen. Dabei werden allgemeine Regeln festgelegt. Beispielsweise, dass Lehrer die übermittelten Entschuldigungen nur lesen dürfen. Weiters haben wir die `has_object_permission` die dabei detailreicher vorgeht und prüft ob ein Benutzer auf ein bestimmtes Objekt zugreifen darf. Schüler haben nur das Recht eigene Entschuldigungen zu sehen und Lehrer nur von Klassen für die sie zuständig sind. Dadurch entsteht eine klare Trennung zwischen allgemeiner und objektspezifischer Kontrolle.
```python
class ExcusePermission(permissions.BasePermission):
    """
    - POST: Parent oder Student, Admin
    - GET: Parent/Student nur eigene, Teacher nur per Klasse, Admin alle
    - DELETE: Parent/Student eigene, Admin alle
    """
    def has_permission(self, request, view):
        if request.user.is_superuser:
            return True
        elif not (request.user and request.user.is_authenticated):
            return False
        elif isTeacher(request.user):
            return request.method in permissions.SAFE_METHODS
        elif isParent(request.user):
            return True
        elif isStudent(request.user):
            return request.method != 'PATCH'
        return False
        
    def has_object_permission(self, request, view, obj):
        if request.user.is_superuser:
            return True
        elif isStudent(request.user):
            return obj.student_id == request.user.student.pk
        elif isParent(request.user):
            return obj.student.parents.contains(request.user.parent)
        elif isTeacher(request.user):
            return teacherClasses(
              request.user).filter(pk=obj.student.klasse_id).exists()
        return False
```

#pagebreak()
#set_footer_name("Jan Schubert")
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

#pagebreak()
#set_footer_name("Fabian Trummer")
== Systemintegration //F
Systemintegration von ExcuseMe verbindet Flutter-Frontend, Django REST Backend und die PostgreSQL-Datenbank zu einem Datenfluss. Eingehende HTTP-Requests werden über den URL-Router (`urls.py`) an die API weitergeleitet. Dort werden JWT-Token-Validierung, eine rollenbasierte Berechtigungsprüfung und Datenserialisierung durchlaufen. Erst danach wird ein Datensatz mit Django ORM in der Datenbank gespeichert. Die Authentifizierung erfolgt über die Endpunkte `/api/token` und `/api/token/refresh` mit SimpleJWT. Damit wird zustandslose Kommunikation von Client und Server ermöglicht.
\
Das in der folgenden Abbildung xy ersichtliche Flowchart visualisiert diesen Ablauf:

#figure(
  image("../resources/datenfluss-chart.png", width: 85%),
  caption: [Datenfluss-Flowchart]
)
//vlt noch einer erklärung zum Chart?
== Testverfahren //F
=== Unit Tests
Die Unit-Tests von `ExcuseMe` validieren alle Datenbankmodelle unabhängig von der Anwendungslogik. Dabei werden Objekterstellung, Fremdschlüssel und Manty-to-Many-Beziehungen geprüft. Mittels `django_autotest.yaml` werden die Tests implementiert, die bei jedem Push oder Pull Request auf `main` oder `dev` über GitHub Actions ausgeführt werden.

#figure(
  image("../resources/Unit-Test.png", height: 75%),
  caption: [Unit-Tests]
)
=== Integration Tests
siehe @Diskussion-der-Ergebnisse Diskussion der Ergebnisse

=== E2E Tests
siehe @Diskussion-der-Ergebnisse Diskussion der Ergebnisse