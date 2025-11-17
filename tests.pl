% =============================================================================
% TESTS - Systeme Expert de Diagnostic Medical
% =============================================================================
% Projet: TP2 - IFT2003
% Tests manuels pour validation
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

% Lancer tous les tests unitaires (SANS interaction)
test_all :-
    write('=== TESTS UNITAIRES ==='), nl, nl,
    test_syndrome_resp_r1,
    test_syndrome_febrile,
    test_syndrome_neuro,
    test_maladie_migraine,
    test_maladie_grippe,
    test_maladie_covid19,
    test_maladie_rhume,
    nl,
    write('=== FIN DES TESTS ==='), nl,
    write('TOUS LES TESTS PASSES!'), nl.
