% =============================================================================
% MAIN - Système Expert de Diagnostic Médical
% =============================================================================
% Projet: TP2 - IFT2003
% Description: Moteur d'inférence (backward chaining) + Interface utilisateur
% =============================================================================

% Chargement de la base de connaissances
:- consult('base_connaissances.pl').

% -----------------------------------------------------------------------------
% POINT D'ENTRÉE PRINCIPAL
% -----------------------------------------------------------------------------

% Démarrer le système expert
% demarrer/0 - Lance une session de diagnostic

% -----------------------------------------------------------------------------
% MOTEUR D'INFÉRENCE (Chaînage arrière)
% -----------------------------------------------------------------------------

% diagnostiquer/1 - Tente de diagnostiquer une maladie
% Paramètre: Maladie (atome)
% Retourne: true si la maladie est diagnostiquée, false sinon

% verifier_syndrome/1 - Vérifie si un syndrome est présent
% Paramètre: Syndrome (atome)
% Retourne: true si le syndrome est détecté, false sinon

% verifier_symptome/1 - Vérifie si un symptôme est présent
% Paramètre: Symptome (atome)
% Retourne: true si le symptôme est confirmé, false sinon

% -----------------------------------------------------------------------------
% INTERFACE UTILISATEUR
% -----------------------------------------------------------------------------

% poser_question/1 - Pose une question à l'utilisateur
% Paramètre: Symptome (atome)
% Format: "Avez-vous [symptome] ?"
%         1. Oui
%         2. Non
%         3. Je ne sais pas

% traduire_symptome/2 - Traduit un symptôme Prolog en français
% Paramètres: SymptomeProlog (atome), SymptomeFrancais (string)
% Exemple: traduire_symptome(fievre_elevee, "de la fièvre élevée (>38.5°C)")

% lire_reponse/1 - Lit et valide la réponse utilisateur (1/2/3)
% Paramètre: Reponse (integer)
% Retourne: 1 (Oui), 2 (Non), ou 3 (Je ne sais pas)

% afficher_diagnostic/1 - Affiche le diagnostic final
% Paramètre: Maladie (atome)
% Format: "Diagnostic: [Maladie]"
%         "Syndromes identifiés: [Liste]"

% afficher_aucun_diagnostic/0 - Message si aucun diagnostic n'est trouvé

% -----------------------------------------------------------------------------
% GESTION DE LA MÉMOIRE (Dynamic facts)
% -----------------------------------------------------------------------------

% Faits dynamiques pour stocker les réponses de l'utilisateur
:- dynamic reponse/2.  % reponse(Symptome, Valeur) où Valeur = oui/non/inconnu

% reinitialiser/0 - Efface toutes les réponses mémorisées

% -----------------------------------------------------------------------------
% UTILITAIRES
% -----------------------------------------------------------------------------

% traduire_maladie/2 - Traduit le nom Prolog d'une maladie en français
% Paramètres: MaladieProlog (atome), MaladieFrancais (string)
% Exemple: traduire_maladie(grippe, "Grippe")

% traduire_syndrome/2 - Traduit un syndrome Prolog en français
% Paramètres: SyndromeProlog (atome), SyndromeFrancais (string)
% Exemple: traduire_syndrome(syndrome_respiratoire, "Syndrome respiratoire")
