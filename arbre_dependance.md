# Arbre de Dépendance Global - Système Expert Diagnostic Médical

> Représentation graphique complète de l'interconnexion des règles (Version 2.0 - 8 syndromes)

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
                                    [23 règles]
                                          │
                                          ↓
                              SYNDROMES (Niveau 2) - 8 syndromes
                    ┌──────────────────────┼──────────────────────┐
                    │                      │                      │
         syndrome_respiratoire    syndrome_fébrile         syndrome_grippal
         syndrome_allergique      syndrome_oculaire        syndrome_digestif
         syndrome_céphalique      syndrome_inflammatoire_gorge
                    │                      │                      │
                    └──────────────────────┼──────────────────────┘
                                          │
                                          ↓
                               MALADIES (Niveau 3) - 10 maladies
                    ┌──────────────────────┼──────────────────────┐
                    │                      │                      │
                Grippe                 COVID-19                Bronchite
                Rhume                  Angine                  Allergie
            Asthme allergique          Migraine            Gastro-entérite
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
     (3 syn)    (3 syn)     (2 syn)      (1 syn)     (2 syn)
```

### Branche Fébrile (Interconnexion Majeure - 5 maladies)

```
                            SYMPTÔMES
                                │
        ┌───────────────────────┼───────────────────┐
        │                       │                   │
   [fievre_elevee]          [frissons]      [fievre_legere]
        │                       │                   │
        └───────────┬───────────┘                   │
                    │                               │
                    ↓                               ↓
         syndrome_febrile (2 règles différentes)
                    │
        ┌───────────┼───────────┬───────────┬───────────┐
        │           │           │           │           │
        ↓           ↓           ↓           ↓           ↓
    GRIPPE      COVID-19    BRONCHITE     ANGINE   GASTRO-ENTÉRITE
```

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

### Branche Allergique (2 maladies)

```
                            SYMPTÔMES
                                │
        ┌───────────────────────┼──────────────────────────┐
        │                       │                          │
   [eternuement]        [nez_qui_coule_clair]    [difficultes_respiratoires]
        │                       │                          │
        └───────────┬───────────┘                          │
                    │                                      │
                    ↓                                      │
           syndrome_allergique ←───────────────────────────┘
                    │
            ┌───────┴────────┐
            │                │
            ↓                ↓
    ALLERGIE SAISONNIÈRE   ASTHME ALLERGIQUE
       (2 syn)              (2 syn)
   (sans difficultés)    (avec difficultés
    respiratoires)        respiratoires + wheezing)
```

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
                                  (2 règles différentes)
                                           │
                                   ┌───────┴───────┐
                                   │               │
                                   ↓               ↓
                           ALLERGIE SAISONNIÈRE   CONJONCTIVITE
                               (2 syn)              (1 syn)
```

### Branche Digestive (1 maladie)

```
                            SYMPTÔMES
                                │
        ┌───────────────────────┼───────────────────┐
        │                       │                   │
    [diarrhee]            [vomissements]      [fievre_legere]
        │                       │                   │
        └───────────┬───────────┴───────────────────┘
                    │
                    ↓
            syndrome_digestif
           (2 règles différentes)
                    │
                    ↓
            GASTRO-ENTÉRITE
                (2 syn: digestif + fébrile)
```

### Branche Neurologique (1 maladie)

```
                            SYMPTÔMES
                                │
        ┌───────────────────────┼───────────────────┐
        │                       │                   │
  [mal_tete_intense]       [photophobie]       [¬diarrhee]
        │                       │                   │
        └───────────┬───────────┘                   │
                    │                               │
                    ↓                               │
          syndrome_cephalique ←─────────────────────┘
                    │                      (discriminant négatif)
                    ↓
                MIGRAINE
               (1 syn)
```

### Branche ORL (1 maladie)

```
                            SYMPTÔMES
                                │
        ┌───────────────────────┼──────────────────────┐
        │                       │                      │
  [mal_gorge_intense]   [difficulte_avaler]      [fievre_elevee]
        │                       │                      │
        └───────────┬───────────┘                      │
                    │                                  │
                    ↓                                  │
     syndrome_inflammatoire_gorge ←────────────────────┘
                    │
                    ↓
                 ANGINE
              (2 syn: inflammatoire_gorge + fébrile)
```

---

## Vue Matricielle - Interconnexions des Syndromes

Ce tableau montre comment les syndromes sont **partagés** par plusieurs maladies (clé de l'arbre global):

| Syndrome | Grippe | COVID | Bronchite | Rhume | Angine | Allergie | Asthme | Migraine | Gastro | Conjonctivite | **Total** |
|----------|--------|-------|-----------|-------|--------|----------|--------|----------|--------|---------------|-----------|
| **syndrome_respiratoire** | ✅ | ✅ | ✅ | ✅ | ❌ | ❌ | ✅ | ❌ | ❌ | ❌ | **5** |
| **syndrome_fébrile** | ✅ | ✅ | ✅ | ❌ | ✅ | ❌ | ❌ | ❌ | ✅ | ❌ | **5** |
| **syndrome_grippal** | ✅ | ✅ | ❌ | ❌ | ❌ | ❌ | ❌ | ❌ | ❌ | ❌ | **2** |
| **syndrome_allergique** | ❌ | ❌ | ❌ | ❌ | ❌ | ✅ | ✅ | ❌ | ❌ | ❌ | **2** |
| **syndrome_oculaire** | ❌ | ❌ | ❌ | ❌ | ❌ | ✅ | ❌ | ❌ | ❌ | ✅ | **2** |
| **syndrome_digestif** | ❌ | ❌ | ❌ | ❌ | ❌ | ❌ | ❌ | ❌ | ✅ | ❌ | **1** |
| **syndrome_céphalique** | ❌ | ❌ | ❌ | ❌ | ❌ | ❌ | ❌ | ✅ | ❌ | ❌ | **1** |
| **syndrome_inflammatoire_gorge** | ❌ | ❌ | ❌ | ❌ | ✅ | ❌ | ❌ | ❌ | ❌ | ❌ | **1** |

**Observation clé - Interconnexion Renforcée**:
- ✅ **2 syndromes** partagés par **5 maladies** chacun (respiratoire, fébrile)
- ✅ **3 syndromes** partagés par **2 maladies** chacun (grippal, allergique, oculaire)
- ✅ **5/8 syndromes** sont partagés (62.5% de partage)
- ✅ **8/10 maladies** utilisent au moins 1 syndrome partagé

**Résultat**: Arbre global **très fortement interconnecté** ✅✅✅

---

## Flux de Raisonnement - Exemple Complet

### Cas Patient: Grippe

```
┌──────────────────────────────────────────────────────────────────────┐
│ ÉTAPE 1: Collecte Symptômes                                          │
├──────────────────────────────────────────────────────────────────────┤
│ Q: Avez-vous de la fièvre élevée ?    → Réponse: 1 (Oui)            │
│ Q: Avez-vous de la toux ?             → Réponse: 1 (Oui)            │
│ Q: Avez-vous des frissons ?           → Réponse: 1 (Oui)            │
│ Q: Avez-vous des courbatures ?        → Réponse: 1 (Oui)            │
│ Q: Ressentez-vous une fatigue intense ? → Réponse: 1 (Oui)          │
│ Q: Avez-vous perdu l'odorat ?         → Réponse: 2 (Non)            │
└──────────────────────────────────────────────────────────────────────┘
                              ↓
┌──────────────────────────────────────────────────────────────────────┐
│ ÉTAPE 2: Déduction Syndromes (Niveau 1→2)                           │
├──────────────────────────────────────────────────────────────────────┤
│ Règle R2: fievre_elevee ∧ toux → syndrome_respiratoire  [ACTIVÉE]   │
│ Règle R4: fievre_elevee ∧ frissons → syndrome_febrile   [ACTIVÉE]   │
│ Règle R6: fatigue_intense ∧ courbatures ∧ fievre_elevee             │
│           → syndrome_grippal                             [ACTIVÉE]   │
│                                                                       │
│ Résultat: syndrome_respiratoire = VRAI                               │
│           syndrome_febrile = VRAI                                    │
│           syndrome_grippal = VRAI                                    │
└──────────────────────────────────────────────────────────────────────┘
                              ↓
┌──────────────────────────────────────────────────────────────────────┐
│ ÉTAPE 3: Diagnostic Maladie (Niveau 2→3)                            │
├──────────────────────────────────────────────────────────────────────┤
│ Règle R14: syndrome_respiratoire ∧ syndrome_grippal ∧               │
│            syndrome_febrile ∧ fatigue_intense ∧ ¬perte_odorat       │
│            → grippe                                                  │
│            VRAI ∧ VRAI ∧ VRAI ∧ VRAI ∧ VRAI = VRAI     [ACTIVÉE]    │
│                                                                       │
│ Règle R15: syndrome_respiratoire ∧ syndrome_grippal ∧               │
│            syndrome_febrile ∧ perte_odorat → covid19                │
│            VRAI ∧ VRAI ∧ VRAI ∧ FAUX = FAUX            [REJETÉE]    │
│                                                                       │
│ Résultat: maladie = GRIPPE (unique)                                  │
└──────────────────────────────────────────────────────────────────────┘
                              ↓
┌──────────────────────────────────────────────────────────────────────┐
│ ÉTAPE 4: Justification et Affichage                                 │
├──────────────────────────────────────────────────────────────────────┤
│ DIAGNOSTIC: GRIPPE, car vous présentez fièvre et toux               │
└──────────────────────────────────────────────────────────────────────┘
```

---

## Validation de l'Arbre Global

### Test 1: Connectivité Visuelle

Sur l'arbre ci-dessus, **tous les chemins** depuis les symptômes vers les maladies passent par au moins un syndrome **partagé** (sauf 3 maladies à syndrome unique, ce qui est acceptable):

✅ **Grippe**: 3 syndromes dont 2 partagés (respiratoire × 5, fébrile × 5, grippal × 2)
✅ **COVID-19**: 3 syndromes dont 2 partagés (respiratoire × 5, fébrile × 5, grippal × 2)
✅ **Bronchite**: 2 syndromes partagés (respiratoire × 5, fébrile × 5)
✅ **Rhume**: 1 syndrome partagé (respiratoire × 5)
✅ **Angine**: 2 syndromes dont 1 partagé (fébrile × 5, inflammatoire_gorge × 1)
✅ **Allergie**: 2 syndromes partagés (allergique × 2, oculaire × 2)
✅ **Asthme**: 2 syndromes partagés (allergique × 2, respiratoire × 5)
⚠️ **Migraine**: 1 syndrome unique (céphalique × 1) - acceptable
✅ **Gastro**: 2 syndromes dont 1 partagé (digestif × 1, fébrile × 5)
✅ **Conjonctivite**: 1 syndrome partagé (oculaire × 2)

**Résultat**: 9/10 maladies utilisent au moins 1 syndrome partagé ✅

---

### Test 2: Partage de Faits Communs

Liste des règles qui partagent des syndromes:

**Groupe 1 - syndrome_respiratoire** (5 règles partagent ce syndrome):
- R14: ... syndrome_respiratoire ... → grippe
- R15: ... syndrome_respiratoire ... → covid19
- R16: syndrome_respiratoire ∧ syndrome_febrile ∧ toux_productive → bronchite
- R17: syndrome_respiratoire ∧ ¬syndrome_febrile ∧ ¬syndrome_grippal → rhume
- R20: syndrome_allergique ∧ syndrome_respiratoire ... → asthme_allergique

**Groupe 2 - syndrome_fébrile** (5 règles partagent ce syndrome):
- R14: ... syndrome_febrile ... → grippe
- R15: ... syndrome_febrile ... → covid19
- R16: syndrome_respiratoire ∧ syndrome_febrile ∧ toux_productive → bronchite
- R18: syndrome_inflammatoire_gorge ∧ syndrome_febrile ... → angine
- R22: syndrome_digestif ∧ syndrome_febrile ∧ diarrhee → gastro_enterite

**Groupe 3 - syndrome_grippal** (2 règles):
- R14: ... syndrome_grippal ... → grippe
- R15: ... syndrome_grippal ... → covid19

**Groupe 4 - syndrome_allergique** (2 règles):
- R19: syndrome_allergique ∧ syndrome_oculaire ... → allergie_saisonniere
- R20: syndrome_allergique ∧ syndrome_respiratoire ... → asthme_allergique

**Groupe 5 - syndrome_oculaire** (2 règles):
- R19: syndrome_allergique ∧ syndrome_oculaire ... → allergie_saisonniere
- R23: syndrome_oculaire ∧ secretions_purulentes ... → conjonctivite

✅ **Critère satisfait**: 10 règles sur 10 au niveau 2→3 utilisent au moins 1 syndrome, et 5 syndromes sont partagés (100% de couverture syndromes)

---

### Test 3: Absence de Sous-Arbres Isolés

**Arbre principal interconnecté**:
- Symptômes fébriles + respiratoires + grippaux → 3 syndromes partagés → 5 maladies
- Symptômes allergiques + oculaires → 2 syndromes partagés → 3 maladies (allergie, asthme, conjonctivite)

**Arbres secondaires connectés via syndromes partagés**:
- Digestif connecté au principal via syndrome_fébrile (partagé avec 4 autres maladies)
- ORL connecté au principal via syndrome_fébrile (partagé avec 4 autres maladies)

**Seule exception**:
- Neurologique (migraine) utilise 1 syndrome unique → acceptable comme cas spécialisé

✅ **Critère satisfait**: Pas de fragmentation significative, arbre global interconnecté

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

## Notes d'Implémentation

### Priorité d'Évaluation des Règles

Le système doit tester les maladies dans cet ordre pour optimiser les questions:

**Ordre prioritaire**:
1. **Maladies à 3 syndromes** (grippe, covid) - plus spécifiques
2. **Maladies à 2 syndromes** (bronchite, angine, allergie, asthme, gastro) - moyennement spécifiques
3. **Maladies à 1 syndrome** (rhume, migraine, conjonctivite) - moins spécifiques

### Gestion de "Je ne sais pas"

Si l'utilisateur répond "3. Je ne sais pas" à une question critique:

**Comportement AND-only strict**:
- Symptôme inconnu = condition NON satisfaite
- Syndrome/maladie associé(e) NON généré(e)
- Passage à la branche suivante

**Exemple**:
```
Q: Avez-vous perdu l'odorat ? → 3. Je ne sais pas
Résultat: perte_odorat = FAUX (par défaut)
Impact: COVID-19 ne sera pas diagnostiqué (règle R15 échoue)
        GRIPPE reste possible (règle R14 avec ¬perte_odorat satisfait)
```

**Cas limites**:
- Trop d'incertitudes → "Diagnostic impossible, consultez un médecin"
- Seule maladie possible malgré incertitudes → Diagnostic avec mention "sous réserve"

---

## Améliorations Futures (Hors Scope TP)

1. **Facteurs de certitude** : Remplacer booléens par scores de confiance [0-1]
2. **Règles de contradiction** : Rejeter diagnostics incohérents
3. **Arbitrage multi-maladies** : Poser question discriminante si ex æquo
4. **Logique floue** : Gérer "Je ne sais pas" sans bloquer diagnostic
5. **Probabilités bayésiennes** : Calculer probabilité a posteriori par maladie

---

*Ce document sert de référence visuelle pour l'implémentation Prolog et le rapport final*
