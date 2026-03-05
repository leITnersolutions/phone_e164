# phone_e164 — Odoo 19 Phone Format Fix for Vodia

Dieses Modul erzwingt die Speicherung von Telefonnummern im **reinen E.164-Format** (`+4312345678`) ohne Leerzeichen — notwendig für den exakten String-Abgleich des **Vodia PBX CRM Connectors**.

## Problem

Odoo speichert Telefonnummern standardmäßig im INTERNATIONAL-Format mit Leerzeichen (`+43 1 234 5678`). Vodia vergleicht die eingehende Rufnummer zeichengenau — ein Leerzeichen verhindert die Erkennung des Kontakts.

## Lösung

### Option 1 — Modul (neue Eingaben)

Das Modul überschreibt `phone.mixin._phone_format()` und gibt immer `E164` zurück.

**Installation via GitHub (Odoo.sh oder eigener Server):**

1. Repository in dein Odoo-Addons-Verzeichnis klonen:
   ```bash
   git clone https://github.com/<dein-user>/phone_e164.git /mnt/extra-addons/phone_e164
   ```

2. In `odoo.conf` sicherstellen, dass der Pfad in `addons_path` enthalten ist.

3. Modul installieren:
   ```bash
   odoo -u phone_e164 -d <datenbankname>
   ```
   Oder über **Apps → phone_e164 → Installieren** in der Odoo-Oberfläche (Entwicklermodus aktiv).

### Option 2 — SQL-Migration (bestehende Nummern)

```bash
# Backup zuerst!
pg_dump -U odoo <datenbankname> > backup_before_phone_fix.sql

# Migration ausführen
psql -U odoo -d <datenbankname> -f migrate_phones.sql
```

Das Script:
- Entfernt alle Leerzeichen (inkl. `\u00A0` non-breaking spaces) aus `phone` und `mobile`
- Zeigt vorher/nachher Anzahl betroffener Datensätze
- Läuft in einer Transaktion (sicher)
- Enthält auskommentierte Statements für `res.company`, `hr.employee`, `crm.lead`

## Dateistruktur

```
phone_e164/
├── __init__.py
├── __manifest__.py
├── models/
│   ├── __init__.py
│   └── phone_mixin.py
├── migrate_phones.sql
└── README.md
```

## Kompatibilität

| Odoo Version | Status |
|---|---|
| 19.0 | ✅ Getestet |
| 18.0 | ✅ Sollte funktionieren |
| 17.0 | ✅ Sollte funktionieren |

## Hinweis

Falls Nummern ohne Ländervorwahl eingegeben werden (z.B. `0664...`), muss am Partner oder der Firma ein **Land** gesetzt sein, damit die Vorwahl korrekt ergänzt werden kann. Ohne Land-Kontext bleibt die Nummer unverändert.
