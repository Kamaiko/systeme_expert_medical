% =============================================================================
% TESTS - Système Expert de Diagnostic Médical
% =============================================================================
% Projet: TP2 - IFT2003
% Description: Cas de test pour valider le système expert (minimum 3 tests)
% =============================================================================

% Chargement de la base de connaissances et du moteur
:- consult('base_connaissances.pl').
:- consult('main.pl').

% -----------------------------------------------------------------------------
% EXÉCUTION DE TOUS LES TESTS
% -----------------------------------------------------------------------------

% executer_tous_les_tests/0 - Lance tous les cas de test
% Affiche un résumé: nombre de tests réussis/échoués

% -----------------------------------------------------------------------------
% CAS DE TEST 1: Diagnostic du Rhume
% -----------------------------------------------------------------------------
% Symptômes présents:
%   - toux = oui
%   - nez_bouche = oui
%   - gorge_irritee = oui
%   - fievre_elevee = non
%   - fatigue_intense = non
% Résultat attendu: rhume
% Syndromes attendus: syndrome_respiratoire

% test_rhume/0 - Cas de test pour le Rhume

% -----------------------------------------------------------------------------
% CAS DE TEST 2: Diagnostic de la Grippe
% -----------------------------------------------------------------------------
% Symptômes présents:
%   - fievre_elevee = oui
%   - toux = oui
%   - fatigue_intense = oui
%   - courbatures = oui
%   - frissons = oui
%   - perte_odorat = non
% Résultat attendu: grippe
% Syndromes attendus: syndrome_respiratoire, syndrome_grippal, syndrome_febrile

% test_grippe/0 - Cas de test pour la Grippe

% -----------------------------------------------------------------------------
% CAS DE TEST 3: Diagnostic du COVID-19
% -----------------------------------------------------------------------------
% Symptômes présents:
%   - fievre_elevee = oui
%   - toux = oui
%   - fatigue_intense = oui
%   - courbatures = oui
%   - perte_odorat = oui
% Résultat attendu: covid19
% Syndromes attendus: syndrome_respiratoire, syndrome_grippal, syndrome_febrile

% test_covid19/0 - Cas de test pour le COVID-19

% -----------------------------------------------------------------------------
% CAS DE TEST 4: Diagnostic de l'Allergie Saisonnière
% -----------------------------------------------------------------------------
% Symptômes présents:
%   - eternuement = oui
%   - nez_qui_coule_clair = oui
%   - yeux_rouges = oui
%   - yeux_qui_piquent = oui
%   - difficultes_respiratoires = non
% Résultat attendu: allergie_saisonniere
% Syndromes attendus: syndrome_allergique, syndrome_oculaire

% test_allergie/0 - Cas de test pour l'Allergie saisonnière

% -----------------------------------------------------------------------------
% CAS DE TEST 5: Diagnostic de la Gastro-entérite
% -----------------------------------------------------------------------------
% Symptômes présents:
%   - diarrhee = oui
%   - vomissements = oui
%   - fievre_elevee = oui
% Résultat attendu: gastro_enterite
% Syndromes attendus: syndrome_digestif, syndrome_febrile

% test_gastro/0 - Cas de test pour la Gastro-entérite

% -----------------------------------------------------------------------------
% UTILITAIRES DE TEST
% -----------------------------------------------------------------------------

% initialiser_test/1 - Prépare l'environnement pour un test
% Paramètre: NomTest (atome)

% definir_symptomes/1 - Définit les symptômes pour un cas de test
% Paramètre: ListeSymptomes (liste de tuples (Symptome, Valeur))
% Exemple: definir_symptomes([(toux, oui), (fievre_elevee, non)])

% verifier_diagnostic/2 - Vérifie si le diagnostic est correct
% Paramètres: DiagnosticAttendu (atome), DiagnosticObtenu (atome)
% Retourne: true si identiques, false sinon

% afficher_resultat_test/2 - Affiche le résultat d'un test
% Paramètres: NomTest (atome), Succes (booléen)
