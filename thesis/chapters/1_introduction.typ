#import "@preview/glossy:0.9.0"
#import "@preview/aero-dhbw:0.1.1": pa-figure



= Einleitung
== Problemdefinition und Relevanz //J&F

=== Darstellung des Problems
Ist man Schüler oder hat bereits selbst Kinder, kennt man die Umstände, welche Entschuldigungen mit sich bringen. Ob vergessene Fristen, fehlerhafte Formulierungen oder zerknitterte, zerrissene oder verlorene Zettel. Das Erstellen einer korrekten Schulentschuldigung ist oft umständlicher als nötig. Zudem bleibt aus Sicht der Eltern häufig unklar, ob die geschriebene Entschuldigung überhaupt beim Lehrer angekommen ist. ExcuseMe setzt genau hier an und automatisiert diesen Prozess, sodass eine regelkonforme Entschuldigung mit wenigen Klicks erstellt und direkt an den jeweiligen Lehrer gesendet werden kann.

=== Warum ist dieses Problem relevant?
Viele Schulen nutzen für Fehlzeiten noch handschriftliche Entschuldigungen, wodurch nahezu jede Familie mit schulpflichtigen Kindern davon betroffen ist. Das Verfassen der Entschuldigungen ist dabei oft umständlich, unübersichtlich und zeitaufwendig. Eine digitale Lösung könnte den Prozess vereinfachen und einen Mehrwert schaffen. Beispielsweise durch
die Erstellung einer Statistik, welche zeigt, zu welchen Zeiten oder Tagen 
im Durchschnitt besonders viele Schüler fehlen. Zudem stellt es einen weiteren Schritt in Richtung Digitalisierung im Bildungswesen dar.
=== Grenzen bestehender Lösungen: Was funktioniert momentan nicht gut?


#pagebreak()
== Zielsetzung der Arbeit //J&F
Ziel unserer Arbeit ist, dass Schüler ihre Entschuldigungen bei Krankheit oder anderen Gründen einfach online hochladen. Diese Entschuldigungen werden von den Eltern/Erziehungsberechtigten digital unterschrieben und automatisch an den zuständigen Lehrer oder Klassenvorstand gesendet. So bekommt die Schule die Infos sicher und ohne Umwege. Alle Beteiligten haben dadurch immer den aktuellen Stand. 

=== Was soll das finale System erreichen?
Ein Schüler soll per App oder Website Entschuldigungen hochladen können. Dazu wird jeweils eine Bestätigung zugestellt, sobald diese von den Eltern/Erziehungsberechtigten signiert wurde und beim Lehrer ankommt. Lehrer bekommen automatisch Bescheid und müssen nichts mehr händisch eintragen. Alles ist gespeichert, transparent und jederzeit nachvollziehbar. So ist jederzeit ersichtlich welche Fehlstunden noch unentschuldigt sind und keiner muss sich sorgen ob die Entschuldigungen ankommen.

=== Spezifische, messbare Teilziele
- Entwicklung eines Backends mit API Schnittstelle
- Direkte, sichere Weiterleitung an Lehrkräfte oder Klassenvorstand
- Jederzeitiger Überblick über den Status der Entschuldigungen
- Benutzerfreundliche App, die das Hochladen und Signieren in wenigen Schritten ermöglicht
- Digitale Signatur der Eltern
- Automatische Erstellung von Statistiken über Fehlzeiten (z.B. durchschnittliche Fehlrate an bestimmten Tagen oder Zeiten)

== Aufbau der Arbeit //J&F

Die Arbeit Gliedert sich in folgende Themen. Zunächst werden in Kapitel 2 die theoretischen Grundlagen mit Überblick über relevante Literatur zu Client-Server-Architektur, Backend- und  Frontend-Technologien sowie Teamstrukturen. Im Anschluss beschreibt Kapitel 3 beschreibt das Systemdesign, die  eingesetzten Technologien und die Rollenverteilung im Entwicklungsteam. Kapitel 4 dokumentiert die Implementierung und präsentiert die erzielten Ergebnisse. Abschließend diskutiert Kapitel 5 die Resultate, benennt Limitationen und gibt einen Ausblick auf mögliche Weiterentwicklungen.
