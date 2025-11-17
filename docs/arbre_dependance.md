# Arbre de Dépendance Global - Système Expert Diagnostic Médical

> Représentation graphique complète de l'interconnexion des règles (Version finale - 20 règles, 8 syndromes)

---

## Vue d'Ensemble - Arbre Global Interconnecté

```
                                    SYMPTÔMES (Niveau 1)
                                          │
            ┌─────────────────────────────┼─────────────────────────────┐
            │                             │                             │
     SYMPTÔMES RESPIRATOIRES      SYMPTÔMES FÉBRILES           SYMPTÔMES NEUROLOGIQUES
     SYMPTÔMES GRIPPAUX           SYMPTÔMES DIGESTIFS         SYMPTÔMES ALLERGIQUES
     SYMPTÔMES ORL                SYMPTÔMES OCULAIRES
            │                             │                             │
            └─────────────────────────────┼─────────────────────────────┘
                                          │
                                    [20 règles]
                                          │
                                          ↓
                              SYNDROMES (Niveau 2) - 8 syndromes
                    ┌──────────────────────┼──────────────────────┐
                    │                      │                      │
         syndrome_respiratoire    syndrome_febrile         syndrome_grippal
         syndrome_allergique      syndrome_oculaire        syndrome_digestif
         syndrome_neurologique    syndrome_orl
                    │                      │                      │
                    └──────────────────────┼──────────────────────┘
                                          │
                                          ↓
                               MALADIES (Niveau 3) - 10 maladies
                    ┌──────────────────────┼──────────────────────┐
                    │                      │                      │
                Grippe                 COVID-19                Bronchite
                Rhume                  Angine                  Allergie saisonnière
                Asthme                 Migraine            Gastro-entérite
               Conjonctivite
```

---

## Arbre Détaillé - Toutes les Connexions

### Branche Respiratoire (Interconnexion Majeure - 5 maladies)

```
                            SYMPTÔMES
                                │
        ┌───────────────────────┼───────────────────────┐
        │                       │                       │
   [fievre_legere]          [toux]              [nez_bouche]
   [fievre_elevee]                              [gorge_irritee]
        │                       │                       │
        └───────────┬───────────┴───────────┬───────────┘
                    │                       │
                    ↓                       ↓
         syndrome_respiratoire (3 règles différentes)
                    │
        ┌───────────┼───────────┬───────────┬───────────┐
        │           │           │           │           │
        ↓           ↓           ↓           ↓           ↓
    GRIPPE      COVID-19    BRONCHITE     RHUME       ASTHME
     (3 syn)    (3 syn)     (symp+syn)    (1 syn)    (symp+2 syn)
```

**Règles activées**:
- **R1**: `fievre_legere ∧ toux → syndrome_respiratoire`
- **R2**: `fievre_elevee ∧ toux → syndrome_respiratoire`
- **R3**: `nez_bouche ∧ gorge_irritee → syndrome_respiratoire`

**Maladies utilisant syndrome_respiratoire**: Grippe, COVID-19, Bronchite, Rhume, Asthme

---

### Branche Fébrile (Interconnexion Majeure - 4 maladies)

```
                            SYMPTÔMES
                                │
                        [fievre_elevee]
                                │
                                ↓
                      syndrome_febrile (1 règle simplifiée)
                                │
        ┌───────────┬───────────┼───────────┬───────────┐
        │           │           │           │           │
        ↓           ↓           ↓           ↓
    GRIPPE      COVID-19     ANGINE    GASTRO-ENTÉRITE
```

**Règle activée**:
- **R4**: `fievre_elevee → syndrome_febrile`

**Note**: Simplifié depuis version 23 règles (frissons n'est plus obligatoire)

**Maladies utilisant syndrome_febrile**: Grippe, COVID-19, Angine, Gastro-entérite

---

### Sous-branche Syndrome Grippal (2 maladies)

```
                            SYMPTÔMES
                                │
        ┌───────────────────────┼──────────────────────────┐
        │                       │                          │
  [fatigue_intense]       [courbatures]            [fievre_elevee]
        │                       │                          │
        └───────────────────────┴──────────┬───────────────┘
                                           │
                                           ↓
                                  syndrome_grippal
                                           │
                                   ┌───────┴───────┐
                                   │               │
                                   ↓               ↓
                               GRIPPE          COVID-19
```

**Règle activée**:
- **R5**: `fatigue_intense ∧ courbatures ∧ fievre_elevee → syndrome_grippal`

**Maladies utilisant syndrome_grippal**: Grippe, COVID-19

---

### Branche Allergique (2 maladies)

```
                            SYMPTÔMES
                                │
                          [eternuement]
                                │
                                ↓
                      syndrome_allergique (1 règle simplifiée)
                                │
                        ┌───────┴────────┐
                        │                │
                        ↓                ↓
                ALLERGIE SAISONNIÈRE   ASTHME
                   (2 syn)          (symp+2 syn)
                (sans difficultés)  (avec wheezing +
                 respiratoires)     difficultés respiratoires)
```

**Règle activée**:
- **R6**: `eternuement → syndrome_allergique`

**Note**: Simplifié depuis version 23 règles (nez_qui_coule_clair n'est plus obligatoire)

**Maladies utilisant syndrome_allergique**: Allergie saisonnière, Asthme

---

### Branche Oculaire (2 maladies)

```
                            SYMPTÔMES
                                │
        ┌───────────────────────┼──────────────────────────┐
        │                       │                          │
   [yeux_rouges]        [yeux_qui_piquent]    [secretions_purulentes]
        │                       │                          │
        └───────────────────────┴──────────┬───────────────┘
                                           │
                                           ↓
                                  syndrome_oculaire
                                           │
                                   ┌───────┴───────┐
                                   │               │
                                   ↓               ↓
                           ALLERGIE SAISONNIÈRE   CONJONCTIVITE
                               (2 syn)              (symp+syn)
```

**Règles activées**:
- **R7**: `yeux_rouges ∧ yeux_qui_piquent → syndrome_oculaire`

**Maladies utilisant syndrome_oculaire**: Allergie saisonnière, Conjonctivite

---

### Branche Digestive (1 maladie)

```
                            SYMPTÔMES
                                │
        ┌───────────────────────┼───────────────────┐
        │                       │                   │
    [diarrhee]            [vomissements]      [fievre_elevee]
        │                       │                   │
        └───────────┬───────────┘                   │
                    │                               │
                    ↓                               │
            syndrome_digestif                       │
                    │                               │
                    └───────────┬───────────────────┘
                                │
                                ↓
                        GASTRO-ENTÉRITE
                        (2 syn: digestif + fébrile)
```

**Règle activée**:
- **R8**: `diarrhee ∧ vomissements → syndrome_digestif`

**Maladies utilisant syndrome_digestif**: Gastro-entérite

---

### Branche Neurologique (1 maladie)

```
                            SYMPTÔMES
                                │
        ┌───────────────────────┼───────────────────┐
        │                       │                   │
  [mal_tete_intense]       [photophobie]           │
        │                       │                   │
        └───────────┬───────────┘                   │
                    │                               │
                    ↓                               │
          syndrome_neurologique                     │
                    │                               │
                    ↓                               │
                MIGRAINE                            │
               (1 syn)                              │
```

**Règle activée**:
- **R9**: `mal_tete_intense ∧ photophobie → syndrome_neurologique`

**Maladies utilisant syndrome_neurologique**: Migraine

---

### Branche ORL (1 maladie)

```
                            SYMPTÔMES
                                │
        ┌───────────────────────┼──────────────────────┐
        │                       │                      │
  [mal_gorge_intense]     [fievre_elevee]             │
        │                       │                      │
        └───────────┬───────────┘                      │
                    │                                  │
                    ↓                                  │
             syndrome_orl (1 règle simplifiée)        │
                    │                                  │
                    └──────────┬───────────────────────┘
                               │
                               ↓
                           ANGINE
                        (2 syn: orl + fébrile)
```

**Règle activée**:
- **R10**: `mal_gorge_intense → syndrome_orl`

**Note**: Simplifié depuis version 23 règles (difficulte_avaler n'est plus obligatoire)

**Maladies utilisant syndrome_orl**: Angine

---

## Vue Matricielle - Interconnexions des Syndromes

Ce tableau montre comment les syndromes sont **partagés** par plusieurs maladies (clé de l'arbre global):

| Syndrome | Grippe | COVID | Bronchite | Rhume | Angine | Allergie | Asthme | Migraine | Gastro | Conjonctivite | **Total** |
|----------|--------|-------|-----------|-------|--------|----------|--------|----------|--------|---------------|-----------|
| **syndrome_respiratoire** | ✅ | ✅ | ✅ | ✅ | ❌ | ❌ | ✅ | ❌ | ❌ | ❌ | **5** |
| **syndrome_febrile** | ✅ | ✅ | ❌ | ❌ | ✅ | ❌ | ❌ | ❌ | ✅ | ❌ | **4** |
| **syndrome_grippal** | ✅ | ✅ | ❌ | ❌ | ❌ | ❌ | ❌ | ❌ | ❌ | ❌ | **2** |
| **syndrome_allergique** | ❌ | ❌ | ❌ | ❌ | ❌ | ✅ | ✅ | ❌ | ❌ | ❌ | **2** |
| **syndrome_oculaire** | ❌ | ❌ | ❌ | ❌ | ❌ | ✅ | ❌ | ❌ | ❌ | ✅ | **2** |
| **syndrome_digestif** | ❌ | ❌ | ❌ | ❌ | ❌ | ❌ | ❌ | ❌ | ✅ | ❌ | **1** |
| **syndrome_neurologique** | ❌ | ❌ | ❌ | ❌ | ❌ | ❌ | ❌ | ✅ | ❌ | ❌ | **1** |
| **syndrome_orl** | ❌ | ❌ | ❌ | ❌ | ✅ | ❌ | ❌ | ❌ | ❌ | ❌ | **1** |

**Observation clé - Interconnexion Renforcée**:
- ✅ **1 syndrome** partagé par **5 maladies** (respiratoire)
- ✅ **1 syndrome** partagé par **4 maladies** (fébrile)
- ✅ **3 syndromes** partagés par **2 maladies** chacun (grippal, allergique, oculaire)
- ✅ **5/8 syndromes** sont partagés (62.5% de partage)
- ✅ **8/10 maladies** utilisent au moins 1 syndrome partagé

**Résultat**: Arbre global **très fortement interconnecté** ✅✅✅

---

## Les 20 Règles d'Inférence (Version Finale)

### Niveau 1 → 2: Symptômes → Syndromes (10 règles)

| # | Règle | Syndrome produit |
|---|-------|------------------|
| **R1** | `fievre_legere ∧ toux → syndrome_respiratoire` | Respiratoire |
| **R2** | `fievre_elevee ∧ toux → syndrome_respiratoire` | Respiratoire |
| **R3** | `nez_bouche ∧ gorge_irritee → syndrome_respiratoire` | Respiratoire |
| **R4** | `fievre_elevee → syndrome_febrile` | Fébrile (SIMPLIFIÉ) |
| **R5** | `fatigue_intense ∧ courbatures ∧ fievre_elevee → syndrome_grippal` | Grippal |
| **R6** | `eternuement → syndrome_allergique` | Allergique (SIMPLIFIÉ) |
| **R7** | `yeux_rouges ∧ yeux_qui_piquent → syndrome_oculaire` | Oculaire |
| **R8** | `diarrhee ∧ vomissements → syndrome_digestif` | Digestif |
| **R9** | `mal_tete_intense ∧ photophobie → syndrome_neurologique` | Neurologique |
| **R10** | `mal_gorge_intense → syndrome_orl` | ORL (SIMPLIFIÉ) |

### Niveau 2 → 3: Syndromes → Maladies (10 règles)

| # | Règle | Maladie produite |
|---|-------|------------------|
| **R11** | `syndrome_respiratoire ∧ syndrome_grippal ∧ syndrome_febrile ∧ ¬perte_odorat → grippe` | Grippe |
| **R12** | `syndrome_respiratoire ∧ syndrome_grippal ∧ syndrome_febrile ∧ perte_odorat → covid19` | COVID-19 |
| **R13** | `syndrome_respiratoire ∧ fievre_legere ∧ toux_productive → bronchite` | Bronchite |
| **R14** | `syndrome_respiratoire ∧ ¬syndrome_febrile ∧ ¬syndrome_grippal → rhume` | Rhume |
| **R15** | `syndrome_orl ∧ syndrome_febrile → angine` | Angine |
| **R16** | `syndrome_allergique ∧ syndrome_oculaire ∧ ¬difficultes_respiratoires → allergie` | Allergie saisonnière |
| **R17** | `syndrome_respiratoire ∧ syndrome_allergique ∧ wheezing ∧ difficultes_respiratoires → asthme` | Asthme |
| **R18** | `syndrome_neurologique → migraine` | Migraine |
| **R19** | `syndrome_digestif ∧ syndrome_febrile → gastro_enterite` | Gastro-entérite |
| **R20** | `syndrome_oculaire ∧ secretions_purulentes → conjonctivite` | Conjonctivite |

---

## Flux de Raisonnement - Exemple Complet (Grippe)

```
┌──────────────────────────────────────────────────────────────────────┐
│ ÉTAPE 1: Collecte Symptômes (Backward Chaining)                     │
├──────────────────────────────────────────────────────────────────────┤
│ Le moteur teste l'hypothèse "grippe" et vérifie ses conditions:     │
│                                                                       │
│ Q: Avez-vous perdu l'odorat ou le goût?  → 2 (Non)                  │
│    [¬perte_odorat = VRAI → continue grippe, élimine COVID]          │
│                                                                       │
│ Q: Avez-vous de la fièvre?                → 1 (Oui)                  │
│    → Q: Est-elle élevée (>38.5°C)?       → 1 (Oui)                  │
│    [fievre_elevee = OUI]                                             │
│                                                                       │
│ Q: Avez-vous de la toux?                  → 1 (Oui)                  │
│    [toux = OUI → R2 activable: syndrome_respiratoire]               │
│                                                                       │
│ Q: Ressentez-vous une fatigue intense?    → 1 (Oui)                  │
│ Q: Avez-vous des courbatures?             → 1 (Oui)                  │
│    [fatigue_intense ∧ courbatures ∧ fievre_elevee                   │
│     → R5 activable: syndrome_grippal]                                │
└──────────────────────────────────────────────────────────────────────┘
                              ↓
┌──────────────────────────────────────────────────────────────────────┐
│ ÉTAPE 2: Déduction Syndromes (Niveau 1→2)                           │
├──────────────────────────────────────────────────────────────────────┤
│ R2: fievre_elevee ∧ toux → syndrome_respiratoire      [ACTIVÉE]     │
│ R4: fievre_elevee → syndrome_febrile                   [ACTIVÉE]     │
│ R5: fatigue_intense ∧ courbatures ∧ fievre_elevee                   │
│     → syndrome_grippal                                 [ACTIVÉE]     │
│                                                                       │
│ Résultat: syndrome_respiratoire = VRAI                               │
│           syndrome_febrile = VRAI                                    │
│           syndrome_grippal = VRAI                                    │
└──────────────────────────────────────────────────────────────────────┘
                              ↓
┌──────────────────────────────────────────────────────────────────────┐
│ ÉTAPE 3: Diagnostic Maladie (Niveau 2→3)                            │
├──────────────────────────────────────────────────────────────────────┤
│ R11: syndrome_respiratoire ∧ syndrome_grippal ∧                     │
│      syndrome_febrile ∧ ¬perte_odorat → grippe                      │
│      VRAI ∧ VRAI ∧ VRAI ∧ VRAI = VRAI              [DIAGNOSTIQUÉ]   │
│                                                                       │
│ Résultat: maladie = GRIPPE                                           │
└──────────────────────────────────────────────────────────────────────┘
                              ↓
┌──────────────────────────────────────────────────────────────────────┐
│ ÉTAPE 4: Affichage                                                   │
├──────────────────────────────────────────────────────────────────────┤
│ === DIAGNOSTIC ===                                                   │
│ Diagnostic: Grippe                                                   │
│                                                                       │
│ RECOMMANDATIONS:                                                     │
│   - Repos au lit pendant 3-5 jours                                   │
│   - Hydratation abondante (eau, tisanes)                             │
│   - Paracetamol pour fievre et douleurs                              │
│   - Consultation si symptomes persistent >7 jours                    │
└──────────────────────────────────────────────────────────────────────┘
```

**Total questions posées**: 6 (optimisé grâce au backward chaining)

---

## Validation de l'Arbre Global

### Test 1: Connectivité des Maladies

Sur l'arbre ci-dessus, **tous les chemins** depuis les symptômes vers les maladies passent par au moins un syndrome:

✅ **Grippe**: 3 syndromes dont 2 partagés (respiratoire × 5, fébrile × 4, grippal × 2)
✅ **COVID-19**: 3 syndromes dont 2 partagés (respiratoire × 5, fébrile × 4, grippal × 2)
✅ **Bronchite**: 1 syndrome partagé + symptômes discriminants (respiratoire × 5)
✅ **Rhume**: 1 syndrome partagé (respiratoire × 5)
✅ **Angine**: 2 syndromes dont 1 partagé (orl × 1, fébrile × 4)
✅ **Allergie**: 2 syndromes partagés (allergique × 2, oculaire × 2)
✅ **Asthme**: 2 syndromes partagés + symptômes discriminants (respiratoire × 5, allergique × 2)
✅ **Migraine**: 1 syndrome unique (neurologique × 1) - acceptable car très spécifique
✅ **Gastro**: 2 syndromes dont 1 partagé (digestif × 1, fébrile × 4)
✅ **Conjonctivite**: 1 syndrome partagé + symptôme discriminant (oculaire × 2)

**Résultat**: 9/10 maladies utilisent au moins 1 syndrome partagé ✅

---

### Test 2: Partage de Syndromes

**Syndromes partagés par plusieurs maladies**:

1. **syndrome_respiratoire** (5 maladies): Grippe, COVID-19, Bronchite, Rhume, Asthme
2. **syndrome_febrile** (4 maladies): Grippe, COVID-19, Angine, Gastro-entérite
3. **syndrome_grippal** (2 maladies): Grippe, COVID-19
4. **syndrome_allergique** (2 maladies): Allergie saisonnière, Asthme
5. **syndrome_oculaire** (2 maladies): Allergie saisonnière, Conjonctivite

**Syndromes uniques** (maladies très spécifiques):
- **syndrome_digestif** (1 maladie): Gastro-entérite
- **syndrome_neurologique** (1 maladie): Migraine
- **syndrome_orl** (1 maladie): Angine

✅ **Critère satisfait**: 5 syndromes partagés sur 8 (62.5%) créent une forte interconnexion

---

### Test 3: Absence de Sous-Arbres Isolés

**Arbre principal interconnecté**:
- Branche respiratoire-fébrile-grippale → 3 syndromes partagés → 5 maladies principales
- Branche allergique-oculaire → 2 syndromes partagés → 3 maladies

**Arbres secondaires connectés via syndromes partagés**:
- Digestif connecté au principal via **syndrome_febrile** (partagé avec 3 autres maladies)
- ORL connecté au principal via **syndrome_febrile** (partagé avec 3 autres maladies)

**Seule exception acceptable**:
- Neurologique (Migraine) utilise 1 syndrome unique → acceptable car symptômes très spécifiques et sans confusion possible

✅ **Critère satisfait**: Pas de fragmentation significative, arbre global interconnecté

---

## Ordre de Test des Maladies (Backward Chaining Optimisé)

Le moteur teste les maladies dans cet ordre pour minimiser le nombre de questions:

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

**Résultat attendu**: Moyenne de **4-6 questions** par diagnostic

---

## Changements depuis Version 23 Règles

### Règles supprimées (simplification)

❌ **Ancienne R4**: `fievre_elevee ∧ frissons → syndrome_febrile`
   → **Nouvelle R4**: `fievre_elevee → syndrome_febrile` (frissons optionnel)

❌ **Ancienne R6**: `eternuement ∧ nez_qui_coule_clair → syndrome_allergique`
   → **Nouvelle R6**: `eternuement → syndrome_allergique` (nez clair optionnel)

❌ **Ancienne R10**: `mal_gorge_intense ∧ difficulte_avaler → syndrome_orl`
   → **Nouvelle R10**: `mal_gorge_intense → syndrome_orl` (difficulté avaler optionnelle)

**Justification**: Conditions minimales suffisantes (règles souples) pour améliorer la détection

---

## Légende des Symboles

```
→  : Déduction logique (implique)
∧  : ET logique
¬  : NON logique (négation)
↓  : Flux descendant
├──: Branchement
└──: Fin de branche
[ ] : Condition ou attribut
✅  : Validé/Actif/Partagé
❌  : Rejeté/Inactif/Non partagé
⚠️  : Attention/Limitation acceptable
(N syn) : Nombre de syndromes utilisés par la maladie
```

---

*Document mis à jour selon RESUME_PLAN.md - Version finale avec 20 règles et 8 syndromes*
