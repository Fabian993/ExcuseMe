#import "footer.typ": set_footer_name
#import "@preview/abbr:0.3.0"
#show: abbr.show-rule
#abbr.load("../abbreviations.csv", delimiter: ",")

= Theoretische Fundierung und Literaturüberblick

#set_footer_name("Jan Schubert")
== Grundlagen der modernen Softwareentwicklung // J

=== Definition und Bedeutung des Client-Server-Architekturprinzips <Client-Server-Architekturprinzip>

#figure(
  image("../resources/client-server-architecture.png"),
  caption: [Client-Server-Architekturprinzip],
  // author = {Jan Schubert},
  // date = {12.05.2026},
)

Häufig wird bei der Entwicklung von Software die Client-Server-Architektur angewandt.
Diese unterteilt - wie der Name schon sagt - zwei miteinander kommunizierende Systeme in Client und Server. Der Server dabei stellt die zentrale Logik der Anwendung dar und wertet dabei die Anfragen des Clients aus. Dafür einigen sich beide auf ein bestimmtes Protokoll, das definiert, wie die Kommunikation stattfindet.
@client_server

Hierzu gehören beispielsweise das @HTTP für Web oder @DNS für die Namensauflösung von einem @URL. Beide spielen eine fundamentale Rolle in der Welt des Internets und sind internationale Standards.

=== Model-View-Controller <Model-View-Controller>
#figure(
  image("../resources/mvc.png"),
  caption: [Model-View-Controller],
  // author = {Jan Schubert},
  // date = {19.05.2026},
)

Die Abbildung stellt das @MVC:l Design Pattern dar. Dieses Architekturprinzip trennt Datenhaltung (Model), Nutzeroberfläche (View) und Steuerlogik (Controller) voneinander, um eine bessere Arbeitsteilung im Team zu erzielen und die Wartbarkeit des Gesamtsystems zu verbessern.
@mvc_pattern

Views sind für die Darstellung der Daten zuständig. Sie bilden den sichtbaren Teil der Anwendung und gehören damit zum Frontend.
@mvc_pattern

Controller nehmen Eingaben entgegen, verarbeiten sie und steuern den Ablauf der Anwendung. In einer REST-API können sie Anfragen annehmen und passende @CRUD:s Operationen auf Ressourcen auslösen.
@mvc_pattern

Models verwalten die eigentlichen Daten und die zugehörige Logik. Zusammen mit dem Controller bilden sie meist den Backend-Teil serverseitiger Anwendungen.
@mvc_pattern

=== Überblick über geeignete Entwicklungsmodelle
Die Entwicklung von Software startet üblicherweise mit der Planung.
Dabei gibt es verschiedene Vorgehensweisen, um sein Ziele zu erreichen. Viele von diesen Entwicklungsmodellen kommen dabei aus der Projektplanung. Ihre Aufgabe ist es, die verschiedenen Tätigkeiten der Entwickelnden im Lebenszyklus der Software zu strukturieren. Die Modelle werden in mehrere Gruppen unterteilt: Von formell bis informell, was von geschäftlichen Bezug zum Kunden abhängt, sowie linear bis iterativ, was wiederum von der konkreten Vorgehensweise des Modells selbst abhängt. 
@modelle_swe

Während der ursprünglichen Planung dieser Arbeit, kamen das lineare Wasserfallmodell, aber auch flexiblere Modelle wie Scrum oder @XP:s in Frage.

Das Wasserfallmodell ordnet die Tätigkeiten in Analyse, Design, Programmierung, Test, Installation, Instandhaltung. Die einzelnen Schritte werden hierbei genau mitgeschrieben und festgehalten. Der große Nachteil dabei jedoch ist, dass jede Stufe vom Abschluss der vorherigen abhängt. Fehler wirken sich also auf die jeweils nächste Phase aus. Auch die Anforderungen sollten bereits beim ersten Schritt, der Analyse, möglichst genau bekannt sein, weil nur so ein genauer, schrittweiser Plan erstellt werden kann.
@modelle_swe

Scrum hingegen ist da als Agile Entwicklungsmethode fundamental anders: \
Alle zwei bis vier Wochen findet ein Sprint-Meeting statt, in dem Aufträge, die bis zum nächsten Meeting umgesetzt werden sollten, geplant werden. Dazu kommt noch die Sprint-Retrospektive, wo der neue Fortschritt kontrolliert und gegebenenfalls eine Korrektur aufgetragen wird. Kommt es zur Änderung der Anforderungen, können diese bereits in der nächsten Planung berücksichtigt werden, weshalb man hier von "Agiler Entwicklung" spricht.
@modelle_swe

Recht ähnlich ist hier auch @XP:l, welches die Dauer der Iterationen auf meist ein bis zwei Wochen reduziert, da hier Kundenzufriedenheit und daher auch Flexibilität oberste Priorität haben. @XP setzt hier gezielt auf Taktiken der Software Entwicklung wie beispielsweise kleinere, regelmäßigere Veröffentlichung, Pair-Programming, also das abwechselnde arbeiten zu zweit an einem End-Gerät oder automatisierte Tests, welche bei Änderungen die Funktionalität der Software überprüfen.
@modelle_swe

In einer frühen Besprechung mit unserem Betreuungslehrer wurde letztendlich festgelegt, dass bis zum Abschluss der Arbeit, alle zwei Wochen ein Meeting zur Besprechung des Fortschritts stattfindet. Da sich die gegebenen Anforderungen und eingeplanten Zeiten leicht verändern können, beispielsweise durch neue, gewünschte Funktionalität oder andere schulische Aktivitäten, fiel die Wahl auf das flexible "Scrum" Modell. Da hier jedoch einzelne Aspekte wie automatische Test oder kontinuierliche Integration aus dem @XP fehlten, wurde der Beschluss gefasst, diese dennoch in unserer Planung zu berücksichtigen.

// #pagebreak() 
#set_footer_name("Fabian Trummer")
== Theoretische Basis des Backend-Stacks //F

=== Object-Relational Mapping
Das @ORM im Hintergrund nennt sich Django, das es ermöglicht Datenbankzugriffe über Python-Modelle umzusetzen, statt direkt SQL-Abfragen schreiben zu müssen. Dabei beschreibt ein Django-Modell die Struktur der gespeicherten Daten und entspricht in der Regel einer Datenbanktabelle. Auf dieser Grundlage stellt Django automatisch eine Datenbank-@API:s bereit, mit der Objekte  erstellt, abgerufen, verändert und gelöscht werden können. Dadurch bleibt der Code übersichtlicher und stark Python orientiert, während viele Datenbankzugriffe über das Framework laufen.
@django_models,  @django_queries 

=== Prinzipien von RESTful Services

@REST ist ein Konzept für Softwarearchitektur verteilter Systeme, insbesondere Webservices. 

Ein Service wird als RESTful bezeichnet, wenn er die sechs von Roy T. Fielding definierten Architektureinschränkungen einhält. Dazu zählt erstens, die *Client-Server-Trennung*, bei der Client und Server unabhängig voneinander entwickelt werden. Zweitens, die *Zustandslosigkeit*, bei der jede Anfrage alle notwendigen Informationen enthält und kein Sitzungszustand vom Server gespeichert wird. Drittens, die *Cachebarkeit*, welche festlegt, ob Antworten als cachebar oder nicht cachebar gekennzeichnet werden. Viertens, die *einheitliche Schnittstelle*, durch die Ressourcen über @URI identifiziert und mittels HTTP-Methoden wie GET, POST, PUT oder DELETE angesprochen werden. Fünftens, das *Schichtensystem*, bei dem der Client nicht wissen muss, ob er direkt mit dem Server oder einem anderen Zwischenglied kommuniziert. Sechstens, *Code on Demand*. Diese Erweiterung gilt als optional und erlaubt dem Server ausführbaren Code an den Client zu übertragen.
@restful_services

=== Rolle des Django REST Framework
//Automatisierung von APIs, browsable API, etc.
@DRF ist ein auf Django aufbauendes Toolkit zur Entwicklung von RESTful @API:pla. Es vereinfacht die Entwicklung einer @API durch mehrere Kernfunktionen. *Serializer* konvertieren komplexe Django-Modellobjekte automatisch in @JSON oder @XML und umgekehrt. *ViewSets* und *Routers* automatisieren die URL-Konfiguration, sodass ein Entwickler nicht für jeden Endpunkt manuell ein URL-Muster definieren muss. Die integrierte *Browsable API* ermöglicht es, API-Endpunkte direkt im Browser zu erkunden und testen, ohne den Gebrauch von externen Tools. Darüber hinaus bietet @DRF ein bereits integriertes, flexibles Authentifizierungs- und Berechtigungssystem. Es unterstützt verschiedene Authentifizierungsmethoden wie Token- oder Session-basiert.
@drf_doc

=== Datenschutz durch Backend-Security
Ein Ansatz zum Datenschutz besteht in der gezielten Absicherung des Backends einer Webanwendung. Das @OWASP zeigt in seinen 2025 aktualisierten Top 10 die kritischsten Sicherheitsrisiken für Webanwendungen. Zu den relevanten Risiken zählen insbesondere unzureichende oder fehlende Verschlüsselung sensibler Daten wie Passwörter oder personenbezogene Informationen. Ein weiteres Risiko besteht darin, dass Nutzer auf Ressourcen zugreifen können, für die ihnen keine Berechtigung erteilt wurde. Die Umsetzung der von @OWASP empfohlenen Maßnahmen auf Backend-Ebene stellt daher nicht nur eine "Best Practice" dar, sondern ist auch im Sinne der @DSGVO.
@owasp

#pagebreak()
#set_footer_name("Jan Schubert")
== Theoretische Basis des Frontend-Stacks // J

=== Vorteile von Cross-Platform-Frameworks
Cross-Platform-Frameworks können mit einem einzigen Quellcode eine Applikation für gleich mehrere Plattformen bauen. Dabei wird der Code analysiert und direkt in Maschinencode übersetzt, der für die gewünschte Plattform geeignet ist. Eine einzige Codebase dabei hat die Vorteile, dass die Entwicklung der Software schneller voran geht und dabei der gewaltige Aufwand, mehrere Codebases warten zu müssen, eingespart wird. Dies wiederum reduziert die erforderte Zeit und somit verbundene Kosten.
@kotlin_native_vs_cross-platform

Die beliebtesten und performantesten Frameworks, mit den größten Ökosystemen und Communitys sind seit einigen Jahren Flutter und React Native. Jedoch gibt es viele beliebte Alternativen wie Ionic, Kotlin Multiplatform, Uno Platform und viele mehr. Alle weisen ihre eigenen Stärken und Schwächen auf.
@native_vs_cross-platform
@popular_cross-platform-Frameworks

Welche Technologie nun die richtige Wahl ist, hängt am Ende von den gegebenen Anforderungen ab. Also wie gut die Anforderungen von der Technologie abgedeckt wird, wie viel Zeit für das Projekt zur Verfügung steht, sowie welches Wissen und Können das Team bereits besitzt. 
@kotlin_native_vs_cross-platform

=== React Native vs Flutter <React-Native-Vs-Flutter>
React Native basiert auf React, einem Web-Framework, das Entwicklern ein Komponenten-Modell in @JS bzw. @TS zur Verfügung stellt. Der Fokus liegt hier bei mobilen Geräten und Web-Anwendungen.
Dabei nutzt das Framework native Elemente zur Darstellung, also sieht jede verwendete Komponente so aus, wie sie auf der jeweiligen Plattform natürlich aussehen sollte. Zusätzlich profitieren Entwickler von dem  riesigen React- bzw. @JS:lo Ökosystem, was die Integration von weiterer Software ermöglicht.
@native_vs_cross-platform
@react_native_components

Flutter geht hier einen anderen Weg. Statt auf die Darstellung nativer Elemente, setzt Flutter auf die eigene Rendering-Engine "Impeller", was mehr Kontrolle über das Aussehen und Verhalten der App auf jeder Plattform erzielt. Das bedeutet auch, dass die App auf jeder Plattform identisch aussehen kann, was ein konsistentes, Plattform unabhängiges Design ermöglicht. Außerdem bietet Impeller eine starke Performance, die nativen Applikationen meist sehr nahe kommt.
@native_vs_cross-platform 
@impeller

=== Widget-basierte UI-Architektur // J
"In Flutter, almost everything is a _widget_." - Flutter Docs @flutter_widget

Egal ob Knopf, Text, Ausrichtung oder Eingabe; fast alles in Flutter ist ein Widget. Mit diesen Komponenten lassen sich das Aussehen und Verhalten der Benutzeroberfläche der Anwendung anpassen. Die hierarchische Anordnung der einzelnen Widgets formt den sogenannten "Widget Tree". \
Damit ein Button zum Beispiel angezeigt werden kann, könnte er sich in einem Center-Widget befinden, um zentriert zu sein, welches wiederum in einem Scaffold ist, das die Layout-Struktur schafft, das wiederum von einem Stateless oder Stateful Widget gebaut wird. 
@flutter_widget 

=== State Management <State-Management>
In Flutter gibt es zwei fundamentale Arten von Widgets: "Stateless Widgets" und "Stateful Widgets". Wie der Name schon sagt, speichern Stateful Widgets ihren aktuellen State. Änderungen des States führen dazu, dass alle betroffenen Widgets im Widget Tree neu gezeichnet bzw. aktualisiert werden. Drückt der Nutzer also beispielsweise auf den "anmelden" Knopf auf einer Login Seite, könnte sich der State der Seite von "idle" zu "loading" ändern. Diese Änderung würde das Widget neu zeichnen und könnte anhand des States stattdessen mit einem animierten Symbol den Lade-Zustand anzeigen.
@flutter_widget @flutter_state

=== Responsive Design <Responsive-Design>
Responsive Design beschreibt den Designansatz, die Software mit allen möglichen Bildschirmgrößen und Auflösungen kompatibel zu machen und Konsistenz zu schaffen. Dabei wird auch während der Laufzeit auf Änderungen dieser Eigenschaften geachtet. Die Navigationsleiste einer Desktopanwendung befindet sich durch das Querformat in der Regel am linken oder rechten äußeren Rand der Seite. Dieselbe App würde im Hochformat am Smartphone aber viel Platz wegnehmen, weshalb sie sich in diesem Fall besser unterhalb statt seitlich befinden sollte. Folgt man Responsive Designpatterns, würde die Anwendung die Navigationsleiste also dynamisch, je nach Bildschirmgröße, verschieben.
@responsive_design

Stateful Widgets ermöglichen das. Der State eines Widgets kann hier mit der Bildschirmgröße verknüpft und bei dessen Änderung neu dargestellt werden.
