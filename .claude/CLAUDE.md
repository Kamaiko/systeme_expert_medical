# Référence Projet TP2 - Système Expert Diagnostic Médical

> Document de référence pour Claude Code - **IMPLÉMENTATION COMPLÈTE ✅**

---

## 🚀 État Actuel du Projet

**Phase**: IMPLÉMENTATION TERMINÉE ✅ → Prochaine session: Rapport final

**Équipe et Responsabilités**:
- **Alexandre**: Graphe de dépendances (arbre_dependance.md) ✅
- **Xavier**: base_connaissances.pl (20 règles + recommandations) ✅
- **Daniel**: Rapport final ⏳
- **Système**: Entièrement fonctionnel et testé ✅

**Fichiers complétés**:
- ✅ run.pl - Lancement rapide (swipl run.pl)
- ✅ base_connaissances.pl - 20 règles + 10 recommandations médicales
- ✅ main.pl - Moteur backward chaining + interface UX optimisée
- ✅ tests.pl - 18 tests unitaires (100% couverture: 8 syndromes + 10 maladies)
- ✅ README.md - Documentation utilisateur complète
- ✅ docs/ - Documentation technique exhaustive

**Fonctionnalités implémentées**:
- ✅ 20 règles d'inférence (backward chaining pur)
- ✅ 2 questions en cascade (fièvre, toux)
- ✅ 10 recommandations médicales personnalisées
- ✅ Interface get_single_char/1 (UX optimisée)
- ✅ Format sans accents (compatibilité)
- ✅ Tests complets validés (18/18 passent)
- ✅ Règles SOUPLES (conditions minimales)

---

## Informations Générales

**Cours**: IFT2003 - Intelligence Artificielle 1
**Travail**: TP2 - Système Expert de Diagnostic Médical
**Langage**: Prolog (SWI-Prolog)
**Échéance**: 28 Novembre 2025 (21h00)
**Pondération**: 10% de la note finale
**Équipe**: 4 personnes

---

## Architecture Finale Validée

### Structure Fichiers
```
TP2/
├── run.pl                   # Lancement rapide (swipl run.pl)
├── base_connaissances.pl    # 20 règles + 10 recommandations médicales
├── main.pl                  # Moteur backward chaining + interface UX
├── tests.pl                 # 18 tests unitaires (100% couverture)
├── README.md                # Documentation utilisateur complète
└── docs/
    ├── RESUME_PLAN.md       # Plan complet + section tests ✅
    ├── GUIDE_IMPLEMENTATION.md # Guide technique détaillé ✅
    ├── SCENARIOS_TEST.md    # 10 scénarios de test ✅
    └── arbre_dependance.md  # Graphe complet ✅ (Alexandre)
```

### Structure Hiérarchique (3 Niveaux)
```
NIVEAU 1: SYMPTÔMES (21 questions + 2 cascades)
    ↓ (10 règles)
NIVEAU 2: SYNDROMES (8 syndromes intermédiaires)
    ↓ (10 règles)
NIVEAU 3: MALADIES (10 diagnostics finaux)
```

---

## Base de Connaissances Finale

### 10 Maladies
1. **Grippe** - Respiratoire + Grippal + Fébrile (sans perte odorat)
2. **COVID-19** - Respiratoire + Grippal + Fébrile + Perte odorat
3. **Bronchite** - Respiratoire + Fièvre légère + Toux productive
4. **Rhume** - Respiratoire (sans Fébrile, sans Grippal)
5. **Angine** - ORL + Fébrile
6. **Allergie saisonnière** - Allergique + Oculaire (sans difficultés respiratoires)
7. **Asthme** - Respiratoire + Allergique + Wheezing + Difficultés respiratoires
8. **Migraine** - Neurologique
9. **Gastro-entérite** - Digestif + Fébrile
10. **Conjonctivite** - Oculaire + Sécrétions purulentes

### 8 Syndromes Intermédiaires

| Syndrome | Déclencheurs | Maladies connectées |
|----------|--------------|---------------------|
| `syndrome_respiratoire` | fievre_legere ∧ toux OU fievre_elevee ∧ toux OU nez_bouche ∧ gorge_irritee | 5 maladies (Grippe, COVID, Bronchite, Rhume, Asthme) |
| `syndrome_febrile` | fievre_elevee | 4 maladies (Grippe, COVID, Angine, Gastro) |
| `syndrome_grippal` | fatigue_intense ∧ courbatures ∧ fievre_elevee | 2 maladies (Grippe, COVID) |
| `syndrome_allergique` | eternuement | 2 maladies (Allergie, Asthme) |
| `syndrome_oculaire` | yeux_rouges ∧ yeux_qui_piquent | 2 maladies (Allergie, Conjonctivite) |
| `syndrome_digestif` | diarrhee ∧ vomissements | 1 maladie (Gastro-entérite) |
| `syndrome_neurologique` | mal_tete_intense ∧ photophobie | 1 maladie (Migraine) |
| `syndrome_orl` | mal_gorge_intense | 1 maladie (Angine) |

**Note**: 5 syndromes partagés créent l'arbre global interconnecté (requis par l'énoncé).

---

## Les 20 Règles d'Inférence (VERSION FINALE)

### Niveau 1 → 2: Symptômes → Syndromes (10 règles)

**R1**: `fievre_legere ∧ toux → syndrome_respiratoire`
**R2**: `fievre_elevee ∧ toux → syndrome_respiratoire`
**R3**: `nez_bouche ∧ gorge_irritee → syndrome_respiratoire`
**R4**: `fievre_elevee → syndrome_febrile`
**R5**: `fatigue_intense ∧ courbatures ∧ fievre_elevee → syndrome_grippal`
**R6**: `eternuement → syndrome_allergique`
**R7**: `yeux_rouges ∧ yeux_qui_piquent → syndrome_oculaire`
**R8**: `diarrhee ∧ vomissements → syndrome_digestif`
**R9**: `mal_tete_intense ∧ photophobie → syndrome_neurologique`
**R10**: `mal_gorge_intense → syndrome_orl`

### Niveau 2 → 3: Syndromes → Maladies (10 règles)

**R11**: `syndrome_respiratoire ∧ syndrome_grippal ∧ syndrome_febrile ∧ ¬perte_odorat → grippe`
**R12**: `syndrome_respiratoire ∧ syndrome_grippal ∧ syndrome_febrile ∧ perte_odorat → covid19`
**R13**: `syndrome_respiratoire ∧ fievre_legere ∧ toux_productive → bronchite`
**R14**: `syndrome_respiratoire ∧ ¬syndrome_febrile ∧ ¬syndrome_grippal → rhume`
**R15**: `syndrome_orl ∧ syndrome_febrile → angine`
**R16**: `syndrome_allergique ∧ syndrome_oculaire ∧ ¬difficultes_respiratoires → allergie`
**R17**: `syndrome_respiratoire ∧ syndrome_allergique ∧ wheezing ∧ difficultes_respiratoires → asthme`
**R18**: `syndrome_neurologique → migraine`
**R19**: `syndrome_digestif ∧ syndrome_febrile → gastro_enterite`
**R20**: `syndrome_oculaire ∧ secretions_purulentes → conjonctivite`

**Changements depuis version 23 règles:**
- Supprimé: syndrome_febrile nécessitait frissons → Maintenant fievre_elevee suffit
- Supprimé: syndrome_allergique nécessitait nez_qui_coule_clair → Maintenant eternuement suffit
- Supprimé: syndrome_orl nécessitait difficulte_avaler → Maintenant mal_gorge_intense suffit

---

## Questions et Cascades

### Format Questions (Oui/Non UNIQUEMENT)

```
Question: Avez-vous de la fièvre?
1. Oui
2. Non

Votre réponse (1/2): _
```

**IMPORTANT**: Pas d'option "3. Je ne sais pas" (décision finale validée)

### 2 Questions en Cascade

**CASCADE 1: Fièvre**
```
Q: "Avez-vous de la fièvre?" (1. Oui / 2. Non)
  → Si OUI: "Est-elle élevée (température >38.5°C)?" (1. Oui / 2. Non)
    → Si OUI: Enregistre fievre=oui, fievre_elevee=oui, fievre_legere=non
    → Si NON: Enregistre fievre=oui, fievre_elevee=non, fievre_legere=oui
  → Si NON: Enregistre fievre=non, fievre_elevee=non, fievre_legere=non
```

**CASCADE 2: Toux**
```
Q: "Avez-vous de la toux?" (1. Oui / 2. Non)
  → Si OUI: "Est-elle productive (avec crachats/expectorations)?" (1. Oui / 2. Non)
    → Si OUI: Enregistre toux=oui, toux_productive=oui
    → Si NON: Enregistre toux=oui, toux_productive=non
  → Si NON: Enregistre toux=non, toux_productive=non
```

### 21 Questions Principales (Ordre Thématique)

| # | Thème | Symptôme | Question |
|---|-------|----------|----------|
| 1 | COVID/Unique | `perte_odorat` | Avez-vous perdu l'odorat ou le goût? |
| 2 | Fièvre | `fievre` | Avez-vous de la fièvre? *(CASCADE)* |
| 3 | Fièvre | `frissons` | Avez-vous des frissons? |
| 4 | Respiratoire | `toux` | Avez-vous de la toux? *(CASCADE)* |
| 5 | Respiratoire | `nez_bouche` | Avez-vous le nez bouché? |
| 6 | Respiratoire | `difficultes_respiratoires` | Avez-vous des difficultés à respirer? |
| 7 | Respiratoire | `wheezing` | Avez-vous un sifflement respiratoire (wheezing)? |
| 8 | Gorge | `gorge_irritee` | Avez-vous la gorge irritée? |
| 9 | Gorge | `mal_gorge_intense` | Avez-vous un mal de gorge intense? |
| 10 | Gorge | `difficulte_avaler` | Avez-vous de la difficulté à avaler? |
| 11 | Nasaux | `eternuement` | Éternuez-vous fréquemment? |
| 12 | Nasaux | `nez_qui_coule_clair` | Avez-vous le nez qui coule (écoulement clair)? |
| 13 | Oculaire | `yeux_rouges` | Avez-vous les yeux rouges? |
| 14 | Oculaire | `yeux_qui_piquent` | Avez-vous les yeux qui piquent ou qui démangent? |
| 15 | Oculaire | `secretions_purulentes` | Avez-vous des sécrétions purulentes aux yeux? |
| 16 | Grippal | `fatigue_intense` | Ressentez-vous une fatigue intense? |
| 17 | Grippal | `courbatures` | Avez-vous des courbatures (douleurs musculaires)? |
| 18 | Neurologique | `mal_tete_intense` | Avez-vous un mal de tête intense? |
| 19 | Neurologique | `photophobie` | Êtes-vous sensible à la lumière (photophobie)? |
| 20 | Digestif | `diarrhee` | Avez-vous de la diarrhée? |
| 21 | Digestif | `vomissements` | Avez-vous des vomissements? |

**Convention**: snake_case, sans accents, mots complets

---

## Implémentation Moteur d'Inférence

### Backward Chaining - Fonctionnement

1. **Tester hypothèses séquentiellement** (ordre recommandé ci-dessous)
2. **Pour chaque hypothèse**: Vérifier conditions (syndromes + symptômes discriminants)
3. **Si condition manquante**: Poser question utilisateur
4. **Cache réponses**: Ne jamais re-poser la même question
5. **Inférer syndromes**: Déduire à partir des symptômes
6. **Diagnostic**: Première hypothèse satisfaite

### Ordre de Test des Maladies (Recommandé)

```prolog
% Ordre optimisé: discriminants uniques d'abord
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
])
```

**Résultat**: Moyenne 4-6 questions (optimal pour backward chaining)

### Prédicats Clés à Implémenter

```prolog
% Base de faits dynamique
:- dynamic connu/2.  % connu(symptome, oui/non)

% Vérification symptôme avec cache
verifier_symptome(Symptome) :-
    connu(Symptome, oui), !.
verifier_symptome(Symptome) :-
    connu(Symptome, non), !, fail.
verifier_symptome(Symptome) :-
    poser_question(Symptome, Reponse),
    assert(connu(Symptome, Reponse)),
    Reponse = oui.

% Gestion cascades
poser_question(fievre, Reponse) :-
    % Question principale
    % Si oui → poser sous-question fievre_elevee
    % Enregistrer fievre_elevee et fievre_legere selon réponse

% Règles syndromes (exemple)
syndrome_respiratoire :-
    verifier_symptome(fievre_legere),
    verifier_symptome(toux).

% Règles maladies (exemple)
grippe :-
    syndrome_respiratoire,
    syndrome_grippal,
    syndrome_febrile,
    \+ verifier_symptome(perte_odorat).

% Moteur principal
diagnostiquer(Maladie) :-
    member(Maladie, [covid19, migraine, conjonctivite, ...]),
    call(Maladie).
```

---

## Format Sortie

```
=======================================================
=== DIAGNOSTIC ===
=======================================================

Diagnostic: Migraine

-------------------------------------------------------
RECOMMANDATIONS:
-------------------------------------------------------
  - Repos dans piece sombre et calme
  - Antalgiques des premiers symptomes
  - Identifier facteurs declenchants
  - Consulter si migraines frequentes (>4/mois)
  - Tenir journal des crises
```

**Recommandations médicales** ajoutées pour chaque diagnostic (10 maladies)

---

## Critères Évaluation (Rappel)

| Critère | % | Focus Implémentation |
|---------|---|---------------------|
| Analyse/Modélisation | 33% | ✅ Complété (20 règles, graphe) |
| **Moteur + Code** | **27%** | 🔴 **À IMPLÉMENTER** |
| Validation/Tests | 15% | ⏳ Après implémentation |
| Rapport | 12% | ⏳ Daniel (après implémentation) |
| Longueur | 3% | Max 8 pages |
| Visuel | 10% | Times 12pt, justifié |

**Total**: 100%

---

## Notes Critiques pour l'Implémentation

### ✅ À FAIRE
- Implémenter les 20 règles en Prolog dans base_connaissances.pl
- Coder moteur backward chaining dans main.pl
- Gérer les 2 cascades (fievre, toux) avec logique conditionnelle
- Cache des réponses (ne jamais re-poser une question)
- Affichage diagnostic + syndromes identifiés
- Tests unitaires (tests.pl)

### ❌ À ÉVITER
- Générer recommandations médicales
- Ajouter option "Je ne sais pas" (décision finale: seulement Oui/Non)
- Créer sous-arbres indépendants (vérifier interconnexion)
- Dépasser 20 règles
- Interface graphique (terminal SWI-Prolog seulement)

### 🎯 Objectif Session Suivante

**IMPLÉMENTER main.pl et finaliser base_connaissances.pl**

Ordre suggéré:
1. Compléter base_connaissances.pl avec code Prolog des 20 règles
2. Implémenter infrastructure main.pl (verifier_symptome, cache, cascades)
3. Implémenter règles syndromes
4. Implémenter règles maladies
5. Implémenter moteur diagnostiquer/1
6. Interface utilisateur (poser_question/2)
7. Tests avec scénarios RESUME_PLAN.md (Migraine: 3 questions)

---

## Exemple Session Cible

```
=== SYSTEME EXPERT DE DIAGNOSTIC MEDICAL ===

Ce systeme vous posera quelques questions pour etablir
un diagnostic parmi 10 maladies courantes.

-------------------------------------------------------

Question: Avez-vous perdu l'odorat ou le gout?
1. Oui
2. Non
Votre reponse: 2

Question: Avez-vous un mal de tete intense?
1. Oui
2. Non
Votre reponse: 1

Question: Etes-vous sensible a la lumiere (photophobie)?
1. Oui
2. Non
Votre reponse: 1

=======================================================
=== DIAGNOSTIC ===
=======================================================

Diagnostic: Migraine

-------------------------------------------------------
RECOMMANDATIONS:
-------------------------------------------------------
  - Repos dans piece sombre et calme
  - Antalgiques des premiers symptomes
  - Identifier facteurs declenchants
  - Consulter si migraines frequentes (>4/mois)
  - Tenir journal des crises

-------------------------------------------------------
Session terminee.
```

**Résultat**: 3 questions pour Migraine (optimal), 4-7 questions en moyenne

---

*Document de référence TP2 - **IMPLÉMENTATION TERMINÉE ET VALIDÉE** (18 tests passent)*
