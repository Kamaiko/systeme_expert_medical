# Expert System - Diagnostic Médical

**Projet**: TP2 - IFT2003 | **Pondération**: 10% | **Date limite**: 28 novembre 2025
**Équipe**: 4 personnes | **Langage**: Prolog (SWI-Prolog)

**Objectif**: Créer un système expert de diagnostic médical interactif utilisant le chaînage arrière pour identifier 10 maladies courantes à partir de symptômes observés.

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

### Méthode d'Inférence
**Chaînage arrière (backward chaining)**: Le système part de l'hypothèse de maladie et remonte aux symptômes pour valider ou réfuter le diagnostic.

### Structure Hiérarchique (3 Niveaux)
```
NIVEAU 1: SYMPTÔMES (17 symptômes de base)
    ↓ (13 règles)
NIVEAU 2: SYNDROMES (8 syndromes intermédiaires)
    ↓ (10 règles)
NIVEAU 3: MALADIES (10 diagnostics finaux)
```

---

## Vue d'Ensemble - Base de Connaissances

| Composante | Quantité | Détails |
|------------|----------|---------|
| **Maladies** | 10 | Grippe, COVID-19, Bronchite, Rhume, Angine, Allergie saisonnière, Asthme, Migraine, Gastro-entérite, Conjonctivite |
| **Syndromes** | 8 | Respiratoire, Fébrile, Grippal, Allergique, Oculaire, Digestif, Neurologique, ORL |
| **Symptômes** | 17 | Fébriles, Respiratoires, Grippaux, Neurologiques, Digestifs, Allergiques, Oculaires |
| **Règles totales** | 23 | 13 règles (Symptômes → Syndromes) + 10 règles (Syndromes → Maladies) |

**Principe clé**: Les syndromes intermédiaires créent un arbre de dépendance global interconnecté (évite les sous-arbres isolés).

---

## Les 10 Maladies

| Maladie | Syndromes requis | Discriminants clés |
|---------|------------------|-------------------|
| **Grippe** | Respiratoire + Grippal + Fébrile | Fatigue intense (sans perte odorat) |
| **COVID-19** | Respiratoire + Grippal + Fébrile | Perte odorat/goût |
| **Bronchite** | Respiratoire + Fébrile | Toux productive |
| **Rhume** | Respiratoire seul | Sans fièvre élevée, sans fatigue intense |
| **Angine** | ORL + Fébrile | Mal gorge intense + difficulté avaler |
| **Allergie saisonnière** | Allergique + Oculaire | Éternuements + nez clair (sans difficultés respiratoires) |
| **Asthme** | Respiratoire + Allergique | Difficultés respiratoires + wheezing |
| **Migraine** | Neurologique seul | Mal tête intense + photophobie |
| **Gastro-entérite** | Digestif + Fébrile | Diarrhée + vomissements |
| **Conjonctivite** | Oculaire seul | Sécrétions purulentes |

---

## Les 8 Syndromes Intermédiaires

| Syndrome | Symptômes déclencheurs | Maladies connectées (Nb) |
|----------|------------------------|--------------------------|
| **syndrome_respiratoire** | Fièvre + toux, ou Nez bouché + gorge irritée | 5 maladies (Grippe, COVID, Bronchite, Rhume, Asthme) |
| **syndrome_febrile** | Fièvre élevée + frissons | 5 maladies (Grippe, COVID, Bronchite, Angine, Gastro) |
| **syndrome_grippal** | Fatigue intense + courbatures + fièvre élevée | 2 maladies (Grippe, COVID) |
| **syndrome_allergique** | Éternuements + nez clair | 2 maladies (Allergie, Asthme) |
| **syndrome_oculaire** | Yeux rouges + yeux qui piquent | 2 maladies (Allergie, Conjonctivite) |
| **syndrome_digestif** | Diarrhée + vomissements | 1 maladie (Gastro-entérite) |
| **syndrome_neurologique** | Mal tête intense + photophobie | 1 maladie (Migraine) |
| **syndrome_orl** | Mal gorge intense + difficulté avaler | 1 maladie (Angine) |

**Note**: 5 syndromes sur 8 sont partagés par plusieurs maladies, créant ainsi l'arbre de dépendance global requis.

---

## Les 17 Symptômes (Conventions Prolog)

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

**Scénario**: Diagnostic du Rhume

```
=== SYSTÈME EXPERT DE DIAGNOSTIC MÉDICAL ===

Question 1: Avez-vous de la toux ?
1. Oui | 2. Non | 3. Je ne sais pas
> 1

Question 2: Avez-vous le nez bouché ?
1. Oui | 2. Non | 3. Je ne sais pas
> 1

Question 3: Avez-vous la gorge irritée ?
1. Oui | 2. Non | 3. Je ne sais pas
> 1

Question 4: Avez-vous de la fièvre élevée (>38.5°C) ?
1. Oui | 2. Non | 3. Je ne sais pas
> 2

Question 5: Avez-vous de la fatigue intense ?
1. Oui | 2. Non | 3. Je ne sais pas
> 2

=== DIAGNOSTIC ===
Diagnostic: Rhume
Syndromes identifiés: syndrome_respiratoire
```

---

## Les 23 Règles du Système

### Niveau 1 → 2: Symptômes → Syndromes (13 règles)

**Syndrome Respiratoire** (3 règles - flexibilité):
- R1: Fièvre légère + Toux → Respiratoire
- R2: Fièvre élevée + Toux → Respiratoire
- R3: Nez bouché + Gorge irritée → Respiratoire

**Syndrome Fébrile** (2 règles):
- R4: Fièvre élevée + Frissons → Fébrile
- R5: Fièvre élevée → Fébrile

**Syndrome Grippal** (1 règle):
- R6: Fatigue intense + Courbatures + Fièvre élevée → Grippal

**Syndrome Allergique** (2 règles):
- R7: Éternuements + Nez clair → Allergique
- R8: Éternuements → Allergique

**Syndrome Oculaire** (1 règle):
- R9: Yeux rouges + Yeux qui piquent → Oculaire

**Syndrome Digestif** (1 règle):
- R10: Diarrhée + Vomissements → Digestif

**Syndrome Neurologique** (1 règle):
- R11: Mal tête intense + Photophobie → Neurologique

**Syndrome ORL** (2 règles):
- R12: Mal gorge intense + Difficulté avaler → ORL
- R13: Mal gorge intense → ORL

---

### Niveau 2 → 3: Syndromes → Maladies (10 règles)

- **R14: Grippe** = Respiratoire + Grippal + Fébrile + Fatigue intense (sans perte odorat)
- **R15: COVID-19** = Respiratoire + Grippal + Fébrile + Perte odorat
- **R16: Bronchite** = Respiratoire + Fébrile + Toux productive
- **R17: Rhume** = Respiratoire (sans Fébrile, sans Grippal)
- **R18: Angine** = ORL + Fébrile
- **R19: Allergie saisonnière** = Allergique + Oculaire (sans difficultés respiratoires)
- **R20: Asthme** = Respiratoire + Allergique + Difficultés respiratoires + Wheezing
- **R21: Migraine** = Neurologique
- **R22: Gastro-entérite** = Digestif + Fébrile
- **R23: Conjonctivite** = Oculaire + Sécrétions purulentes

**Principe**: Les discriminants (conditions négatives et positives spécifiques) évitent les faux positifs entre maladies similaires.

---

## Contraintes Respectées

- Maximum 30 règles (23 règles créées)
- Arbre de dépendance global interconnecté (5/8 syndromes partagés)
- Chaînage arrière implémenté
- Interface simple avec 3 choix de réponse
- Rapport maximum 8 pages

---

**Document préparé pour présentation TP2 - IFT2003**
