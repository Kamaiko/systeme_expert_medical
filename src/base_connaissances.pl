/**
 * BASE DE CONNAISSANCES - Système Expert de Diagnostic Médical
 *
 * @author  Équipe TP2 - IFT2003
 * @version 1.0
 * @date    Novembre 2025
 *
 * @description
 * Ce module contient la base de connaissances médicale pour un système expert
 * de diagnostic utilisant le chaînage arrière (backward chaining). Il implémente
 * une architecture hiérarchique à 3 niveaux pour diagnostiquer 10 maladies courantes
 * à partir de symptômes observés.
 *
 * Architecture:
 *   - NIVEAU 1: 21 symptômes de base (+ 2 cascades conditionnelles)
 *   - NIVEAU 2: 8 syndromes intermédiaires (combinaisons de symptômes)
 *   - NIVEAU 3: 10 maladies diagnostiquées (combinaisons de syndromes)
 *
 * Règles d'inférence:
 *   - 10 règles Niveau 1→2 (Symptômes → Syndromes)
 *   - 10 règles Niveau 2→3 (Syndromes → Maladies)
 *   - Total: 20 règles conformes aux exigences (20-30 règles)
 *
 * Maladies diagnostiquées:
 *   1. Grippe              6. Allergie saisonnière
 *   2. COVID-19            7. Asthme
 *   3. Bronchite           8. Migraine
 *   4. Rhume               9. Gastro-entérite
 *   5. Angine             10. Conjonctivite
 *
 * Syndromes intermédiaires:
 *   - syndrome_respiratoire, syndrome_febrile, syndrome_grippal
 *   - syndrome_allergique, syndrome_oculaire, syndrome_digestif
 *   - syndrome_neurologique, syndrome_orl
 *
 * @remarks
 * - Ce module est conçu pour être chargé par main.pl
 * - Utilise le prédicat verifier_symptome/1 défini dans main.pl
 * - Format sans accents pour compatibilité maximale
 * - Recommandations médicales fournies à titre informatif uniquement
 *
 * @see main.pl pour le moteur d'inférence
 * @see tests.pl pour la validation (18 tests unitaires)
 */

% =============================================================================
% Projet: TP2 - IFT2003 Intelligence Artificielle 1
% Architecture: 3 niveaux (Symptômes → Syndromes → Maladies)
% Total: 20 règles (10 symptômes→syndromes + 10 syndromes→maladies)
% =============================================================================

% -----------------------------------------------------------------------------
% NIVEAU 1 → NIVEAU 2: Règles Symptômes → Syndromes (10 règles)
% -----------------------------------------------------------------------------

% Syndrome Respiratoire (3 règles pour flexibilité)
% R1: Fièvre légère ∧ Toux → Respiratoire
% R2: Fièvre élevée ∧ Toux → Respiratoire
% R3: Nez bouché ∧ Gorge irritée → Respiratoire

% Syndrome Fébrile (1 règle - SIMPLIFIÉ)
% R4: Fièvre élevée → Fébrile
% Note: Frissons ne sont plus obligatoires (règle souple)

% Syndrome Grippal (1 règle stricte)
% R5: Fatigue intense ∧ Courbatures ∧ Fièvre élevée → Grippal

% Syndrome Allergique (1 règle - SIMPLIFIÉ)
% R6: Éternuements → Allergique
% Note: Nez clair n'est plus obligatoire (règle souple)

% Syndrome Oculaire (1 règle)
% R7: Yeux rouges ∧ Yeux qui piquent → Oculaire

% Syndrome Digestif (1 règle)
% R8: Diarrhée ∧ Vomissements → Digestif

% Syndrome Neurologique (1 règle)
% R9: Mal tête intense ∧ Photophobie → Neurologique

% Syndrome ORL (1 règle - SIMPLIFIÉ)
% R10: Mal gorge intense → ORL
% Note: Difficulté avaler n'est plus obligatoire (règle souple)

% -----------------------------------------------------------------------------
% NIVEAU 2 → NIVEAU 3: Règles Syndromes → Maladies (10 règles)
% -----------------------------------------------------------------------------

% R11: Grippe = Respiratoire ∧ Grippal ∧ Fébrile ∧ ¬Perte odorat
% R12: COVID-19 = Respiratoire ∧ Grippal ∧ Fébrile ∧ Perte odorat
% R13: Bronchite = Respiratoire ∧ Fièvre légère ∧ Toux productive
% R14: Rhume = Respiratoire ∧ ¬Fébrile ∧ ¬Grippal
% R15: Angine = ORL ∧ Fébrile
% R16: Allergie saisonnière = Allergique ∧ Oculaire ∧ ¬Difficultés respiratoires
% R17: Asthme = Respiratoire ∧ Allergique ∧ Wheezing ∧ Difficultés respiratoires
% R18: Migraine = Neurologique
% R19: Gastro-entérite = Digestif ∧ Fébrile
% R20: Conjonctivite = Oculaire ∧ Sécrétions purulentes

% -----------------------------------------------------------------------------
% SYMPTÔMES DE BASE (21 questions + 2 cascades)
% -----------------------------------------------------------------------------
% COVID/Unique: perte_odorat
%
% Fièvre (avec CASCADE):
%   - fievre (question principale)
%     → Si OUI: fievre_elevee (sous-question "Est-elle élevée >38.5°C?")
%       → Si OUI: enregistre fievre_elevee=oui, fievre_legere=non
%       → Si NON: enregistre fievre_elevee=non, fievre_legere=oui
%     → Si NON: enregistre fievre_elevee=non, fievre_legere=non
%   - frissons
%
% Respiratoires (avec CASCADE pour toux):
%   - toux (question principale)
%     → Si OUI: toux_productive (sous-question "Est-elle productive?")
%       → Si OUI: enregistre toux_productive=oui
%       → Si NON: enregistre toux_productive=non
%     → Si NON: enregistre toux_productive=non
%   - nez_bouche
%   - difficultes_respiratoires
%   - wheezing
%
% Gorge (ORL): gorge_irritee, mal_gorge_intense, difficulte_avaler
% Nasaux/Allergiques: eternuement, nez_qui_coule_clair
% Oculaires: yeux_rouges, yeux_qui_piquent, secretions_purulentes
% Systémiques/Grippaux: fatigue_intense, courbatures
% Neurologiques: mal_tete_intense, photophobie
% Digestifs: diarrhee, vomissements
% -----------------------------------------------------------------------------

% =============================================================================
% ORDRE THÉMATIQUE DES QUESTIONS (Backward Chaining)
% =============================================================================
% IMPORTANT: Avec backward chaining, l'ordre exact dépend de quelle maladie
% est testée. Cependant, pour favoriser un flow naturel par thèmes, organiser
% les clauses de syndromes pour que les symptômes d'un même thème soient
% vérifiés ensemble.
%
% Organisation thématique recommandée:
%
%   Thème 1: COVID/Unique
%   1. perte_odorat
%
%   Thème 2: Fièvre et frissons
%   2. fievre → 2a. fievre_elevee (cascade si oui)
%   3. frissons
%
%   Thème 3: Respiratoires
%   4. toux → 4a. toux_productive (cascade si oui)
%   5. nez_bouche
%   6. difficultes_respiratoires
%   7. wheezing
%
%   Thème 4: Gorge (ORL)
%   8. gorge_irritee
%   9. mal_gorge_intense
%   10. difficulte_avaler
%
%   Thème 5: Nasaux/Allergiques
%   11. eternuement
%   12. nez_qui_coule_clair
%
%   Thème 6: Oculaires
%   13. yeux_rouges
%   14. yeux_qui_piquent
%   15. secretions_purulentes
%
%   Thème 7: Systémiques/Grippaux
%   16. fatigue_intense
%   17. courbatures
%
%   Thème 8: Neurologiques
%   18. mal_tete_intense
%   19. photophobie
%
%   Thème 9: Digestifs
%   20. diarrhee
%   21. vomissements
%
% Le backward chaining posera uniquement les questions nécessaires selon
% l'hypothèse testée, mais cet ordre thématique améliore l'expérience
% utilisateur en regroupant les questions liées.
% =============================================================================

% =============================================================================
% CHANGEMENTS DEPUIS VERSION 23 RÈGLES
% =============================================================================
% ❌ Supprimé R4 ancien: syndrome_febrile nécessitait frissons
%    → Maintenant R4: fievre_elevee suffit (règle souple)
%
% ❌ Supprimé R7 ancien: syndrome_allergique nécessitait nez_qui_coule_clair
%    → Maintenant R6: eternuement suffit (règle souple)
%
% ❌ Supprimé R12 ancien: syndrome_orl nécessitait difficulte_avaler
%    → Maintenant R10: mal_gorge_intense suffit (règle souple)
%
% Total: 20 règles (réduit de 23) - Conforme limite 20-30 règles de l'énoncé
% =============================================================================

% =============================================================================
% IMPLEMENTATION DES REGLES
% =============================================================================

% -----------------------------------------------------------------------------
% NIVEAU 1 → NIVEAU 2: Symptomes → Syndromes (10 regles)
% -----------------------------------------------------------------------------

% R1: Fievre legere ∧ Toux → Respiratoire
syndrome_respiratoire :-
    verifier_symptome(fievre_legere),
    verifier_symptome(toux).

% R2: Fievre elevee ∧ Toux → Respiratoire
syndrome_respiratoire :-
    verifier_symptome(fievre_elevee),
    verifier_symptome(toux).

% R3: Nez bouche ∧ Gorge irritee → Respiratoire
syndrome_respiratoire :-
    verifier_symptome(nez_bouche),
    verifier_symptome(gorge_irritee).

% R4: Fievre elevee → Febrile (SIMPLIFIE)
syndrome_febrile :-
    verifier_symptome(fievre_elevee).

% R5: Fatigue intense ∧ Courbatures ∧ Fievre elevee → Grippal
syndrome_grippal :-
    verifier_symptome(fatigue_intense),
    verifier_symptome(courbatures),
    verifier_symptome(fievre_elevee).

% R6: Eternuements → Allergique (SIMPLIFIE)
syndrome_allergique :-
    verifier_symptome(eternuement).

% R7: Yeux rouges ∧ Yeux qui piquent → Oculaire
syndrome_oculaire :-
    verifier_symptome(yeux_rouges),
    verifier_symptome(yeux_qui_piquent).

% R8: Diarrhee ∧ Vomissements → Digestif
syndrome_digestif :-
    verifier_symptome(diarrhee),
    verifier_symptome(vomissements).

% R9: Mal tete intense ∧ Photophobie → Neurologique
syndrome_neurologique :-
    verifier_symptome(mal_tete_intense),
    verifier_symptome(photophobie).

% R10: Mal gorge intense → ORL (SIMPLIFIE)
syndrome_orl :-
    verifier_symptome(mal_gorge_intense).

% -----------------------------------------------------------------------------
% NIVEAU 2 → NIVEAU 3: Syndromes → Maladies (10 regles)
% -----------------------------------------------------------------------------

% R11: Grippe = Respiratoire ∧ Grippal ∧ Febrile ∧ ¬Perte odorat
grippe :-
    syndrome_respiratoire,
    syndrome_grippal,
    syndrome_febrile,
    \+ verifier_symptome(perte_odorat).

% R12: COVID-19 = Perte odorat ∧ Respiratoire ∧ Grippal ∧ Febrile
% NOTE: perte_odorat EN PREMIER (discriminant unique) pour optimiser backward chaining
covid19 :-
    verifier_symptome(perte_odorat),
    syndrome_respiratoire,
    syndrome_grippal,
    syndrome_febrile.

% R13: Bronchite = Respiratoire ∧ Fievre legere ∧ Toux productive
bronchite :-
    syndrome_respiratoire,
    verifier_symptome(fievre_legere),
    verifier_symptome(toux_productive).

% R14: Rhume = Respiratoire ∧ ¬Febrile ∧ ¬Grippal
rhume :-
    syndrome_respiratoire,
    \+ syndrome_febrile,
    \+ syndrome_grippal.

% R15: Angine = ORL ∧ Febrile
angine :-
    syndrome_orl,
    syndrome_febrile.

% R16: Allergie saisonniere = Allergique ∧ Oculaire ∧ ¬Difficultes respiratoires
allergie :-
    syndrome_allergique,
    syndrome_oculaire,
    \+ verifier_symptome(difficultes_respiratoires).

% R17: Asthme = Respiratoire ∧ Allergique ∧ Wheezing ∧ Difficultes respiratoires
asthme :-
    syndrome_respiratoire,
    syndrome_allergique,
    verifier_symptome(wheezing),
    verifier_symptome(difficultes_respiratoires).

% R18: Migraine = Neurologique
migraine :-
    syndrome_neurologique.

% R19: Gastro-enterite = Digestif ∧ Febrile
gastro_enterite :-
    syndrome_digestif,
    syndrome_febrile.

% R20: Conjonctivite = Oculaire ∧ Secretions purulentes
conjonctivite :-
    syndrome_oculaire,
    verifier_symptome(secretions_purulentes).

% -----------------------------------------------------------------------------
% RECOMMANDATIONS MEDICALES (SANS ACCENTS)
% -----------------------------------------------------------------------------

recommandation(grippe, [
    "Repos au lit pendant 3-5 jours",
    "Hydratation abondante (eau, tisanes)",
    "Paracetamol pour fievre et douleurs",
    "Consultation si symptomes persistent >7 jours"
]).

recommandation(covid19, [
    "Isolement immediat pendant 5-10 jours",
    "Repos et hydratation",
    "Surveillance oxymetrie (consulter si <95%)",
    "Consulter medecin pour evaluation et traitement",
    "Informer contacts proches"
]).

recommandation(bronchite, [
    "Repos et hydratation",
    "Eviter fumee et irritants respiratoires",
    "Humidificateur d'air recommande",
    "Consulter si fievre persiste >3 jours",
    "Antibiotiques seulement si prescrits"
]).

recommandation(rhume, [
    "Repos leger",
    "Hydratation reguliere",
    "Lavages nasaux serum physiologique",
    "Consultation si aggravation apres 7 jours"
]).

recommandation(angine, [
    "Consulter medecin pour test streptocoque",
    "Antibiotiques si angine bacterienne",
    "Antalgiques pour douleur gorge",
    "Repos et alimentation molle"
]).

recommandation(allergie, [
    "Identifier et eviter allergenes",
    "Antihistaminiques si necessaire",
    "Lavages nasaux serum physiologique",
    "Consulter allergologue pour tests cutanes"
]).

recommandation(asthme, [
    "CONSULTATION URGENTE recommandee",
    "Eviter allergenes et irritants",
    "Bronchodilatateur si prescrit",
    "Plan d'action asthme avec medecin",
    "Surveillance reguliere fonction respiratoire"
]).

recommandation(migraine, [
    "Repos dans piece sombre et calme",
    "Antalgiques des premiers symptomes",
    "Identifier facteurs declenchants",
    "Consulter si migraines frequentes (>4/mois)",
    "Tenir journal des crises"
]).

recommandation(gastro_enterite, [
    "Hydratation intensive (SRO recommande)",
    "Alimentation legere (riz, banane, compote)",
    "Eviter produits laitiers temporairement",
    "Consulter si deshydratation ou sang dans selles",
    "Repos et hygiene des mains"
]).

recommandation(conjonctivite, [
    "Lavages oculaires serum physiologique",
    "Ne pas partager serviettes/oreillers",
    "Consulter si secretions purulentes persistantes",
    "Antibiotiques topiques si bacterienne",
    "Eviter frottement yeux"
]).
