#import "@preview/glossy:0.9.0"
#import "@preview/aero-dhbw:0.1.1": pa-figure

= Theoretische Fundierung und Literaturüberblick


== Grundlagen der modernen Softwareentwicklung

=== Definition und Bedeutung des Client-Server-Architekturprinzips

=== Überblick über geeignete Entwicklungsmodelle
Scrum, Kanban, etc.



== Theoretische Basis des Backend-Stacks //F

=== Das ORM (Object-Relational Mapping)
Das ORM im Hintergrund nennt sich Django, das es ermöglicht Datenbankenzugriffe über Python-Modelle umzusetzen, statt direkt SQL-Abfragen schreiben zu müssen. Dabei beschreibt ein Django-Modell die Struktur der gespeicherten Daten und entspricht in der Regel einer Datenbanktabelle. Auf dieser Grundlage stellt Django automatisch eine Datenbank-API bereit, mit der Objekte  erstellt, abgerufen, verändert und gelöscht werden können. Dadurch bleibt der Code übersichtlicher und stark Python orientiert, während viele Datenbankzugriffe über das Framework laufen. 
@django_models,  @django_queries 

=== Prinzipien von RESTful Services
//Rest definieren
Representational State Transfer (REST) ist ein Konzept für Softwarearchitektur verteilter Systeme, insbesondere Webservices. 
//Erklären was RESTful Services sind
Ein Service wird als RESTful bezeichnet, wenn er die sechs von Roy T. Fielding definierten Architektureinschränkungen einhält. Dazu zählt erstens die *Client-Server-Trennung*, bei der Client und Server unabhängig voneinander entwickelt werden. Zweitens die *Zustandslosigkeit*, bei der jede Anfrage alle notwendigen Informationen enthält und kein Sitzungszustand vom Server gespeichert wird. Drittens die *Cachebarkeit*, welche festlegt, ob Antworten als cachebar oder nicht cachebar gekennzeichnet werden. Viertens die *einheitliche Schnittstelle*, durch die Ressourcen über Uniform Resource Identifiers (URIs) identifiziert und mittels HTTP-Methoden wie GET, POST, PUT oder DELETE angesprochen werden. Fünftens das *Schichtensystem*, bei dem der Client nicht wissen muss, ob er direkt mit dem Server oder einem anderen Zwischenglied kommuniziert. Sechstens *Code on Demand*. Diese Erweiterung gilt als optional und erlaubt dem Server ausführbaren Code an den Client zu übertragen.
@restful_services

#pagebreak()

=== Rolle des Django REST Framework (DRF)
Automatisierung von APIs, browsable API, etc.

=== Datenschutz durch Backend-Security

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
