-- ============================================
-- DONNÉES COMPLÈTES POUR TOUTES LES TABLES
-- Projet Électrification Rurale Sénégal - ASER
-- Jeu de données réaliste pour tests complets
-- ============================================
USE ASER_DB;
-- Désactivation des vérifications pour insertion rapide
SET FOREIGN_KEY_CHECKS = 0;
SET AUTOCOMMIT = 0;

-- ============================================
-- 1. TYPES D'ÉLECTRIFICATION (10 types)
-- ============================================
INSERT INTO type_electrification (nom_type, source_energie, cout_installation_par_kw, cout_maintenance_annuel, duree_vie_moyenne, cout_remplacement) VALUES
('Raccordement réseau national', 'Réseau national', 800.00, 50.00, 25, 200.00),
('Panneau solaire domestique', 'Solaire', 1200.00, 80.00, 15, 800.00),
('Mini-réseau solaire', 'Solaire', 1500.00, 120.00, 20, 1000.00),
('Éolienne communautaire', 'Éolienne', 2000.00, 150.00, 20, 1200.00),
('Générateur diesel', 'Hydrocarbure', 600.00, 200.00, 10, 500.00),
('Système hybride solaire-diesel', 'Hybride', 1800.00, 180.00, 18, 1100.00),
('Micro-centrale hydroélectrique', 'Hydroélectrique', 2500.00, 100.00, 30, 1500.00),
('Biomasse communautaire', 'Biomasse', 1000.00, 90.00, 15, 700.00),
('Micro-réseau hybride', 'Micro-réseau', 1600.00, 140.00, 18, 950.00),
('Solaire individuel', 'Solaire', 900.00, 60.00, 12, 600.00);

-- ============================================
-- 2. VILLAGES (100 villages représentatifs)
-- ============================================
INSERT INTO villages (nom_village, latitude, longitude, population, region, statut_electrification, date_electrifaction, accessibilite) VALUES
-- RÉGION DAKAR (Taux électrification élevé: ~85%)
('Bargny', 14.693700, -17.444100, 1200, 'Dakar', 'Électrifié', '2020-03-15', 'Facile'),
('Yenne', 14.716700, -17.383300, 850, 'Dakar', 'Électrifié', '2019-11-20', 'Facile'),
('Diamniadio', 14.700000, -17.183300, 2100, 'Dakar', 'Électrifié', '2021-01-10', 'Facile'),
('Rufisque Est', 14.717200, -17.279400, 1800, 'Dakar', 'Électrifié', '2020-08-15', 'Facile'),
('Sebikotane', 14.743900, -17.141700, 950, 'Dakar', 'Électrifié', '2022-03-22', 'Moyenne'),
('Sangalkam', 14.769400, -17.233300, 1150, 'Dakar', 'Électrifié', '2021-07-08', 'Facile'),
('Malika Nord', 14.788900, -17.377800, 780, 'Dakar', 'Non électrifié', NULL, 'Moyenne'),
('Keur Massar', 14.783300, -17.316700, 920, 'Dakar', 'Électrifié', '2023-01-15', 'Moyenne'),

-- RÉGION THIÈS (Taux électrification moyen: ~70%)
('Pout', 14.769400, -17.048300, 950, 'Thiès', 'Électrifié', '2022-06-12', 'Moyenne'),
('Khombole', 14.783300, -17.016700, 650, 'Thiès', 'Non électrifié', NULL, 'Moyenne'),
('Sindia', 14.616700, -16.933300, 1800, 'Thiès', 'Électrifié', '2023-02-28', 'Facile'),
('Bambey', 14.702800, -16.459400, 1500, 'Thiès', 'Électrifié', '2021-07-18', 'Facile'),
('Diourbel Nord', 14.665600, -16.229200, 750, 'Thiès', 'Non électrifié', NULL, 'Difficile'),
('Thiès Ouest', 14.788300, -16.926700, 2200, 'Thiès', 'Électrifié', '2019-12-05', 'Facile'),
('Mboro', 14.791700, -16.975000, 680, 'Thiès', 'Non électrifié', NULL, 'Moyenne'),
('Tivaouane Sud', 14.950000, -16.816700, 1100, 'Thiès', 'Électrifié', '2020-09-14', 'Moyenne'),

-- RÉGION SAINT-LOUIS (Taux électrification moyen: ~60%)
('Dagana', 16.516700, -15.500000, 1100, 'Saint-Louis', 'Électrifié', '2021-09-20', 'Facile'),
('Richard Toll', 16.466700, -15.700000, 1800, 'Saint-Louis', 'Électrifié', '2020-12-05', 'Facile'),
('Ross Béthio', 16.283300, -15.800000, 950, 'Saint-Louis', 'Non électrifié', NULL, 'Moyenne'),
('Saint-Louis Banlieue', 16.018900, -16.489200, 1200, 'Saint-Louis', 'Électrifié', '2021-05-22', 'Moyenne'),
('Podor', 16.651900, -14.970000, 880, 'Saint-Louis', 'Non électrifié', NULL, 'Difficile'),
('Fanaye', 16.533300, -15.200000, 720, 'Saint-Louis', 'Non électrifié', NULL, 'Moyenne'),
('Ndiaye', 16.100000, -16.233300, 1050, 'Saint-Louis', 'Électrifié', '2022-11-08', 'Moyenne'),

-- RÉGION KOLDA (Taux électrification faible: ~25%)
('Vélingara', 13.150000, -14.116700, 1250, 'Kolda', 'Non électrifié', NULL, 'Difficile'),
('Dabo', 12.783300, -12.333300, 1100, 'Kolda', 'Non électrifié', NULL, 'Difficile'),
('Saré Yoba Diéga', 13.050000, -14.083300, 750, 'Kolda', 'Non électrifié', NULL, 'Moyenne'),
('Médina Yoro Foulah', 13.216700, -12.350000, 1350, 'Kolda', 'Électrifié', '2023-08-15', 'Moyenne'),
('Kolda Centre', 12.890000, -14.950000, 2200, 'Kolda', 'Électrifié', '2022-03-10', 'Facile'),
('Bagadadji', 13.083300, -14.533300, 980, 'Kolda', 'Non électrifié', NULL, 'Difficile'),
('Saré Bidji', 13.200000, -13.783300, 650, 'Kolda', 'Non électrifié', NULL, 'Difficile'),
('Dioulacolon', 12.950000, -13.400000, 1150, 'Kolda', 'Électrifié', '2023-11-20', 'Moyenne'),

-- RÉGION TAMBACOUNDA (Taux électrification faible: ~30%)
('Goudiry', 14.183300, -12.716700, 890, 'Tambacounda', 'Non électrifié', NULL, 'Difficile'),
('Bakel', 14.900000, -12.466700, 1050, 'Tambacounda', 'Non électrifié', NULL, 'Difficile'),
('Kidira', 14.450000, -12.216700, 600, 'Tambacounda', 'Électrifié', '2023-05-10', 'Moyenne'),
('Tambacounda Centre', 13.766700, -13.666700, 1900, 'Tambacounda', 'Électrifié', '2020-11-25', 'Facile'),
('Koumpentoum', 14.547200, -14.547200, 650, 'Tambacounda', 'Non électrifié', NULL, 'Moyenne'),
('Dialakoto', 14.166700, -13.350000, 520, 'Tambacounda', 'Non électrifié', NULL, 'Difficile'),
('Missirah', 13.650000, -13.283300, 780, 'Tambacounda', 'Non électrifié', NULL, 'Moyenne'),
('Kothiary', 14.083300, -12.583300, 450, 'Tambacounda', 'Électrifié', '2024-02-18', 'Difficile'),

-- RÉGION KAOLACK (Taux électrification moyen: ~45%)
('Nioro du Rip', 13.750000, -15.783300, 1200, 'Kaolack', 'Électrifié', '2022-03-18', 'Moyenne'),
('Kaffrine', 14.116700, -15.550000, 1400, 'Kaolack', 'Non électrifié', NULL, 'Moyenne'),
('Malem Hodar', 14.016700, -15.816700, 750, 'Kaolack', 'Non électrifié', NULL, 'Difficile'),
('Kaolack Sud', 14.152800, -16.072800, 1800, 'Kaolack', 'Électrifié', '2021-12-08', 'Facile'),
('Birkelane', 14.266700, -15.650000, 920, 'Kaolack', 'Non électrifié', NULL, 'Moyenne'),
('Ndoffane', 14.033300, -15.950000, 680, 'Kaolack', 'Électrifié', '2023-06-25', 'Moyenne'),
('Koungheul', 14.800000, -14.800000, 1050, 'Kaolack', 'Non électrifié', NULL, 'Moyenne'),

-- RÉGION FATICK (Taux électrification moyen: ~40%)
('Foundiougne', 14.133300, -16.466700, 980, 'Fatick', 'Électrifié', '2021-07-22', 'Moyenne'),
('Gossas', 14.500000, -16.066700, 850, 'Fatick', 'Non électrifié', NULL, 'Moyenne'),
('Sokone', 13.883300, -16.383300, 1150, 'Fatick', 'Non électrifié', NULL, 'Difficile'),
('Fatick Centre', 14.333300, -16.416700, 1300, 'Fatick', 'Électrifié', '2022-09-14', 'Facile'),
('Diofior', 14.216700, -16.483300, 670, 'Fatick', 'Non électrifié', NULL, 'Moyenne'),
('Toubacouta', 13.950000, -16.450000, 580, 'Fatick', 'Non électrifié', NULL, 'Difficile'),
('Niakhar', 14.183300, -16.133300, 720, 'Fatick', 'Électrifié', '2023-04-12', 'Moyenne'),

-- RÉGION LOUGA (Taux électrification moyen: ~38%)
('Louga Centre', 15.616700, -16.233300, 1600, 'Louga', 'Électrifié', '2020-06-30', 'Facile'),
('Linguère', 15.400000, -15.116700, 1200, 'Louga', 'Électrifié', '2021-11-15', 'Moyenne'),
('Kébémer', 15.383300, -16.450000, 850, 'Louga', 'Non électrifié', NULL, 'Moyenne'),
('Dahra', 15.350000, -15.483300, 650, 'Louga', 'Non électrifié', NULL, 'Difficile'),
('Yang Yang', 15.766700, -16.466700, 720, 'Louga', 'Non électrifié', NULL, 'Moyenne'),
('Sakal', 15.533300, -15.800000, 480, 'Louga', 'Non électrifié', NULL, 'Difficile'),

-- RÉGION MATAM (Taux électrification faible: ~25%)
('Matam Centre', 15.655600, -13.250000, 1100, 'Matam', 'Électrifié', '2022-08-20', 'Moyenne'),
('Kanel', 15.550000, -13.183300, 980, 'Matam', 'Non électrifié', NULL, 'Moyenne'),
('Ranérou', 15.300000, -13.966700, 750, 'Matam', 'Non électrifié', NULL, 'Difficile'),
('Ourossogui', 15.650000, -13.350000, 820, 'Matam', 'Électrifié', '2023-12-10', 'Moyenne'),
('Thilogne', 15.583300, -13.500000, 650, 'Matam', 'Non électrifié', NULL, 'Difficile'),

-- RÉGION KÉDOUGOU (Taux électrification très faible: ~18%)
('Kédougou Centre', 12.555600, -12.183300, 1800, 'Kédougou', 'Électrifié', '2021-05-08', 'Moyenne'),
('Saraya', 12.800000, -11.750000, 650, 'Kédougou', 'Non électrifié', NULL, 'Difficile'),
('Salémata', 12.900000, -12.050000, 580, 'Kédougou', 'Non électrifié', NULL, 'Difficile'),
('Bandafassi', 12.533300, -12.550000, 420, 'Kédougou', 'Non électrifié', NULL, 'Difficile'),
('Dindefelo', 12.466700, -12.466700, 380, 'Kédougou', 'Non électrifié', NULL, 'Difficile'),

-- RÉGION ZIGUINCHOR (Taux électrification moyen: ~45%)
('Ziguinchor Centre', 12.583300, -16.266700, 2100, 'Ziguinchor', 'Électrifié', '2019-10-15', 'Facile'),
('Oussouye', 12.483300, -16.550000, 750, 'Ziguinchor', 'Électrifié', '2022-07-20', 'Moyenne'),
('Bignona', 12.816700, -16.233300, 1200, 'Ziguinchor', 'Non électrifié', NULL, 'Moyenne'),
('Djibonker', 12.666700, -16.100000, 580, 'Ziguinchor', 'Non électrifié', NULL, 'Difficile'),
('Tendouck', 12.700000, -16.683300, 450, 'Ziguinchor', 'Non électrifié', NULL, 'Moyenne'),

-- RÉGION SÉDHIOU (Taux électrification faible: ~22%)
('Sédhiou Centre', 12.708300, -15.558300, 1300, 'Sédhiou', 'Électrifié', '2023-03-25', 'Moyenne'),
('Bounkiling', 13.016700, -15.566700, 680, 'Sédhiou', 'Non électrifié', NULL, 'Difficile'),
('Goudomp', 12.566700, -15.116700, 520, 'Sédhiou', 'Non électrifié', NULL, 'Moyenne'),
('Diannah Malary', 12.900000, -15.783300, 450, 'Sédhiou', 'Non électrifié', NULL, 'Difficile'),

-- RÉGION KAFFRINE (Taux électrification moyen: ~35%)
('Kaffrine Centre', 14.116700, -15.550000, 1500, 'Kaffrine', 'Électrifié', '2022-01-30', 'Facile'),
('Birkelane Ville', 14.266700, -15.650000, 980, 'Kaffrine', 'Non électrifié', NULL, 'Moyenne'),
('Koungheul Nord', 14.800000, -14.800000, 720, 'Kaffrine', 'Non électrifié', NULL, 'Moyenne'),
('Malem Hodar Est', 14.016700, -15.816700, 650, 'Kaffrine', 'Électrifié', '2023-09-15', 'Moyenne'),

-- RÉGION DIOURBEL (Taux électrification moyen: ~55%)
('Diourbel Centre', 14.650000, -16.233300, 1800, 'Diourbel', 'Électrifié', '2020-04-12', 'Facile'),
('Touba', 14.850000, -15.883300, 3200, 'Diourbel', 'Électrifié', '2019-08-20', 'Facile'),
('Mbacké', 14.800000, -15.916700, 1400, 'Diourbel', 'Électrifié', '2021-02-18', 'Moyenne'),
('Bambey Est', 14.702800, -16.459400, 850, 'Diourbel', 'Non électrifié', NULL, 'Moyenne'),
('Ndame', 14.583300, -16.350000, 680, 'Diourbel', 'Non électrifié', NULL, 'Difficile'),
('Khelcom', 14.716700, -16.083300, 520, 'Diourbel', 'Électrifié', '2023-07-05', 'Moyenne');

-- ============================================
-- 3. ÉLECTRIFICATIONS (pour tous les villages électrifiés)
-- ============================================
INSERT INTO electrification (id_village, id_type_electrification, date_electrification, puissance_installee, heures_coupure_moyennes) VALUES
-- Dakar (réseau national principalement)
(1, 1, '2020-03-15', 50.5, 2.5),   -- Bargny
(2, 1, '2019-11-20', 35.2, 1.8),   -- Yenne
(3, 1, '2021-01-10', 85.0, 1.2),   -- Diamniadio
(4, 1, '2020-08-15', 72.3, 2.0),   -- Rufisque Est
(5, 1, '2022-03-22', 42.8, 2.2),   -- Sebikotane
(6, 1, '2021-07-08', 58.5, 1.9),   -- Sangalkam
(8, 1, '2023-01-15', 38.7, 2.8),   -- Keur Massar

-- Thiès (mixte réseau national et solaire)
(9, 3, '2022-06-12', 45.8, 3.2),   -- Pout (mini-réseau solaire)
(11, 1, '2023-02-28', 70.5, 2.0),  -- Sindia
(12, 1, '2021-07-18', 58.7, 2.8),  -- Bambey
(14, 1, '2019-12-05', 92.1, 1.5),  -- Thiès Ouest
(16, 2, '2020-09-14', 35.4, 5.2),  -- Tivaouane Sud (solaire domestique)

-- Saint-Louis (réseau national)
(17, 1, '2021-09-20', 55.0, 2.8),  -- Dagana
(18, 1, '2020-12-05', 75.8, 1.5),  -- Richard Toll
(20, 1, '2021-05-22', 48.3, 3.2),  -- Saint-Louis Banlieue
(23, 6, '2022-11-08', 42.5, 4.8),  -- Ndiaye (hybride)

-- Kolda (principalement solaire)
(27, 2, '2023-08-15', 25.5, 8.5),  -- Médina Yoro Foulah
(28, 1, '2022-03-10', 95.2, 4.5),  -- Kolda Centre
(31, 3, '2023-11-20', 38.9, 6.2),  -- Dioulacolon (mini-réseau)

-- Tambacounda (générateurs et solaire)
(35, 5, '2023-05-10', 20.0, 12.0), -- Kidira (diesel)
(36, 1, '2020-11-25', 78.9, 5.2),  -- Tambacounda Centre
(40, 2, '2024-02-18', 18.5, 9.8),  -- Kothiary (solaire)

-- Kaolack (réseau national et hybride)
(41, 1, '2022-03-18', 60.2, 3.5),  -- Nioro du Rip
(44, 1, '2021-12-08', 82.5, 2.8),  -- Kaolack Sud
(46, 6, '2023-06-25', 35.7, 5.5),  -- Ndoffane (hybride)

-- Fatick (hybride et réseau)
(49, 6, '2021-07-22', 40.8, 4.2),  -- Foundiougne
(52, 1, '2022-09-14', 66.7, 3.0),  -- Fatick Centre
(55, 2, '2023-04-12', 28.4, 7.1),  -- Niakhar (solaire)

-- Louga (réseau national)
(57, 1, '2020-06-30', 78.5, 3.8),  -- Louga Centre
(58, 1, '2021-11-15', 58.9, 4.2),  -- Linguère

-- Matam (générateurs et solaire)
(63, 5, '2022-08-20', 35.8, 10.5), -- Matam Centre (diesel)
(66, 2, '2023-12-10', 22.7, 8.9),  -- Ourossogui (solaire)

-- Kédougou (hybride)
(69, 6, '2021-05-08', 65.4, 7.8),  -- Kédougou Centre

-- Ziguinchor (réseau national)
(74, 1, '2019-10-15', 89.3, 3.5),  -- Ziguinchor Centre
(75, 2, '2022-07-20', 31.2, 6.8),  -- Oussouye (solaire)

-- Sédhiou (solaire)
(79, 2, '2023-03-25', 42.6, 8.2),  -- Sédhiou Centre

-- Kaffrine (réseau et solaire)
(83, 1, '2022-01-30', 68.9, 4.1),  -- Kaffrine Centre
(86, 3, '2023-09-15', 35.8, 5.9),  -- Malem Hodar Est (mini-réseau)

-- Diourbel (réseau national)
(87, 1, '2020-04-12', 85.7, 2.9),  -- Diourbel Centre
(88, 1, '2019-08-20', 145.8, 2.1), -- Touba
(89, 1, '2021-02-18', 67.3, 3.4),  -- Mbacké
(92, 2, '2023-07-05', 24.9, 6.5);  -- Khelcom (solaire)

-- ============================================
-- 4. PROJETS D'ÉLECTRIFICATION (40 projets)
-- ============================================
INSERT INTO projets_electrification (id_village, id_type_electrification, nom_projet, statut_projet, date_debut, date_fin_prevue, date_fin_reelle, cout_total_projet, villages_beneficiaires, source_financement, responsable_projet) VALUES
-- Projets terminés (électrifications déjà réalisées)
(1, 1, 'Électrification Bargny Phase 1', 'Terminé', '2020-01-10', '2020-03-20', '2020-03-15', 125000.00, 1, 'Banque Mondiale', 'Mamadou Diop'),
(3, 1, 'Raccordement Diamniadio', 'Terminé', '2020-11-15', '2021-01-15', '2021-01-10', 280000.00, 1, 'AFD', 'Fatou Sall'),
(11, 1, 'Extension réseau Sindia', 'Terminé', '2022-12-01', '2023-03-15', '2023-02-28', 180000.00, 1, 'AFD', 'Fatou Sall'),
(28, 1, 'Électrification Kolda Centre', 'Terminé', '2021-11-15', '2022-03-25', '2022-03-10', 295000.00, 1, 'BOAD', 'Cheikh Fall'),
(36, 1, 'Raccordement Tambacounda', 'Terminé', '2020-08-10', '2020-12-05', '2020-11-25', 350000.00, 1, 'Banque Mondiale', 'Mamadou Diop'),
(44, 1, 'Extension Kaolack Sud', 'Terminé', '2021-09-20', '2021-12-20', '2021-12-08', 245000.00, 1, 'Union Européenne', 'Aida Ndiaye'),
(74, 1, 'Modernisation Ziguinchor', 'Terminé', '2019-06-01', '2019-10-30', '2019-10-15', 420000.00, 1, 'Gouvernement', 'Ibrahima Sarr'),
(88, 1, 'Renforcement Touba', 'Terminé', '2019-05-15', '2019-08-30', '2019-08-20', 680000.00, 2, 'BOAD', 'Cheikh Fall'),

-- Projets en cours
(7, 2, 'Solaire Malika Nord', 'En cours', '2025-04-01', '2025-08-30', NULL, 95000.00, 1, 'USAID', 'Ousmane Ba'),
(10, 3, 'Mini-réseau Khombole', 'En cours', '2025-04-15', '2025-10-20', NULL, 140000.00, 2, 'Union Européenne', 'Aida Ndiaye'),
(24, 2, 'Solaire Vélingara', 'En cours', '2025-03-15', '2025-12-20', NULL, 185000.00, 3, 'AFD', 'Marième Touré'),
(25, 2, 'Solaire Dabo', 'En cours', '2025-05-01', '2026-01-15', NULL, 165000.00, 2, 'USAID', 'Ousmane Ba'),
(33, 5, 'Générateur Goudiry', 'En cours', '2025-06-10', '2025-11-30', NULL, 120000.00, 1, 'Gouvernement', 'Mamadou Ndiaye'),
(42, 1, 'Extension Kaffrine', 'En cours', '2025-03-01', '2025-09-15', NULL, 275000.00, 1, 'Banque Mondiale', 'Mamadou Diop'),
(50, 3, 'Mini-réseau Gossas', 'En cours', '2025-07-01', '2026-02-28', NULL, 195000.00, 2, 'AFD', 'Fatou Sall'),

-- Projets planifiés
(13, 2, 'Solaire Diourbel Nord', 'Planifié', '2025-08-01', '2026-01-15', NULL, 85000.00, 1, 'Gouvernement', 'Ibrahima Sarr'),
(15, 3, 'Mini-réseau Mboro', 'Planifié', '2025-09-15', '2026-04-30', NULL, 158000.00, 2, 'Union Européenne', 'Aida Ndiaye'),
(19, 1, 'Extension Ross Béthio', 'Planifié', '2025-10-01', '2026-03-30', NULL, 165000.00, 1, 'BOAD', 'Cheikh Fall'),
(21, 4, 'Éolien Podor', 'Planifié', '2025-11-01', '2026-08-30', NULL, 450000.00, 3, 'BOAD', 'Marième Touré'),
(26, 2, 'Solaire Bagadadji', 'Planifié', '2025-12-01', '2026-06-30', NULL, 125000.00, 1, 'USAID', 'Ousmane Ba'),
(29, 3, 'Mini-réseau Saré Bidji', 'Planifié', '2026-01-15', '2026-08-15', NULL, 145000.00, 2, 'AFD', 'Fatou Sall'),
(34, 5, 'Générateur Bakel', 'Planifié', '2025-10-15', '2026-02-28', NULL, 98000.00, 1, 'Gouvernement', 'Mamadou Ndiaye'),
(43, 2, 'Solaire Malem Hodar', 'Planifié', '2025-11-20', '2026-05-30', NULL, 78000.00, 1, 'USAID', 'Ousmane Ba'),
(45, 2, 'Solaire Birkelane', 'Planifié', '2026-02-01', '2026-08-30', NULL, 115000.00, 1, 'Union Européenne', 'Aida Ndiaye'),
(47, 1, 'Extension Koungheul', 'Planifié', '2025-09-01', '2026-01-15', NULL, 185000.00, 1, 'Banque Mondiale', 'Mamadou Diop'),
(51, 3, 'Mini-réseau Sokone', 'Planifié', '2025-11-01', '2026-05-30', NULL, 175000.00, 2, 'AFD', 'Fatou Sall'),
(59, 2, 'Solaire Kébémer', 'Planifié', '2025-12-15', '2026-07-15', NULL, 108000.00, 1, 'USAID', 'Ousmane Ba'),
(64, 5, 'Générateur Kanel', 'Planifié', '2026-01-01', '2026-06-30', NULL, 92000.00, 1, 'Gouvernement', 'Mamadou Ndiaye'),
(70, 6, 'Hybride Saraya', 'Planifié', '2025-08-15', '2026-03-30', NULL, 225000.00, 2, 'BOAD', 'Cheikh Fall'),

-- Projets de maintenance
(3, 1, 'Maintenance Diamniadio', 'Maintenance', '2025-07-10', '2025-08-15', NULL, 25000.00, 1, 'ASER', 'Ousmane Diallo'),
(88, 1, 'Maintenance Touba', 'Maintenance', '2025-06-20', '2025-07-25', NULL, 35000.00, 1, 'ASER', 'Aminata Sy'),

-- Projets suspendus
(77, 2, 'Solaire Bignona', 'Suspendu', '2025-05-01', '2025-11-30', NULL, 125000.00, 1, 'Union Européenne', 'Aida Ndiaye'),
(81, 3, 'Mini-réseau Bounkiling', 'Suspendu', '2025-04-15', '2025-12-15', NULL, 168000.00, 2, 'AFD', 'Fatou Sall');

-- ============================================
-- 5. CONSOMMATIONS (données historiques et mensuelles)
-- ============================================
INSERT INTO consommations (id_village, annee, mois, consommation_kwh) VALUES
-- Consommations annuelles (villages électrifiés depuis longtemps)
-- Dakar
(1, 2022, NULL, 42620.50), (1, 2023, NULL, 45620.50), (1, 2024, NULL, 48750.25),
(2, 2022, NULL, 29150.75), (2, 2023, NULL, 32150.75), (2, 2024, NULL, 34200.80),
(3, 2022, NULL, 72450.20), (3, 2023, NULL, 78450.20), (3, 2024, NULL, 82100.15),
(4, 2022, NULL, 65380.40), (4, 2023, NULL, 68950.60), (4, 2024, NULL, 72800.90),
(5, 2023, NULL, 38750.30), (5, 2024, NULL, 42100.85),
(6, 2022, NULL, 52180.65), (6, 2023, NULL, 55420.90), (6, 2024, NULL, 58950.40),

-- Thiès
(9, 2023, NULL, 38300.30), (9, 2024, NULL, 42300.60),
(11, 2023, NULL, 65850.40), (11, 2024, NULL, 68950.90),
(12, 2022, NULL, 51680.25), (12, 2023, NULL, 54920.80), (12, 2024, NULL, 58150.45),
(14, 2022, NULL, 82150.90), (14, 2023, NULL, 86750.40), (14, 2024, NULL, 91250.80),

-- Saint-Louis
(17, 2022, NULL, 48950.60), (17, 2023, NULL, 52180.90), (17, 2024, NULL, 55420.30),
(18, 2022, NULL, 68750.40), (18, 2023, NULL, 72890.80), (18, 2024, NULL, 76950.20),
(20, 2022, NULL, 42850.30), (20, 2023, NULL, 45620.70), (20, 2024, NULL, 48750.10),

-- Kolda
(27, 2023, NULL, 28750.25), (27, 2024, NULL, 31200.80),
(28, 2022, NULL, 89250.60), (28, 2023, NULL, 92100.40), (28, 2024, NULL, 95750.20),
(31, 2024, NULL, 35680.90),

-- Tambacounda
(35, 2023, NULL, 18950.40), (35, 2024, NULL, 21350.60),
(36, 2022, NULL, 75680.30), (36, 2023, NULL, 79850.70), (36, 2024, NULL, 83920.50),

-- Autres régions (échantillon)
(41, 2022, NULL, 54780.90), (41, 2023, NULL, 58250.40), (41, 2024, NULL, 61890.80),
(44, 2022, NULL, 78950.20), (44, 2023, NULL, 83420.60), (44, 2024, NULL, 87850.90),
(49, 2022, NULL, 36850.40), (49, 2023, NULL, 39420.80), (49, 2024, NULL, 42180.50),
(52, 2023, NULL, 58950.30), (52, 2024, NULL, 62480.70),
(57, 2022, NULL, 71250.80), (57, 2023, NULL, 75680.20), (57, 2024, NULL, 79850.60),
(74, 2022, NULL, 95680.40), (74, 2023, NULL, 101250.80), (74, 2024, NULL, 106820.20),
(87, 2022, NULL, 82450.90), (87, 2023, NULL, 87650.30), (87, 2024, NULL, 92850.70),
(88, 2022, NULL, 168950.40), (88, 2023, NULL, 178420.80), (88, 2024, NULL, 187890.20),

-- Consommations mensuelles 2024 (échantillon de villages)
-- Bargny (village id=1) - variation saisonnière réaliste
(1, 2024, 1, 3850.25), (1, 2024, 2, 3520.80), (1, 2024, 3, 3980.45), (1, 2024, 4, 4125.60),
(1, 2024, 5, 4380.20), (1, 2024, 6, 4850.75), (1, 2024, 7, 5120.30), (1, 2024, 8, 4920.15),
(1, 2024, 9, 4650.90), (1, 2024, 10, 4280.40), (1, 2024, 11, 3950.70), (1, 2024, 12, 3648.95),

-- Diamniadio (village id=3) - gros consommateur
(3, 2024, 1, 6420.80), (3, 2024, 2, 6150.25), (3, 2024, 3, 6980.45), (3, 2024, 4, 7250.60),
(3, 2024, 5, 7680.90), (3, 2024, 6, 8120.75), (3, 2024, 7, 8450.30), (3, 2024, 8, 8020.15),
(3, 2024, 9, 7580.40), (3, 2024, 10, 7120.85), (3, 2024, 11, 6650.25), (3, 2024, 12, 6273.45),

-- Kolda Centre (village id=28) - consommation modérée
(28, 2024, 1, 7420.30), (28, 2024, 2, 7180.60), (28, 2024, 3, 8150.90), (28, 2024, 4, 8680.40),
(28, 2024, 5, 9250.80), (28, 2024, 6, 8950.20), (28, 2024, 7, 8420.70), (28, 2024, 8, 8180.50),
(28, 2024, 9, 7950.30), (28, 2024, 10, 7680.90), (28, 2024, 11, 7320.40), (28, 2024, 12, 6940.10),

-- Touba (village id=88) - très gros consommateur
(88, 2024, 1, 14820.40), (88, 2024, 2, 14250.80), (88, 2024, 3, 15680.20), (88, 2024, 4, 16950.60),
(88, 2024, 5, 18420.90), (88, 2024, 6, 17850.30), (88, 2024, 7, 16980.70), (88, 2024, 8, 16420.50),
(88, 2024, 9, 15750.90), (88, 2024, 10, 15120.40), (88, 2024, 11, 14580.80), (88, 2024, 12, 13910.65);

-- ============================================
-- 6. APPAREILS ÉLECTRIQUES (répartition réaliste)
-- ============================================
INSERT INTO appareils_electriques (id_village, nom_appareil, type_appareil, nombre_appareils_par_type, priorite_usage) VALUES
-- ÉCLAIRAGE (quasi universel dans villages électrifiés)
(1, 'Ampoule LED', 'Éclairage', 125, 'Essentiel'), (2, 'Ampoule LED', 'Éclairage', 95, 'Essentiel'),
(3, 'Ampoule LED', 'Éclairage', 180, 'Essentiel'), (4, 'Ampoule LED', 'Éclairage', 165, 'Essentiel'),
(5, 'Ampoule LED', 'Éclairage', 85, 'Essentiel'), (6, 'Ampoule LED', 'Éclairage', 110, 'Essentiel'),
(8, 'Ampoule LED', 'Éclairage', 92, 'Essentiel'), (9, 'Ampoule LED', 'Éclairage', 78, 'Essentiel'),
(11, 'Ampoule LED', 'Éclairage', 150, 'Essentiel'), (12, 'Ampoule LED', 'Éclairage', 135, 'Essentiel'),
(14, 'Ampoule LED', 'Éclairage', 220, 'Essentiel'), (16, 'Ampoule LED', 'Éclairage', 98, 'Essentiel'),
(17, 'Ampoule LED', 'Éclairage', 110, 'Essentiel'), (18, 'Ampoule LED', 'Éclairage', 160, 'Essentiel'),
(20, 'Ampoule LED', 'Éclairage', 108, 'Essentiel'), (23, 'Ampoule LED', 'Éclairage', 95, 'Essentiel'),
(27, 'Ampoule LED', 'Éclairage', 75, 'Essentiel'), (28, 'Ampoule LED', 'Éclairage', 200, 'Essentiel'),
(31, 'Ampoule LED', 'Éclairage', 88, 'Essentiel'), (35, 'Ampoule LED', 'Éclairage', 45, 'Essentiel'),
(36, 'Ampoule LED', 'Éclairage', 175, 'Essentiel'), (40, 'Ampoule LED', 'Éclairage', 35, 'Essentiel'),
(41, 'Ampoule LED', 'Éclairage', 115, 'Essentiel'), (44, 'Ampoule LED', 'Éclairage', 155, 'Essentiel'),
(46, 'Ampoule LED', 'Éclairage', 68, 'Essentiel'), (49, 'Ampoule LED', 'Éclairage', 82, 'Essentiel'),
(52, 'Ampoule LED', 'Éclairage', 125, 'Essentiel'), (55, 'Ampoule LED', 'Éclairage', 58, 'Essentiel'),
(57, 'Ampoule LED', 'Éclairage', 145, 'Essentiel'), (58, 'Ampoule LED', 'Éclairage', 108, 'Essentiel'),
(63, 'Ampoule LED', 'Éclairage', 98, 'Essentiel'), (66, 'Ampoule LED', 'Éclairage', 72, 'Essentiel'),
(69, 'Ampoule LED', 'Éclairage', 168, 'Essentiel'), (74, 'Ampoule LED', 'Éclairage', 235, 'Essentiel'),
(75, 'Ampoule LED', 'Éclairage', 68, 'Essentiel'), (79, 'Ampoule LED', 'Éclairage', 118, 'Essentiel'),
(83, 'Ampoule LED', 'Éclairage', 138, 'Essentiel'), (86, 'Ampoule LED', 'Éclairage', 65, 'Essentiel'),
(87, 'Ampoule LED', 'Éclairage', 168, 'Essentiel'), (88, 'Ampoule LED', 'Éclairage', 358, 'Essentiel'),
(89, 'Ampoule LED', 'Éclairage', 128, 'Essentiel'), (92, 'Ampoule LED', 'Éclairage', 48, 'Essentiel'),

-- TÉLÉPHONES PORTABLES (très répandu)
(1, 'Téléphone portable', 'Communication', 350, 'Essentiel'), (2, 'Téléphone portable', 'Communication', 280, 'Essentiel'),
(3, 'Téléphone portable', 'Communication', 520, 'Essentiel'), (4, 'Téléphone portable', 'Communication', 485, 'Essentiel'),
(5, 'Téléphone portable', 'Communication', 240, 'Essentiel'), (6, 'Téléphone portable', 'Communication', 315, 'Essentiel'),
(8, 'Téléphone portable', 'Communication', 275, 'Essentiel'), (9, 'Téléphone portable', 'Communication', 235, 'Essentiel'),
(11, 'Téléphone portable', 'Communication', 420, 'Essentiel'), (12, 'Téléphone portable', 'Communication', 385, 'Essentiel'),
(14, 'Téléphone portable', 'Communication', 635, 'Essentiel'), (16, 'Téléphone portable', 'Communication', 285, 'Essentiel'),
(17, 'Téléphone portable', 'Communication', 290, 'Essentiel'), (18, 'Téléphone portable', 'Communication', 485, 'Essentiel'),
(20, 'Téléphone portable', 'Communication', 325, 'Essentiel'), (23, 'Téléphone portable', 'Communication', 285, 'Essentiel'),
(27, 'Téléphone portable', 'Communication', 320, 'Essentiel'), (28, 'Téléphone portable', 'Communication', 580, 'Essentiel'),
(31, 'Téléphone portable', 'Communication', 295, 'Essentiel'), (35, 'Téléphone portable', 'Communication', 165, 'Essentiel'),
(36, 'Téléphone portable', 'Communication', 515, 'Essentiel'), (40, 'Téléphone portable', 'Communication', 125, 'Essentiel'),
(41, 'Téléphone portable', 'Communication', 365, 'Essentiel'), (44, 'Téléphone portable', 'Communication', 485, 'Essentiel'),
(57, 'Téléphone portable', 'Communication', 445, 'Essentiel'), (74, 'Téléphone portable', 'Communication', 685, 'Essentiel'),
(87, 'Téléphone portable', 'Communication', 525, 'Essentiel'), (88, 'Téléphone portable', 'Communication', 1085, 'Essentiel'),

-- RADIOS (très répandu)
(1, 'Radio FM', 'Communication', 95, 'Important'), (3, 'Radio FM', 'Communication', 140, 'Important'),
(4, 'Radio FM', 'Communication', 125, 'Important'), (11, 'Radio FM', 'Communication', 120, 'Important'),
(14, 'Radio FM', 'Communication', 165, 'Important'), (18, 'Radio FM', 'Communication', 135, 'Important'),
(28, 'Radio FM', 'Communication', 165, 'Important'), (36, 'Radio FM', 'Communication', 145, 'Important'),
(44, 'Radio FM', 'Communication', 135, 'Important'), (57, 'Radio FM', 'Communication', 125, 'Important'),
(74, 'Radio FM', 'Communication', 185, 'Important'), (87, 'Radio FM', 'Communication', 145, 'Important'),
(88, 'Radio FM', 'Communication', 285, 'Important'), (89, 'Radio FM', 'Communication', 118, 'Important'),

-- TÉLÉVISIONS (moyennement répandu)
(1, 'Télévision LCD', 'Communication', 45, 'Confort'), (3, 'Télévision LCD', 'Communication', 85, 'Confort'),
(4, 'Télévision LCD', 'Communication', 78, 'Confort'), (11, 'Télévision LCD', 'Communication', 60, 'Confort'),
(14, 'Télévision LCD', 'Communication', 108, 'Confort'), (18, 'Télévision LCD', 'Communication', 70, 'Confort'),
(28, 'Télévision LCD', 'Communication', 95, 'Confort'), (36, 'Télévision LCD', 'Communication', 85, 'Confort'),
(44, 'Télévision LCD', 'Communication', 78, 'Confort'), (57, 'Télévision LCD', 'Communication', 68, 'Confort'),
(74, 'Télévision LCD', 'Communication', 125, 'Confort'), (87, 'Télévision LCD', 'Communication', 88, 'Confort'),
(88, 'Télévision LCD', 'Communication', 195, 'Confort'), (89, 'Télévision LCD', 'Communication', 75, 'Confort'),

-- VENTILATEURS (répandu, surtout saison chaude)
(1, 'Ventilateur', 'Électroménager', 80, 'Confort'), (3, 'Ventilateur', 'Électroménager', 120, 'Confort'),
(4, 'Ventilateur', 'Électroménager', 108, 'Confort'), (11, 'Ventilateur', 'Électroménager', 90, 'Confort'),
(14, 'Ventilateur', 'Électroménager', 135, 'Confort'), (18, 'Ventilateur', 'Électroménager', 95, 'Confort'),
(28, 'Ventilateur', 'Électroménager', 118, 'Confort'), (36, 'Ventilateur', 'Électroménager', 105, 'Confort'),
(44, 'Ventilateur', 'Électroménager', 98, 'Confort'), (57, 'Ventilateur', 'Électroménager', 88, 'Confort'),
(74, 'Ventilateur', 'Électroménager', 148, 'Confort'), (87, 'Ventilateur', 'Électroménager', 108, 'Confort'),
(88, 'Ventilateur', 'Électroménager', 225, 'Confort'), (89, 'Ventilateur', 'Électroménager', 95, 'Confort'),

-- RÉFRIGÉRATEURS (moins répandu, important)
(1, 'Réfrigérateur', 'Électroménager', 25, 'Important'), (3, 'Réfrigérateur', 'Électroménager', 50, 'Important'),
(4, 'Réfrigérateur', 'Électroménager', 45, 'Important'), (11, 'Réfrigérateur', 'Électroménager', 35, 'Important'),
(14, 'Réfrigérateur', 'Électroménager', 68, 'Important'), (18, 'Réfrigérateur', 'Électroménager', 40, 'Important'),
(28, 'Réfrigérateur', 'Électroménager', 58, 'Important'), (36, 'Réfrigérateur', 'Électroménager', 48, 'Important'),
(44, 'Réfrigérateur', 'Électroménager', 42, 'Important'), (57, 'Réfrigérateur', 'Électroménager', 38, 'Important'),
(74, 'Réfrigérateur', 'Électroménager', 78, 'Important'), (87, 'Réfrigérateur', 'Électroménager', 52, 'Important'),
(88, 'Réfrigérateur', 'Électroménager', 125, 'Important'), (89, 'Réfrigérateur', 'Électroménager', 42, 'Important'),

-- FERS À REPASSER (répandu)
(1, 'Fer à repasser', 'Électroménager', 38, 'Confort'), (3, 'Fer à repasser', 'Électroménager', 68, 'Confort'),
(11, 'Fer à repasser', 'Électroménager', 55, 'Confort'), (14, 'Fer à repasser', 'Électroménager', 85, 'Confort'),
(18, 'Fer à repasser', 'Électroménager', 58, 'Confort'), (28, 'Fer à repasser', 'Électroménager', 75, 'Confort'),
(36, 'Fer à repasser', 'Électroménager', 65, 'Confort'), (74, 'Fer à repasser', 'Électroménager', 95, 'Confort'),
(88, 'Fer à repasser', 'Électroménager', 158, 'Confort'), (89, 'Fer à repasser', 'Électroménager', 55, 'Confort'),

-- ÉQUIPEMENTS PROFESSIONNELS
(1, 'Machine à coudre électrique', 'Professionnel', 12, 'Important'),
(3, 'Machine à coudre électrique', 'Professionnel', 18, 'Important'),
(11, 'Machine à coudre électrique', 'Professionnel', 15, 'Important'),
(14, 'Machine à coudre électrique', 'Professionnel', 25, 'Important'),
(18, 'Machine à coudre électrique', 'Professionnel', 16, 'Important'),
(28, 'Machine à coudre électrique', 'Professionnel', 22, 'Important'),
(74, 'Machine à coudre électrique', 'Professionnel', 28, 'Important'),
(88, 'Machine à coudre électrique', 'Professionnel', 45, 'Important'),

(11, 'Moulin à grain électrique', 'Professionnel', 3, 'Important'),
(14, 'Moulin à grain électrique', 'Professionnel', 5, 'Important'),
(18, 'Moulin à grain électrique', 'Professionnel', 4, 'Important'),
(28, 'Moulin à grain électrique', 'Professionnel', 6, 'Important'),
(36, 'Moulin à grain électrique', 'Professionnel', 4, 'Important'),
(44, 'Moulin à grain électrique', 'Professionnel', 4, 'Important'),
(74, 'Moulin à grain électrique', 'Professionnel', 7, 'Important'),
(88, 'Moulin à grain électrique', 'Professionnel', 12, 'Important'),

-- ÉQUIPEMENTS MÉDICAUX (centres de santé)
(3, 'Réfrigérateur médical', 'Médical', 2, 'Essentiel'),
(14, 'Réfrigérateur médical', 'Médical', 3, 'Essentiel'),
(18, 'Réfrigérateur médical', 'Médical', 2, 'Essentiel'),
(28, 'Réfrigérateur médical', 'Médical', 3, 'Essentiel'),
(36, 'Réfrigérateur médical', 'Médical', 2, 'Essentiel'),
(44, 'Réfrigérateur médical', 'Médical', 2, 'Essentiel'),
(57, 'Réfrigérateur médical', 'Médical', 2, 'Essentiel'),
(74, 'Réfrigérateur médical', 'Médical', 4, 'Essentiel'),
(87, 'Réfrigérateur médical', 'Médical', 3, 'Essentiel'),
(88, 'Réfrigérateur médical', 'Médical', 6, 'Essentiel'),

-- ÉQUIPEMENTS ÉDUCATIFS (écoles)
(3, 'Ordinateur portable', 'Éducatif', 8, 'Important'),
(14, 'Ordinateur portable', 'Éducatif', 12, 'Important'),
(18, 'Ordinateur portable', 'Éducatif', 6, 'Important'),
(28, 'Ordinateur portable', 'Éducatif', 10, 'Important'),
(36, 'Ordinateur portable', 'Éducatif', 8, 'Important'),
(44, 'Ordinateur portable', 'Éducatif', 7, 'Important'),
(57, 'Ordinateur portable', 'Éducatif', 9, 'Important'),
(74, 'Ordinateur portable', 'Éducatif', 15, 'Important'),
(87, 'Ordinateur portable', 'Éducatif', 11, 'Important'),
(88, 'Ordinateur portable', 'Éducatif', 25, 'Important'),

-- ÉQUIPEMENTS AGRICOLES
(11, 'Pompe à eau électrique', 'Agriculture', 2, 'Important'),
(14, 'Pompe à eau électrique', 'Agriculture', 3, 'Important'),
(17, 'Pompe à eau électrique', 'Agriculture', 2, 'Important'),
(18, 'Pompe à eau électrique', 'Agriculture', 4, 'Important'),
(28, 'Pompe à eau électrique', 'Agriculture', 3, 'Important'),
(36, 'Pompe à eau électrique', 'Agriculture', 2, 'Important'),
(44, 'Pompe à eau électrique', 'Agriculture', 3, 'Important'),
(57, 'Pompe à eau électrique', 'Agriculture', 2, 'Important'),
(74, 'Pompe à eau électrique', 'Agriculture', 4, 'Important'),
(88, 'Pompe à eau électrique', 'Agriculture', 8, 'Important');

-- ============================================
-- 7. LIGNES CONTINUES (infrastructure réseau)
-- ============================================
INSERT INTO ligne_continue (id_electrification, id_village, id_type_electrification, nom_ligne, point_depart, point_arrivee, trace_ligne) VALUES

-- Lignes réseau national Dakar-Thiès
(1, 1, 1, 'Ligne Dakar-Bargny', 
 ST_GeomFromText('POINT(-17.4441 14.6937)'), 
 ST_GeomFromText('POINT(-17.4441 14.6937)'),
 ST_GeomFromText('LINESTRING(-17.4441 14.6937, -17.4441 14.6937)')),

(2, 2, 1, 'Ligne Bargny-Yenne', 
 ST_GeomFromText('POINT(-17.4441 14.6937)'), 
 ST_GeomFromText('POINT(-17.3833 14.7167)'),
 ST_GeomFromText('LINESTRING(-17.4441 14.6937, -17.4200 14.7000, -17.3833 14.7167)')),

(3, 3, 1, 'Ligne Dakar-Diamniadio', 
 ST_GeomFromText('POINT(-17.4441 14.6937)'), 
 ST_GeomFromText('POINT(-17.1833 14.7000)'),
 ST_GeomFromText('LINESTRING(-17.4441 14.6937, -17.3500 14.7100, -17.2500 14.7050, -17.1833 14.7000)')),

-- Lignes vers Thiès
(11, 11, 1, 'Extension Thiès-Sindia', 
 ST_GeomFromText('POINT(-16.9267 14.7883)'), 
 ST_GeomFromText('POINT(-16.9333 14.6167)'),
 ST_GeomFromText('LINESTRING(-16.9267 14.7883, -16.9300 14.7000, -16.9333 14.6167)')),

(12, 12, 1, 'Ligne Thiès-Bambey', 
 ST_GeomFromText('POINT(-16.9267 14.7883)'), 
 ST_GeomFromText('POINT(-16.4594 14.7028)'),
 ST_GeomFromText('LINESTRING(-16.9267 14.7883, -16.7500 14.7500, -16.5500 14.7200, -16.4594 14.7028)')),

-- Lignes Saint-Louis
(17, 17, 1, 'Ligne Saint-Louis-Dagana', 
 ST_GeomFromText('POINT(-16.4892 16.0189)'), 
 ST_GeomFromText('POINT(-15.5000 16.5167)'),
 ST_GeomFromText('LINESTRING(-16.4892 16.0189, -16.0000 16.2000, -15.7500 16.3500, -15.5000 16.5167)')),

(18, 18, 1, 'Extension Dagana-Richard Toll', 
 ST_GeomFromText('POINT(-15.5000 16.5167)'), 
 ST_GeomFromText('POINT(-15.7000 16.4667)'),
 ST_GeomFromText('LINESTRING(-15.5000 16.5167, -15.6000 16.4900, -15.7000 16.4667)')),

-- Ligne principale Kaolack
(41, 41, 1, 'Ligne Kaolack principale', 
 ST_GeomFromText('POINT(-16.0728 14.1528)'), 
 ST_GeomFromText('POINT(-15.7833 13.7500)'),
 ST_GeomFromText('LINESTRING(-16.0728 14.1528, -15.9500 14.0000, -15.8500 13.8500, -15.7833 13.7500)')),

-- Réseau Diourbel-Touba  
(57, 57, 1, 'Ligne Diourbel-Touba', 
 ST_GeomFromText('POINT(-16.2333 14.6500)'), 
 ST_GeomFromText('POINT(-15.8833 14.8500)'),
 ST_GeomFromText('LINESTRING(-16.2333 14.6500, -16.1000 14.7000, -15.9500 14.7500, -15.8833 14.8500)')),

(58, 58, 1, 'Extension Touba-Mbacké', 
 ST_GeomFromText('POINT(-15.8833 14.8500)'), 
 ST_GeomFromText('POINT(-15.9167 14.8000)'),
 ST_GeomFromText('LINESTRING(-15.8833 14.8500, -15.9000 14.8250, -15.9167 14.8000)'));


