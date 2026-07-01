#import "footer.typ": set_footer_name
#import "@preview/abbr:0.3.0"
#show: abbr.show-rule
#abbr.load("../abbreviations.csv", delimiter: ",")

= Diskussion, Limitationen und Ausblick

#set_footer_name("Fabian Trummer & Jan Schubert")
== Diskussion der Ergebnisse <Diskussion-der-Ergebnisse>
// Erfolgskontrolle. Änderungen / Abweichungen, warum

Von den mittlerweile sechs erstellten Sprints verbleiben aktuell noch ein Sprint, sowie ein Backlog in dem @HMI Features gespeichert wurden.

Ein Großteil aller geplanten Features wurde vollständig umgesetzt. Hierzu gehören das vollständige Backend, also das @DRF samt Browsable @API, Security und Datenmodell, sowie die CI/CD Pipeline, welche für automatische Tests und Deployment des Projekts zuständig ist.

Zum aktuellen Zeitpunkt enthält das Projekt Unit Tests zur Überprüfung der korrekten Funktionsweise der Datenbankmodelle. Integrationstests für die API sowie das Flutter-Frontend wurden aufgrund des begrenzten Zeitrahmens der Diplomarbeit nicht realisiert. Die Erweiterung um Integrations-Tests bleibt dabei eine mögliche Weiterentwicklung für die Zukunft.

== Limitationen // J
// Zeitliche, technische oder ressourcenbedingte Einschränkungen

Bereits vorhandene Erfahrung mit dem @DRF war der ausschlaggebende Grund, es als Backend Framework zu verwenden. Retrospektiv wäre für das Backend ein Web-Framework wie NestJS, das direkt auf @JS basiert, womöglich eine passendere Wahl gewesen. 

Zeitliche Einschränkungen kamen hauptsächlich von schulischer Seite aus und haben die Planung und Entwicklung des Projekts wiederholt verlangsamt und eingeschränkt. SCRUM als Entwicklungsmodell zu verwenden war hier entscheidend, da so die nötige zeitliche Flexibilität durch die zweiwöchigen Sprints gegeben war.

Während der ursprünglichen Recherchen kamen die Themen Authentifizierung und digitale Signatur der Nutzer öfters auf, da an den meisten funktionierenden Lösungen auf dem Markt ein Preisschild hängt. Dass @OAuth:s nicht in Frage käme, wurde auf Absprache mit dem Betreuer der Arbeit festgelegt. Daher fiel die Wahl auf eine eigene Authentifizierungs- und Signatur-Lösung mittels @DRF. Mehr hierzu findet sich im @DRF_Kapitel. \
Dass die Authentifizierung mittels @LDAP der Schule vergleichsweise einfach gewesen wäre, kam erst zu einem späteren Zeitpunkt nach der Implementierung auf. Die Verwendung dieser Technologie hätte viel Zeit in der Planung und Implementierung des Projekts einsparen können.

Aufgrund verschiedener Faktoren, darunter Datenschutz, Leistung, Qualität und Finanzierung, fiel die Wahl des Deployments auf Railway. Genaueres hierzu findet sich in @Railway_Kapitel.

== Ausblick // J
// nächste Schritte. Vorschläge für Erweiterungen. Grenzen bestehender Lösungen: Was funktioniert momentan nicht gut?

Die nachstehende Tabelle zeigt die ursprünglich geplanten, aber aktuell noch fehlenden Features der Software. Wie man sieht, befinden sich die meisten Lücken im Frontend, da dies der letzte Abschnitt der Arbeit war und hier die meiste Zeit in ein sauberes, plattformübergreifendes Design, sowie verschiedene schulische Aktivitäten, floss.

#figure(
  table(
    columns: (40%, 60%),
    inset: 10pt,
    align: center,
    table.header([*Backend*], [*Frontend*]),
    [], [Eltern signieren Entschuldigung],
    [], [Lehrer sehen Statistik],
    [], [Lehrer bestätigen Entschuldigungen],
    table.cell(colspan: 2)[LDAP Anbindung],
  ),
  caption: [Verbleibende Features]
  // author: Fabian Trummer
)


In zukünftigen Expansionen liegt der Fokus auf der Entwicklung dieser Features. Primär soll somit die Frontend App funktional erweitert werden. Auch die Nutzererfahrung soll verbessert werden, indem mit Filter-Optionen in Form von Buttons die Anzeige von Fehlstunden und Entschuldigungen kontrollieren.