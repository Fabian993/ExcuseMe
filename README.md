# ExcuseMe
## Fragen:
- **Haben wir die Grundidee richtig verstanden?:**  
Eine cross-platform App, die SchülerInnen (und ihre Eltern) erlaubt, Fehlstunden‑Entschuldigungen an ihre Klassenvorstände zu schicken. Für minderjährige SchülerInnen muss die Entschuldigung digital von den Eltern signiert werden.

- **Soll das ganze eine Simulation sein die hochgeladene Entschuldigungen lokal speichert oder wird ein Server benötigt?**
    - Datenbank lokal oder Cloud Lösung?

- **Ist es Sinnvoll zu zweit auf einem Develop Branch in Github zu arbeiten oder jeder auf einem eigenen?**

- **Wie soll die Regestrierung erfolgen?**
    - Bekommen Eltern eine eigene Email?
    - Werden Eltern per Email eingeladen?

- **Welche Rollen sollen erstellt/verteilt werden?**
    - Wer hat welche permissions?

- **Es wäre Sinnvoll wenn User benachrichtigt werden:**
    - Wer soll benachrichtigt werden?
    - Email, Mobil?

- **Sollen Lehrer über Sichtbarkeit der Entschuldigungen entscheiden können?**

- **Soll die Hochgeladene Datei ein Bild der Entschuldigung sein oder Text?**

- **Skalierbarkeit**
    - Wie viele Personen sollen die App gleichzeitig nutzen können?
    - Soll die App nur Schulintern laufen?

# Projekt‑Requirements für „Excuse Me“

> **Titel** Excuse Me  
> **Ziel** Eine cross-platform App, die SchülerInnen (und ihre Eltern) erlaubt, Fehlstunden‑Entschuldigungen an ihre Klassenvorstände zu schicken. Für minderjährige SchülerInnen muss die Entschuldigung digital von den Eltern signiert werden.  

> **Technologie‑Stack**  
> - Backend: Django 5.x  
> - Frontend: Flutter 3.x (alternativ Ionic)  
> - Datenbank: MySQL 8.x oder PostgreSQL  (PostgreSQL: Opensource, bessere Community, bessere Skalierbarkeit, unterstützt jsonb (json binary))
> - Auth: OAuth2 / JWT + Django‑Auth  
> - Hosting: Heroku / DigitalOcean (zwei separate Services: API & Mobile)  

## 1. Überblick Rollen

| Name | Rolle | Hauptaufgabe |
|-------------|-------|--------------|
| Eltern | *Parent* | Anlegen/Signieren von Entschuldigungen, Benachrichtigungen |
| Schüler | *Student* | Anzeigen eigener Entschuldigungen, Status |
| Lehrkraft | *Teacher* | Genehmigung/Verweigerung, Status‑Update |
| Schulleiter | *Admin* | System‑Konfiguration, Reports |
| Entwickler | *Developer* | Backend‑ und Frontend‑Entwicklung, Tests |


## 2. Funktionsbeschreibung (Brainstorming)

### 2.1 Authentifizierung & Rollen‑Management
- **Registrierung**  
  - Eltern & Lehrkräfte per E‑Mail, Bestätigung, Passwortrichtlinie  
  - Schüler werden über Eltern registriert (Sicherheitscode oder Eltern‑Bestätigung)
- **Login**  
  - JWT‑Token‑Ausgabe, Refresh‑Token, 2FA optional
- **Roles**  
  - `parent`, `student`, `teacher`, `admin`, `dev`

### 2.2 CRUD‑Operationen
| Aktion | Eltern | Schüler | Lehrkraft | Admin |
|--------|--------|---------|-----------|-------|
| **Create** | ✓ | – | – | – |
| **Read** | eigene, von Lehrer genehmigte | eigene | eigene und zugewiesene | alle |
| **Update** | erst Signatur, danach keine | – | Statusänderung (approved/rejected) | – |
| **Delete** | nur in Draft, Bestätigung erforderlich | – | – | – |

- **Draft‑Status** – Eltern können Entschuldigung anlegen, später signieren. Werden dabei auch nach gewisser Zeit auf die signierung hingewiesen.
- **Signature** – Digitale Signatur wird in DB gespeichert (ECDSA + SHA‑256).  
- **Status‑Übersicht** – Ampelsystem (Green: Approved, Yellow: Pending, Red: Rejected).  

### 2.3 Kalender & Historie
- **Kalender‑Ansicht**
  - Anzeige aller Entschuldigungen mit Status.  
- **Filter**  
  - Nach Status, Datum, Klassenstufe.  

### 2.4 Benachrichtigungen
| Art | Auslöser | Empfänger | Inhalt |
|-------|---------|-----------|---------|
| Push‑Notification (FCM) | Status‑Änderung | Eltern, Schüler | Kurzinfo |
| E‑Mail | Status‑Änderung, Signatur | Eltern, Schüler | Vollständige Entschuldigungs‑Daten |
| In‑App | Neue Entschuldigung | Eltern, Lehrer | Hinweis |

### 2.5 Reporting & Analytics
- **Dashboard** (Admin)  
  - Anzahl Entschuldigungen pro Klasse, Statusverteilung, Spitzenzeiten.  
- **Export**  
  - CSV/Excel für Schulleiter.  

### 2.6 Sicherheit & Datenschutz
- **Datenschutz**  
  - DSGVO‑konforme Speicherung, Aufbewahrungsfrist 3 Jahre.  
- **Sicherheit**  
  - HTTPS, OWASP‑Sicherheitsstandards (CSRF, XSS, SQL‑Injection).  
  - Signatur‑Validierung auf Server‑Seite.  
- **Audit‑Log**  
  - Änderungen an Entschuldigungen protokolliert (User, Timestamp, Action).


## 3. Use‑Case‑Diagram

1. **Parent** → *Create Excuse* (Draft) → *Sign*  
2. **Parent** → *View Status*  
3. **Teacher** → *View Pending Excuses* → *Approve/Reject*  
4. **Teacher** → *Add Comment*  
5. **Admin** → *Generate Report*  
6. **Student** → *View Own Excuses*  


## 4. Akzeptanzkriterien

| Feature | Akzeptanzkriterium |
|---------|--------------------|
| **Digital Signature** | Signatur wird im Backend validiert und mit der Entschuldigung verknüpft. |
| **Role‑Based UI** | Eltern sehen nur ihre Entschuldigungen, Lehrer ihre Klassen. |
| **Notifications** | Push‑Notification innerhalb von 5 s nach Status‑Änderung. |
| **Data Persistence** | Alle Daten in SQL, Backup alle 24 h. |
| **Test‑Coverage** | 90 % Unit/Integration‑Tests, 80 % E2E‑Tests (Flutter). |


## 5. Projekt‑Timeline (360 h)

| Phase | Dauer (h) | Deliverable |
|-------|-----------|--------------|
| Anforderungsanalyse + Architektur | 50 | Requirements‑Doc, UML |
| Datenbank‑Design & Setup | 40 | ER‑Diagram, Migration scripts |
| Auth + RBAC | 60 | JWT‑Auth, Role‑Middleware |
| Excuse‑Module (CRUD, Sign) | 80 | REST API + Flutter UI |
| Notification‑System | 30 | FCM + Email |
| Dashboard & Reporting | 30 | Admin UI |
| Tests & QA | 40 | Test‑Suite, CI/CD |
| Deployment & Dokumentation | 30 | Docker, Heroku, Docs |
| Abschluss & Präsentation | 10 | PPT, Demo |
