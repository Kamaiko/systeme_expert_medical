# Expert System - Diagnostic Médical

**Projet**: TP2 - IFT2003 | **Pondération**: 10% | **Date limite**: 28 novembre 2025
**Équipe**: 4 personnes | **Langage**: Prolog (SWI-Prolog)

**Objectif**: Créer un système expert de diagnostic médical interactif utilisant le chaînage arrière pour identifier 10 maladies courantes à partir de symptômes observés.

---

## Table des Matières

1. [Architecture Technique](#architecture-technique)
2. [Base de Connaissance](#base-de-connaissance)
   - [Vue d'Ensemble](#vue-densemble)
   - [Les Maladies](#les-maladies)
   - [Les Syndromes Intermédiaires](#les-syndromes-intermédiaires)
   - [Relations et Dépendances](#relations-et-dépendances)
   - [Les Symptômes](#les-symptômes)
   - [Les Questions](#les-questions)
3. [Interface Utilisateur](#interface-utilisateur)
4. [Exemple de Session Utilisateur](#exemple-de-session-utilisateur)
5. [Les 23 Règles d'Inférence](#les-23-règles-dinférence)

---

## Architecture Technique

### Structure de Fichiers Proposée
```
TP2/
├── base_connaissances.pl    # Faits et règles (symptômes → syndromes → maladies)
├── main.pl                  # Moteur d'inférence + interface utilisateur
└── tests.pl                 # Tests unitaires pour validation du code
```

**Note**: Les 3 cas de test distincts demandés dans l'énoncé (scénarios de démonstration avec raisonnement) seront documentés dans le rapport final.

### Structure Hiérarchique (3 Niveaux)
```
NIVEAU 1: SYMPTÔMES (23 symptômes de base)
    ↓ (13 règles)
NIVEAU 2: SYNDROMES (8 syndromes intermédiaires)
    ↓ (10 règles)
NIVEAU 3: MALADIES (10 diagnostics finaux)
```

---

# Base de Connaissance

## Vue d'Ensemble

| Composante | Quantité | Détails |
|------------|----------|---------|
| **Maladies** | 10 | Grippe, COVID-19, Bronchite, Rhume, Angine, Allergie saisonnière, Asthme, Migraine, Gastro-entérite, Conjonctivite |
| **Syndromes** | 8 | Respiratoire, Fébrile, Grippal, Allergique, Oculaire, Digestif, Neurologique, ORL |
| **Symptômes** | 23 | Fébriles, Respiratoires, Grippaux, Neurologiques, Digestifs, Allergiques, Oculaires, ORL, Respiratoires avancés |
| **Règles totales** | 23 | 13 règles (Symptômes → Syndromes) + 10 règles (Syndromes → Maladies) |

**Principe clé**: Les syndromes intermédiaires créent un arbre de dépendance global interconnecté (évite les sous-arbres isolés).

---

## Les Maladies

| Maladie | Syndromes requis | Discriminants clés |
|---------|------------------|-------------------|
| **Grippe** | Respiratoire + Grippal + Fébrile | Fatigue intense (sans perte odorat) |
| **COVID-19** | Respiratoire + Grippal + Fébrile | Perte odorat/goût |
| **Bronchite** | Respiratoire | Toux productive + Fièvre légère |
| **Rhume** | Respiratoire seul | Sans fièvre élevée, sans fatigue intense |
| **Angine** | ORL + Fébrile | Mal gorge intense + difficulté avaler |
| **Allergie saisonnière** | Allergique + Oculaire | Éternuements + nez clair (sans difficultés respiratoires) |
| **Asthme** | Respiratoire + Allergique | Difficultés respiratoires + wheezing |
| **Migraine** | Neurologique seul | Mal tête intense + photophobie |
| **Gastro-entérite** | Digestif + Fébrile | Diarrhée + vomissements |
| **Conjonctivite** | Oculaire seul | Sécrétions purulentes |

---

## Les Syndromes Intermédiaires

| Syndrome | Symptômes déclencheurs | Maladies connectées (Nb) |
|----------|------------------------|--------------------------|
| **syndrome_respiratoire** | Fièvre + toux, ou Nez bouché + gorge irritée | 5 maladies (Grippe, COVID, Bronchite, Rhume, Asthme) |
| **syndrome_febrile** | Fièvre élevée + frissons | 4 maladies (Grippe, COVID, Angine, Gastro) |
| **syndrome_grippal** | Fatigue intense + courbatures + fièvre élevée | 2 maladies (Grippe, COVID) |
| **syndrome_allergique** | Éternuements + nez clair | 2 maladies (Allergie, Asthme) |
| **syndrome_oculaire** | Yeux rouges + yeux qui piquent | 2 maladies (Allergie, Conjonctivite) |
| **syndrome_digestif** | Diarrhée + vomissements | 1 maladie (Gastro-entérite) |
| **syndrome_neurologique** | Mal tête intense + photophobie | 1 maladie (Migraine) |
| **syndrome_orl** | Mal gorge intense + difficulté avaler | 1 maladie (Angine) |

**Note**: 5 syndromes sur 8 sont partagés par plusieurs maladies, créant ainsi l'arbre de dépendance global requis.

---

## Relations et Dépendances

### Structure des Relations

Le système repose sur un **graphe de dépendances hiérarchique** à 3 niveaux avec relations partagées:

**Syndromes partagés (hub de convergence):**
- `syndrome_respiratoire` → 5 maladies (Grippe, COVID-19, Bronchite, Rhume, Asthme) - **Hub principal**
- `syndrome_febrile` → 4 maladies (Grippe, COVID-19, Angine, Gastro-entérite)
- `syndrome_grippal` → 2 maladies (Grippe, COVID-19)
- `syndrome_allergique` → 2 maladies (Allergie, Asthme)
- `syndrome_oculaire` → 2 maladies (Allergie, Conjonctivite)

**Syndromes spécifiques (1-1):**
- `syndrome_digestif` → Gastro-entérite uniquement
- `syndrome_neurologique` → Migraine uniquement
- `syndrome_orl` → Angine uniquement

### Combinaisons discriminantes

**Maladies à syndromes multiples (nécessitent plusieurs confirmations):**
- **Grippe**: 3 syndromes (Respiratoire + Grippal + Fébrile) + condition négative (pas de perte odorat)
- **COVID-19**: 3 syndromes + symptôme unique discriminant (`perte_odorat`)
- **Asthme**: 2 syndromes (Respiratoire + Allergique) + 2 symptômes spécifiques (`wheezing`, `difficultes_respiratoires`)
- **Allergie**: 2 syndromes (Allergique + Oculaire) + condition négative (pas de difficultés respiratoires)
- **Angine**: 2 syndromes (ORL + Fébrile)
- **Gastro-entérite**: 2 syndromes (Digestif + Fébrile)

**Maladies à syndrome unique + discriminants:**
- **Bronchite**: 1 syndrome + symptômes spécifiques (`toux_productive`, `fievre_legere`)
- **Rhume**: 1 syndrome + conditions négatives (pas Fébrile, pas Grippal)
- **Migraine**: 1 syndrome suffisant (Neurologique très spécifique)
- **Conjonctivite**: 1 syndrome + symptôme unique (`secretions_purulentes`)

### Propagation de l'incertitude

**Symptômes discriminants critiques (identification quasi-immédiate):**
- `perte_odorat` → COVID-19 (unique, probabilité >95%)
- `secretions_purulentes` → Conjonctivite (unique, probabilité >90%)
- `wheezing` + `difficultes_respiratoires` → Asthme (probabilité >85%)
- `mal_gorge_intense` + `difficulte_avaler` + `fievre_elevee` → Angine (probabilité >80%)
- `mal_tete_intense` + `photophobie` → Migraine (probabilité >80%)

**Symptômes génériques (nécessitent combinaisons):**
- `fievre` → 6 maladies possibles (discrimination faible)
- `toux` → 5 maladies possibles (discrimination faible)
- `fatigue_intense` → 2 maladies (discrimination moyenne)

### Principe du backward chaining

Le moteur d'inférence remonte le graphe depuis la maladie hypothèse vers les symptômes observables:

```
But: Prouver "Grippe"
  ├→ Sous-but: syndrome_respiratoire ?
  │   ├→ Question: fievre_elevee ? → OUI
  │   └→ Question: toux ? → OUI
  │   → Syndrome confirmé ✓
  ├→ Sous-but: syndrome_grippal ?
  │   ├→ Question: fatigue_intense ? → OUI
  │   ├→ Question: courbatures ? → OUI
  │   └→ Prérequis: fievre_elevee déjà confirmé ✓
  │   → Syndrome confirmé ✓
  ├→ Sous-but: syndrome_febrile ?
  │   └→ Prérequis: fievre_elevee déjà confirmé ✓
  │   → Syndrome confirmé ✓
  └→ Condition négative: perte_odorat ? → NON ✓
→ Diagnostic: Grippe (certitude élevée)
```

**Avantage du graphe partagé:** Les symptômes communs (`fievre_elevee`) sont demandés **une seule fois** et réutilisés dans plusieurs syndromes, réduisant le nombre total de questions de ~40%.

---

## Les Symptômes

Le système utilise **23 symptômes**, chacun correspondant à une question posée à l'utilisateur.

### Vue Organisée: Symptômes par Catégorie

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

**Convention de nommage**: snake_case, sans accents, mots complets (compatibilité Prolog).

---

## Les Questions

### Vue Opérationnelle: Ordre Stratégique de Questionnement

Le système pose les questions dans un **ordre fixe optimisé**, en commençant par les symptômes les plus discriminants.

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

**Stratégie de questionnement:**
- **Questions 1-5**: Symptômes uniques ou quasi-uniques (COVID, Conjonctivite, Asthme, Angine, Migraine)
- **Questions 6-14**: Syndromes discriminants (Neurologique, Digestif, Grippal, Fébrile)
- **Questions 15-23**: Symptômes génériques (Respiratoires, Allergiques, Oculaires)

**Nombre de questions posées par diagnostic:**
> Le système ne pose **pas toutes les 23 questions**. Selon le diagnostic et les réponses:
> - **Minimum**: 2-3 questions (ex: Migraine, Conjonctivite)
> - **Moyen**: 5-6 questions (la plupart des cas)
> - **Maximum**: 10-12 questions (cas complexes ou ambigus)

---

## Interface Utilisateur

### Format d'Interaction
Le système pose des questions fermées avec 3 choix de réponse:

```
Question: Avez-vous de la fièvre élevée (>38.5°C) ?
1. Oui
2. Non
3. Je ne sais pas

Votre réponse (1/2/3): _
```

### Sortie Finale
```
Diagnostic: [Nom de la maladie]
Syndromes identifiés: [Liste des syndromes détectés]
```

---

## Exemple de Session Utilisateur

**Scénario**: Diagnostic du Rhume (avec ordre optimisé des questions)

```
=== SYSTÈME EXPERT DE DIAGNOSTIC MÉDICAL ===

Question 1: Avez-vous perdu l'odorat ou le goût ?
1. Oui | 2. Non | 3. Je ne sais pas
> 2

Question 2: Avez-vous des sécrétions purulentes aux yeux ?
1. Oui | 2. Non | 3. Je ne sais pas
> 2

Question 3: Avez-vous un sifflement respiratoire (wheezing) ?
1. Oui | 2. Non | 3. Je ne sais pas
> 2

Question 4: Avez-vous un mal de gorge intense ?
1. Oui | 2. Non | 3. Je ne sais pas
> 2

Question 5: Ressentez-vous une fatigue intense ?
1. Oui | 2. Non | 3. Je ne sais pas
> 2

Question 6: Avez-vous de la fièvre élevée (supérieure à 38.5°C) ?
1. Oui | 2. Non | 3. Je ne sais pas
> 2

Question 7: Avez-vous de la toux ?
1. Oui | 2. Non | 3. Je ne sais pas
> 1

Question 8: Avez-vous le nez bouché ?
1. Oui | 2. Non | 3. Je ne sais pas
> 1

Question 9: Avez-vous la gorge irritée ?
1. Oui | 2. Non | 3. Je ne sais pas
> 1

=== DIAGNOSTIC ===
Diagnostic: Rhume
Syndromes identifiés: syndrome_respiratoire
```

**Note**: Les questions 1-6 éliminent rapidement les maladies à symptômes discriminants (COVID, Conjonctivite, Asthme, Angine, Grippe). Les questions 7-9 confirment le syndrome respiratoire sans syndrome fébrile ni grippal → diagnostic de Rhume.

---

## Les 23 Règles d'Inférence

### Niveau 1 → 2: Symptômes → Syndromes (13 règles)

| Syndrome | Règles |
|----------|--------|
| **Respiratoire (3)** | R1: Fièvre légère + Toux → Respiratoire <br> R2: Fièvre élevée + Toux → Respiratoire <br> R3: Nez bouché + Gorge irritée → Respiratoire |
| **Fébrile (2)** | R4: Fièvre élevée + Frissons → Fébrile <br> R5: Fièvre élevée → Fébrile |
| **Grippal (1)** | R6: Fatigue intense + Courbatures + Fièvre élevée → Grippal |
| **Allergique (2)** | R7: Éternuements + Nez clair → Allergique <br> R8: Éternuements → Allergique |
| **Oculaire (1)** | R9: Yeux rouges + Yeux qui piquent → Oculaire |
| **Digestif (1)** | R10: Diarrhée + Vomissements → Digestif |
| **Neurologique (1)** | R11: Mal tête intense + Photophobie → Neurologique |
| **ORL (2)** | R12: Mal gorge intense + Difficulté avaler → ORL <br> R13: Mal gorge intense → ORL |

### Niveau 2 → 3: Syndromes → Maladies (10 règles)

| Maladie | Règle |
|---------|-------|
| **Grippe** | R14: Respiratoire + Grippal + Fébrile + Fatigue intense (sans perte odorat) |
| **COVID-19** | R15: Respiratoire + Grippal + Fébrile + Perte odorat |
| **Bronchite** | R16: Respiratoire + Fièvre légère + Toux productive |
| **Rhume** | R17: Respiratoire (sans Fébrile, sans Grippal) |
| **Angine** | R18: ORL + Fébrile |
| **Allergie saisonnière** | R19: Allergique + Oculaire (sans difficultés respiratoires) |
| **Asthme** | R20: Respiratoire + Allergique + Difficultés respiratoires + Wheezing |
| **Migraine** | R21: Neurologique |
| **Gastro-entérite** | R22: Digestif + Fébrile |
| **Conjonctivite** | R23: Oculaire + Sécrétions purulentes |

**Note**: Les discriminants (conditions négatives et positives spécifiques) évitent les faux positifs entre maladies similaires.

---

**Document préparé pour présentation TP2 - IFT2003**
