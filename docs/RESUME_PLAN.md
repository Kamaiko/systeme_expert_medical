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
   - [Les Symptômes](#les-symptômes)
   - [Les Questions](#les-questions)
3. [Interface Utilisateur](#interface-utilisateur)
4. [Exemple de Session Utilisateur](#exemple-de-session-utilisateur)
5. [Les 20 Règles d'Inférence](#les-20-règles-dinférence)

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
NIVEAU 1: SYMPTÔMES (21 symptômes + 2 cascades)
    ↓ (10 règles)
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
| **Questions** | 21 (+2 cascades) | 21 questions principales + 2 sous-questions conditionnelles (fièvre_elevee, toux_productive) |
| **Règles totales** | 20 | 10 règles (Symptômes → Syndromes) + 10 règles (Syndromes → Maladies) |

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
| **syndrome_febrile** | Fièvre élevée | 4 maladies (Grippe, COVID, Angine, Gastro) |
| **syndrome_grippal** | Fatigue intense + courbatures + fièvre élevée | 2 maladies (Grippe, COVID) |
| **syndrome_allergique** | Éternuements | 2 maladies (Allergie, Asthme) |
| **syndrome_oculaire** | Yeux rouges + yeux qui piquent | 2 maladies (Allergie, Conjonctivite) |
| **syndrome_digestif** | Diarrhée + vomissements | 1 maladie (Gastro-entérite) |
| **syndrome_neurologique** | Mal tête intense + photophobie | 1 maladie (Migraine) |
| **syndrome_orl** | Mal gorge intense | 1 maladie (Angine) |

**Note**: 5 syndromes sur 8 sont partagés par plusieurs maladies, créant ainsi l'arbre de dépendance global requis.

---

## Les Symptômes

Le système utilise **21 questions principales** avec **2 questions en cascade conditionnelle** (fièvre, toux).

### Organisation Thématique des Symptômes

| Thème | Symptômes Prolog | Questions en français |
|-------|------------------|----------------------|
| **COVID/Unique** | `perte_odorat` | Avez-vous perdu l'odorat ou le goût? |
| **Fièvre** | `fievre` **(CASCADE)** → `fievre_elevee` / `fievre_legere`, `frissons` | Avez-vous de la fièvre? → Si OUI: Est-elle élevée (>38.5°C)? <br> Avez-vous des frissons? |
| **Respiratoires** | `toux` **(CASCADE)** → `toux_productive`, `nez_bouche`, `difficultes_respiratoires`, `wheezing` | Avez-vous de la toux? → Si OUI: Est-elle productive? <br> Avez-vous le nez bouché? <br> Avez-vous des difficultés à respirer? <br> Avez-vous un sifflement respiratoire (wheezing)? |
| **Gorge (ORL)** | `gorge_irritee`, `mal_gorge_intense`, `difficulte_avaler` | Avez-vous la gorge irritée? <br> Avez-vous un mal de gorge intense? <br> Avez-vous de la difficulté à avaler? |
| **Nasaux/Allergiques** | `eternuement`, `nez_qui_coule_clair` | Éternuez-vous fréquemment? <br> Avez-vous le nez qui coule (écoulement clair)? |
| **Oculaires** | `yeux_rouges`, `yeux_qui_piquent`, `secretions_purulentes` | Avez-vous les yeux rouges? <br> Avez-vous les yeux qui piquent? <br> Avez-vous des sécrétions purulentes aux yeux? |
| **Systémiques/Grippaux** | `fatigue_intense`, `courbatures` | Ressentez-vous une fatigue intense? <br> Avez-vous des courbatures? |
| **Neurologiques** | `mal_tete_intense`, `photophobie` | Avez-vous un mal de tête intense? <br> Êtes-vous sensible à la lumière (photophobie)? |
| **Digestifs** | `diarrhee`, `vomissements` | Avez-vous de la diarrhée? <br> Avez-vous des vomissements? |

**Note sur les cascades:**
- **Fièvre**: Si réponse OUI → demande sous-question "élevée?" → enregistre `fievre_elevee` (OUI) ou `fievre_legere` (NON)
- **Toux**: Si réponse OUI → demande sous-question "productive?" → enregistre `toux_productive` (OUI/NON)

**Convention de nommage**: snake_case, sans accents, mots complets (compatibilité Prolog).

---

## Les Questions

### Ordre Thématique de Questionnement

Le système pose les questions groupées par **thèmes médicaux** pour un flow conversationnel naturel.

| # | Thème | Symptôme Prolog | Question en français |
|---|-------|-----------------|---------------------|
| 1 | COVID/Unique | `perte_odorat` | Avez-vous perdu l'odorat ou le goût? |
| 2 | Fièvre | `fievre` | Avez-vous de la fièvre? |
| 2a | ↳ Cascade | `fievre_elevee` / `fievre_legere` | **→ Si OUI:** Est-elle élevée (>38.5°C)? |
| 3 | Fièvre | `frissons` | Avez-vous des frissons? |
| 4 | Respiratoire | `toux` | Avez-vous de la toux? |
| 4a | ↳ Cascade | `toux_productive` | **→ Si OUI:** Est-elle productive (avec crachats)? |
| 5 | Respiratoire | `nez_bouche` | Avez-vous le nez bouché? |
| 6 | Respiratoire | `difficultes_respiratoires` | Avez-vous des difficultés à respirer? |
| 7 | Respiratoire | `wheezing` | Avez-vous un sifflement respiratoire (wheezing)? |
| 8 | Gorge (ORL) | `gorge_irritee` | Avez-vous la gorge irritée? |
| 9 | Gorge (ORL) | `mal_gorge_intense` | Avez-vous un mal de gorge intense? |
| 10 | Gorge (ORL) | `difficulte_avaler` | Avez-vous de la difficulté à avaler? |
| 11 | Nasaux/Allergique | `eternuement` | Éternuez-vous fréquemment? |
| 12 | Nasaux/Allergique | `nez_qui_coule_clair` | Avez-vous le nez qui coule (écoulement clair)? |
| 13 | Oculaire | `yeux_rouges` | Avez-vous les yeux rouges? |
| 14 | Oculaire | `yeux_qui_piquent` | Avez-vous les yeux qui piquent ou qui démangent? |
| 15 | Oculaire | `secretions_purulentes` | Avez-vous des sécrétions purulentes aux yeux? |
| 16 | Systémique/Grippal | `fatigue_intense` | Ressentez-vous une fatigue intense? |
| 17 | Systémique/Grippal | `courbatures` | Avez-vous des courbatures (douleurs musculaires)? |
| 18 | Neurologique | `mal_tete_intense` | Avez-vous un mal de tête intense? |
| 19 | Neurologique | `photophobie` | Êtes-vous sensible à la lumière (photophobie)? |
| 20 | Digestif | `diarrhee` | Avez-vous de la diarrhée? |
| 21 | Digestif | `vomissements` | Avez-vous des vomissements? |

**Stratégie de questionnement:**
- **Organisation thématique**: Questions regroupées par catégories médicales (Fièvre, Respiratoire, Gorge, etc.)
- **Cascades conditionnelles**: 2 questions ont des sous-questions (fièvre → élevée?, toux → productive?)
- **Backward chaining**: Le moteur ne pose que les questions nécessaires selon les hypothèses testées

**Nombre de questions posées par diagnostic:**
> Avec backward chaining, le système pose uniquement les questions pertinentes:
> - **Minimum**: 2-3 questions (ex: Migraine, Conjonctivite)
> - **Moyen**: 4-6 questions (la plupart des cas)
> - **Maximum**: 8-10 questions (cas complexes ou ambigus)

---

## Interface Utilisateur

### Format d'Interaction
Le système pose des questions fermées avec **2 choix de réponse**:

```
Question: Avez-vous de la fièvre?
1. Oui
2. Non

Votre réponse (1/2): _
```

**Pour les questions en cascade:**
```
Question: Avez-vous de la fièvre?
1. Oui
2. Non
Votre réponse (1/2): 1

Question: Est-elle élevée (température >38.5°C)?
1. Oui
2. Non
Votre réponse (1/2): 2

[Enregistre: fievre=oui, fievre_elevee=non, fievre_legere=oui]
```

### Sortie Finale
```
=== DIAGNOSTIC ===
Diagnostic: [Nom de la maladie]
Syndromes identifiés: [Liste des syndromes détectés]
```

---

## Exemple de Session Utilisateur

**Scénario**: Diagnostic de Migraine (3 questions seulement)

```
=== SYSTÈME EXPERT DE DIAGNOSTIC MÉDICAL ===

Question 1: Avez-vous perdu l'odorat ou le goût?
1. Oui | 2. Non
> 2

Question 2: Avez-vous un mal de tête intense?
1. Oui | 2. Non
> 1

Question 3: Êtes-vous sensible à la lumière (photophobie)?
1. Oui | 2. Non
> 1

=== DIAGNOSTIC ===
Diagnostic: Migraine
Syndromes identifiés: syndrome_neurologique
```

**Note**: Avec backward chaining, le moteur teste les maladies dans un ordre optimisé. Après avoir éliminé COVID (perte_odorat = non), il teste Migraine qui nécessite syndrome_neurologique (mal_tete_intense + photophobie). Les deux symptômes étant présents, le diagnostic est immédiat en seulement 3 questions.

---

## Les 20 Règles d'Inférence

### Niveau 1 → 2: Symptômes → Syndromes (10 règles)

| Syndrome | Règles |
|----------|--------|
| **Respiratoire (3)** | R1: Fièvre légère ∧ Toux → Respiratoire <br> R2: Fièvre élevée ∧ Toux → Respiratoire <br> R3: Nez bouché ∧ Gorge irritée → Respiratoire |
| **Fébrile (1)** | R4: Fièvre élevée → Fébrile |
| **Grippal (1)** | R5: Fatigue intense ∧ Courbatures ∧ Fièvre élevée → Grippal |
| **Allergique (1)** | R6: Éternuements → Allergique |
| **Oculaire (1)** | R7: Yeux rouges ∧ Yeux qui piquent → Oculaire |
| **Digestif (1)** | R8: Diarrhée ∧ Vomissements → Digestif |
| **Neurologique (1)** | R9: Mal tête intense ∧ Photophobie → Neurologique |
| **ORL (1)** | R10: Mal gorge intense → ORL |

### Niveau 2 → 3: Syndromes → Maladies (10 règles)

| Maladie | Règle |
|---------|-------|
| **Grippe** | R11: Respiratoire ∧ Grippal ∧ Fébrile ∧ ¬Perte odorat |
| **COVID-19** | R12: Respiratoire ∧ Grippal ∧ Fébrile ∧ Perte odorat |
| **Bronchite** | R13: Respiratoire ∧ Fièvre légère ∧ Toux productive |
| **Rhume** | R14: Respiratoire ∧ ¬Fébrile ∧ ¬Grippal |
| **Angine** | R15: ORL ∧ Fébrile |
| **Allergie saisonnière** | R16: Allergique ∧ Oculaire ∧ ¬Difficultés respiratoires |
| **Asthme** | R17: Respiratoire ∧ Allergique ∧ Wheezing ∧ Difficultés respiratoires |
| **Migraine** | R18: Neurologique |
| **Gastro-entérite** | R19: Digestif ∧ Fébrile |
| **Conjonctivite** | R20: Oculaire ∧ Sécrétions purulentes |

**Changements depuis version 23 règles:**
- ❌ Supprimé R4 ancien (Fébrile avec frissons) → Fébrile simplifié (fièvre élevée suffit)
- ❌ Supprimé R7 ancien (Allergique avec nez clair) → Allergique simplifié (éternuements suffisent)
- ❌ Supprimé R12 ancien (ORL avec difficulté avaler) → ORL simplifié (mal gorge intense suffit)

**Note**: Les discriminants (conditions négatives ¬ et positives spécifiques) évitent les faux positifs entre maladies similaires.

---

**Document préparé pour présentation TP2 - IFT2003**
