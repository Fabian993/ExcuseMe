#import "footer.typ": set_footer_name
#import "@preview/abbr:0.3.0"
#show: abbr.show-rule
#abbr.load("../abbreviations.csv", delimiter: ",")

= Diskussion, Limitationen und Ausblick

#set_footer_name("Fabian Trummer & Jan Schubert")
== Diskussion der Ergebnisse <Diskussion-der-Ergebnisse>
// Erfolgskontrolle. Änderungen / Abweichungen, warum

Von den mittlerweile sechs erstellten Sprints verbleiben aktuell noch ein Sprint, sowie ein Backlog in dem @HMI Features gespeichert wurden. 

== Limitationen // J
// Zeitliche, technische oder ressourcenbedingte Einschränkungen

Bereits vorhandene Erfahrung mit dem @DRF war der ausschlaggebende Grund, es als Backend Framework zu verwenden. Retrospektiv wäre für das Backend ein Web-Framework wie NestJS, das direkt auf @JS basiert, womöglich eine passendere Wahl gewesen. 

Zeitliche Einschränkungen kamen hauptsächlich von schulischer Seite aus und haben die Planung und Entwicklung des Projekts wiederholt verlangsamt und eingeschränkt. SCRUM als Entwicklungsmodell zu verwenden war hier entscheidend, da so die nötige zeitliche Flexibilität durch die zweiwöchigen Sprints gegeben war.

Während der ursprünglichen Recherchen kamen die Themen Authentifizierung und digitale Signatur der Nutzer öfters auf. Da an den meisten funktionierenden Lösungen auf dem Markt ein Preisschild hängt. dass @OAuth:s nicht in Frage käme, wurde auf Absprache mit dem Betreuer der Arbeit festgelegt. Daher fiel die Wahl auf eine eigene Authentifizierungs- und Signatur-Lösung mittels @DRF. Mehr hierzu findet sich im @DRF_Kapitel. \
Dass die Authentifizierung mittels @LDAP der Schule vergleichsweise einfach gewesen wäre, kam erst zu einem späteren Zeitpunkt nach der Implementierung auf. Die Verwendung dieser Technologie hätte viel Zeit in der Planung und Implementierung des Projekts einsparen können.

Aufgrund verschiedener Faktoren, darunter Datenschutz, Leistung, Qualität und Finanzierung, fiel die Wahl des Deployments auf Railway. Genaueres hierzu findet sich in @Railway_Kapitel.

== Ausblick
// nächste Schritte. Vorschläge für Erweiterungen. Grenzen bestehender Lösungen: Was funktioniert momentan nicht gut?
FRONTEND
  - Entschuldigung hochladen
  - Eigene Entschuldigungen sehen (statt alle)
  - Eltern signieren Entschuldigung
  - Einsehbarer Status der Entschuldigungen
  - Lehrer sehen Statistik
  - Lehrer bestätigen Entschuldigung
  - Anbindung an ELDA App für Auth / Credentials

  