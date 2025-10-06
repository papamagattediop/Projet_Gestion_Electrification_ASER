-- ===========================================================================================================
									-- BASE DE DONNÉES ÉLECTRIFICATION RURALE SÉNÉGAL(ASER)
									-- Projet ENSAE/AS2 - ASER
									-- Gestion de 14 958 villages
                                    -- Papa Magatte DIOP & Fatou Soumaya WADE
-- ===========================================================================================================

-- ============================================
-- COMMENTAIRES ET DOCUMENTATION
-- ============================================

/*
STRUCTURE DE LA BASE DE DONNÉES ASER 
-------------------------------------------------------------------------------
Cette base de données est conçue pour gérer l'électrification de 14 958 villages 
au Sénégal dans le cadre des activités de l'ASER.

TABLES PRINCIPALES:
1. villages - Informations géographiques et démographiques
2. type_electrification - Technologies et méthodes disponibles
3. electrification - État actuel de l'électrification
4. projets_electrification - Projets en cours et planifiés
5. consommations - Données de consommation électrique
6. appareils_electriques - Équipements utilisés
7. ligne_continue - Optimisation du réseau électrique

OPTIMISATIONS:
- Index spatiaux pour les requêtes géographiques
-----------------------------------------------------------------------------------------
*/
-- =============================================================================================
--                                     CREATION DES TABLES 
-- =============================================================================================

DROP DATABASE IF EXISTS ASER_DB;
CREATE DATABASE ASER_DB 
CHARACTER SET utf8mb4 
COLLATE utf8mb4_unicode_ci;

USE ASER_DB;


-- ============================================
-- 1. TABLE VILLAGES (Entité centrale)
-- ============================================

CREATE TABLE villages (
    id_village INT AUTO_INCREMENT PRIMARY KEY,
    nom_village VARCHAR(100) NOT NULL,
    latitude DECIMAL(10,8) NOT NULL,
    longitude DECIMAL(11,8) NOT NULL,
    population INT NOT NULL CHECK (population > 0),
    region VARCHAR(50) NOT NULL,
    statut_electrification ENUM('Non électrifié', 'Électrifié') NOT NULL DEFAULT 'Non électrifié',
    date_electrifaction TIMESTAMP,
    accessibilite ENUM('Facile', 'Moyenne', 'Difficile') NOT NULL ,
    -- Index pour optimiser les requêtes fréquentes
    INDEX idx_villages_region (region),
    INDEX idx_villages_statut (statut_electrification),
    INDEX idx_villages_population (population)
    
) ENGINE=InnoDB COMMENT='Table principale des villages sénégalais';


-- ====================================================
-- 2. TABLE TYPE_ELECTRIFICATION (Technologies)
-- ====================================================
CREATE TABLE type_electrification (
    id_type_electrification INT AUTO_INCREMENT PRIMARY KEY,
    nom_type VARCHAR(50) NOT NULL UNIQUE,
    source_energie ENUM(
        'Réseau national', 
        'Solaire', 
        'Éolienne', 
        'Hydrocarbure', 
        'Hybride', 
        'Biomasse',
        'Hydroélectrique',
        'Micro-réseau'
    ) NOT NULL,
    cout_installation_par_kw DECIMAL(8,2) NOT NULL CHECK (cout_installation_par_kw > 0),
    cout_maintenance_annuel DECIMAL(8,2) NOT NULL CHECK (cout_maintenance_annuel >= 0),
    duree_vie_moyenne INT NOT NULL CHECK (duree_vie_moyenne > 0),
    cout_remplacement DECIMAL(10,2) NOT NULL CHECK (cout_remplacement > 0),
	date_creation TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    -- Index
    INDEX idx_type_source (source_energie),
    INDEX idx_type_cout (cout_installation_par_kw)
) ENGINE=InnoDB COMMENT='Types et technologies d\'électrification disponibles';

-- ==================================================
-- 3. TABLE ELECTRIFICATION (État électrification)
-- =================================================
CREATE TABLE electrification (
    id_electrification INT AUTO_INCREMENT PRIMARY KEY,
    id_village INT NOT NULL,
    id_type_electrification INT NOT NULL,
    date_electrification DATE NOT NULL,
    puissance_installee DECIMAL(8,2) NOT NULL CHECK (puissance_installee > 0),
    heures_coupure_moyennes DECIMAL(4,2) NOT NULL DEFAULT 0 COMMENT 'Heures coupure par mois',
    
    -- Clés étrangères
    FOREIGN KEY (id_village) REFERENCES villages(id_village) ON DELETE CASCADE,
    FOREIGN KEY (id_type_electrification) REFERENCES type_electrification(id_type_electrification),
    
    -- Contraintes
    CHECK (heures_coupure_moyennes >= 0 AND heures_coupure_moyennes <= 744), -- max heures/mois
    
    -- Index
    INDEX idx_electrif_village (id_village),
    INDEX idx_electrif_date (date_electrification),
    INDEX idx_electrif_type (id_type_electrification)
) ENGINE=InnoDB COMMENT='État d\'électrification des villages';

-- ============================================
-- 4. TABLE PROJETS_ELECTRIFICATION (Projets)
-- ============================================
CREATE TABLE projets_electrification (
    id_projet INT AUTO_INCREMENT PRIMARY KEY,
    id_village INT NOT NULL,
    id_type_electrification INT NOT NULL,
    id_electrification INT NULL,
    nom_projet VARCHAR(150) NOT NULL,
    statut_projet ENUM('Planifié', 'En cours', 'Terminé', 'Maintenance', 'Suspendu', 'Annulé') 
                  NOT NULL DEFAULT 'Planifié',
    date_debut DATE NOT NULL,
    date_fin_prevue DATE NOT NULL,
    date_fin_reelle DATE NULL,
    cout_total_projet DECIMAL(15,2) NOT NULL CHECK (cout_total_projet > 0),
    villages_beneficiaires INT NOT NULL DEFAULT 1 CHECK (villages_beneficiaires > 0),
    source_financement VARCHAR(100) NOT NULL,
    responsable_projet VARCHAR(100),

    -- Clés étrangères
    FOREIGN KEY (id_village) REFERENCES villages(id_village) ON DELETE CASCADE,
    FOREIGN KEY (id_type_electrification) REFERENCES type_electrification(id_type_electrification),
    FOREIGN KEY (id_electrification) REFERENCES electrification(id_electrification) ON DELETE SET NULL,
    
    -- Contraintes logiques
    CHECK (date_fin_prevue >= date_debut),
    CHECK (date_fin_reelle IS NULL OR date_fin_reelle >= date_debut),
    
    -- Index
    INDEX idx_projet_village (id_village),
    INDEX idx_projet_statut (statut_projet),
    INDEX idx_projet_dates (date_debut, date_fin_prevue),
    INDEX idx_projet_financement (source_financement)
) ENGINE=InnoDB COMMENT='Projets d\'électrification en cours et réalisés';

-- ===================================================
-- 5. TABLE CONSOMMATIONS (Consommation électrique)
-- ===================================================
CREATE TABLE consommations (
    id_consommation INT AUTO_INCREMENT PRIMARY KEY,
    id_village INT NOT NULL,
    annee YEAR NOT NULL,
    mois TINYINT(2) DEFAULT NULL CHECK (mois BETWEEN 1 AND 12),
    consommation_kwh DECIMAL(10,2) NOT NULL CHECK (consommation_kwh >= 0),
    
    -- Clé étrangère
    FOREIGN KEY (id_village) REFERENCES villages(id_village) ON DELETE CASCADE,
    
    -- Contrainte unicité par village/année/mois
    UNIQUE KEY unique_consommation (id_village, annee, mois),
    
    -- Index
    INDEX idx_conso_village (id_village),
    INDEX idx_conso_annee (annee),
    INDEX idx_conso_periode (annee, mois)
) ENGINE=InnoDB COMMENT='Données de consommation électrique par village';

-- ==============================================
-- 6. TABLE APPAREILS_ELECTRIQUES (Équipements)
-- ==============================================
CREATE TABLE appareils_electriques (
    id_appareil INT AUTO_INCREMENT PRIMARY KEY,
    id_village INT NOT NULL,
    nom_appareil VARCHAR(50) NOT NULL,
    type_appareil ENUM(
        'Éclairage', 
        'Électroménager', 
        'Communication', 
        'Professionnel',
        'Médical',
        'Éducatif',
        'Agriculture'
    ) NOT NULL,
    nombre_appareils_par_type INT NOT NULL DEFAULT 1 CHECK (nombre_appareils_par_type > 0),
    priorite_usage ENUM(
        'Essentiel', 
        'Important', 
        'Confort', 
        'Luxe'
    ) NOT NULL DEFAULT 'Important',
   
    -- Clé étrangère
    FOREIGN KEY (id_village) REFERENCES villages(id_village) ON DELETE CASCADE,
    
    -- Index
    INDEX idx_appareil_village (id_village),
    INDEX idx_appareil_type (type_appareil),
    INDEX idx_appareil_priorite (priorite_usage),
    INDEX idx_appareil_nom (nom_appareil)
) ENGINE=InnoDB COMMENT='Appareils électriques utilisés dans les villages';

-- ================================================
-- 7. TABLE LIGNE_CONTINUE (Optimisation réseau)
-- ================================================
CREATE TABLE ligne_continue (
    id_ligne INT AUTO_INCREMENT PRIMARY KEY,
    id_electrification INT NULL,
    id_village INT NULL,
    id_type_electrification INT NOT NULL,
    nom_ligne VARCHAR(100) NOT NULL,
    point_depart POINT NOT NULL,
    point_arrivee POINT NOT NULL,
    trace_ligne LINESTRING NOT NULL,
   
    -- Clés étrangères
    FOREIGN KEY (id_electrification) REFERENCES electrification(id_electrification) ON DELETE SET NULL,
    FOREIGN KEY (id_village) REFERENCES villages(id_village),
    FOREIGN KEY (id_type_electrification) REFERENCES type_electrification(id_type_electrification),
    
    -- Index spatiaux et classiques
    SPATIAL INDEX idx_ligne_depart (point_depart),
    SPATIAL INDEX idx_ligne_arrivee (point_arrivee),
    SPATIAL INDEX idx_ligne_trace (trace_ligne)
) ENGINE=InnoDB COMMENT='Lignes électriques continues pour optimisation réseau';


-- =========================================================================================
--                                  INTERROGATIONS SUR LA BASE 
-- =========================================================================================

-- ==== REQUÊTE 1: Villages non électrifiés à partir d'un point sur une distance de 100 km 

-- Point de référence: Dakar (latitude: 14.6937, longitude: -17.4441)
SELECT 
    v.nom_village,
    v.region,
    v.population,
    v.accessibilite,
    ROUND(ST_Distance_Sphere(POINT(v.longitude, v.latitude), POINT(-17.4441, 14.6937)) / 1000, 2) AS distance_km
FROM villages v
WHERE v.statut_electrification = 'Non électrifié'
    AND ST_Distance_Sphere(POINT(v.longitude, v.latitude), POINT(-17.4441, 14.6937)) <= 100000 -- 100 km en mètres
ORDER BY distance_km ASC;

-- Point de référence: Sedhiou : POINT(-15.558300, 12.708300)
SELECT 
    v.nom_village,
    v.region,
    v.population,
    v.accessibilite,
    ROUND(ST_Distance_Sphere(POINT(v.longitude, v.latitude), POINT(-15.5583, 12.7083)) / 1000, 2) AS distance_km
FROM villages v
WHERE v.statut_electrification = 'Non électrifié'
    AND ST_Distance_Sphere(POINT(v.longitude, v.latitude), POINT(-15.5583, 12.7083)) <= 100000 -- 100 km en mètres
ORDER BY distance_km ASC;

-- ==== REQUÊTE 2: Type d'électrification optimal sur 20 ans (en tenant compte du  coûts remplacements)

SELECT 
    te.nom_type,
    te.source_energie,
    te.cout_installation_par_kw AS cout_initial,
    te.cout_maintenance_annuel AS maintenance_annuelle,
    te.duree_vie_moyenne AS duree_vie_ans,
    te.cout_remplacement,
    
    -- Calcul du nombre de remplacements sur 20 ans
    FLOOR(20 / te.duree_vie_moyenne) AS nb_remplacements_20ans,
    
    -- Calcul du coût total sur 20 ans par kW
    ROUND(
        te.cout_installation_par_kw + 
        (te.cout_maintenance_annuel * 20) + 
        (te.cout_remplacement * FLOOR(20 / te.duree_vie_moyenne)), 2
    ) AS cout_total_20_ans_par_kw,
    
    -- Coût annualisé sur 20 ans
    ROUND(
        (te.cout_installation_par_kw + 
         (te.cout_maintenance_annuel * 20) + 
         (te.cout_remplacement * FLOOR(20 / te.duree_vie_moyenne))) / 20, 2
    ) AS cout_annualise_par_kw,
    
    -- Classement par coût (1 = plus économique)
    RANK() OVER (ORDER BY 
        te.cout_installation_par_kw + 
        (te.cout_maintenance_annuel * 20) + 
        (te.cout_remplacement * FLOOR(20 / te.duree_vie_moyenne))
    ) AS rang_economique
FROM type_electrification te
ORDER BY cout_total_20_ans_par_kw ASC;

-- Analyse détaillée des coûts
SELECT 'ANALYSE: Décomposition des coûts sur 20 ans' AS analyse;

SELECT 
    te.nom_type,
    te.cout_installation_par_kw AS cout_initial,
    (te.cout_maintenance_annuel * 20) AS cout_maintenance_20ans,
    (te.cout_remplacement * FLOOR(20 / te.duree_vie_moyenne)) AS cout_remplacements_20ans,
    ROUND(
        te.cout_installation_par_kw + 
        (te.cout_maintenance_annuel * 20) + 
        (te.cout_remplacement * FLOOR(20 / te.duree_vie_moyenne)), 2
    ) AS cout_total_20ans,
    
    -- Pourcentage de chaque composant
    ROUND((te.cout_installation_par_kw / 
           (te.cout_installation_par_kw + (te.cout_maintenance_annuel * 20) + 
            (te.cout_remplacement * FLOOR(20 / te.duree_vie_moyenne)))) * 100, 1) AS pct_installation,
    ROUND(((te.cout_maintenance_annuel * 20) / 
           (te.cout_installation_par_kw + (te.cout_maintenance_annuel * 20) + 
            (te.cout_remplacement * FLOOR(20 / te.duree_vie_moyenne)))) * 100, 1) AS pct_maintenance,
    ROUND(((te.cout_remplacement * FLOOR(20 / te.duree_vie_moyenne)) / 
           (te.cout_installation_par_kw + (te.cout_maintenance_annuel * 20) + 
            (te.cout_remplacement * FLOOR(20 / te.duree_vie_moyenne)))) * 100, 1) AS pct_remplacements
FROM type_electrification te
ORDER BY cout_total_20ans ASC;


-- ==== REQUÊTE 3: Villages de plus de mille habitants dans la région de Kolda

-- Comptage et statistiques
SELECT 
    COUNT(*) AS nb_villages_kolda_plus_1000_hab,
    SUM(population) AS population_totale,
    ROUND(AVG(population), 0) AS population_moyenne,
    MIN(population) AS population_min,
    MAX(population) AS population_max,
    SUM(CASE WHEN statut_electrification = 'Électrifié' THEN 1 ELSE 0 END) AS villages_electrifies,
    SUM(CASE WHEN statut_electrification = 'Non électrifié' THEN 1 ELSE 0 END) AS villages_non_electrifies,
    ROUND(
        SUM(CASE WHEN statut_electrification = 'Électrifié' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2
    ) AS taux_electrification_pct
FROM villages 
WHERE region = 'Kolda' 
    AND population > 1000;

-- Détail des villages concernés
SELECT 
    nom_village,
    population,
    statut_electrification,
    date_electrifaction,
    accessibilite
FROM villages 
WHERE region = 'Kolda' 
    AND population > 1000
ORDER BY population DESC;



-- ==== REQUÊTE 4: Villages 500+ habitants à moins de 50 km d'une zone électrifiée

SELECT 
    COUNT(DISTINCT v1.id_village) AS nb_villages_500plus_pres_zone_electrifiee
FROM villages v1
WHERE v1.population >= 500
    AND EXISTS (
        SELECT 1 
        FROM villages v2 
        WHERE v2.statut_electrification = 'Électrifié'
            AND v1.id_village != v2.id_village
            AND ST_Distance_Sphere(POINT(v1.longitude, v1.latitude), POINT(v2.longitude, v2.latitude)) <= 50000
    );

-- Détail avec distance minimale (échantillon)
SELECT 
    v1.nom_village,
    v1.population,
    v1.region,
    v1.statut_electrification,
    MIN(ROUND(ST_Distance_Sphere(POINT(v1.longitude, v1.latitude), POINT(v2.longitude, v2.latitude)) / 1000, 2)) AS distance_min_zone_electrifiee_km
FROM villages v1
INNER JOIN villages v2 ON v2.statut_electrification = 'Électrifié' 
    AND v1.id_village != v2.id_village
    AND ST_Distance_Sphere(POINT(v1.longitude, v1.latitude), POINT(v2.longitude, v2.latitude)) <= 50000
WHERE v1.population >= 500
GROUP BY v1.id_village, v1.nom_village, v1.population, v1.region, v1.statut_electrification
ORDER BY distance_min_zone_electrifiee_km ASC
LIMIT 15;

-- Analyse par région
SELECT 
    v1.region,
    COUNT(DISTINCT v1.id_village) AS nb_villages_concernes,
    ROUND(AVG(v1.population), 0) AS population_moyenne
FROM villages v1
WHERE v1.population >= 500
    AND EXISTS (
        SELECT 1 FROM villages v2 
        WHERE v2.statut_electrification = 'Électrifié'
            AND ST_Distance_Sphere(POINT(v1.longitude, v1.latitude), POINT(v2.longitude, v2.latitude)) <= 50000
    )
GROUP BY v1.region
ORDER BY nb_villages_concernes DESC;

-- ==== REQUÊTE 5: Villages non-électrifiés à moins de 10 km d'un village électrifié depuis moins de 2 ans
-- Comptage total
SELECT 
    COUNT(DISTINCT v1.id_village) AS nb_villages_non_electrifies_pres_electrif_recente
FROM villages v1
INNER JOIN villages v2 ON v2.statut_electrification = 'Électrifié'
INNER JOIN electrification e ON v2.id_village = e.id_village
WHERE v1.statut_electrification = 'Non électrifié'
    AND e.date_electrification >= DATE_SUB(CURDATE(), INTERVAL 2 YEAR)
    AND ST_Distance_Sphere(POINT(v1.longitude, v1.latitude), POINT(v2.longitude, v2.latitude)) <= 10000
    AND v1.id_village != v2.id_village;

-- Détail avec informations sur l'électrification récente
SELECT 
    v1.nom_village AS village_non_electrifie,
    v1.population,
    v1.region AS region_village,
    v1.accessibilite,
    v2.nom_village AS village_electrifie_recent,
    v2.region AS region_electrifie,
    e.date_electrification,
    ROUND(ST_Distance_Sphere(POINT(v1.longitude, v1.latitude), POINT(v2.longitude, v2.latitude)) / 1000, 2) AS distance_km,
    DATEDIFF(CURDATE(), e.date_electrification) AS jours_depuis_electrification
FROM villages v1
INNER JOIN villages v2 ON v2.statut_electrification = 'Électrifié'
INNER JOIN electrification e ON v2.id_village = e.id_village
WHERE v1.statut_electrification = 'Non électrifié'
    AND e.date_electrification >= DATE_SUB(CURDATE(), INTERVAL 2 YEAR)
    AND ST_Distance_Sphere(POINT(v1.longitude, v1.latitude), POINT(v2.longitude, v2.latitude)) <= 10000
    AND v1.id_village != v2.id_village
ORDER BY distance_km ASC, e.date_electrification DESC
LIMIT 20;

-- ==== REQUÊTE 6: Consommation moyenne (kWh) d'un village de mille habitants par an

-- Consommation annuelle moyenne (villages entre 950 et 1050 habitants)
SELECT 
    ROUND(AVG(c.consommation_kwh), 2) AS consommation_moyenne_kwh_annuelle,
    COUNT(DISTINCT v.id_village) AS nb_villages_echantillon,
    ROUND(AVG(v.population), 0) AS population_moyenne_echantillon,
    ROUND(MIN(c.consommation_kwh), 2) AS consommation_min,
    ROUND(MAX(c.consommation_kwh), 2) AS consommation_max,
    ROUND(STDDEV(c.consommation_kwh), 2) AS ecart_type
FROM villages v
INNER JOIN consommations c ON v.id_village = c.id_village
WHERE v.population BETWEEN 950 AND 1050
    AND v.statut_electrification = 'Électrifié'
    AND c.mois IS NULL  -- Données annuelles seulement
    AND c.annee IN (2023, 2024);

-- Consommation par habitant
SELECT 
    ROUND(AVG(c.consommation_kwh / v.population), 2) AS consommation_par_habitant_kwh_an,
    ROUND(MIN(c.consommation_kwh / v.population), 2) AS consommation_min_par_hab,
    ROUND(MAX(c.consommation_kwh / v.population), 2) AS consommation_max_par_hab
FROM villages v
INNER JOIN consommations c ON v.id_village = c.id_village
WHERE v.population BETWEEN 950 AND 1050
    AND v.statut_electrification = 'Électrifié'
    AND c.mois IS NULL
    AND c.annee IN (2023, 2024);

-- Évolution par année
SELECT 
    c.annee,
    ROUND(AVG(c.consommation_kwh), 2) AS consommation_moyenne,
    ROUND(AVG(c.consommation_kwh / v.population), 2) AS consommation_par_habitant,
    COUNT(DISTINCT v.id_village) AS nb_villages
FROM villages v
INNER JOIN consommations c ON v.id_village = c.id_village
WHERE v.population BETWEEN 950 AND 1050
    AND v.statut_electrification = 'Électrifié'
    AND c.mois IS NULL
GROUP BY c.annee
ORDER BY c.annee;

-- Détail par village (échantillon)
SELECT 
    v.nom_village,
    v.population,
    v.region,
    c.annee,
    c.consommation_kwh,
    ROUND(c.consommation_kwh / v.population, 2) AS consommation_par_habitant
FROM villages v
INNER JOIN consommations c ON v.id_village = c.id_village
WHERE v.population BETWEEN 950 AND 1050
    AND v.statut_electrification = 'Électrifié'
    AND c.mois IS NULL
    AND c.annee = 2024
ORDER BY c.consommation_kwh DESC
LIMIT 10;

-- ==== REQUÊTE 7: Les cinq appareils les plus utilisés dans les villages électrifiés 

-- Top 5 par nombre total d'appareils
SELECT 
    ae.nom_appareil,
    ae.type_appareil,
    ae.priorite_usage,
    COUNT(DISTINCT ae.id_village) AS nb_villages_utilisent,
    SUM(ae.nombre_appareils_par_type) AS total_appareils,
    ROUND(AVG(ae.nombre_appareils_par_type), 1) AS moyenne_par_village,
    ROUND(
        COUNT(DISTINCT ae.id_village) * 100.0 / 
        (SELECT COUNT(*) FROM villages WHERE statut_electrification = 'Électrifié'), 2
    ) AS pourcentage_penetration_villages
FROM appareils_electriques ae
INNER JOIN villages v ON ae.id_village = v.id_village
WHERE v.statut_electrification = 'Électrifié'
GROUP BY ae.nom_appareil, ae.type_appareil, ae.priorite_usage
ORDER BY total_appareils DESC
LIMIT 5;

-- Top 5 par pénétration (pourcentage de villages qui l'utilisent)
SELECT 'TOP 5 par pénétration dans les villages' AS classement;

SELECT 
    ae.nom_appareil,
    ae.type_appareil,
    COUNT(DISTINCT ae.id_village) AS nb_villages_utilisent,
    ROUND(
        COUNT(DISTINCT ae.id_village) * 100.0 / 
        (SELECT COUNT(*) FROM villages WHERE statut_electrification = 'Électrifié'), 2
    ) AS pourcentage_penetration,
    SUM(ae.nombre_appareils_par_type) AS total_appareils
FROM appareils_electriques ae
INNER JOIN villages v ON ae.id_village = v.id_village
WHERE v.statut_electrification = 'Électrifié'
GROUP BY ae.nom_appareil, ae.type_appareil
ORDER BY pourcentage_penetration DESC, total_appareils DESC
LIMIT 5;

-- Analyse par type d'appareil
SELECT 'ANALYSE par type d\'appareil' AS analyse;

SELECT 
    ae.type_appareil,
    COUNT(DISTINCT ae.nom_appareil) AS nb_types_appareils,
    COUNT(DISTINCT ae.id_village) AS nb_villages_utilisent,
    SUM(ae.nombre_appareils_par_type) AS total_appareils,
    ROUND(AVG(ae.nombre_appareils_par_type), 1) AS moyenne_par_village
FROM appareils_electriques ae
INNER JOIN villages v ON ae.id_village = v.id_village
WHERE v.statut_electrification = 'Électrifié'
GROUP BY ae.type_appareil
ORDER BY total_appareils DESC;

-- ==== REQUÊTE 8: Villages prioritaires pour électrification (Score multicritère)
-- Combinaison: population + accessibilité + proximité infrastructure + impact social

SELECT 
    v.nom_village,
    v.region,
    v.population,
    v.accessibilite,
    
    -- Score démographique (population normalisée sur 40 points max)
    ROUND(LEAST(v.population / 1000, 40), 1) AS score_population,
    
    -- Score accessibilité (Bonne=20, Moyenne=10, Difficile=5)
    CASE v.accessibilite 
        WHEN 'Bonne' THEN 20
        WHEN 'Moyenne' THEN 10
        WHEN 'Difficile' THEN 5
        ELSE 0
    END AS score_accessibilite,
    
    -- Score proximité infrastructure (distance min zone électrifiée)
    CASE
        WHEN (SELECT MIN(ST_Distance_Sphere(POINT(v.longitude, v.latitude), POINT(v2.longitude, v2.latitude))) 
              FROM villages v2 WHERE v2.statut_electrification = 'Électrifié') <= 10000 THEN 20
        WHEN (SELECT MIN(ST_Distance_Sphere(POINT(v.longitude, v.latitude), POINT(v2.longitude, v2.latitude))) 
              FROM villages v2 WHERE v2.statut_electrification = 'Électrifié') <= 25000 THEN 15
        WHEN (SELECT MIN(ST_Distance_Sphere(POINT(v.longitude, v.latitude), POINT(v2.longitude, v2.latitude))) 
              FROM villages v2 WHERE v2.statut_electrification = 'Électrifié') <= 50000 THEN 10
        ELSE 5
    END AS score_proximite,
    
    -- Score impact social (densité population + services publics potentiels)
    CASE 
        WHEN v.population >= 5000 THEN 20  -- Centre régional
        WHEN v.population >= 2000 THEN 15  -- Gros village
        WHEN v.population >= 1000 THEN 10  -- Village moyen
        WHEN v.population >= 500 THEN 5    -- Petit village
        ELSE 2
    END AS score_impact_social,
    
    -- SCORE TOTAL (sur 100)
    ROUND(
        LEAST(v.population / 1000, 40) +  -- Score population
        CASE v.accessibilite 
            WHEN 'Bonne' THEN 20
            WHEN 'Moyenne' THEN 10
            WHEN 'Difficile' THEN 5
            ELSE 0
        END +  -- Score accessibilité
        CASE 
            WHEN (SELECT MIN(ST_Distance_Sphere(POINT(v.longitude, v.latitude), POINT(v2.longitude, v2.latitude))) 
                  FROM villages v2 WHERE v2.statut_electrification = 'Électrifié') <= 10000 THEN 20
            WHEN (SELECT MIN(ST_Distance_Sphere(POINT(v.longitude, v.latitude), POINT(v2.longitude, v2.latitude))) 
                  FROM villages v2 WHERE v2.statut_electrification = 'Électrifié') <= 25000 THEN 15
            WHEN (SELECT MIN(ST_Distance_Sphere(POINT(v.longitude, v.latitude), POINT(v2.longitude, v2.latitude))) 
                  FROM villages v2 WHERE v2.statut_electrification = 'Électrifié') <= 50000 THEN 10
            ELSE 5
        END +  -- Score proximité
        CASE 
            WHEN v.population >= 5000 THEN 20
            WHEN v.population >= 2000 THEN 15
            WHEN v.population >= 1000 THEN 10
            WHEN v.population >= 500 THEN 5
            ELSE 2
        END, 1  -- Score impact social
    ) AS score_priorite_total,
    
    -- Classification priorité
    CASE 
        WHEN ROUND(LEAST(v.population / 1000, 40) + 
                   CASE v.accessibilite WHEN 'Bonne' THEN 20 WHEN 'Moyenne' THEN 10 WHEN 'Difficile' THEN 5 ELSE 0 END + 
                   CASE WHEN (SELECT MIN(ST_Distance_Sphere(POINT(v.longitude, v.latitude), POINT(v2.longitude, v2.latitude))) 
                             FROM villages v2 WHERE v2.statut_electrification = 'Électrifié') <= 10000 THEN 20
                        WHEN (SELECT MIN(ST_Distance_Sphere(POINT(v.longitude, v.latitude), POINT(v2.longitude, v2.latitude))) 
                             FROM villages v2 WHERE v2.statut_electrification = 'Électrifié') <= 25000 THEN 15 
                        ELSE 10 END +
                   CASE WHEN v.population >= 5000 THEN 20 WHEN v.population >= 2000 THEN 15 ELSE 10 END, 1) >= 80 THEN 'TRÈS HAUTE'
        WHEN ROUND(LEAST(v.population / 1000, 40) + 
                   CASE v.accessibilite WHEN 'Bonne' THEN 20 WHEN 'Moyenne' THEN 10 WHEN 'Difficile' THEN 5 ELSE 0 END + 
                   CASE WHEN (SELECT MIN(ST_Distance_Sphere(POINT(v.longitude, v.latitude), POINT(v2.longitude, v2.latitude))) 
                   

                             FROM villages v2 WHERE v2.statut_electrification = 'Électrifié') <= 10000 THEN 20 ELSE 10 END +
                   CASE WHEN v.population >= 2000 THEN 15 ELSE 10 END, 1) >= 60 THEN 'HAUTE'
        WHEN ROUND(LEAST(v.population / 1000, 40) + 
                   CASE v.accessibilite WHEN 'Bonne' THEN 20 WHEN 'Moyenne' THEN 10 ELSE 5 END + 10 + 10, 1) >= 40 THEN 'MOYENNE'
        ELSE 'BASSE'
	END AS priorite_classification

FROM villages v
WHERE v.statut_electrification = 'Non électrifié'
ORDER BY score_priorite_total DESC, v.population DESC
LIMIT 20;

-- ==== REQUÊTE 9: Budget nécessaire pour électrification complète par région et méthode

-- Budget global par région avec méthode optimale
SELECT 
    v.region,
    COUNT(*) AS villages_non_electrifies,
    SUM(v.population) AS population_non_electrifiee,
    
    -- Estimation puissance nécessaire (2 kW par 100 habitants)
    ROUND(SUM(v.population) * 0.02, 1) AS puissance_totale_kw_estimee,
    
    -- Coût avec méthode la moins chère (réseau national)
    ROUND(SUM(v.population) * 0.02 * (SELECT MIN(cout_installation_par_kw) FROM type_electrification), 0) AS cout_methode_economique,
    
    -- Coût avec méthode adaptée selon accessibilité
    ROUND(
        SUM(CASE 
            WHEN v.accessibilite = 'Bonne' THEN v.population * 0.02 * 
                (SELECT cout_installation_par_kw FROM type_electrification WHERE nom_type = 'Réseau national')
            WHEN v.accessibilite = 'Moyenne' THEN v.population * 0.02 * 
                (SELECT cout_installation_par_kw FROM type_electrification WHERE nom_type = 'Solaire photovoltaïque')
            ELSE v.population * 0.02 * 
                (SELECT cout_installation_par_kw FROM type_electrification WHERE nom_type = 'Générateur diesel')
        END), 0
    ) AS cout_methode_adaptee,
    
    -- Coût moyen par village
    ROUND(
        SUM(CASE 
            WHEN v.accessibilite = 'Bonne' THEN v.population * 0.02 * 
                (SELECT cout_installation_par_kw FROM type_electrification WHERE nom_type = 'Réseau national')
            WHEN v.accessibilite = 'Moyenne' THEN v.population * 0.02 * 
                (SELECT cout_installation_par_kw FROM type_electrification WHERE nom_type = 'Solaire photovoltaïque')
            ELSE v.population * 0.02 * 
                (SELECT cout_installation_par_kw FROM type_electrification WHERE nom_type = 'Générateur diesel')
        END) / COUNT(*), 0
    ) AS cout_moyen_par_village,
    
    -- Priorité budgétaire (score population/coût)
    ROUND(
        SUM(v.population) / 
        (SUM(CASE 
            WHEN v.accessibilite = 'Bonne' THEN v.population * 0.02 * 
                (SELECT cout_installation_par_kw FROM type_electrification WHERE nom_type = 'Réseau national')
            WHEN v.accessibilite = 'Moyenne' THEN v.population * 0.02 * 
                (SELECT cout_installation_par_kw FROM type_electrification WHERE nom_type = 'Solaire photovoltaïque')
            ELSE v.population * 0.02 * 
                (SELECT cout_installation_par_kw FROM type_electrification WHERE nom_type = 'Générateur diesel')
        END) / 1000000), 2
    ) AS ratio_population_cout_millions

FROM villages v
WHERE v.statut_electrification = 'Non électrifié'
GROUP BY v.region
ORDER BY ratio_population_cout_millions DESC;

-- Détail par méthode d'électrification
SELECT 'ESTIMATION par méthode d\'électrification' AS detail;

SELECT 
    te.nom_type,
    te.source_energie,
    te.cout_installation_par_kw,
    
    -- Nombre de villages adaptés à cette méthode
    COUNT(CASE WHEN te.nom_type = 'Réseau national' AND v.accessibilite = 'Bonne' THEN 1
               WHEN te.nom_type = 'Solaire photovoltaïque' AND v.accessibilite IN ('Bonne', 'Moyenne') THEN 1
               WHEN te.nom_type = 'Générateur diesel' THEN 1
               ELSE NULL END) AS villages_adaptes,
    
    -- Population totale concernée
    SUM(CASE WHEN te.nom_type = 'Réseau national' AND v.accessibilite = 'Bonne' THEN v.population
             WHEN te.nom_type = 'Solaire photovoltaïque' AND v.accessibilite IN ('Bonne', 'Moyenne') THEN v.population
             WHEN te.nom_type = 'Générateur diesel' THEN v.population
             ELSE 0 END) AS population_adaptee,
    
    -- Budget total estimé
    ROUND(
        SUM(CASE WHEN te.nom_type = 'Réseau national' AND v.accessibilite = 'Facile' THEN v.population * 0.02 * te.cout_installation_par_kw
                 WHEN te.nom_type = 'Solaire photovoltaïque' AND v.accessibilite IN ('Facile', 'Moyenne') THEN v.population * 0.02 * te.cout_installation_par_kw
                 WHEN te.nom_type = 'Générateur diesel' THEN v.population * 0.02 * te.cout_installation_par_kw
                 ELSE 0 END) / 1000000, 2
    ) AS budget_millions_fcfa

FROM type_electrification te
CROSS JOIN villages v
WHERE v.statut_electrification = 'Non électrifié'
GROUP BY te.nom_type, te.source_energie, te.cout_installation_par_kw
HAVING villages_adaptes > 0
ORDER BY budget_millions_fcfa DESC;

-- ===========================================
--  REQUETTES 10 : VILLAGES ÉLECTRIFIABLES SUR UNE LIGNE 
-- ===========================================

-- Ligne électrique Dakar-Tambacounda (axe principal)
-- Paramètres de la ligne Dakar-Tambacounda
-- Dakar: POINT(-17.4441, 14.6937)
-- Tambacounda: POINT(-13.6667, 13.7667)

WITH ligne_electrique AS (
    SELECT 
        -17.4441 AS point_A_lon, 14.6937 AS point_A_lat,  -- Dakar
        -13.6667 AS point_B_lon, 13.7667 AS point_B_lat   -- Tambacounda
),
villages_distances AS (
    SELECT 
        v.*,
        le.point_A_lon, le.point_A_lat, le.point_B_lon, le.point_B_lat,
        
        -- Distance du village à la ligne électrique (formule point-à-ligne)
        ROUND(
            ABS(
                ((le.point_B_lat - le.point_A_lat) * (le.point_A_lon - v.longitude)) - 
                ((le.point_A_lon - le.point_B_lon) * (le.point_A_lat - v.latitude))
            ) / 
            SQRT(
                POW(le.point_B_lat - le.point_A_lat, 2) + 
                POW(le.point_B_lon - le.point_A_lon, 2)
            ) * 111, 2  -- Conversion en km
        ) AS distance_ligne_km,
        
        -- Position sur la ligne (pour optimiser l'ordre d'électrification)
        ROUND(
            (((v.longitude - le.point_A_lon) * (le.point_B_lon - le.point_A_lon)) + 
             ((v.latitude - le.point_A_lat) * (le.point_B_lat - le.point_A_lat))) / 
            (POW(le.point_B_lon - le.point_A_lon, 2) + POW(le.point_B_lat - le.point_A_lat, 2)), 3
        ) AS position_ligne_ratio
        
    FROM villages v
    CROSS JOIN ligne_electrique le
)
SELECT 
    COUNT(*) AS total_villages_electrifiables,
    COUNT(CASE WHEN statut_electrification = 'Non électrifié' THEN 1 END) AS villages_non_electrifies_electrifiables,
    COUNT(CASE WHEN statut_electrification = 'Électrifié' THEN 1 END) AS villages_deja_electrifies,
    SUM(population) AS population_totale_electrifiable,
    SUM(CASE WHEN statut_electrification = 'Non électrifié' THEN population ELSE 0 END) AS population_non_electrifiee_electrifiable,
    ROUND(AVG(distance_ligne_km), 2) AS distance_moyenne_ligne,
    ROUND(AVG(population), 0) AS population_moyenne_village
FROM villages_distances
WHERE distance_ligne_km <= 20;

-- Détail des villages électrifiables sur la ligne Dakar-Tambacounda
SELECT 'DÉTAIL: Villages électrifiables sur ligne Dakar-Tambacounda' AS detail;

WITH ligne_electrique AS (
    SELECT -17.4441 AS point_A_lon, 14.6937 AS point_A_lat, -13.6667 AS point_B_lon, 13.7667 AS point_B_lat
),
villages_distances AS (
    SELECT 
        v.*,
        le.point_A_lon, le.point_A_lat, le.point_B_lon, le.point_B_lat,
        ROUND(
            ABS(((le.point_B_lat - le.point_A_lat) * (le.point_A_lon - v.longitude)) - 
                ((le.point_A_lon - le.point_B_lon) * (le.point_A_lat - v.latitude))) / 
            SQRT(POW(le.point_B_lat - le.point_A_lat, 2) + POW(le.point_B_lon - le.point_A_lon, 2)) * 111, 2
        ) AS distance_ligne_km,
        ROUND(
            (((v.longitude - le.point_A_lon) * (le.point_B_lon - le.point_A_lon)) + 
             ((v.latitude - le.point_A_lat) * (le.point_B_lat - le.point_A_lat))) / 
            (POW(le.point_B_lon - le.point_A_lon, 2) + POW(le.point_B_lat - le.point_A_lat, 2)), 3
        ) AS position_ligne_ratio
    FROM villages v
    CROSS JOIN ligne_electrique le
)
SELECT 
    nom_village,
    region,
    population,
    statut_electrification,
    accessibilite,
    distance_ligne_km,
    position_ligne_ratio,
    CASE 
        WHEN position_ligne_ratio < 0 THEN 'Avant Dakar'
        WHEN position_ligne_ratio > 1 THEN 'Après Tambacounda'
        ELSE CONCAT('Km ', ROUND(position_ligne_ratio * 
            ROUND(ST_Distance_Sphere(POINT(-17.4441, 14.6937), POINT(-13.6667, 13.7667)) / 1000, 0), 0))
    END AS position_sur_ligne,
    
    -- Priorité électrification (score basé sur population et distance)
    ROUND(
        (population / 1000) * 0.6 +  -- 60% population
        ((20 - distance_ligne_km) / 20) * 0.4 * 10, 1  -- 40% proximité ligne
    ) AS score_priorite
    
FROM villages_distances
WHERE distance_ligne_km <= 20
    AND statut_electrification = 'Non électrifié'
ORDER BY position_ligne_ratio ASC, score_priorite DESC
LIMIT 25;

-- ===========================================
--  REQUETTE 11 : CLASSEMENT VILLAGES PAR IMPORTANCE DÉMOGRAPHIQUE
-- ===========================================

-- Classement général avec indicateurs démographiques
SELECT 
    ROW_NUMBER() OVER (ORDER BY population DESC) AS rang_national,
    nom_village,
    region,
    population,
    statut_electrification,
    accessibilite,
    
    -- Catégorie démographique
    CASE 
        WHEN population >= 100000 THEN 'Métropole'
        WHEN population >= 50000 THEN 'Grande ville'
        WHEN population >= 20000 THEN 'Ville moyenne'
        WHEN population >= 10000 THEN 'Petite ville'
        WHEN population >= 5000 THEN 'Gros village'
        WHEN population >= 2000 THEN 'Village moyen'
        WHEN population >= 1000 THEN 'Village'
        ELSE 'Petit village'
    END AS categorie_demographique,
    
    -- Pourcentage de la population nationale
    ROUND(population * 100.0 / (SELECT SUM(population) FROM villages), 3) AS pct_population_nationale,
    
    -- Rang dans la région
    ROW_NUMBER() OVER (PARTITION BY region ORDER BY population DESC) AS rang_regional,
    
    -- Densité relative dans la région
    ROUND(population * 100.0 / 
        (SELECT SUM(population) FROM villages v2 WHERE v2.region = villages.region), 2) AS pct_population_regionale,
    
    -- Priorité électrification basée sur démographie
    CASE 
        WHEN population >= 50000 AND statut_electrification = 'Non électrifié' THEN 'URGENTE'
        WHEN population >= 20000 AND statut_electrification = 'Non électrifié' THEN 'TRÈS HAUTE'
        WHEN population >= 10000 AND statut_electrification = 'Non électrifié' THEN 'HAUTE'
        WHEN population >= 5000 AND statut_electrification = 'Non électrifié' THEN 'MOYENNE'
        WHEN population >= 2000 AND statut_electrification = 'Non électrifié' THEN 'NORMALE'
        WHEN statut_electrification = 'Non électrifié' THEN 'BASSE'
        ELSE 'ÉLECTRIFIÉ'
    END AS priorite_electrification
    
FROM villages
ORDER BY population DESC
LIMIT 30;

-- Classement par région avec statistiques démographiques
SELECT 'CLASSEMENT: Top villages par région' AS classement_regional;

SELECT 
    region,
    nom_village,
    population,
    statut_electrification,
    ROW_NUMBER() OVER (PARTITION BY region ORDER BY population DESC) AS rang_regional,
    
    -- Indicateurs régionaux
    ROUND(population * 100.0 / SUM(population) OVER (PARTITION BY region), 2) AS pct_population_regionale,
    ROUND(population * 100.0 / AVG(population) OVER (PARTITION BY region), 1) AS ratio_population_moyenne_regionale,
    
    -- Comparaison nationale
    ROUND(population * 100.0 / (SELECT AVG(population) FROM villages), 1) AS ratio_population_moyenne_nationale

FROM villages
WHERE population >= 1000  -- Focus sur villages significatifs
ORDER BY region ASC, population DESC;

-- Analyse démographique par catégorie de taille
SELECT 'ANALYSE: Répartition démographique par catégorie' AS analyse_demographique;

SELECT 
    CASE 
        WHEN population >= 100000 THEN 'Métropole (100k+)'
        WHEN population >= 50000 THEN 'Grande ville (50-100k)'
        WHEN population >= 20000 THEN 'Ville moyenne (20-50k)'
        WHEN population >= 10000 THEN 'Petite ville (10-20k)'
        WHEN population >= 5000 THEN 'Gros village (5-10k)'
        WHEN population >= 2000 THEN 'Village moyen (2-5k)'
        WHEN population >= 1000 THEN 'Village (1-2k)'
        ELSE 'Petit village (<1k)'
    END AS categorie_taille,
    
    COUNT(*) AS nombre_villages,
    SUM(population) AS population_totale,
    ROUND(AVG(population), 0) AS population_moyenne,
    MIN(population) AS population_min,
    MAX(population) AS population_max,
    
    -- Pourcentages
    ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM villages), 2) AS pct_villages,
    ROUND(SUM(population) * 100.0 / (SELECT SUM(population) FROM villages), 2) AS pct_population,
    
    -- Électrification
    SUM(CASE WHEN statut_electrification = 'Électrifié' THEN 1 ELSE 0 END) AS electrifies,
    SUM(CASE WHEN statut_electrification = 'Non électrifié' THEN 1 ELSE 0 END) AS non_electrifies,
    ROUND(SUM(CASE WHEN statut_electrification = 'Électrifié' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 1) AS taux_electrification_pct
    
FROM villages
GROUP BY 
    CASE 
        WHEN population >= 100000 THEN 'Métropole (100k+)'
        WHEN population >= 50000 THEN 'Grande ville (50-100k)'
        WHEN population >= 20000 THEN 'Ville moyenne (20-50k)'
        WHEN population >= 10000 THEN 'Petite ville (10-20k)'
        WHEN population >= 5000 THEN 'Gros village (5-10k)'
        WHEN population >= 2000 THEN 'Village moyen (2-5k)'
        WHEN population >= 1000 THEN 'Village (1-2k)'
        ELSE 'Petit village (<1k)'
    END
ORDER BY MIN(population) DESC;

-- Villages les plus importants non électrifiés (priorité absolue)
SELECT 'PRIORITÉ: Villages les plus peuplés non électrifiés' AS priorite_absolue;

SELECT 
    ROW_NUMBER() OVER (ORDER BY population DESC) AS rang_priorite,
    nom_village,
    region,
    population,
    accessibilite,
    
    -- Impact potentiel électrification
    ROUND(population * 0.02, 1) AS puissance_necessaire_kw_estimee,
    ROUND(population * 250, 0) AS budget_electrification_estime_fcfa,  -- 250 FCFA/habitant
    
    -- Distance zone électrifiée la plus proche
    (SELECT MIN(ROUND(ST_Distance_Sphere(POINT(v1.longitude, v1.latitude), POINT(v2.longitude, v2.latitude)) / 1000, 2))
     FROM villages v2 
     WHERE v2.statut_electrification = 'Électrifié') AS distance_zone_electrifiee_km,
    
    -- Classification priorité
    CASE 
        WHEN population >= 50000 THEN '🔴 URGENCE NATIONALE'
        WHEN population >= 20000 THEN '🟠 PRIORITÉ RÉGIONALE'
        WHEN population >= 10000 THEN '🟡 IMPORTANT'
        ELSE '🟢 NORMAL'
    END AS niveau_priorite

FROM villages v1
WHERE statut_electrification = 'Non électrifié'
ORDER BY population DESC
LIMIT 20;

