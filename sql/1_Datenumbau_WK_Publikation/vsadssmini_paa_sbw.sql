WITH sbw AS (
    SELECT
        k.t_ili_tid as oid_dss,
        k.t_datasetname as dataset,
        CASE
            WHEN k.funktion = 'Abflusslose_Toilette' THEN 'Abflusslose Toilette'
            WHEN k.funktion = 'abflussloseGrube' THEN 'Abflusslose Grube'
            WHEN k.funktion = 'ARABauwerk' THEN 'ARA'
            WHEN k.funktion = 'Duekerkammer' THEN 'Dükerkammer'
            WHEN k.funktion = 'Duekeroberhaupt' THEN 'Dükeroberhaupt'
            WHEN k.funktion IN ('Einleitstelle_gewaesserrelevant','Einleitstelle_nicht_gewaesserrelevant') THEN 'Einleitstelle'
            WHEN k.funktion IN ('andere','Behandlungsanlage','Fettabscheider','Oelabscheider','Schwimmstoffabscheider','unbekannt','Vorbehandlungsanlage','Wirbelfallschacht') THEN 'Übrige Sonderbauwerke'
            WHEN k.funktion = 'Guellegrube' THEN 'Güllegrube'
            WHEN k.funktion = 'Klaergrube' THEN 'Klärgrube'
            WHEN k.funktion = 'KLARA' THEN 'Kleinkläranlage'
            WHEN k.funktion = 'Kontroll_Einsteigschacht' THEN 'Kontrollschacht'
            WHEN k.funktion = 'Regenbecken_Regenklaerbecken' THEN 'Regenklärbecken'
            WHEN k.funktion = 'Regenbecken_Regenrueckhaltebecken' THEN 'Regenrückhaltebecken'
            WHEN k.funktion = 'Regenbecken_Regenrueckhaltekanal' THEN 'Regenrückhaltekanal'
            WHEN k.funktion IN ('Regenbecken_Durchlaufbecken','Regenbecken_Fangbecken','Regenbecken_Fangkanal','Regenbecken_Stauraumkanal','Regenbecken_Verbundbecken') THEN 'Regenüberlaufbecken'
            WHEN k.funktion = 'Regenueberlauf' THEN 'Regenüberlauf'
            ELSE REPLACE(k.funktion, '_', ' ')
        END AS funktion,
        k.finanzierung,
        k.funktionhierarchisch,
        k.lage,
        k.astatus,
        k.baujahr,
        CASE 
            WHEN k.baulicherzustand = 'Z0' THEN 'Z0: Nicht mehr funktionstüchtig'
            WHEN k.baulicherzustand = 'Z1' THEN 'Z1: Starke Mängel'
            WHEN k.baulicherzustand = 'Z2' THEN 'Z2: Mittlere Mängel'
            WHEN k.baulicherzustand = 'Z3' THEN 'Z3: Leichte Mängel'
            WHEN k.baulicherzustand = 'Z4' THEN 'Z4: Keine Mängel'
            ELSE k.baulicherzustand
        END AS baulicherzustand,
        k.bezeichnung,
        eig.organisationstyp AS eigentuemer_organisationstyp,
        eig.bezeichnung AS eigentuemer_bezeichnung,
        betr.organisationstyp AS betreiber_organisationstyp,
        betr.bezeichnung AS betreiber_bezeichnung,
        k.zustandserhebung_jahr,
        CASE
            WHEN k.funktion = 'Versickerungsanlage' THEN 'P_VS'
            WHEN k.funktion = 'Messstelle' THEN 'P_MST'
            WHEN k.funktion LIKE 'Einleitstelle%' THEN 'P_EST'
            WHEN k.funktion = 'Trennbauwerk' THEN 'P_TB'
            WHEN k.funktion = 'Duekeroberhaupt' THEN 'P_DU'
            WHEN k.funktion = 'Pumpwerk'  THEN 'P_PW'
            WHEN k.funktion IN ('Regenbecken_Regenrueckhaltebecken','Regenbecken_Regenrueckhaltekanal') THEN 'P_RRB'
            WHEN k.funktion LIKE 'Regenbecken_%' AND k.funktion NOT IN ('Regenbecken_Regenrueckhaltebecken','Regenbecken_Regenrueckhaltekanal') THEN 'P_RB'
            WHEN k.funktion = 'Regenueberlauf' THEN 'P_RU'
            WHEN k.funktion IN ('KLARA','ARABauwerk') THEN 'P_ARA'
            WHEN (k.funktion IN ('Behandlungsanlage','Wirbelfallschacht') OR k.funktion LIKE '%abscheider')  THEN 'P_uSBW'
            WHEN k.funktion IN ('andere','unbekannt') AND sk.paa_knotenref IS NOT NULL THEN 'P_uSBW'
        END AS stilid
    FROM ${DB_SCHEMA_EDIT}.vsadssmini_knoten k
    LEFT JOIN ${DB_SCHEMA_EDIT}.administration_organisation eig ON k.eigentuemerref = eig.t_id 
    LEFT JOIN ${DB_SCHEMA_EDIT}.administration_organisation betr ON k.betreiberref = betr.t_id
    LEFT JOIN ${DB_SCHEMA_EDIT}.vsadssmini_sk sk ON k.t_id = sk.paa_knotenref
    WHERE k.lage IS NOT NULL
)
INSERT INTO 
    ${DB_SCHEMA_PUB_STAGING}.wk_paa_sbw 
    (
        baujahr, 
        baulicherzustand, 
        betreiber_bezeichnung, 
        betreiber_organisationstyp, 
        bezeichnung, 
        eigentuemer_bezeichnung, 
        eigentuemer_organisationstyp, 
        funktion, 
        funktionhierarchisch, 
        lage, 
        oid_dss, 
        astatus, 
        dataset, 
        stilid, 
        zustandserhebung_jahr
    )
SELECT
    baujahr,
    baulicherzustand,
    betreiber_bezeichnung,
    betreiber_organisationstyp,
    bezeichnung,
    eigentuemer_bezeichnung,
    eigentuemer_organisationstyp,
    funktion,
    funktionhierarchisch,
    lage,
    oid_dss,
    astatus,
    dataset,
    stilid,
    zustandserhebung_jahr
FROM sbw
WHERE astatus LIKE 'in_Betrieb%'
AND funktionhierarchisch = 'PAA'
AND stilid IS NOT NULL
;
