-- =============================================================
-- phone_e164: Bereinigung bestehender Telefonnummern
-- Entfernt alle Leerzeichen (inkl. non-breaking spaces \u00A0)
-- aus den Feldern phone und mobile in res_partner.
--
-- WICHTIG: Vorher ein Datenbank-Backup erstellen!
-- Ausführen als: psql -U odoo -d <datenbankname> -f migrate_phones.sql
-- =============================================================

BEGIN;

-- Vorher: Anzahl betroffener Datensätze anzeigen
SELECT
    COUNT(*) FILTER (WHERE phone  ~ '\s') AS phone_with_spaces,
    COUNT(*) FILTER (WHERE mobile ~ '\s') AS mobile_with_spaces
FROM res_partner;

-- phone-Feld: alle Whitespace-Zeichen entfernen
UPDATE res_partner
SET phone = REGEXP_REPLACE(phone, '\s+', '', 'g')
WHERE phone ~ '\s';

-- mobile-Feld: alle Whitespace-Zeichen entfernen
UPDATE res_partner
SET mobile = REGEXP_REPLACE(mobile, '\s+', '', 'g')
WHERE mobile ~ '\s';

-- Nachher: Kontrolle
SELECT
    COUNT(*) FILTER (WHERE phone  ~ '\s') AS phone_with_spaces_remaining,
    COUNT(*) FILTER (WHERE mobile ~ '\s') AS mobile_with_spaces_remaining
FROM res_partner;

COMMIT;

-- =============================================================
-- Optional: auch andere Modelle bereinigen falls nötig
-- (z.B. res.company, hr.employee, crm.lead)
-- =============================================================

-- UPDATE res_company
-- SET phone = REGEXP_REPLACE(phone, '\s+', '', 'g')
-- WHERE phone ~ '\s';

-- UPDATE hr_employee
-- SET work_phone   = REGEXP_REPLACE(work_phone,   '\s+', '', 'g'),
--     mobile_phone = REGEXP_REPLACE(mobile_phone, '\s+', '', 'g')
-- WHERE work_phone ~ '\s' OR mobile_phone ~ '\s';

-- UPDATE crm_lead
-- SET phone  = REGEXP_REPLACE(phone,  '\s+', '', 'g'),
--     mobile = REGEXP_REPLACE(mobile, '\s+', '', 'g')
-- WHERE phone ~ '\s' OR mobile ~ '\s';
