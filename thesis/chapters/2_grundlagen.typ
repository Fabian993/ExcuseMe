
= Theoretische Fundierung und Literaturüberblick


== Grundlagen der modernen Softwareentwicklung

=== Definition und Bedeutung des Client-Server-Architekturprinzips
Häufig wird bei der Entwicklung von Software die Client-Server-Architektur angewandt. 
Diese unterteilt, wie der Name schon sagt, die beiden Kommunikationspartner in Client und Server. Der Server dabei stellt die zentrale Logik der Anwendung dar und wertet dabei die Anfragen des Clients aus. Dafür einigen sich beide auf ein bestimmtes Protokoll, das definiert, *wie* die Kommunikation stattfindet.
@csa

=== Überblick über geeignete Entwicklungsmodelle
Scrum, Kanban, etc.



== Theoretische Basis des Backend-Stacks //F

=== Das ORM (Object-Relational Mapping)
Das ORM im Hintergrund nennt sich Django, das es ermöglicht Datenbankzugriffe über Python-Modelle umzusetzen, statt direkt SQL-Abfragen schreiben zu müssen. Dabei beschreibt ein Django-Modell die Struktur der gespeicherten Daten und entspricht in der Regel einer Datenbanktabelle. Auf dieser Grundlage stellt Django automatisch eine Datenbank-API bereit, mit der Objekte  erstellt, abgerufen, verändert und gelöscht werden können. Dadurch bleibt der Code übersichtlicher und stark Python orientiert, während viele Datenbankzugriffe über das Framework laufen. 
@django_models,  @django_queries 

=== Prinzipien von RESTful Services
//Rest definieren
Representational State Transfer (REST) ist ein Konzept für Softwarearchitektur verteilter Systeme, insbesondere Webservices. 
//Erklären was RESTful Services sind
Ein Service wird als RESTful bezeichnet, wenn er die sechs von Roy T. Fielding definierten Architektureinschränkungen einhält. Dazu zählt erstens, die *Client-Server-Trennung*, bei der Client und Server unabhängig voneinander entwickelt werden. Zweitens, die *Zustandslosigkeit*, bei der jede Anfrage alle notwendigen Informationen enthält und kein Sitzungszustand vom Server gespeichert wird. Drittens, die *Cachebarkeit*, welche festlegt, ob Antworten als cachebar oder nicht cachebar gekennzeichnet werden. Viertens, die *einheitliche Schnittstelle*, durch die Ressourcen über Uniform Resource Identifiers (URIs) identifiziert und mittels HTTP-Methoden wie GET, POST, PUT oder DELETE angesprochen werden. Fünftens, das *Schichtensystem*, bei dem der Client nicht wissen muss, ob er direkt mit dem Server oder einem anderen Zwischenglied kommuniziert. Sechstens, *Code on Demand*. Diese Erweiterung gilt als optional und erlaubt dem Server ausführbaren Code an den Client zu übertragen.
@restful_services

#pagebreak()

=== Rolle des Django REST Framework (DRF)
//Automatisierung von APIs, browsable API, etc.
Django REST Framework (DRF) ist ein auf Django aufbauendes Toolkit zur Entwicklung von RESTful APIs (Application  Programming Interfaces). Es vereinfacht die Entwicklung einer API durch mehrere Kernfunktionen. *Serializer* konvertieren komplexe Django-Modellobjekte automatisch in JSON oder XML und umgekehrt. *ViewSets* und *Routers* automatisieren die URL-Konfiguration, sodass ein Entwickler nicht für jeden Endpunkt manuell ein URL-Muster definieren muss. Die integrierte *Browsable API* ermöglicht es, API-Endpunkte direkt im Browser zu erkunden und testen, ohne den Gebrauch von externen Tools. Darüber hinaus bietet DRF ein bereits integriertes, flexibles Authentifizierungs- und Berechtigungssystem. Es unterstützt verschiedene Authentifizierungsmethoden wie Token- oder Session-basiert.
@drf

=== Datenschutz durch Backend-Security
Ein Ansatz zum Datenschutz besteht in der gezielten Absicherung des Backends einer Webanwendung. Das Open Web Application Security Project (OWASP) zeigt in seinen 2025 aktualisierten Top 10 die kritischsten Sicherheitsrisiken für Webanwendungen. Zu den relevanten Risiken zählen insbesondere unzureichende oder fehlende Verschlüsselung sensibler Daten wie Passwörter oder personenbezogene Informationen. Ein weiteres Risiko besteht darin, dass Nutzer auf Ressourcen zugreifen können, für die ihnen keine Berechtigung erteilt wurde. Die Umsetzung der von OWASP empfohlenen Maßnahmen auf Backend-Ebene stellt daher nicht nur eine Best Practice dar, sondern ist auch im Sinne der Datenschutz-Grundverordnung (DSGVO).
@owasp

== Theoretische Basis des Frontend-Stacks //J

=== Vorteile von Cross-Platform-Frameworks

=== Dart-Sprache und Widget-basierte UI-Architektur

=== State Management Muster
Theoretischer Hintergrund zur Datenverwaltung in mobilen Anwendungen.

=== Responsive Design
Skeleton



== Kollaboration und Teamstruktur 

=== Theoretische Modelle des Teamworks
Aufteilung von Verantwortlichkeiten und Schnittstellenmanagement.

=== Auswahl des Team-Workflows
Begründung von gewählten Methoden -> Sprints, Issues, Meilensteine, ...
