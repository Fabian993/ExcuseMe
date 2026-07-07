#import "footer.typ": set_footer_name
#import "@preview/abbr:0.3.0"
#show: abbr.show-rule
#abbr.load("../abbreviations.csv", delimiter: ",")

= Diskussion, Limitationen und Ausblick

#set_footer_name("Fabian Trummer & Jan Schubert")
== Diskussion der Ergebnisse <Diskussion-der-Ergebnisse>
// Erfolgskontrolle. Änderungen / Abweichungen, warum
=== ExcuseMe-Workflow
In @abb:excuse_sequence ist der tatsächlich umgesetzte Workflow für das Entschuldigen einer Fehlstunde in Form eines Sequenzdiagrammes zu sehen. Die Entschuldigung wird vom Schüler erstellt, von einer beziehungsberechtigen Person signiert und ist schließlich für den Klassenvorstand einsehbar. Dieser kann nun die Entschuldigung annehmen bzw. ablehnen.

#figure(
  image("../resources/excuse_sequence.png"),
  caption: [Entschuldigung-Workflow],
  // author: Jan Schubert
)<abb:excuse_sequence>

=== APP

#table(
  columns: (auto, auto),
  //inset: 12pt,
  //align: horizon,
  
  stroke: none,
  
  [
    #figure(
      image("../resources/Student_Absences.png", width: 95%),
      caption: [Fehlstunden]
    )<abb:student_absences>
  ],
  [
    #figure(
      image("../resources/Student_Excuses.png", width: 95%),
      caption: [Entschuldigungen]
    )<abb:student_escuses>
  ],
  [
    #figure(
      image("../resources/Student_Stats.png", width: 95%),
      caption: [Statistik]
    )<abb:student_stats>
  ],
  [
    #figure(
      image("../resources/Student_Settings.png", width: 95%),
      caption: [Einstellungen]
    )<abb:student_settings>
  ],
)

Von @abb:student_absences bis @abb:student_settings ist ersichtlich, dass alle geplanten Features erfolgreich umgesetzt wurden: Ein voll funkionsfähiges Frontend, das nicht nur Abwesenheiten, sondern auch eingereichte Entschuldigungen anzeigt und mit Statistiken Übersicht schafft.  

=== Statistik
Um einen Überblick zu behalten, bietet ExcuseMe eine dedizierte Statistik-Seite. Diese visualisiert mithilfe eines Kreisdiagramms (Pie-Chart) den aktuellen Entschuldigungsstand jedes Schülers auf einen Blick, wie in @abb:student_stats zu sehen ist. Je nach Rolle des angemeldeten Users werden entweder die eigenen Daten (Schüler), die Daten der dazugehörigen Kinder (Eltern) oder eine klassenweise Übersicht (Lehrer) angezeigt.

Überschreitet ein Schüler eine Anzahl an 20 unentschuldigten Fehlstunden, werden Erziehungsberechtigte per Benachrichtigung vorgewarnt.

//Bilder

=== Rollenbasierte-UI

#table(
  columns: (auto, auto),
  stroke: none,
  [
    #figure(
      image("../resources/Parents_Excuses.png", width: 95%),
      caption: [Parent Ansicht],
    )<abb:parent_ansicht>
  ],
  [
    #figure(
      image("../resources/Teacher_Excuses.png", width: 95%),
      caption: [Teacher Ansicht],  
    )<abb:teacher_ansicht>
  ]
)

In @abb:parent_ansicht und @abb:teacher_ansicht ist erkenntlich, dass Erziehungsberechtigte und Lehrkräfte die Entschuldigungen eine wenig anders dargestellt bekommen und sie selbst keine Fehlstunden besitzen.
Erziehungsberechtige sehen dabei alle offenen und signierten Entschuldigungen ihrer Kinder. Lehrer hingegen sehen die Entschuldigungen aller Schüler ihrer Klasse.

== Limitationen // J
// Zeitliche, technische oder ressourcenbedingte Einschränkungen

Bereits vorhandene Erfahrung mit dem @DRF war der ausschlaggebende Grund, es als Backend Framework zu verwenden. Retrospektiv wäre für das Backend ein Web-Framework wie NestJS, das direkt auf @JS basiert, womöglich eine passendere Wahl gewesen. 

Zeitliche Einschränkungen kamen hauptsächlich von schulischer Seite aus und haben die Planung und Entwicklung des Projekts wiederholt verlangsamt und eingeschränkt. SCRUM als Entwicklungsmodell zu verwenden war hier entscheidend, da so die nötige zeitliche Flexibilität durch die zweiwöchigen Sprints gegeben war.

Während der ursprünglichen Recherchen kamen die Themen Authentifizierung und digitale Signatur der Nutzer öfters auf, da an den meisten funktionierenden Lösungen auf dem Markt ein Preisschild hängt. Dass @OAuth:s nicht in Frage käme, wurde auf Absprache mit dem Betreuer der Arbeit festgelegt. Daher fiel die Wahl auf eine eigene Authentifizierungs- und Signatur-Lösung mittels @DRF, die im @DRF_Kapitel genauer beschrieben sind. \
Dass die Authentifizierung mittels @LDAP der Schule vergleichsweise einfach gewesen wäre, kam erst zu einem späteren Zeitpunkt nach der Implementierung auf. Die Verwendung dieser Technologie hätte viel Zeit in der Planung und Implementierung des Projekts einsparen können.

Aufgrund verschiedener Faktoren wie Datenschutz, Leistung, Qualität und Finanzierung, fiel die Wahl des Deployments auf Railway. Genaueres dazu findet sich im @Railway_Kapitel.
