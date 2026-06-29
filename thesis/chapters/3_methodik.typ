#import "footer.typ": set_footer_name
#import "@preview/abbr:0.3.0"
#show: abbr.show-rule
#abbr.load("../abbreviations.csv", delimiter: ",")


= Methodik und Systemdesign

#set_footer_name("Jan Schubert")
== Software-Entwicklungszyklus // J

=== Beschreibung des angewandten Zyklus
Die Planung und Umsetzung von ExcuseMe wurde anhand des Scrum-Modells durchgeführt. Scrum ist ein agiles Vorgehensmodell, das das Projekt in kurze Sprints von zwei bis vier Wochen unterteilt. Jeder Sprint beginnt mit der Planung und endet mit einer Retrospektive, in der der vorherige Sprint bewertet und der nächste angepasst wird. Die Planung, Testing, *Refactoring,* Strategie und Abarbeitung verschiedener @AP orientieren sich am V-Modell, weil dort jeder Entwicklungs- und Analysephase eine passende Testaktivität zugeordnet ist. Dadurch werden die Softwarequalität erhöht und Projektrisiken reduziert. 

Im Falle von ExcuseMe nahm der Betreuer der Arbeit die Rolle des Scrum-Masters ein, indem er für die Kontrolle bzw. Besprechung des Fortschritts und die Einhaltung von gegebenen Zeiten sorgte, sowie die Priorisierung der einzelnen Arbeitspakete überprüfte.  
@scrum_master
  
=== Work Breakdown Structure
Nachdem ein Sprint geplant wurde, erfolgte die Zerlegung in kleinere, umsetzbare Teilaufgaben in Form von GitHub-Issues. Dabei wurde festgelegt, wer welche Aufgaben bis zum nächsten Sprint erledigt haben muss, um die gegebenen Ziele zu erreichen. Hieraus entsteht eine nachvollziehbare Aufgabenverteilung. 


== Architektur-Design // J

=== Übersicht
#figure(
  image("../resources/architecture_overview.png"),
  caption: [Architektur Übersicht]
  // author = {Jan Schubert},
  // date = {16.05.2026}
)

Die Abbildung zeigt die zentrale Systemarchitektur der Anwendung mit Client, REST-API und relationaler Datenbank (siehe @Client-Server-Architekturprinzip Definition und Bedeutung des Client-Server-Architekturprinzips).

Der End-Nutzer verwendet die in Flutter geschriebene ExcuseMe App, welche das Frontend bzw. den Client darstellt.
Bereits bei der Anmeldung schickt die App über das Internet eine Anfrage, Request genannt, an das Backend bzw. den Server, der wiederum für dessen Auswertung zuständig ist. Hierzu gehören die Authentisierung des Nutzers und Authorisierung der Anfrage, sowie die Weiterleitung an die Datenbank. Im Falle dieser Arbeit läuft sie auf dem selben Server. Die Query, also die Datenbank-spezifische Suchanfrage, wird von der Datenbank verarbeitet. Das Ergbnis wird ans Backend zurück gereicht und von dort als Antwort, Response genannt, über das Internet an den Client zurück geschickt.

=== Schematisierung der Daten <Datenbank-Schema>

#figure(
  image("../resources/db_design.png"),
  caption: [Datenbanken Schema]
  // author = {Jan Schubert},
  // date = {16.05.2026}
)

Die Abbildung zeigt das ursprünglich geplante relationale Datenbanken Schema von ExcuseMe.

Zuerst werden Schulen und Klassen eingetragen, welche die Datengrundlage bilden. Daraufhin werden Nutzer und deren Daten hinzugefügt und mit einer der Rollen "Student", "Teacher" oder "Parent" verknüpft. Um die Signatur durch Erziehungsberechtigte zu ermöglichen, werden Students und Parents ebenso miteinander verknüpft und in der Tabelle StudentParent gespeichert. Zuletzt müssen den Klassen noch ein Klassenvorstand hinzugefügt werden. \
Nun können Entschuldigungen aller Art erstellt und ihnen ein Lehrer in der Tabelle DokumentTeacher zugeordnet werden.

// Während der frühen Planungsphase dieser Arbeit fiel aufgrund der Art der Daten die Wahl auf eine relationale Datenbank. 

=== API <API_Kapitel>
#figure(
  table(
    columns: (auto, auto, auto),
    inset: 12pt,
    align: horizon,
    table.header(
      [*Model*], [*View*], [*Controller*]
    ),
    [School], [schools/], [SchoolViewSet],
    [Klasse], [klasses/], [KlasseViewSet],
    [User], [users/], [UserViewSet],
    [Teacher], [teachers/], [TeacherViewSet],
    [Student], [students/], [StudentViewSet],
    [Parent], [parents/], [ParentViewSet],
    [Status], [status/], [StatusViewSet],
    [Excuse], [excuses/], [ExcuseViewSet],
    [ExcuseTeacher], [excuseteacher/], [ExcuseTeacherViewSet],
  ),
  caption: [Django @MVC:s Übersicht]
  // author = {Jan Schubert},
  // date = {16.05.2026}
)

Die Tabelle zeigt eine Übersicht über die Namen aller Datenbank-Modelle (links), deren mit "/api/" beginnenden verknüpfte Routen bzw. den Ort der Resource (mittig), sowie den zugehörigen Controller (rechts).

Eigentlich orientiert sich Django selbst an einer Variation des @MVC Modells, die sich @MVT Modell nennt. Der Unterschied beider Design Architekturen ist, dass Django's Views Aufgaben des Controllers übernehmen und durch Templates ersetzt werden. Diese machen das Erstellen von Websites mithilfe von @DTL Django möglich.
@mvt_structure

=== Applikation

Da der Zugriff auf die @API über eine eigene Cross‑Platform‑App erfolgt, sind serverseitige Templates hier jedoch überflüssig. Die App stellt die Benutzeroberfläche zum Anmelden, zum Anzeigen von Fehlstunden und zum Hochladen von Entschuldigungen bereit und übernimmt damit im MVC‑Designpattern die Rolle der View (siehe @Model-View-Controller Model‑View‑Controller).

=== JSON-Response-Struktur
Flutter und Django kommunizieren über eine REST‑API, bei der alle Daten im JSON‑Format ausgetauscht werden. \
Django liefert über das @DRF strukturierte @JSON``-Responses. Dabei wird jeder Endpunkt der @API mit einem JSON-Schema versehen (siehe @API_Kapitel API). Optional können Daten mit Django‑Serializers direkt in JSON‑Schema umgewandelt werden.

Die Flutter App sollte erhaltene Antworten nutzen, um die JSON-Daten in typsichere Dart-Objekte umzuwandeln und umgekehrt.

Folgendes JSON-Schema definiert zum Beispiel die Struktur der Response für den Endpunkt "Status":

```json
// Response of /api/status/
{
    "count": 3,
    "next": null,
    "previous": null,
    "results": [
        {
            "id": 1,
            "name": "Accepted"
        },
        {
            "id": 2,
            "name": "Rejected"
        },
        {
            "id": 3,
            "name": "Waiting"
        }
    ]
}
```

Alle Ergebnisse werden dabei zusammen mit der Gesamtanzahl an Elementen und nächstem bzw. vorherigem Objekt in einem @DRF``-Wrapper zurückgesandt. 

```json
// DRF-Wrapper
{
    "count": int,
    "next": null,
    "previous": null,
    "results": []
}
```

Um ein spezifisches Element als Antwort zu erhalten, kann der @URL die ID des gesuchten Elements hinzugefügt werden. 

```json
// Response of /api/status/3/
{
    "id": 3,
    "name": "Waiting"
}
```

Die nachstehende Tabelle gibt eine Übersicht über die zentralen API-Endpunkte und deren typische JSON-Responses. Für Listenendpunkte wird dabei die von @DRF:lo verwendete Wrapper-Struktur mit `count`, `next`, `previous` und `results` verwendet. \
Zur besseren Lesbarkeit werden in der Tabelle nur die wesentlichen Felder der jeweiligen Responses dargestellt.

#figure(
  table(
    columns: (4cm, auto),
    inset: 12pt,
    align: left,
    table.header(
      [*Route*], [*Response*]
    ),
    [schools/], [
        ```json
        {
            "id": 1,
            "name": "Beispielschule",
            "address": "Musterstraße 1"
        }
        ```
    ],
    [users/], [
        ```json
        {
            "username": "max.mustermann",
            "email": "max.mustermann@email.com",
            "first_name": "Max",
            "last_name": "Mustermann",
            "school": {},
            "role": "student"
        }
        ```
    ],
    [klasses/], [
        ```json
        {
            "id": 1,
            "name": "4AKIFT",
            "school": {},
            "teachers": []
        }
        ```
    ],
    [
        teachers/, \
        students/, \
        parents/
    ], [        
        ```json
        {
            "id": 1,
            "user": {}
        }
        ```
    ],
    [status/], [
        ```json
        {
            "id": 1,
            "name": "Accepted"
        }
        ```
    ],
    [excuses/], [        
        ```json
        {
                "id": 1,
                "title": "Abwesenheit",
                "content": "Krankheit",
                "created_at": "2000-01-01T00:00:00Z",
                "uploaded_by_user": {},
                "student": {}
        }
        ```
    ],
    [excuseteacher/], [
        ```json
        {
            "id": 1,
            "excuse": {},
            "teacher": {},
            "status": {},
            "read_at": "2000-01-01T00:00:00Z"
        }
        ```
    ]
  ),
  caption: [Übersicht API Responses]
  // author = {Jan Schubert},
  // date = {19.05.2026}
)

#pagebreak()
#set_footer_name("Fabian Trummer")
== Technologien //F

=== Django 
Mögliche Optionen für das Backend bestanden aus Flask, FastAPI und Django in Python, sowie Node.js und NestJS in @JS. Der Fokus bei der Wahl lag auf Django und Node.js, da diese bereits im Unterricht behandelt wurden. Obwohl der Wissensstand in Richtung Node.js größer war wurde sich für das Django-Backend entschieden und das aus folgenden Gründen:

Erstens ist der Einstieg in ein neues Projekt sehr einfach. Sobald Django installiert ist, kann man direkt mit einem vorgefertigten Projekt-Template starten und hat ein funktionierendes Grundgerüst. \
Der Hauptgrund für die Wahl von Django ist die schnelle Entwicklung, da wichtige Funktionen wie Authentifizierung, Admin-Oberfläche, @ORM und Migrationen bereits inkludiert sind. Das spart Zeit im Vergleich zu leichteren Frameworks wie Node.js, bei denen man vieles selbst  zusammenbauen muss. Weiters bringt es eine klare, übersichtliche Architektur mit, die sehr hilft den Überblick über das Projekt zu wahren. \
Zusätzlich verfügt Django über bereits vorhandene Sicherheitsfeatures, beispielsweise den eingebauten Schutz vor @XSS, eine Sicherheitslücke bei der Angreifer schädlichen Code in legitime Seiten einschleusen oder @SQLi einer Cyber-Schwachstelle die Angreifern ermöglicht manipulierenden Code in Eingabefelder einzuschleusen. \
Wichtig ist, dass Entwicklungsgeschwindigkeit und klare Struktur gegenüber einer höheren Performance, beispielsweise durch Node.js, bevorzugt wurden und dabei eine geringere Performance in Kauf genommen wurde.\
@django_doc, @django_getting_started, @django_models, @django_security


=== Django Rest Framework (DRF) <DRF_Kapitel>
// Warum Django REST?
@DRF ist ein Framework zur Erstellung von Rest-APIs auf Basis von Django. Es erweitert Django um Funktionen, die speziell für die Bereitstellung von Schnittstellen zwischen Backend und Frontend wichtig sind, zum Beispiel Serialisierung, Authentifizierung, Berechtigungen und ViewSets. \
Für das Projekt war @DRF eine sinnvolle Ergänzung, da damit die @API strukturiert und mit deutlich weniger Aufwand umgesetzt werden konnte. Zusätzlich bietet @DRF eine Browsable API, welche die direkte Ansicht und Testung von Endpunkten im Browser ermöglicht. Dadurch wurde die Entwicklung vereinfacht und die Wartbarkeit des Backend verbessert.
@drf_doc, @drf_browsable_api, @drf_serialization, @drf_auth_permissions


=== Flutter  
Flutter wurde für ExcuseMe gewählt, da bereits Vorkenntnisse vorhanden sind und das Framework eine effiziente Cross-Platform-Entwicklung ermöglicht. Zudem bietet Flutter durch seine eigene Rendering-Engine eine hohe Performance sowie ein konsistentes Erscheinungsbild über verschiedene Plattformen hinweg. Weitere Informationen sind von @React-Native-Vs-Flutter React Native vs Flutter bis @State-Management State-Management zu finden.

// Warum Flutter?
// - Bereits Erfahrung damit
// - Riesiges Ökosystem
// - Fast native Performance
// - Cross-Platform-Entwicklung

=== PostgreSQL
//Warum PostgreSQL
Für das Projekt wurde PostgreSQL als Datenbank gewählt, da es sich um ein leistungsfähiges und zuverlässiges relationales Datenbanksystem handelt, das sich gut in Django integrieren lässt. Besonders bei Anwendungen mit strukturierten Daten und klaren Beziehungen zwischen Entitäten bietet eine relationale Datenbank große Vorteile.

In ExcuseMe müssen Benutzer, Rollen, Abwesenheiten und weitere zugehörige Informationen konsistent gespeichert und miteinander verknüpft werden. Dafür sind relationale Datenbanken besonders geeignet, da sie mit Tabellen, Schlüsseln und Transaktionen eine hohe Datenintegrität gewährleisten.

Als Alternative wäre auch SQLite möglich gewesen, das jedoch in diesem Projekt an seine Grenzen gestoßen wäre. MySQL oder MariaDB wurden ebenfalls in Erwägung gezogen, doch in vielen Fällen bietet PostgreSQL mehr Flexibilität bei komplexen Anfragen und Datenmodellen. NoSQL-Datenbanken wie MongoDB sind vorallem dann sinnvoll, wenn Daten unstrukturiert oder sehr flexibel aufgebaut sind. Da die Daten im Falle von ExcuseMe jedoch klar definiert und eng miteinander verknüpft sind, wäre eine NoSQL-Datenbank hier eher ungeeignet. Genauere Details zum Datenbank-Schema sind im @Datenbank-Schema zu finden. 
@django_databases, @postgresql_docs, @ionos_postgresql_vs_mysql, @aws_mongodb_vs_postgresql


=== JSON Web Token
//Warum JWT?
@JWT ist ein Standard zur sicheren Übetragung von Informationen zwischen Client und Server und wird in Webanwendungen zur Authentifizierung eingesetzt. Nach dem Login erhält der Client einen *Token*, der bei weiteren Anfragen mitgesendet wird, wodurch sich User nicht bei jedem Request erneut anmelden müssen. Das macht die Kommunikation zwischen Frontend und Backend effizienter.\
Für das Projekt war @JWT besonders sinnvoll, da eine getrennte Architektur aus Flutter-Frontend und Django-Backend verwendet wird. Dabei wird der Token vom Client gespeichert und bei geschützten Anfragen verwendet werden, wodurch sich der Login einfach verwalten lässt.\
Alternativ wäre auch Authentifizierung per Web-Cookie möglich gewesen, bei der der Server die Sitzung verwaltet. Diese Lösung ist auch weit verbreitet, jedoch passt diese nicht gut zu klar getrennten API-Architekturen.
@auth0_jwt_intro, @jwtapp_jwt_vs_sessions

#figure(
  image("../resources/jwt_stucture.png"),
  caption: [JWT-Struktur]
  // author = {Fabian Trummer},
  // date = {29.05.2026}
)

#figure(
  image("../resources/jwt_workflow.png"),
  caption: [JWT-Workflow]
  // author = {Fabian Trummer},
  // date = {29.05.2026}
)

=== Railway (Cloud Service) <Railway_Kapitel>
//Warum Railway?
Railway ist eine @PaaS Cloud-Plattform, die es Entwicklern ermöglicht, Web-Anwendungen, Server, Datenbanken und Background Services durch automatisierte Deployment-Workflows ohne Server-Management bereitzustellen.\
In der Arbeit wird Railway für die automatisierte CI/CD-Pipeline einer WebApp eingesetzt. Durch die Integration mit GitHub, wird ein Workflow realisiert, der das deployte System bei jedem Push auf den main-Branch automatisch aktualisiert, neu kompiliert und baut. Dadurch erhält man Continous Deployment das heißt, dass jede Code-Änderung, die Tests besteht, direkt in Produktion geht, wodurch man ein nahtloses Updaten der API erhält.\
Alternativ zu Railway gibt es auch @PaaS Anbieter wie Render oder Fly.io, wobei Railway durch Usage-based Billing und einer breiteren Datenbank Unterstützung (PostgreSQL, MySQL, MongoDB, Redis) überzeugt. VPS-Lösungen wie Hetzner oder Self-Hosting kamen aufgrund des fehlenden automatisierten CI/CD und des höheren Wartungsaufwandes nicht in Betracht.
@railway_features @railway_PaaS_comparison

=== Digitale Signatur
Die Absicherung der Entschuldigungen erfolgt durch eine digitale Signaturlösung, die sich an der @QES orientiert. Für jeden Elternteil beim ersten Signiervorgang automatisch ein asymmetrisches Schlüsselpaar erzeugt. Dabei wird der private Schlüssel verschlüsselt in der Datenbank gespeichert. Mit dem privaten Schlüssel wird die Entschuldigung signiert und zusammen mit den Nutzerdaten übertragen, sodass anschließend mithilfe des zugehörigen öffentlichen Schlüssels verifiziert werden kann, ob die Daten unverändert sind und tatsächlich vom jeweiligen Benutzer stammen. Eine Zertifizierung durch einen offiziellen Anbieter gibt es dabei nicht, da die Lösung ausschließlich für den internen Gebrauch vorgesehen ist.

== Skalierbarkeit 
// Programmier-Paradigmen wie @OOP bzw. Sprachen, die @OOP ermöglichen, wie Python, Dart, ...
// Technologien wie Redis, Traefik(?), 

=== Datenbank
PostgreSQL ist skalierbar durch `Read Replicas` zur Lastverteilung bei leseintensiven Workloads und `Load Balancing`. Für große Datenmengen steht `Partitionierung` zur Verfügung, bei der große Tabellen in kleinere Partitionen unterteilt werden, was die Abfrage-Performance verbessert. Zusätzlich ermöglicht `Vertical Scaling` (Erweiterung von RAM, CPU, Storage) die Anpassung an wachsende Anforderungen.
@postgresql_availability, @postgresql_partitioning

=== Backend
@DRF skaliert durch `Horizontal Scaling`, bei dem mehrere Instanzen der Anwendung hinter einem sogenannten `Load Balancer` betrieben werden. Jeder Request wird auf eine der verfügbaren Instanzen verteilt, wodurch die Last auf mehrere Server aufgeteilt wird.
\
Zur Skalierung wird `Caching` mit Redis eingesetzt, um häufig abgerufene Daten (z.B. API-Antworten) im Memory zu speichern und somit die Datenbanklast zu reduzieren. Damit Sessions beim `Horizontal Scaling` erhalten bleiben, werden auch diese im Redis gespeichert. 
\
`Asynchrone Tasks` werden mit Celery und Redis als Message Broker verarbeitet. Dadurch werden langsame Tasks wie E-Mails oder Benachrichtigungen aus dem Request-Response-Zyklus ausgelagert. 
@drf_doc

=== Frontend
Flutter skaliert automatisch mit steigenden Nutzerzahlen, da es eine client-seitige Anwendung ist. Jede Instanz der App läuft lokal auf dem Gerät des Nutzers, wodurch für mehr Nutzer keine zusätzlichen Server-Ressourcen benötigt werden. 
\
Die Trennung von UI und Business-Logik ermöglicht die Wiederverwendung von Code und erleichtert die Erweiterung der App.
Durch die compilierte Native Performance (AOT-Compilation) bleibt die Performance auch bei größeren Apps konstant hochwertig. Dazu ermöglicht Flutter eine Cross-Platform-Entwicklung (iOS, Android, Web und Desktop) mit einer einzigen Codebase, was die Skalierung auf weitern Plattformen vereinfacht.
@flutter_app_guide

== Rollenverteilung und Zusammenarbeit //F
//Teamreflexion

=== Aufteilung
  #figure(
    table(
      columns: (auto, auto),
      inset: 10pt,
      align: center,
      table.header([*Jan Schubert*], [*Fabian Trummer*]),
      [Projektinitialisierung], [Management],
      [Frontend implementierung], [Backend implementierung],
      [Testentwicklung], [Security],
      [Statistik], [Digitale Signatur],
    ),
    caption: [Aufteilung der Themen]
)

=== Kommunikation
Die Kommunikation läuft hauptsächlich über tägliche bis wöchentliche Gespräche, in denen folgende Themen behandelt werden: aktuelle Features, derzeit auftretende Probleme, Schwierigkeiten sowie Zeitbedarf und die geplante Dauer für Features. 
\
Kommunikationsbasis ist die Plattform Discord. Dort werden wichtige Details, Links, Vorgehensweisen, Fragen an den Betreuer sowie Arbeitszeiten geteilt, diskutiert und dokumentiert. Zudem wurde auch eine Pipeline zwischen GitHub und Discord eingerichtet, die uns über jeden push auf GitHub informiert. 
\
Darüber hinaus findet alle zwei Wochen eine Besprechung mit dem Betreuungslehrer statt. Dort wird der aktuelle Stand besprochen und die weiteren Features und Issues für den folgenden Sprint festgelegt.

#figure(
  image("../resources/kommunikation.png", width: 50%),
  caption: [Kommunikation Discord]
  // author = {Fabian Trummer},
  // date = {30.05.2026}
)

