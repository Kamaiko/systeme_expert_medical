# Plan de Projet - Système Expert de Diagnostic Médical
**Cours**: IFT2003 - Travail Pratique #2
**Échéance**: 28 Novembre 2025 (21h00)
**Pondération**: 10% de la note finale

---

## 🎯 Vision du Projet

### Concept : "Akinator Médical"

Le système fonctionne comme Akinator mais pour diagnostiquer des maladies courantes.

### Exemple de session utilisateur

```
SYSTÈME: Bienvenue dans le système de diagnostic médical.

SYSTÈME: Avez-vous de la fièvre ?
  1. Oui
  2. Non
  3. Je ne sais pas
UTILISATEUR: 1

SYSTÈME: Avez-vous de la toux ?
  1. Oui
  2. Non
  3. Je ne sais pas
UTILISATEUR: 1

SYSTÈME: Ressentez-vous une fatigue intense ?
  1. Oui
  2. Non
  3. Je ne sais pas
UTILISATEUR: 1

SYSTÈME: Avez-vous perdu l'odorat ou le goût ?
  1. Oui
  2. Non
  3. Je ne sais pas
UTILISATEUR: 2

DIAGNOSTIC: GRIPPE, car vous présentez fièvre et toux
```

---

## 🏗️ Architecture du Système

### Structure Hiérarchique (3 Niveaux)

Le système utilise une architecture à 3 niveaux pour garantir un arbre de dépendance global interconnecté:

```
SYMPTÔMES DE BASE
    ↓ (~13 règles)
SYNDROMES INTERMÉDIAIRES (8 syndromes)
    ↓ (~10 règles)
MALADIES FINALES
```

**⚠️ EXIGENCE CRITIQUE**: Les syndromes intermédiaires doivent être **partagés** par plusieurs maladies pour créer un arbre global interconnecté (pas de sous-arbres indépendants).

**Exemple d'interconnexion**:
- `syndrome_respiratoire` est partagé par 5 maladies (Grippe, COVID-19, Bronchite, Rhume, Asthme)
- `syndrome_fébrile` est partagé par 5 maladies (Grippe, COVID-19, Bronchite, Angine, Gastro-entérite)
- `syndrome_allergique` est partagé par 2 maladies (Allergie saisonnière, Asthme allergique)
- `syndrome_oculaire` est partagé par 2 maladies (Allergie saisonnière, Conjonctivite)

Voir [arbre_dependance.md](arbre_dependance.md) pour la visualisation complète.

---

## 📊 Base de Connaissances

### Liste des 10 Maladies (Diversifiées)

| # | Maladie | Catégorie | Syndromes Associés | Symptômes Distinctifs |
|---|---------|-----------|--------------------|-----------------------|
| 1 | **Grippe** | Respiratoire/Virale | syndrome_respiratoire + syndrome_grippal + syndrome_fébrile | Fatigue intense, courbatures, ¬perte_odorat |
| 2 | **COVID-19** | Respiratoire/Virale | syndrome_respiratoire + syndrome_grippal + syndrome_fébrile | Perte odorat/goût |
| 3 | **Bronchite** | Respiratoire | syndrome_respiratoire + syndrome_fébrile | Toux productive (glaires) |
| 4 | **Rhume** | Respiratoire | syndrome_respiratoire (uniquement) | ¬fièvre_élevée, ¬syndrome_grippal |
| 5 | **Angine** | ORL | syndrome_inflammatoire_gorge + syndrome_fébrile | Douleur gorge intense |
| 6 | **Allergie saisonnière** | Allergique | syndrome_allergique + syndrome_oculaire | Éternuements, yeux qui piquent, ¬difficultés_respiratoires |
| 7 | **Asthme allergique** | Allergique/Respiratoire | syndrome_allergique + syndrome_respiratoire | Wheezing, difficultés respiratoires |
| 8 | **Migraine** | Neurologique | syndrome_céphalique | Photophobie, douleur unilatérale, ¬diarrhée |
| 9 | **Gastro-entérite** | Digestive | syndrome_digestif + syndrome_fébrile | Diarrhée, vomissements |
| 10 | **Conjonctivite** | Ophtalmologique | syndrome_oculaire | Sécrétions purulentes, ¬éternuement |

### Les 8 Syndromes Intermédiaires (Clés de l'Interconnexion)

Ces syndromes sont le **ciment** qui connecte toutes les règles en un arbre global :

| Syndrome | Définition | Utilisé par (maladies) | Nb | Règle type |
|----------|------------|------------------------|----|----|
| **syndrome_respiratoire** | Atteinte voies respiratoires | Grippe, COVID-19, Bronchite, Rhume, Asthme | **5** | fievre_legere + toux → syndrome_respiratoire |
| **syndrome_fébrile** | État fébrile/fiévreux | Grippe, COVID-19, Bronchite, Angine, Gastro-entérite | **5** | fievre_elevee + frissons → syndrome_febrile |
| **syndrome_grippal** | État grippal généralisé | Grippe, COVID-19 | **2** | fatigue_intense + courbatures + fievre_elevee → syndrome_grippal |
| **syndrome_allergique** | Réaction allergique | Allergie, Asthme | **2** | eternuement + nez_qui_coule_clair → syndrome_allergique |
| **syndrome_oculaire** | Atteinte oculaire | Allergie, Conjonctivite | **2** | yeux_rouges + yeux_qui_piquent → syndrome_oculaire |
| **syndrome_digestif** | Troubles digestifs | Gastro-entérite | **1** | diarrhee + vomissements → syndrome_digestif |
| **syndrome_céphalique** | Maux de tête intenses | Migraine | **1** | mal_tete_intense + photophobie → syndrome_cephalique |
| **syndrome_inflammatoire_gorge** | Inflammation gorge | Angine | **1** | mal_gorge_intense + difficulte_avaler → syndrome_inflammatoire_gorge |

**Rôle critique** : Ces syndromes assurent que l'arbre est **global** et non fragmenté en sous-arbres indépendants.

**Interconnexion renforcée** : 2 syndromes partagés par 5 maladies + 3 syndromes partagés par 2 maladies = arbre global très fortement interconnecté ✅

### Conventions de Nommage Prolog

Pour assurer la compatibilité Prolog, tous les symptômes et syndromes suivent la convention **snake_case sans accents** :

#### Symptômes de Base (23 symptômes)

| Catégorie | Symptômes Prolog | Français |
|-----------|------------------|----------|
| **Fébriles** | `fievre_legere`, `fievre_elevee`, `frissons` | Fièvre légère, Fièvre élevée, Frissons |
| **Respiratoires** | `toux`, `toux_productive`, `nez_bouche`, `gorge_irritee` | Toux, Toux productive, Nez bouché, Gorge irritée |
| **Grippaux** | `fatigue_intense`, `courbatures` | Fatigue intense, Courbatures |
| **COVID** | `perte_odorat` | Perte odorat/goût |
| **Neurologiques** | `mal_tete_intense`, `photophobie` | Mal de tête intense, Photophobie |
| **ORL** | `mal_gorge_intense`, `difficulte_avaler` | Mal gorge intense, Difficulté avaler |
| **Digestifs** | `diarrhee`, `vomissements` | Diarrhée, Vomissements |
| **Allergiques** | `eternuement`, `nez_qui_coule_clair` | Éternuement, Nez qui coule clair |
| **Oculaires** | `yeux_rouges`, `yeux_qui_piquent`, `secretions_purulentes` | Yeux rouges, Yeux qui piquent, Sécrétions purulentes |
| **Respiratoires avancés** | `difficultes_respiratoires`, `wheezing` | Difficultés respiratoires, Wheezing (sifflement) |

**Total : 23 symptômes** utilisés dans les 23 règles du système

---

### Exemples de Règles (Format Pseudo-Code)

#### Règles Niveau 1 → 2 : Symptômes → Syndromes [13 règles]

```prolog
% Syndrome respiratoire (3 règles pour flexibilité)
R1:  fievre_legere ∧ toux → syndrome_respiratoire
R2:  fievre_elevee ∧ toux → syndrome_respiratoire
R3:  nez_bouche ∧ gorge_irritee → syndrome_respiratoire

% Syndrome fébrile (2 règles)
R4:  fievre_elevee ∧ frissons → syndrome_febrile
R5:  fievre_elevee → syndrome_febrile

% Syndrome grippal (1 règle stricte)
R6:  fatigue_intense ∧ courbatures ∧ fievre_elevee → syndrome_grippal

% Syndrome digestif (2 règles)
R7:  diarrhee ∧ vomissements → syndrome_digestif
R8:  diarrhee ∧ fievre_legere → syndrome_digestif

% Syndrome allergique (1 règle)
R9:  eternuement ∧ nez_qui_coule_clair → syndrome_allergique

% Syndrome céphalique (1 règle)
R10: mal_tete_intense ∧ photophobie → syndrome_cephalique

% Syndrome inflammatoire gorge (1 règle)
R11: mal_gorge_intense ∧ difficulte_avaler → syndrome_inflammatoire_gorge

% Syndrome oculaire (2 règles)
R12: yeux_rouges ∧ yeux_qui_piquent → syndrome_oculaire
R13: yeux_rouges ∧ secretions_purulentes → syndrome_oculaire
```

#### Règles Niveau 2 → 3 : Syndromes → Maladies [10 règles]

```prolog
% Grippe: 3 syndromes + discriminant
R14: syndrome_respiratoire ∧ syndrome_grippal ∧ syndrome_febrile ∧ fatigue_intense ∧ ¬perte_odorat → grippe

% COVID-19: 3 syndromes + discriminant unique
R15: syndrome_respiratoire ∧ syndrome_grippal ∧ syndrome_febrile ∧ perte_odorat → covid19

% Bronchite: 2 syndromes + discriminant
R16: syndrome_respiratoire ∧ syndrome_febrile ∧ toux_productive → bronchite

% Rhume: 1 syndrome (exclusion des autres)
R17: syndrome_respiratoire ∧ ¬syndrome_febrile ∧ ¬syndrome_grippal → rhume

% Angine: 2 syndromes
R18: syndrome_inflammatoire_gorge ∧ syndrome_febrile ∧ mal_gorge_intense → angine

% Allergie: 2 syndromes + exclusion
R19: syndrome_allergique ∧ syndrome_oculaire ∧ ¬difficultes_respiratoires → allergie_saisonniere

% Asthme: 2 syndromes + discriminants
R20: syndrome_allergique ∧ syndrome_respiratoire ∧ wheezing ∧ difficultes_respiratoires → asthme_allergique

% Migraine: 1 syndrome + discriminants stricts
R21: syndrome_cephalique ∧ mal_tete_intense ∧ photophobie ∧ ¬diarrhee → migraine

% Gastro-entérite: 2 syndromes
R22: syndrome_digestif ∧ syndrome_febrile ∧ diarrhee → gastro_enterite

% Conjonctivite: 1 syndrome + discriminant
R23: syndrome_oculaire ∧ secretions_purulentes ∧ ¬eternuement → conjonctivite
```

**Total : 23 règles** (13 + 10) ✅ Dans la contrainte 20-30 de l'énoncé

---

## ⚙️ Justifications des Choix de Conception

### Discriminants Stricts avec Négations

Pour éviter les faux positifs (ex: migraine confondue avec gastro à cause de la nausée), nous utilisons des discriminants stricts avec négations:

| Maladie | Discriminant Négatif | Raison |
|---------|----------------------|---------|
| **Grippe** | `¬perte_odorat` | Exclut COVID-19 (symptôme distinctif) |
| **Rhume** | `¬syndrome_febrile ∧ ¬syndrome_grippal` | Exclut maladies fébriles et grippales |
| **Allergie** | `¬difficultes_respiratoires` | Exclut asthme allergique |
| **Migraine** | `¬diarrhee` | Exclut syndrome digestif complet |
| **Conjonctivite** | `¬eternuement` | Exclut allergie saisonnière |

**Trade-off accepté** : Privilégie la **précision** (moins de faux positifs) au détriment de la **couverture** (quelques cas atypiques non détectés).

### Règles Multiples pour Flexibilité (OU Implicite)

Certains syndromes ont plusieurs règles pour couvrir différentes combinaisons de symptômes, simulant un OU logique en Prolog AND-only:

**Exemple - syndrome_respiratoire** (3 chemins possibles):
```prolog
syndrome_respiratoire :- fievre_legere, toux.        % Chemin 1
syndrome_respiratoire :- fievre_elevee, toux.        % Chemin 2
syndrome_respiratoire :- nez_bouche, gorge_irritee.  % Chemin 3
```

Cela permet au système de détecter le syndrome même si le patient ne présente pas exactement la même combinaison de symptômes.

**Syndromes avec règles multiples** :
- `syndrome_respiratoire` : 3 règles (flexibilité maximale)
- `syndrome_febrile` : 2 règles
- `syndrome_digestif` : 2 règles
- `syndrome_oculaire` : 2 règles

### Syndromes Fébrile et Oculaire (Nouveaux)

**syndrome_fébrile** :
- ✅ Renforce l'arbre global interconnecté (partagé par 5 maladies)
- ✅ Améliore la discrimination entre rhume (non fébrile) et autres maladies respiratoires
- ✅ Permet de différencier allergies (non fébriles) et maladies infectieuses

**syndrome_oculaire** :
- ✅ Connecte allergie et conjonctivite (évite diagnostic direct isolé)
- ✅ Améliore la cohérence du système (toutes maladies passent par syndromes)
- ✅ Partage symptômes oculaires entre 2 maladies distinctes

### Limitations Acceptées et Documentées

#### 1. Grippe vs COVID-19 : Ambiguïté Possible

**Edge case** : Patient avec tous symptômes grippaux mais répond "Non" à perte d'odorat.

**Résultat** : Système diagnostiquera "Grippe". Les variants COVID sans anosmie ne seront pas détectés.

**Justification** : Dans le cadre pédagogique du TP, ce trade-off est acceptable car :
- La perte d'odorat reste le discriminant principal entre Grippe et COVID-19
- Un système réel utiliserait des probabilités bayésiennes (hors scope du cours)
- L'objectif est la modélisation du raisonnement, pas la précision médicale absolue

#### 2. Gestion de "Je ne sais pas"

**Comportement** : Si l'utilisateur répond "Je ne sais pas" à un symptôme discriminant clé (ex: perte_odorat pour COVID-19), le système ne pourra pas confirmer la maladie.

**Impact** : Dans un système AND-only, "Je ne sais pas" = condition non satisfaite → syndrome/maladie non généré.

**Justification** : Cette limitation est acceptable dans le cadre pédagogique. Une amélioration future serait l'utilisation de logique floue ou de facteurs de certitude (vus en cours mais hors scope de ce TP).

#### 3. Symptômes Minimaux Requis

**Contrainte** : Le système nécessite au moins 2 symptômes pour détecter un syndrome (sauf `syndrome_febrile` qui accepte fièvre seule).

**Trade-off** :
- ✅ Évite faux positifs (ex: toux seule n'active pas syndrome_respiratoire)
- ⚠️ Crée quelques faux négatifs (cas atypiques avec symptômes isolés)

**Justification** : Choix délibéré privilégiant la précision sur la couverture maximale.

#### 4. Maladies à 1 Syndrome (Gastro, Migraine, Angine)

**Observation** : 3 maladies n'utilisent qu'un seul syndrome unique (non partagé).

**Vulnérabilité potentielle** : Moins de vérifications croisées que maladies à 2-3 syndromes.

**Mitigation** : Discriminants stricts ajoutés (ex: migraine nécessite `¬diarrhee` pour exclure gastro en cas de nausée).

**Justification** : Ces maladies représentent des catégories médicales distinctes. Les connecter artificiellement à d'autres syndromes créerait des faux positifs.

---

## 🏗️ Structure de Fichiers Proposée

```
TP2/
├── base_connaissances.pl    # Faits et règles (symptômes → syndromes → maladies)
├── main.pl                  # Moteur d'inférence + interface utilisateur
└── tests.pl                 # Tests unitaires pour validation du code
```

**Note**: Les 3 cas de test distincts demandés dans l'énoncé (scénarios de démonstration avec raisonnement) seront documentés dans le rapport final.

---

## 💬 Les 23 Questions du Système

Le système pose les questions dans un **ordre fixe optimisé**, en commençant par les symptômes les plus discriminants (qui identifient rapidement des maladies spécifiques ou éliminent plusieurs hypothèses).

### Ordre Stratégique des Questions

| # | Symptôme Prolog | Question en français |
|---|-----------------|---------------------|
| 1 | `perte_odorat` | Avez-vous perdu l'odorat ou le goût ? |
| 2 | `secretions_purulentes` | Avez-vous des sécrétions purulentes aux yeux ? |
| 3 | `wheezing` | Avez-vous un sifflement respiratoire (wheezing) ? |
| 4 | `mal_gorge_intense` | Avez-vous un mal de gorge intense ? |
| 5 | `photophobie` | Êtes-vous sensible à la lumière (photophobie) ? |
| 6 | `mal_tete_intense` | Avez-vous un mal de tête intense ? |
| 7 | `diarrhee` | Avez-vous de la diarrhée ? |
| 8 | `vomissements` | Avez-vous des vomissements ? |
| 9 | `fatigue_intense` | Ressentez-vous une fatigue intense ? |
| 10 | `courbatures` | Avez-vous des courbatures (douleurs musculaires) ? |
| 11 | `fievre_elevee` | Avez-vous de la fièvre élevée (supérieure à 38.5°C) ? |
| 12 | `fievre_legere` | Avez-vous de la fièvre légère (entre 37.5°C et 38.5°C) ? |
| 13 | `frissons` | Avez-vous des frissons ? |
| 14 | `toux_productive` | Avez-vous une toux productive (avec expectorations/crachats) ? |
| 15 | `toux` | Avez-vous de la toux ? |
| 16 | `nez_bouche` | Avez-vous le nez bouché ? |
| 17 | `gorge_irritee` | Avez-vous la gorge irritée ? |
| 18 | `difficulte_avaler` | Avez-vous de la difficulté à avaler ? |
| 19 | `eternuement` | Éternuez-vous fréquemment ? |
| 20 | `nez_qui_coule_clair` | Avez-vous le nez qui coule (écoulement clair) ? |
| 21 | `yeux_rouges` | Avez-vous les yeux rouges ? |
| 22 | `yeux_qui_piquent` | Avez-vous les yeux qui piquent ou qui démangent ? |
| 23 | `difficultes_respiratoires` | Avez-vous des difficultés respiratoires ? |

### Stratégie de Questionnement

**Ordre fixe optimisé (Stratégie 1 Optimisée):**
- **Questions 1-5**: Symptômes uniques ou quasi-uniques (COVID, Conjonctivite, Asthme, Angine, Migraine)
- **Questions 6-14**: Syndromes discriminants (Neurologique, Digestif, Grippal, Fébrile)
- **Questions 15-23**: Symptômes génériques (Respiratoires, Allergiques, Oculaires)

**Nombre de questions posées par diagnostic:**

Le système ne pose **pas toutes les 23 questions**. Selon le diagnostic et les réponses:
- **Minimum**: 2-3 questions (ex: Migraine, Conjonctivite)
- **Moyen**: 5-6 questions (la plupart des cas)
- **Maximum**: 10-12 questions (cas complexes ou ambigus)

### Note Technique sur l'Implémentation Prolog

**En Prolog, l'ordre des clauses = ordre d'évaluation.** Pour implémenter cette stratégie optimisée, il suffit de définir les prédicats de vérification de symptômes dans cet ordre dans `base_connaissances.pl`. Le chaînage arrière natif de Prolog testera alors automatiquement les symptômes discriminants en premier.

**Avantages:**
- ✅ Aucune complexité algorithmique supplémentaire
- ✅ Comportement natif de Prolog (ordre des clauses)
- ✅ Réduction significative du nombre moyen de questions (~30%)
- ✅ Diagnostics uniques détectés rapidement (2-4 questions)

---
