% =============================================================================
% BASE DE CONNAISSANCES - Système Expert de Diagnostic Médical
% =============================================================================
% Projet: TP2 - IFT2003
% Description: Base de règles pour le diagnostic de 10 maladies
% Architecture: 3 niveaux (Symptômes → Syndromes → Maladies)
% Total: 23 règles (13 symptômes→syndromes + 10 syndromes→maladies)
% =============================================================================

% -----------------------------------------------------------------------------
% NIVEAU 1 → NIVEAU 2: Règles Symptômes → Syndromes (13 règles)
% -----------------------------------------------------------------------------

% Syndrome Respiratoire (3 règles pour flexibilité)
% R1: Fièvre légère + Toux → Respiratoire
% R2: Fièvre élevée + Toux → Respiratoire
% R3: Nez bouché + Gorge irritée → Respiratoire

% Syndrome Fébrile (2 règles)
% R4: Fièvre élevée + Frissons → Fébrile
% R5: Fièvre élevée → Fébrile

% Syndrome Grippal (1 règle stricte)
% R6: Fatigue intense + Courbatures + Fièvre élevée → Grippal

% Syndrome Allergique (2 règles)
% R7: Éternuements + Nez clair → Allergique
% R8: Éternuements → Allergique

% Syndrome Oculaire (1 règle)
% R9: Yeux rouges + Yeux qui piquent → Oculaire

% Syndrome Digestif (1 règle)
% R10: Diarrhée + Vomissements → Digestif

% Syndrome Neurologique (1 règle)
% R11: Mal tête intense + Photophobie → Neurologique

% Syndrome ORL (2 règles)
% R12: Mal gorge intense + Difficulté avaler → ORL
% R13: Mal gorge intense → ORL

% -----------------------------------------------------------------------------
% NIVEAU 2 → NIVEAU 3: Règles Syndromes → Maladies (10 règles)
% -----------------------------------------------------------------------------

% R14: Grippe = Respiratoire + Grippal + Fébrile + Fatigue intense (sans perte odorat)
% R15: COVID-19 = Respiratoire + Grippal + Fébrile + Perte odorat
% R16: Bronchite = Respiratoire + Fébrile + Toux productive
% R17: Rhume = Respiratoire (sans Fébrile, sans Grippal)
% R18: Angine = ORL + Fébrile
% R19: Allergie saisonnière = Allergique + Oculaire (sans difficultés respiratoires)
% R20: Asthme = Respiratoire + Allergique + Difficultés respiratoires + Wheezing
% R21: Migraine = Neurologique
% R22: Gastro-entérite = Digestif + Fébrile
% R23: Conjonctivite = Oculaire + Sécrétions purulentes

% -----------------------------------------------------------------------------
% SYMPTÔMES DE BASE (17 symptômes - Conventions snake_case)
% -----------------------------------------------------------------------------
% Fébriles: fievre_legere, fievre_elevee, frissons
% Respiratoires: toux, toux_productive, nez_bouche, gorge_irritee
% Grippaux: fatigue_intense, courbatures
% COVID: perte_odorat
% Neurologiques: mal_tete_intense, photophobie
% ORL: mal_gorge_intense, difficulte_avaler
% Digestifs: diarrhee, vomissements
% Allergiques: eternuement, nez_qui_coule_clair
% Oculaires: yeux_rouges, yeux_qui_piquent, secretions_purulentes
% Respiratoires avancés: difficultes_respiratoires, wheezing
% -----------------------------------------------------------------------------
