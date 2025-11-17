# Scénarios de Test - Système Expert Diagnostic Médical

> 10 scénarios complets pour validation (1 par maladie)

---

## 🎯 Comment Utiliser ces Scénarios

1. Lancer le système: `swipl run.pl`
2. Suivre les réponses indiquées dans chaque scénario
3. Vérifier que:
   - L'ordre des questions correspond (±1-2 questions acceptables)
   - Le nombre de questions est proche de l'attendu
   - Le diagnostic final est correct
   - Les recommandations médicales sont affichées

**Note**: Le système affiche maintenant des **recommandations médicales** pour chaque diagnostic au lieu des syndromes identifiés (implémentation finale).

---

## Scénario 1: Migraine ⭐ (Optimal - 3 questions)

### Profil Patient
Patient avec céphalées intenses et sensibilité lumière.

### Réponses Utilisateur
```
Question 1: Avez-vous perdu l'odorat ou le goût?
→ Réponse: 2 (Non)

Question 2: Avez-vous un mal de tête intense?
→ Réponse: 1 (Oui)

Question 3: Êtes-vous sensible à la lumière (photophobie)?
→ Réponse: 1 (Oui)
```

### Déduction Interne
```
Symptômes confirmés:
- perte_odorat = non
- mal_tete_intense = oui
- photophobie = oui

Syndromes déduits:
- R9: mal_tete_intense ∧ photophobie → syndrome_neurologique

Règle maladie activée:
- R18: syndrome_neurologique → migraine
```

### Résultat Attendu
```
=== DIAGNOSTIC ===
Diagnostic: Migraine
```

**Nombre de questions**: 3 ✅ (optimal)

---

## Scénario 2: COVID-19 ⭐ (Optimal - 7 questions)

### Profil Patient
Patient avec symptômes grippaux + perte odorat (discriminant unique).

### Réponses Utilisateur
```
Question 1: Avez-vous perdu l'odorat ou le goût?
→ Réponse: 1 (Oui)

Question 2: Avez-vous de la fièvre?
→ Réponse: 1 (Oui)
  → Sous-question: Est-elle élevée (>38.5°C)?
  → Réponse: 1 (Oui)

Question 3: Avez-vous de la toux?
→ Réponse: 1 (Oui)
  → Sous-question: Est-elle productive (avec crachats)?
  → Réponse: 2 (Non)

Question 4: Ressentez-vous une fatigue intense?
→ Réponse: 1 (Oui)

Question 5: Avez-vous des courbatures?
→ Réponse: 1 (Oui)
```

### Déduction Interne
```
Symptômes confirmés:
- perte_odorat = oui
- fievre_elevee = oui
- toux = oui
- fatigue_intense = oui
- courbatures = oui

Syndromes déduits:
- R2: fievre_elevee ∧ toux → syndrome_respiratoire
- R4: fievre_elevee → syndrome_febrile
- R5: fatigue_intense ∧ courbatures ∧ fievre_elevee → syndrome_grippal

Règle maladie activée:
- R12: syndrome_respiratoire ∧ syndrome_grippal ∧ syndrome_febrile ∧ perte_odorat → covid19
```

### Résultat Attendu
```
=== DIAGNOSTIC ===
Diagnostic: COVID-19
```

**Nombre de questions**: 7 (5 principales + 2 cascades) ✅

---

## Scénario 3: Grippe (6-7 questions)

### Profil Patient
Patient avec symptômes grippaux complets SANS perte odorat.

### Réponses Utilisateur
```
Question 1: Avez-vous perdu l'odorat ou le goût?
→ Réponse: 2 (Non)

Question 2: Avez-vous un mal de tête intense?
→ Réponse: 2 (Non)

Question 3: Avez-vous des sécrétions purulentes aux yeux?
→ Réponse: 2 (Non)

Question 4: Avez-vous un sifflement respiratoire (wheezing)?
→ Réponse: 2 (Non)

Question 5: Avez-vous de la diarrhée?
→ Réponse: 2 (Non)

Question 6: Avez-vous de la fièvre?
→ Réponse: 1 (Oui)
  → Sous-question: Est-elle élevée (>38.5°C)?
  → Réponse: 1 (Oui)

Question 7: Avez-vous de la toux?
→ Réponse: 1 (Oui)
  → Sous-question: Est-elle productive?
  → Réponse: 2 (Non)

Question 8: Ressentez-vous une fatigue intense?
→ Réponse: 1 (Oui)

Question 9: Avez-vous des courbatures?
→ Réponse: 1 (Oui)
```

### Déduction Interne
```
Symptômes confirmés:
- perte_odorat = non (élimine COVID)
- fievre_elevee = oui
- toux = oui
- fatigue_intense = oui
- courbatures = oui

Syndromes déduits:
- R2: fievre_elevee ∧ toux → syndrome_respiratoire
- R4: fievre_elevee → syndrome_febrile
- R5: fatigue_intense ∧ courbatures ∧ fievre_elevee → syndrome_grippal

Règle maladie activée:
- R11: syndrome_respiratoire ∧ syndrome_grippal ∧ syndrome_febrile ∧ ¬perte_odorat → grippe
```

### Résultat Attendu
```
=== DIAGNOSTIC ===
Diagnostic: Grippe
```

**Nombre de questions**: 9 (7 principales + 2 cascades)

---

## Scénario 4: Conjonctivite (4-5 questions)

### Profil Patient
Patient avec yeux rouges + sécrétions purulentes.

### Réponses Utilisateur
```
Question 1: Avez-vous perdu l'odorat ou le goût?
→ Réponse: 2 (Non)

Question 2: Avez-vous un mal de tête intense?
→ Réponse: 2 (Non)

Question 3: Avez-vous des sécrétions purulentes aux yeux?
→ Réponse: 1 (Oui)

Question 4: Avez-vous les yeux rouges?
→ Réponse: 1 (Oui)

Question 5: Avez-vous les yeux qui piquent ou qui démangent?
→ Réponse: 1 (Oui)
```

### Déduction Interne
```
Symptômes confirmés:
- secretions_purulentes = oui
- yeux_rouges = oui
- yeux_qui_piquent = oui

Syndromes déduits:
- R7: yeux_rouges ∧ yeux_qui_piquent → syndrome_oculaire

Règle maladie activée:
- R20: syndrome_oculaire ∧ secretions_purulentes → conjonctivite
```

### Résultat Attendu
```
=== DIAGNOSTIC ===
Diagnostic: Conjonctivite
```

**Nombre de questions**: 5 ✅

---

## Scénario 5: Asthme (6-7 questions)

### Profil Patient
Patient allergique avec difficultés respiratoires et wheezing.

### Réponses Utilisateur
```
Question 1: Avez-vous perdu l'odorat ou le goût?
→ Réponse: 2 (Non)

Question 2: Avez-vous un mal de tête intense?
→ Réponse: 2 (Non)

Question 3: Avez-vous des sécrétions purulentes aux yeux?
→ Réponse: 2 (Non)

Question 4: Avez-vous un sifflement respiratoire (wheezing)?
→ Réponse: 1 (Oui)

Question 5: Éternuez-vous fréquemment?
→ Réponse: 1 (Oui)

Question 6: Avez-vous le nez bouché?
→ Réponse: 1 (Oui)

Question 7: Avez-vous la gorge irritée?
→ Réponse: 1 (Oui)

Question 8: Avez-vous des difficultés à respirer?
→ Réponse: 1 (Oui)
```

### Déduction Interne
```
Symptômes confirmés:
- wheezing = oui
- eternuement = oui
- nez_bouche = oui
- gorge_irritee = oui
- difficultes_respiratoires = oui

Syndromes déduits:
- R3: nez_bouche ∧ gorge_irritee → syndrome_respiratoire
- R6: eternuement → syndrome_allergique

Règle maladie activée:
- R17: syndrome_respiratoire ∧ syndrome_allergique ∧ wheezing ∧ difficultes_respiratoires → asthme
```

### Résultat Attendu
```
=== DIAGNOSTIC ===
Diagnostic: Asthme
```

**Nombre de questions**: 8 ✅

---

## Scénario 6: Gastro-entérite (5-6 questions)

### Profil Patient
Patient avec diarrhée, vomissements et fièvre.

### Réponses Utilisateur
```
Question 1: Avez-vous perdu l'odorat ou le goût?
→ Réponse: 2 (Non)

Question 2: Avez-vous un mal de tête intense?
→ Réponse: 2 (Non)

Question 3: Avez-vous des sécrétions purulentes aux yeux?
→ Réponse: 2 (Non)

Question 4: Avez-vous un sifflement respiratoire (wheezing)?
→ Réponse: 2 (Non)

Question 5: Avez-vous de la diarrhée?
→ Réponse: 1 (Oui)

Question 6: Avez-vous des vomissements?
→ Réponse: 1 (Oui)

Question 7: Avez-vous de la fièvre?
→ Réponse: 1 (Oui)
  → Sous-question: Est-elle élevée (>38.5°C)?
  → Réponse: 1 (Oui)
```

### Déduction Interne
```
Symptômes confirmés:
- diarrhee = oui
- vomissements = oui
- fievre_elevee = oui

Syndromes déduits:
- R8: diarrhee ∧ vomissements → syndrome_digestif
- R4: fievre_elevee → syndrome_febrile

Règle maladie activée:
- R19: syndrome_digestif ∧ syndrome_febrile → gastro_enterite
```

### Résultat Attendu
```
=== DIAGNOSTIC ===
Diagnostic: Gastro-entérite
```

**Nombre de questions**: 7 (6 principales + 1 cascade) ✅

---

## Scénario 7: Angine (5-6 questions)

### Profil Patient
Patient avec mal de gorge intense et fièvre élevée.

### Réponses Utilisateur
```
Question 1: Avez-vous perdu l'odorat ou le goût?
→ Réponse: 2 (Non)

Question 2: Avez-vous un mal de tête intense?
→ Réponse: 2 (Non)

Question 3: Avez-vous des sécrétions purulentes aux yeux?
→ Réponse: 2 (Non)

Question 4: Avez-vous un sifflement respiratoire (wheezing)?
→ Réponse: 2 (Non)

Question 5: Avez-vous de la diarrhée?
→ Réponse: 2 (Non)

Question 6: Avez-vous de la fièvre?
→ Réponse: 1 (Oui)
  → Sous-question: Est-elle élevée (>38.5°C)?
  → Réponse: 1 (Oui)

Question 7: Avez-vous un mal de gorge intense?
→ Réponse: 1 (Oui)
```

### Déduction Interne
```
Symptômes confirmés:
- mal_gorge_intense = oui
- fievre_elevee = oui

Syndromes déduits:
- R10: mal_gorge_intense → syndrome_orl
- R4: fievre_elevee → syndrome_febrile

Règle maladie activée:
- R15: syndrome_orl ∧ syndrome_febrile → angine
```

### Résultat Attendu
```
=== DIAGNOSTIC ===
Diagnostic: Angine
```

**Nombre de questions**: 7 (6 principales + 1 cascade) ✅

---

## Scénario 8: Bronchite (6-7 questions)

### Profil Patient
Patient avec toux productive et fièvre légère.

### Réponses Utilisateur
```
Question 1: Avez-vous perdu l'odorat ou le goût?
→ Réponse: 2 (Non)

Question 2: Avez-vous un mal de tête intense?
→ Réponse: 2 (Non)

Question 3: Avez-vous des sécrétions purulentes aux yeux?
→ Réponse: 2 (Non)

Question 4: Avez-vous un sifflement respiratoire (wheezing)?
→ Réponse: 2 (Non)

Question 5: Avez-vous de la diarrhée?
→ Réponse: 2 (Non)

Question 6: Avez-vous de la fièvre?
→ Réponse: 1 (Oui)
  → Sous-question: Est-elle élevée (>38.5°C)?
  → Réponse: 2 (Non) [fievre_legere = oui]

Question 7: Avez-vous de la toux?
→ Réponse: 1 (Oui)
  → Sous-question: Est-elle productive (avec crachats)?
  → Réponse: 1 (Oui)

Question 8: Avez-vous le nez bouché?
→ Réponse: 1 (Oui)

Question 9: Avez-vous la gorge irritée?
→ Réponse: 1 (Oui)
```

### Déduction Interne
```
Symptômes confirmés:
- fievre_legere = oui
- toux = oui
- toux_productive = oui
- nez_bouche = oui
- gorge_irritee = oui

Syndromes déduits:
- R1: fievre_legere ∧ toux → syndrome_respiratoire
- R3: nez_bouche ∧ gorge_irritee → syndrome_respiratoire (alternative)

Règle maladie activée:
- R13: syndrome_respiratoire ∧ fievre_legere ∧ toux_productive → bronchite
```

### Résultat Attendu
```
=== DIAGNOSTIC ===
Diagnostic: Bronchite
```

**Nombre de questions**: 9 (7 principales + 2 cascades) ✅

---

## Scénario 9: Allergie Saisonnière (6-7 questions)

### Profil Patient
Patient avec éternuements, yeux irrités, SANS difficultés respiratoires.

### Réponses Utilisateur
```
Question 1: Avez-vous perdu l'odorat ou le goût?
→ Réponse: 2 (Non)

Question 2: Avez-vous un mal de tête intense?
→ Réponse: 2 (Non)

Question 3: Avez-vous des sécrétions purulentes aux yeux?
→ Réponse: 2 (Non)

Question 4: Avez-vous un sifflement respiratoire (wheezing)?
→ Réponse: 2 (Non)

Question 5: Avez-vous de la diarrhée?
→ Réponse: 2 (Non)

Question 6: Éternuez-vous fréquemment?
→ Réponse: 1 (Oui)

Question 7: Avez-vous les yeux rouges?
→ Réponse: 1 (Oui)

Question 8: Avez-vous les yeux qui piquent ou qui démangent?
→ Réponse: 1 (Oui)

Question 9: Avez-vous des difficultés à respirer?
→ Réponse: 2 (Non)
```

### Déduction Interne
```
Symptômes confirmés:
- eternuement = oui
- yeux_rouges = oui
- yeux_qui_piquent = oui
- difficultes_respiratoires = non

Syndromes déduits:
- R6: eternuement → syndrome_allergique
- R7: yeux_rouges ∧ yeux_qui_piquent → syndrome_oculaire

Règle maladie activée:
- R16: syndrome_allergique ∧ syndrome_oculaire ∧ ¬difficultes_respiratoires → allergie
```

### Résultat Attendu
```
=== DIAGNOSTIC ===
Diagnostic: Allergie saisonnière
```

**Nombre de questions**: 9 ✅

---

## Scénario 10: Rhume (7-8 questions)

### Profil Patient
Patient avec symptômes respiratoires légers, SANS fièvre élevée ni fatigue intense.

### Réponses Utilisateur
```
Question 1: Avez-vous perdu l'odorat ou le goût?
→ Réponse: 2 (Non)

Question 2: Avez-vous un mal de tête intense?
→ Réponse: 2 (Non)

Question 3: Avez-vous des sécrétions purulentes aux yeux?
→ Réponse: 2 (Non)

Question 4: Avez-vous un sifflement respiratoire (wheezing)?
→ Réponse: 2 (Non)

Question 5: Avez-vous de la diarrhée?
→ Réponse: 2 (Non)

Question 6: Éternuez-vous fréquemment?
→ Réponse: 2 (Non)

Question 7: Avez-vous de la fièvre?
→ Réponse: 2 (Non) [fievre_elevee = non, fievre_legere = non]

Question 8: Avez-vous le nez bouché?
→ Réponse: 1 (Oui)

Question 9: Avez-vous la gorge irritée?
→ Réponse: 1 (Oui)

Question 10: Ressentez-vous une fatigue intense?
→ Réponse: 2 (Non)
```

### Déduction Interne
```
Symptômes confirmés:
- nez_bouche = oui
- gorge_irritee = oui
- fievre_elevee = non
- fatigue_intense = non

Syndromes déduits:
- R3: nez_bouche ∧ gorge_irritee → syndrome_respiratoire

Vérification négations:
- syndrome_febrile = FAUX (car fievre_elevee = non)
- syndrome_grippal = FAUX (car fatigue_intense = non)

Règle maladie activée:
- R14: syndrome_respiratoire ∧ ¬syndrome_febrile ∧ ¬syndrome_grippal → rhume
```

### Résultat Attendu
```
=== DIAGNOSTIC ===
Diagnostic: Rhume
```

**Nombre de questions**: 10 ✅

---

## 📊 Résumé Statistiques

| Maladie | Nb Questions | Nb Syndromes | Complexité |
|---------|--------------|--------------|------------|
| Migraine | 3 | 1 | Faible ⭐ |
| COVID-19 | 7 | 3 | Moyenne |
| Conjonctivite | 5 | 1 | Faible ⭐ |
| Asthme | 8 | 2 | Moyenne |
| Gastro-entérite | 7 | 2 | Moyenne |
| Angine | 7 | 2 | Moyenne |
| Grippe | 9 | 3 | Élevée |
| Bronchite | 9 | 1 | Moyenne |
| Allergie | 9 | 2 | Moyenne |
| Rhume | 10 | 1 | Élevée |

**Moyenne**: 7.4 questions par diagnostic

**Note**: Le nombre exact de questions peut varier légèrement selon l'ordre de test des hypothèses par le moteur, mais devrait rester dans la fourchette ±2 questions.

---

## ✅ Checklist Validation

Pour chaque scénario testé:
- [ ] Diagnostic final correct
- [ ] Recommandations médicales affichées
- [ ] Nombre de questions raisonnable (3-10)
- [ ] Aucune question posée 2 fois
- [ ] Cascades fonctionnent (fièvre, toux)
- [ ] Affichage en français correct (sans accents)
- [ ] Aucune erreur runtime

**Si tous les scénarios passent → Implémentation validée ✅**

---

## 🎯 Cas pour le Rapport (3 requis)

**Sélection recommandée pour le rapport final**:

1. **Scénario 1: Migraine** - Cas optimal (3 questions, discriminant unique)
2. **Scénario 2: COVID-19** - Cas moyen (7 questions, 3 syndromes)
3. **Scénario 7: Angine** - Cas typique (7 questions, 2 syndromes)

Ces 3 cas démontrent:
- Efficacité backward chaining (Migraine = 3 questions)
- Gestion cascades (COVID/Angine)
- Interconnexion syndromes (3 maladies utilisent syndrome_febrile)
- Négations (grippe ¬perte_odorat)

---

**Document prêt pour validation - Tester chaque scénario après implémentation**
