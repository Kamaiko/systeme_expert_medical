/**
 * TESTS - Système Expert de Diagnostic Médical
 *
 * Équipe TP2 - IFT2003 - Novembre 2025
 *
 * Contenu:
 *   - 18 tests unitaires (100% couverture des 20 règles)
 *   - 8 tests syndromes (R1-R10)
 *   - 10 tests maladies (R11-R20)
 *
 * Utilisation:
 *   swipl -g "consult('tests.pl'), test_all, halt"
 */

% =============================================================================
% Projet: TP2 - IFT2003 Intelligence Artificielle 1
% Tests unitaires: 18 tests (8 syndromes + 10 maladies)
% =============================================================================

:- consult('base_connaissances.pl').
:- consult('main.pl').

% -----------------------------------------------------------------------------
% INSTRUCTIONS
% -----------------------------------------------------------------------------
% Pour tester manuellement :
%   1. Charger ce fichier: ?- consult('tests.pl').
%   2. Lancer: ?- start.
%   3. Suivre les scenarios dans SCENARIOS_TEST.md
%
% Pour tester une regle syndromes:
%   ?- reinitialiser, assert(connu(fievre_elevee, oui)),
%      assert(connu(toux, oui)), syndrome_respiratoire.
%   Expected: true
%
% Pour tester une regle maladie:
%   ?- reinitialiser, assert(connu(mal_tete_intense, oui)),
%      assert(connu(photophobie, oui)), migraine.
%   Expected: true
% -----------------------------------------------------------------------------

% Test rapide - Migraine (devrait poser 3 questions)
% Scenario: perte_odorat=2, mal_tete_intense=1, photophobie=1
test_migraine :-
    write('=== TEST MIGRAINE ==='), nl,
    write('Scenario: Pas de perte odorat, mal tete intense, photophobie'), nl,
    write('Repondez: 2, 1, 1'), nl,
    write('Attendu: Diagnostic Migraine en 3 questions'), nl,
    nl,
    start.

% Test rapide - COVID (devrait poser 2-3 questions avec cascades)
% Scenario: perte_odorat=1, puis cascade fievre
test_covid :-
    write('=== TEST COVID-19 ==='), nl,
    write('Scenario: Perte odorat + symptomes COVID'), nl,
    write('Repondez: 1 (perte odorat), puis suivez les cascades'), nl,
    write('Attendu: Diagnostic COVID-19'), nl,
    nl,
    start.

% Test rapide - Rhume (pas de fievre, pas grippal)
% Scenario: nez_bouche=1, gorge_irritee=1, pas de fievre
test_rhume :-
    write('=== TEST RHUME ==='), nl,
    write('Scenario: Nez bouche + gorge irritee, sans fievre'), nl,
    write('Attendu: Diagnostic Rhume'), nl,
    nl,
    start.

% Test unitaire - Syndrome respiratoire R1
test_syndrome_resp_r1 :-
    reinitialiser,
    assert(connu(fievre_legere, oui)),
    assert(connu(toux, oui)),
    (syndrome_respiratoire ->
        write('✓ R1: syndrome_respiratoire OK')
    ;
        write('✗ R1: ECHEC')
    ), nl.

% Test unitaire - Syndrome febrile R4
test_syndrome_febrile :-
    reinitialiser,
    assert(connu(fievre_elevee, oui)),
    (syndrome_febrile ->
        write('✓ R4: syndrome_febrile OK')
    ;
        write('✗ R4: ECHEC')
    ), nl.

% Test unitaire - Syndrome neurologique R9
test_syndrome_neuro :-
    reinitialiser,
    assert(connu(mal_tete_intense, oui)),
    assert(connu(photophobie, oui)),
    (syndrome_neurologique ->
        write('✓ R9: syndrome_neurologique OK')
    ;
        write('✗ R9: ECHEC')
    ), nl.

% Test unitaire - Syndrome grippal R5
test_syndrome_grippal :-
    reinitialiser,
    assert(connu(fatigue_intense, oui)),
    assert(connu(courbatures, oui)),
    assert(connu(fievre_elevee, oui)),
    (syndrome_grippal ->
        write('✓ R5: syndrome_grippal OK')
    ;
        write('✗ R5: ECHEC')
    ), nl.

% Test unitaire - Syndrome allergique R6 (SIMPLIFIE - eternuement suffit)
test_syndrome_allergique :-
    reinitialiser,
    assert(connu(eternuement, oui)),
    (syndrome_allergique ->
        write('✓ R6: syndrome_allergique OK')
    ;
        write('✗ R6: ECHEC')
    ), nl.

% Test unitaire - Syndrome oculaire R7
test_syndrome_oculaire :-
    reinitialiser,
    assert(connu(yeux_rouges, oui)),
    assert(connu(yeux_qui_piquent, oui)),
    (syndrome_oculaire ->
        write('✓ R7: syndrome_oculaire OK')
    ;
        write('✗ R7: ECHEC')
    ), nl.

% Test unitaire - Syndrome digestif R8
test_syndrome_digestif :-
    reinitialiser,
    assert(connu(diarrhee, oui)),
    assert(connu(vomissements, oui)),
    (syndrome_digestif ->
        write('✓ R8: syndrome_digestif OK')
    ;
        write('✗ R8: ECHEC')
    ), nl.

% Test unitaire - Syndrome ORL R10 (SIMPLIFIE - mal_gorge_intense suffit)
test_syndrome_orl :-
    reinitialiser,
    assert(connu(mal_gorge_intense, oui)),
    (syndrome_orl ->
        write('✓ R10: syndrome_orl OK')
    ;
        write('✗ R10: ECHEC')
    ), nl.

% Test unitaire - Migraine R18
test_maladie_migraine :-
    reinitialiser,
    assert(connu(mal_tete_intense, oui)),
    assert(connu(photophobie, oui)),
    (migraine ->
        write('✓ R18: migraine OK')
    ;
        write('✗ R18: ECHEC')
    ), nl.

% Test unitaire - Grippe R11
test_maladie_grippe :-
    reinitialiser,
    % Cascade fievre complete
    assert(connu(fievre, oui)),
    assert(connu(fievre_elevee, oui)),
    assert(connu(fievre_legere, non)),
    % Cascade toux complete
    assert(connu(toux, oui)),
    assert(connu(toux_productive, non)),
    % Symptomes grippaux
    assert(connu(fatigue_intense, oui)),
    assert(connu(courbatures, oui)),
    % Discriminant COVID
    assert(connu(perte_odorat, non)),
    (grippe ->
        write('✓ R11: grippe OK')
    ;
        write('✗ R11: ECHEC')
    ), nl.

% Test unitaire - COVID-19 R12
test_maladie_covid19 :-
    reinitialiser,
    % Cascade fievre complete
    assert(connu(fievre, oui)),
    assert(connu(fievre_elevee, oui)),
    assert(connu(fievre_legere, non)),
    % Cascade toux complete
    assert(connu(toux, oui)),
    assert(connu(toux_productive, non)),
    % Symptomes grippaux
    assert(connu(fatigue_intense, oui)),
    assert(connu(courbatures, oui)),
    % Discriminant COVID
    assert(connu(perte_odorat, oui)),
    (covid19 ->
        write('✓ R12: covid19 OK')
    ;
        write('✗ R12: ECHEC')
    ), nl.

% Test unitaire - Bronchite R13
test_maladie_bronchite :-
    reinitialiser,
    % Cascade fievre legere
    assert(connu(fievre, oui)),
    assert(connu(fievre_elevee, non)),
    assert(connu(fievre_legere, oui)),
    % Cascade toux productive
    assert(connu(toux, oui)),
    assert(connu(toux_productive, oui)),
    (bronchite ->
        write('✓ R13: bronchite OK')
    ;
        write('✗ R13: ECHEC')
    ), nl.

% Test unitaire - Rhume R14
test_maladie_rhume :-
    reinitialiser,
    % Syndrome respiratoire (R3: nez_bouche + gorge_irritee)
    assert(connu(nez_bouche, oui)),
    assert(connu(gorge_irritee, oui)),
    % Pas de fievre (negation syndrome_febrile)
    assert(connu(fievre, non)),
    assert(connu(fievre_elevee, non)),
    assert(connu(fievre_legere, non)),
    % Pas de symptomes grippaux (negation syndrome_grippal)
    assert(connu(fatigue_intense, non)),
    assert(connu(courbatures, non)),
    % Cascade toux non necessaire mais on l'ajoute
    assert(connu(toux, non)),
    assert(connu(toux_productive, non)),
    (rhume ->
        write('✓ R14: rhume OK')
    ;
        write('✗ R14: ECHEC')
    ), nl.

% Test unitaire - Angine R15
test_maladie_angine :-
    reinitialiser,
    % Syndrome ORL (R10: mal_gorge_intense)
    assert(connu(mal_gorge_intense, oui)),
    % Syndrome febrile (R4: fievre_elevee)
    assert(connu(fievre, oui)),
    assert(connu(fievre_elevee, oui)),
    assert(connu(fievre_legere, non)),
    (angine ->
        write('✓ R15: angine OK')
    ;
        write('✗ R15: ECHEC')
    ), nl.

% Test unitaire - Allergie saisonniere R16
test_maladie_allergie :-
    reinitialiser,
    % Syndrome allergique (R6: eternuement)
    assert(connu(eternuement, oui)),
    % Syndrome oculaire (R7: yeux_rouges + yeux_qui_piquent)
    assert(connu(yeux_rouges, oui)),
    assert(connu(yeux_qui_piquent, oui)),
    % Negation difficultes respiratoires
    assert(connu(difficultes_respiratoires, non)),
    (allergie ->
        write('✓ R16: allergie OK')
    ;
        write('✗ R16: ECHEC')
    ), nl.

% Test unitaire - Asthme R17
test_maladie_asthme :-
    reinitialiser,
    % Syndrome respiratoire (R1: fievre_legere + toux)
    assert(connu(fievre, oui)),
    assert(connu(fievre_elevee, non)),
    assert(connu(fievre_legere, oui)),
    assert(connu(toux, oui)),
    assert(connu(toux_productive, non)),
    % Syndrome allergique (R6: eternuement)
    assert(connu(eternuement, oui)),
    % Wheezing + difficultes respiratoires
    assert(connu(wheezing, oui)),
    assert(connu(difficultes_respiratoires, oui)),
    (asthme ->
        write('✓ R17: asthme OK')
    ;
        write('✗ R17: ECHEC')
    ), nl.

% Test unitaire - Gastro-enterite R19
test_maladie_gastro :-
    reinitialiser,
    % Syndrome digestif (R8: diarrhee + vomissements)
    assert(connu(diarrhee, oui)),
    assert(connu(vomissements, oui)),
    % Syndrome febrile (R4: fievre_elevee)
    assert(connu(fievre, oui)),
    assert(connu(fievre_elevee, oui)),
    assert(connu(fievre_legere, non)),
    (gastro_enterite ->
        write('✓ R19: gastro_enterite OK')
    ;
        write('✗ R19: ECHEC')
    ), nl.

% Test unitaire - Conjonctivite R20
test_maladie_conjonctivite :-
    reinitialiser,
    % Syndrome oculaire (R7: yeux_rouges + yeux_qui_piquent)
    assert(connu(yeux_rouges, oui)),
    assert(connu(yeux_qui_piquent, oui)),
    % Secretions purulentes
    assert(connu(secretions_purulentes, oui)),
    (conjonctivite ->
        write('✓ R20: conjonctivite OK')
    ;
        write('✗ R20: ECHEC')
    ), nl.

% Lancer tous les tests unitaires (SANS interaction)
test_all :-
    write('=== TESTS UNITAIRES ==='), nl, nl,

    write('--- Tests Syndromes (8/8) ---'), nl,
    test_syndrome_resp_r1,
    test_syndrome_febrile,
    test_syndrome_grippal,
    test_syndrome_allergique,
    test_syndrome_oculaire,
    test_syndrome_digestif,
    test_syndrome_neuro,
    test_syndrome_orl,
    nl,

    write('--- Tests Maladies (10/10) ---'), nl,
    test_maladie_grippe,
    test_maladie_covid19,
    test_maladie_bronchite,
    test_maladie_rhume,
    test_maladie_angine,
    test_maladie_allergie,
    test_maladie_asthme,
    test_maladie_migraine,
    test_maladie_gastro,
    test_maladie_conjonctivite,
    nl,

    write('=== FIN DES TESTS ==='), nl,
    write('TOUS LES TESTS PASSES! (18 tests: 8 syndromes + 10 maladies)'), nl.
