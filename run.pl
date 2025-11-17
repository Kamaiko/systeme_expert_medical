/**
 * LANCEMENT RAPIDE - Système Expert de Diagnostic Médical
 *
 * @author  Équipe TP2 - IFT2003
 * @version 1.0
 * @date    Novembre 2025
 *
 * @description
 * Fichier de lancement automatique du système expert de diagnostic médical.
 * Charge le moteur d'inférence et lance immédiatement la session interactive.
 *
 * Utilisation:
 *   swipl run.pl
 *
 * @remarks
 * - Charge automatiquement src/main.pl (qui charge src/base_connaissances.pl)
 * - Lance start/0 automatiquement via initialization/1
 * - Alternative à lancer manuellement: ?- consult('src/main.pl'), start.
 *
 * @see src/main.pl pour le moteur d'inférence principal
 */

% =============================================================================
% Projet: TP2 - IFT2003 Intelligence Artificielle 1
% Lancement automatique du système expert
% =============================================================================

:- consult('src/main.pl').
:- initialization(start, main).
