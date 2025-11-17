# Guide d'Implémentation - Système Expert Diagnostic Médical

> Blueprint complet pour implémentation Prolog - À suivre étape par étape

---

## 📐 Ordre d'Implémentation Recommandé

```
1. base_connaissances.pl
   ├── 1.1 Règles Syndromes (R1-R10)
   └── 1.2 Règles Maladies (R11-R20)

2. main.pl
   ├── 2.1 Infrastructure de base (dynamic facts, reset)
   ├── 2.2 Traductions (symptômes, maladies, syndromes)
   ├── 2.3 Interface utilisateur (questions, lecture réponses)
   ├── 2.4 Gestion cascades (fièvre, toux)
   ├── 2.5 Vérification symptômes (cache + questions)
   ├── 2.6 Vérification syndromes (appel règles BC)
   ├── 2.7 Règles maladies (backward chaining)
   ├── 2.8 Moteur principal (diagnostiquer)
   └── 2.9 Point d'entrée (start)

3. tests.pl
   └── 3.1 Tests manuels guidés
```

---

## ⚠️ Pièges Prolog à Éviter

### Syntaxe Critique

```prolog
% ❌ ERREUR - Majuscule = Variable
syndrome_Respiratoire :- ...  % FAUX!

% ✅ CORRECT - Minuscule = Atome
syndrome_respiratoire :- ...

% ❌ ERREUR - Négation invalide
not(perte_odorat)  % Fonctionne mais déprécié

% ✅ CORRECT - Négation moderne
\+ verifier_symptome(perte_odorat)

% ❌ ERREUR - Oubli du point final
syndrome_grippal :- fatigue_intense, courbatures  % ERREUR!

% ✅ CORRECT - Point obligatoire
syndrome_grippal :- fatigue_intense, courbatures.

% ❌ ERREUR - Virgule au lieu de point-virgule
(fievre_elevee, toux) , (nez_bouche, gorge_irritee).  % Logique incorrecte

% ✅ CORRECT - Point-virgule pour OR
(fievre_elevee, toux) ; (nez_bouche, gorge_irritee).
```

### Dynamic Facts

```prolog
% TOUJOURS déclarer AVANT utilisation
:- dynamic connu/2.
:- dynamic syndrome_detecte/1.

% Puis utiliser
assert(connu(fievre, oui)).
retract(connu(fievre, _)).
retractall(connu(_, _)).
```

---

## 📝 ÉTAPE 1: base_connaissances.pl

### 1.1 Règles Syndromes (R1-R10)

```prolog
% =============================================================================
% BASE DE CONNAISSANCES - Système Expert de Diagnostic Médical
% =============================================================================
% Projet: TP2 - IFT2003
% Description: 20 règles d'inférence (10 syndromes + 10 maladies)
% =============================================================================

% -----------------------------------------------------------------------------
% NIVEAU 1 → NIVEAU 2: Symptômes → Syndromes (10 règles)
% -----------------------------------------------------------------------------

% R1: Fièvre légère ∧ Toux → Respiratoire
syndrome_respiratoire :-
    verifier_symptome(fievre_legere),
    verifier_symptome(toux).

% R2: Fièvre élevée ∧ Toux → Respiratoire
syndrome_respiratoire :-
    verifier_symptome(fievre_elevee),
    verifier_symptome(toux).

% R3: Nez bouché ∧ Gorge irritée → Respiratoire
syndrome_respiratoire :-
    verifier_symptome(nez_bouche),
    verifier_symptome(gorge_irritee).

% R4: Fièvre élevée → Fébrile (SIMPLIFIÉ)
syndrome_febrile :-
    verifier_symptome(fievre_elevee).

% R5: Fatigue intense ∧ Courbatures ∧ Fièvre élevée → Grippal
syndrome_grippal :-
    verifier_symptome(fatigue_intense),
    verifier_symptome(courbatures),
    verifier_symptome(fievre_elevee).

% R6: Éternuements → Allergique (SIMPLIFIÉ)
syndrome_allergique :-
    verifier_symptome(eternuement).

% R7: Yeux rouges ∧ Yeux qui piquent → Oculaire
syndrome_oculaire :-
    verifier_symptome(yeux_rouges),
    verifier_symptome(yeux_qui_piquent).

% R8: Diarrhée ∧ Vomissements → Digestif
syndrome_digestif :-
    verifier_symptome(diarrhee),
    verifier_symptome(vomissements).

% R9: Mal tête intense ∧ Photophobie → Neurologique
syndrome_neurologique :-
    verifier_symptome(mal_tete_intense),
    verifier_symptome(photophobie).

% R10: Mal gorge intense → ORL (SIMPLIFIÉ)
syndrome_orl :-
    verifier_symptome(mal_gorge_intense).
```

### 1.2 Règles Maladies (R11-R20)

```prolog
% -----------------------------------------------------------------------------
% NIVEAU 2 → NIVEAU 3: Syndromes → Maladies (10 règles)
% -----------------------------------------------------------------------------

% R11: Grippe = Respiratoire ∧ Grippal ∧ Fébrile ∧ ¬Perte odorat
grippe :-
    syndrome_respiratoire,
    syndrome_grippal,
    syndrome_febrile,
    \+ verifier_symptome(perte_odorat).

% R12: COVID-19 = Respiratoire ∧ Grippal ∧ Fébrile ∧ Perte odorat
covid19 :-
    syndrome_respiratoire,
    syndrome_grippal,
    syndrome_febrile,
    verifier_symptome(perte_odorat).

% R13: Bronchite = Respiratoire ∧ Fièvre légère ∧ Toux productive
bronchite :-
    syndrome_respiratoire,
    verifier_symptome(fievre_legere),
    verifier_symptome(toux_productive).

% R14: Rhume = Respiratoire ∧ ¬Fébrile ∧ ¬Grippal
rhume :-
    syndrome_respiratoire,
    \+ syndrome_febrile,
    \+ syndrome_grippal.

% R15: Angine = ORL ∧ Fébrile
angine :-
    syndrome_orl,
    syndrome_febrile.

% R16: Allergie saisonnière = Allergique ∧ Oculaire ∧ ¬Difficultés respiratoires
allergie :-
    syndrome_allergique,
    syndrome_oculaire,
    \+ verifier_symptome(difficultes_respiratoires).

% R17: Asthme = Respiratoire ∧ Allergique ∧ Wheezing ∧ Difficultés respiratoires
asthme :-
    syndrome_respiratoire,
    syndrome_allergique,
    verifier_symptome(wheezing),
    verifier_symptome(difficultes_respiratoires).

% R18: Migraine = Neurologique
migraine :-
    syndrome_neurologique.

% R19: Gastro-entérite = Digestif ∧ Fébrile
gastro_enterite :-
    syndrome_digestif,
    syndrome_febrile.

% R20: Conjonctivite = Oculaire ∧ Sécrétions purulentes
conjonctivite :-
    syndrome_oculaire,
    verifier_symptome(secretions_purulentes).
```

**✅ CHECKPOINT 1**: base_connaissances.pl complété (20 règles)

---

## 📝 ÉTAPE 2: main.pl

### 2.1 Infrastructure de Base

```prolog
% =============================================================================
% MAIN - Système Expert de Diagnostic Médical
% =============================================================================
% Projet: TP2 - IFT2003
% Moteur d'inférence (backward chaining) + Interface utilisateur
% =============================================================================

% Chargement de la base de connaissances
:- consult('base_connaissances.pl').

% -----------------------------------------------------------------------------
% GESTION MÉMOIRE - Faits dynamiques
% -----------------------------------------------------------------------------

:- dynamic connu/2.  % connu(Symptome, oui/non)

% Réinitialiser la base de faits
reinitialiser :-
    retractall(connu(_, _)).
```

### 2.2 Traductions Français

```prolog
% -----------------------------------------------------------------------------
% TRADUCTIONS - Symptômes
% -----------------------------------------------------------------------------

traduire_symptome(perte_odorat, "perdu l'odorat ou le goût").
traduire_symptome(fievre, "de la fièvre").
traduire_symptome(fievre_elevee, "une fièvre élevée (>38.5°C)").
traduire_symptome(frissons, "des frissons").
traduire_symptome(toux, "de la toux").
traduire_symptome(toux_productive, "une toux productive (avec crachats/expectorations)").
traduire_symptome(nez_bouche, "le nez bouché").
traduire_symptome(difficultes_respiratoires, "des difficultés à respirer").
traduire_symptome(wheezing, "un sifflement respiratoire (wheezing)").
traduire_symptome(gorge_irritee, "la gorge irritée").
traduire_symptome(mal_gorge_intense, "un mal de gorge intense").
traduire_symptome(difficulte_avaler, "de la difficulté à avaler").
traduire_symptome(eternuement, "éternué fréquemment").
traduire_symptome(nez_qui_coule_clair, "le nez qui coule (écoulement clair)").
traduire_symptome(yeux_rouges, "les yeux rouges").
traduire_symptome(yeux_qui_piquent, "les yeux qui piquent ou qui démangent").
traduire_symptome(secretions_purulentes, "des sécrétions purulentes aux yeux").
traduire_symptome(fatigue_intense, "ressenti une fatigue intense").
traduire_symptome(courbatures, "des courbatures (douleurs musculaires)").
traduire_symptome(mal_tete_intense, "un mal de tête intense").
traduire_symptome(photophobie, "sensible à la lumière (photophobie)").
traduire_symptome(diarrhee, "de la diarrhée").
traduire_symptome(vomissements, "des vomissements").

% -----------------------------------------------------------------------------
% TRADUCTIONS - Maladies
% -----------------------------------------------------------------------------

traduire_maladie(grippe, "Grippe").
traduire_maladie(covid19, "COVID-19").
traduire_maladie(bronchite, "Bronchite").
traduire_maladie(rhume, "Rhume").
traduire_maladie(angine, "Angine").
traduire_maladie(allergie, "Allergie saisonnière").
traduire_maladie(asthme, "Asthme").
traduire_maladie(migraine, "Migraine").
traduire_maladie(gastro_enterite, "Gastro-entérite").
traduire_maladie(conjonctivite, "Conjonctivite").

% -----------------------------------------------------------------------------
% TRADUCTIONS - Syndromes
% -----------------------------------------------------------------------------

traduire_syndrome(syndrome_respiratoire, "Syndrome respiratoire").
traduire_syndrome(syndrome_febrile, "Syndrome fébrile").
traduire_syndrome(syndrome_grippal, "Syndrome grippal").
traduire_syndrome(syndrome_allergique, "Syndrome allergique").
traduire_syndrome(syndrome_oculaire, "Syndrome oculaire").
traduire_syndrome(syndrome_digestif, "Syndrome digestif").
traduire_syndrome(syndrome_neurologique, "Syndrome neurologique").
traduire_syndrome(syndrome_orl, "Syndrome ORL").
```

### 2.3 Interface Utilisateur - Questions

```prolog
% -----------------------------------------------------------------------------
% INTERFACE UTILISATEUR - Gestion des questions
% -----------------------------------------------------------------------------

% Lire réponse utilisateur (1 ou 2 uniquement)
% Utilise get_single_char pour meilleure UX (pas besoin de point ni Enter)
lire_reponse(Reponse) :-
    get_single_char(Code),
    (   Code = 49 -> Reponse = oui      % 49 = code ASCII de '1'
    ;   Code = 50 -> Reponse = non      % 50 = code ASCII de '2'
    ;   (
            write('Réponse invalide. Veuillez entrer 1 ou 2.'), nl,
            write('Votre réponse (1/2): '),
            lire_reponse(Reponse)
        )
    ).

% Poser question simple (pas de cascade)
poser_question_simple(Symptome, Reponse) :-
    traduire_symptome(Symptome, TexteFrancais),
    format('Question: Avez-vous ~w?~n', [TexteFrancais]),
    write('1. Oui'), nl,
    write('2. Non'), nl,
    write('Votre réponse (1/2): '),
    lire_reponse(Reponse).
```

### 2.4 Gestion Cascades (CRITIQUE)

```prolog
% -----------------------------------------------------------------------------
% GESTION CASCADES - Fièvre et Toux
% -----------------------------------------------------------------------------

% CASCADE FIÈVRE
% Q: "Avez-vous de la fièvre?"
%   → Si OUI: "Est-elle élevée (>38.5°C)?"
%     → Si OUI: fievre=oui, fievre_elevee=oui, fievre_legere=non
%     → Si NON: fievre=oui, fievre_elevee=non, fievre_legere=oui
%   → Si NON: fievre=non, fievre_elevee=non, fievre_legere=non

poser_question_fievre :-
    traduire_symptome(fievre, TexteFievre),
    format('Question: Avez-vous ~w?~n', [TexteFievre]),
    write('1. Oui'), nl,
    write('2. Non'), nl,
    write('Votre réponse (1/2): '),
    lire_reponse(ReponseFievre),
    (   ReponseFievre = oui ->
        (
            % Sous-question: fièvre élevée?
            traduire_symptome(fievre_elevee, TexteElevee),
            format('Question: Est-elle élevée (température >38.5°C)?~n', []),
            write('1. Oui'), nl,
            write('2. Non'), nl,
            write('Votre réponse (1/2): '),
            lire_reponse(ReponseElevee),
            (   ReponseElevee = oui ->
                (
                    assert(connu(fievre, oui)),
                    assert(connu(fievre_elevee, oui)),
                    assert(connu(fievre_legere, non))
                )
            ;   % ReponseElevee = non
                (
                    assert(connu(fievre, oui)),
                    assert(connu(fievre_elevee, non)),
                    assert(connu(fievre_legere, oui))
                )
            )
        )
    ;   % ReponseFievre = non
        (
            assert(connu(fievre, non)),
            assert(connu(fievre_elevee, non)),
            assert(connu(fievre_legere, non))
        )
    ).

% CASCADE TOUX
% Q: "Avez-vous de la toux?"
%   → Si OUI: "Est-elle productive (avec crachats)?"
%     → Si OUI: toux=oui, toux_productive=oui
%     → Si NON: toux=oui, toux_productive=non
%   → Si NON: toux=non, toux_productive=non

poser_question_toux :-
    traduire_symptome(toux, TexteToux),
    format('Question: Avez-vous ~w?~n', [TexteToux]),
    write('1. Oui'), nl,
    write('2. Non'), nl,
    write('Votre réponse (1/2): '),
    lire_reponse(ReponseToux),
    (   ReponseToux = oui ->
        (
            % Sous-question: toux productive?
            traduire_symptome(toux_productive, TexteProductive),
            format('Question: Est-elle productive (avec crachats/expectorations)?~n', []),
            write('1. Oui'), nl,
            write('2. Non'), nl,
            write('Votre réponse (1/2): '),
            lire_reponse(ReponseProductive),
            (   ReponseProductive = oui ->
                (
                    assert(connu(toux, oui)),
                    assert(connu(toux_productive, oui))
                )
            ;   % ReponseProductive = non
                (
                    assert(connu(toux, oui)),
                    assert(connu(toux_productive, non))
                )
            )
        )
    ;   % ReponseToux = non
        (
            assert(connu(toux, non)),
            assert(connu(toux_productive, non))
        )
    ).
```

### 2.5 Vérification Symptômes (avec Cache)

**⚠️ IMPORTANT - Gestion des Cascades:**
Les cascades (fièvre, toux) posent plusieurs questions et font `assert` directement dans le cache.
Le prédicat `poser_question_et_enregistrer/1` gère deux cas:
- **Cascades**: Appelle `poser_question_fievre` ou `poser_question_toux` qui fait tous les `assert`, puis coupe avec `!`
- **Symptômes normaux**: Appelle `poser_question_simple`, récupère `Reponse`, et fait `assert` manuellement

Après l'appel, `verifier_symptome` vérifie le cache avec `connu(Symptome, oui)`.

```prolog
% -----------------------------------------------------------------------------
% MOTEUR D'INFÉRENCE - Vérification Symptômes
% -----------------------------------------------------------------------------

% Vérifier un symptôme avec cache (ne pose jamais 2 fois la même question)
verifier_symptome(Symptome) :-
    % Cas 1: Déjà connu comme OUI
    connu(Symptome, oui), !.

verifier_symptome(Symptome) :-
    % Cas 2: Déjà connu comme NON
    connu(Symptome, non), !, fail.

verifier_symptome(Symptome) :-
    % Cas 3: Pas encore demandé - poser question et enregistrer
    \+ connu(Symptome, _),
    poser_question_et_enregistrer(Symptome),
    connu(Symptome, oui).  % Vérifier cache après (cascade fait assert directement)

% -----------------------------------------------------------------------------
% Poser questions et enregistrer dans le cache
% -----------------------------------------------------------------------------

% Gestion CASCADE FIÈVRE
% Si on demande fievre, fievre_elevee ou fievre_legere et que la cascade
% n'a pas encore été posée, on pose la cascade complète
poser_question_et_enregistrer(fievre) :-
    \+ connu(fievre, _),
    poser_question_fievre, !.

poser_question_et_enregistrer(fievre_elevee) :-
    \+ connu(fievre, _),
    poser_question_fievre, !.

poser_question_et_enregistrer(fievre_legere) :-
    \+ connu(fievre, _),
    poser_question_fievre, !.

% Gestion CASCADE TOUX
% Si on demande toux ou toux_productive et que la cascade
% n'a pas encore été posée, on pose la cascade complète
poser_question_et_enregistrer(toux) :-
    \+ connu(toux, _),
    poser_question_toux, !.

poser_question_et_enregistrer(toux_productive) :-
    \+ connu(toux, _),
    poser_question_toux, !.

% Pour tous les AUTRES symptômes (non-cascades)
poser_question_et_enregistrer(Symptome) :-
    \+ member(Symptome, [fievre, fievre_elevee, fievre_legere, toux, toux_productive]),
    poser_question_simple(Symptome, Reponse),
    assert(connu(Symptome, Reponse)).
```

### 2.6 Moteur Principal - Diagnostic

```prolog
% -----------------------------------------------------------------------------
% MOTEUR PRINCIPAL - Backward Chaining
% -----------------------------------------------------------------------------

% Ordre optimisé: maladies avec discriminants uniques d'abord
diagnostiquer(Maladie) :-
    member(Maladie, [
        covid19,           % perte_odorat unique → 2-3 questions
        migraine,          % neurologique unique → 3 questions
        conjonctivite,     % secretions_purulentes unique → 4-5 questions
        asthme,            % wheezing + difficultés respiratoires → 5-6 questions
        gastro_enterite,   % digestif + fébrile → 5-6 questions
        grippe,            % 3 syndromes (complexe) → 6-8 questions
        angine,            % ORL + fébrile → 5-6 questions
        bronchite,         % toux_productive + fievre_legere → 5-7 questions
        allergie,          % allergique + oculaire → 6-7 questions
        rhume              % Diagnostic par élimination (dernier) → 7-8 questions
    ]),
    call(Maladie).  % Appel dynamique de la règle maladie
```

### 2.7 Affichage Résultats

```prolog
% -----------------------------------------------------------------------------
% AFFICHAGE RÉSULTATS
% -----------------------------------------------------------------------------

% Collecter les syndromes détectés
collecter_syndromes(Syndromes) :-
    findall(S, (
        member(S, [syndrome_respiratoire, syndrome_febrile, syndrome_grippal,
                   syndrome_allergique, syndrome_oculaire, syndrome_digestif,
                   syndrome_neurologique, syndrome_orl]),
        call(S)
    ), Syndromes).

% Afficher diagnostic final
afficher_diagnostic(Maladie) :-
    nl,
    write('=== DIAGNOSTIC ==='), nl,
    traduire_maladie(Maladie, NomFrancais),
    format('Diagnostic: ~w~n', [NomFrancais]),
    collecter_syndromes(Syndromes),
    (   Syndromes \= [] ->
        (
            write('Syndromes identifiés: '),
            afficher_liste_syndromes(Syndromes),
            nl
        )
    ;   true
    ).

% Afficher liste de syndromes traduits
afficher_liste_syndromes([]).
afficher_liste_syndromes([S]) :-
    traduire_syndrome(S, NomFrancais),
    write(NomFrancais), !.
afficher_liste_syndromes([S|Rest]) :-
    traduire_syndrome(S, NomFrancais),
    format('~w, ', [NomFrancais]),
    afficher_liste_syndromes(Rest).

% Si aucun diagnostic trouvé
afficher_aucun_diagnostic :-
    nl,
    write('=== DIAGNOSTIC ==='), nl,
    write('Aucun diagnostic trouvé avec les symptômes fournis.'), nl,
    write('Veuillez consulter un professionnel de santé.'), nl.
```

### 2.8 Point d'Entrée Principal

```prolog
% -----------------------------------------------------------------------------
% POINT D'ENTRÉE PRINCIPAL
% -----------------------------------------------------------------------------

start :-
    % Bannière
    nl,
    write('======================================================='), nl,
    write('    SYSTÈME EXPERT DE DIAGNOSTIC MÉDICAL'), nl,
    write('======================================================='), nl,
    nl,
    write('Ce système vous posera quelques questions pour établir'), nl,
    write('un diagnostic parmi 10 maladies courantes.'), nl,
    write('Répondez par 1 (Oui) ou 2 (Non).'), nl,
    nl,
    write('-------------------------------------------------------'), nl,
    nl,

    % Réinitialisation
    reinitialiser,

    % Tentative de diagnostic
    (   diagnostiquer(Maladie) ->
        afficher_diagnostic(Maladie)
    ;   afficher_aucun_diagnostic
    ),

    nl,
    write('-------------------------------------------------------'), nl,
    write('Session terminée.'), nl,
    nl.
```

**✅ CHECKPOINT 2**: main.pl complété

---

## 📝 ÉTAPE 3: tests.pl

### 3.1 Tests Manuels Guidés

```prolog
% =============================================================================
% TESTS - Système Expert de Diagnostic Médical
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
%   3. Suivre les scénarios dans SCENARIOS_TEST.md
%
% Pour tester une règle syndromes:
%   ?- reinitialiser, assert(connu(fievre_elevee, oui)),
%      assert(connu(toux, oui)), syndrome_respiratoire.
%   Expected: true
%
% Pour tester une règle maladie:
%   ?- reinitialiser, assert(connu(mal_tete_intense, oui)),
%      assert(connu(photophobie, oui)), migraine.
%   Expected: true
% -----------------------------------------------------------------------------

% Test rapide - Migraine (devrait poser 3 questions)
test_migraine :-
    write('=== TEST MIGRAINE ==='), nl,
    write('Répondez: perte_odorat=2, mal_tete_intense=1, photophobie=1'), nl,
    nl,
    start.

% Test rapide - COVID (devrait poser 2-3 questions)
test_covid :-
    write('=== TEST COVID-19 ==='), nl,
    write('Répondez: perte_odorat=1, puis suivez les questions'), nl,
    nl,
    start.
```

**✅ CHECKPOINT 3**: tests.pl complété

---

## 🎯 Checklist de Validation

### Après base_connaissances.pl
- [ ] Fichier charge sans erreur: `?- consult('base_connaissances.pl').`
- [ ] 10 règles syndromes définies (R1-R10)
- [ ] 10 règles maladies définies (R11-R20)
- [ ] Aucune erreur de syntaxe (points, virgules, négations)

### Après main.pl
- [ ] Fichier charge sans erreur: `?- consult('main.pl').`
- [ ] Charge base_connaissances.pl automatiquement
- [ ] Toutes traductions définies (23 symptômes + 10 maladies + 8 syndromes)
- [ ] Cascades fièvre/toux fonctionnelles
- [ ] Test manuel: `?- start.` lance le système

### Validation Fonctionnelle
- [ ] Test scénario Migraine (3 questions attendues)
- [ ] Test scénario COVID-19 (2-3 questions attendues)
- [ ] Test cascade fièvre (2 questions si oui)
- [ ] Test cascade toux (2 questions si oui)
- [ ] Pas de question posée 2 fois (cache fonctionne)
- [ ] Affichage final correct (diagnostic + syndromes)

### Validation Complète
- [ ] 10 scénarios SCENARIOS_TEST.md passent
- [ ] Moyenne 4-6 questions par diagnostic
- [ ] Aucune erreur runtime
- [ ] Messages en français corrects

---

## 🚨 Débogage Commun

### Erreur: "connu/2 not defined"
```prolog
% Solution: Ajouter déclaration dynamic
:- dynamic connu/2.
```

### Erreur: Boucle infinie
```prolog
% Problème: verifier_symptome sans cut
% Solution: Ajouter ! après connu(Symptome, oui)
verifier_symptome(Symptome) :-
    connu(Symptome, oui), !.  % Cut ici!
```

### Erreur: Question posée 2 fois
```prolog
% Problème: Cascade posée plusieurs fois
% Solution: Vérifier que cascade n'a pas déjà été posée
poser_question_et_enregistrer(fievre_elevee) :-
    \+ connu(fievre, _),  % Important! Vérifie si cascade déjà posée
    poser_question_fievre, !.
```

### Erreur: Syndromes non détectés
```prolog
% Vérification: Tester règle directement
?- assert(connu(fievre_elevee, oui)), assert(connu(toux, oui)), syndrome_respiratoire.
% Expected: true
```

---

## 📌 Notes Importantes

### Ordre des Clauses
L'ordre des clauses Prolog **est important** pour `verifier_symptome/1`:
1. D'abord: cache positif (connu oui)
2. Ensuite: cache négatif (connu non)
3. Enfin: poser question

### Négation
Toujours utiliser `\+` (not provable) au lieu de `not`:
- `\+ verifier_symptome(perte_odorat)` ✅
- `not(verifier_symptome(perte_odorat))` ❌ (déprécié)

### Dynamic Facts
Les `assert` modifient la base de faits **globalement**.
Toujours appeler `reinitialiser` avant un nouveau diagnostic.

### Format Strings
```prolog
format('Diagnostic: ~w~n', [NomFrancais])
% ~w = placeholder
% ~n = newline
% [NomFrancais] = liste arguments
```

### Encodage Fichier
**CRITIQUE**: Les fichiers `.pl` doivent être encodés en **UTF-8** pour supporter les accents français:
- Les traductions contiennent: fièvre, diarrhée, éternué, etc.
- Si le fichier est en ASCII ou Latin-1, l'affichage sera corrompu
- Dans votre éditeur: Vérifier que l'encodage est UTF-8 (sans BOM)
- SWI-Prolog gère UTF-8 nativement ✅

### get_single_char/1
La fonction `get_single_char/1` lit un seul caractère sans attendre Enter:
- L'utilisateur tape juste `1` ou `2`
- Le système réagit immédiatement
- Meilleure expérience utilisateur que `read/1`

---

**Document prêt pour implémentation - Suivre étape par étape**
