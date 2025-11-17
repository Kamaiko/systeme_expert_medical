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

## Scénario 3: Grippe (9 questions)

### Profil Patient
Patient avec symptômes grippaux complets SANS perte odorat.

### Réponses Utilisateur
```
Question 1: Avez-vous perdu l'odorat ou le goût?
→ Réponse: 2 (Non)

Question 2: Avez-vous un mal de tête intense?
→ Réponse: 2 (Non)

Question 3: Avez-vous les yeux rouges?
→ Réponse: 2 (Non)

Question 4: Avez-vous de la fièvre?
→ Réponse: 1 (Oui)
  → Sous-question: Est-elle élevée (>38.5°C)?
  → Réponse: 1 (Oui)

Question 5: Avez-vous de la toux?
→ Réponse: 1 (Oui)
  → Sous-question: Est-elle productive (avec crachats/expectorations)?
  → Réponse: 2 (Non)

Question 6: Avez-vous eternue frequemment?
→ Réponse: 2 (Non)

Question 7: Avez-vous de la diarrhée?
→ Réponse: 2 (Non)

Question 8: Ressentez-vous une fatigue intense?
→ Réponse: 1 (Oui)

Question 9: Avez-vous des courbatures (douleurs musculaires)?
→ Réponse: 1 (Oui)
```

### Déduction Interne
```
Hypothèses testées et éliminées:
1. covid19 → perte_odorat = non → Rejetée
2. migraine → mal_tete_intense = non → Rejetée
3. conjonctivite → yeux_rouges = non → Rejetée
4. asthme → syndrome_respiratoire (fievre_elevee + toux) ✓
            mais syndrome_allergique (eternuement = non) ✗ → Rejetée
5. gastro_enterite → diarrhee = non → Rejetée

6. grippe → Testée:

Symptômes confirmés:
- perte_odorat = non (en cache)
- fievre_elevee = oui (en cache)
- toux = oui (en cache)
- eternuement = non (en cache)
- diarrhee = non (en cache)
- fatigue_intense = oui
- courbatures = oui

Syndromes déduits:
- R2: fievre_elevee ∧ toux → syndrome_respiratoire (vérifié pour asthme, réutilisé)
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

**Nombre de questions**: 9 principales (dont 2 avec cascades = 11 réponses totales)

**Note**: Questions 1-3 éliminent covid19, migraine, conjonctivite. Questions 4-6 testent asthme (qui échoue sur syndrome_allergique). Question 7 élimine gastro-entérite. Questions 8-9 confirment grippe via syndrome_grippal.

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

Question 3: Avez-vous les yeux rouges?
→ Réponse: 1 (Oui)

Question 4: Avez-vous les yeux qui piquent ou qui démangent?
→ Réponse: 1 (Oui)

Question 5: Avez-vous des sécrétions purulentes aux yeux?
→ Réponse: 1 (Oui)
```

### Déduction Interne
```
Hypothèses testées:
1. covid19 → perte_odorat = non → Rejetée
2. migraine → mal_tete_intense = non → Rejetée
3. conjonctivite → Testée:

Condition 1: syndrome_oculaire
- R7: yeux_rouges ∧ yeux_qui_piquent
  - yeux_rouges = oui (Q3)
  - yeux_qui_piquent = oui (Q4)
- syndrome_oculaire = VRAI ✓

Condition 2: secretions_purulentes
- secretions_purulentes = oui (Q5)

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

## Scénario 5: Asthme (10 questions)

### Profil Patient
Patient allergique avec difficultés respiratoires et wheezing.

### Réponses Utilisateur
```
Question 1: Avez-vous perdu l'odorat ou le goût?
→ Réponse: 2 (Non)

Question 2: Avez-vous un mal de tête intense?
→ Réponse: 1 (Oui)

Question 3: Avez-vous sensible a la lumiere (photophobie)?
→ Réponse: 2 (Non)

Question 4: Avez-vous les yeux rouges?
→ Réponse: 2 (Non)

Question 5: Avez-vous de la fievre?
→ Réponse: 2 (Non)

Question 6: Avez-vous le nez bouché?
→ Réponse: 1 (Oui)

Question 7: Avez-vous la gorge irritée?
→ Réponse: 1 (Oui)

Question 8: Avez-vous eternue frequemment?
→ Réponse: 1 (Oui)

Question 9: Avez-vous un sifflement respiratoire (wheezing)?
→ Réponse: 1 (Oui)

Question 10: Avez-vous des difficultés à respirer?
→ Réponse: 1 (Oui)
```

### Déduction Interne
```
Hypothèses testées et éliminées:
1. covid19 → perte_odorat = non → Rejetée
2. migraine → mal_tete_intense = oui, photophobie = non → Rejetée
3. conjonctivite → yeux_rouges = non → Rejetée
4. asthme → Testée:

Condition 1: syndrome_respiratoire
- R3: nez_bouche ∧ gorge_irritee
  - fievre = non (donc R1 et R2 échouent)
  - nez_bouche = oui (Q6)
  - gorge_irritee = oui (Q7)
- syndrome_respiratoire = VRAI ✓

Condition 2: syndrome_allergique
- R6: eternuement
  - eternuement = oui (Q8)
- syndrome_allergique = VRAI ✓

Condition 3: wheezing
- wheezing = oui (Q9)

Condition 4: difficultes_respiratoires
- difficultes_respiratoires = oui (Q10)

Règle maladie activée:
- R17: syndrome_respiratoire ∧ syndrome_allergique ∧ wheezing ∧ difficultes_respiratoires → asthme
```

### Résultat Attendu
```
=== DIAGNOSTIC ===
Diagnostic: Asthme
```

**Nombre de questions**: 10 ✅

**Note**: Questions 1-4 éliminent covid19, migraine, conjonctivite. Question 5 élimine les clauses R1/R2 de syndrome_respiratoire (nécessitent fièvre). Questions 6-10 confirment asthme via R3 (nez+gorge), R6 (éternuement), wheezing et difficultés respiratoires.

---

## Scénario 6: Gastro-entérite (9 questions)

### Profil Patient
Patient avec diarrhée, vomissements et fièvre.

### Réponses Utilisateur
```
Question 1: Avez-vous perdu l'odorat ou le goût?
→ Réponse: 2 (Non)

Question 2: Avez-vous un mal de tête intense?
→ Réponse: 2 (Non)

Question 3: Avez-vous les yeux rouges?
→ Réponse: 2 (Non)

Question 4: Avez-vous de la fièvre?
→ Réponse: 1 (Oui)
  → Sous-question: Est-elle élevée (>38.5°C)?
  → Réponse: 1 (Oui)

Question 5: Avez-vous de la toux?
→ Réponse: 2 (Non)

Question 6: Avez-vous le nez bouché?
→ Réponse: 2 (Non)

Question 7: Avez-vous de la diarrhée?
→ Réponse: 1 (Oui)

Question 8: Avez-vous des vomissements?
→ Réponse: 1 (Oui)
```

### Déduction Interne
```
Hypothèses testées et éliminées:
1. covid19 → perte_odorat = non → Rejetée
2. migraine → mal_tete_intense = non → Rejetée
3. conjonctivite → yeux_rouges = non → Rejetée
4. asthme → syndrome_respiratoire:
   - R1: fievre_legere=non (car fievre_elevee=oui) échoue
   - R2: fievre_elevee=oui, toux=non échoue
   - R3: nez_bouche=non échoue
   → syndrome_respiratoire échoue → Rejetée
5. gastro_enterite → Testée:

Condition 1: syndrome_digestif
- R8: diarrhee ∧ vomissements
  - diarrhee = oui (Q7)
  - vomissements = oui (Q8)
- syndrome_digestif = VRAI ✓

Condition 2: syndrome_febrile
- R4: fievre_elevee
  - fievre_elevee = oui (Q4, en cache)
- syndrome_febrile = VRAI ✓

Règle maladie activée:
- R19: syndrome_digestif ∧ syndrome_febrile → gastro_enterite
```

### Résultat Attendu
```
=== DIAGNOSTIC ===
Diagnostic: Gastro-entérite
```

**Nombre de questions**: 9 (8 principales + 1 cascade) ✅

---

## Scénario 7: Angine (9 questions)

### Profil Patient
Patient avec mal de gorge intense et fièvre élevée.

### Réponses Utilisateur
```
Question 1: Avez-vous perdu l'odorat ou le goût?
→ Réponse: 2 (Non)

Question 2: Avez-vous un mal de tête intense?
→ Réponse: 2 (Non)

Question 3: Avez-vous les yeux rouges?
→ Réponse: 2 (Non)

Question 4: Avez-vous de la fièvre?
→ Réponse: 1 (Oui)
  → Sous-question: Est-elle élevée (>38.5°C)?
  → Réponse: 1 (Oui)

Question 5: Avez-vous de la toux?
→ Réponse: 2 (Non)

Question 6: Avez-vous le nez bouché?
→ Réponse: 2 (Non)

Question 7: Avez-vous de la diarrhée?
→ Réponse: 2 (Non)

Question 8: Avez-vous un mal de gorge intense?
→ Réponse: 1 (Oui)
```

### Déduction Interne
```
Hypothèses testées et éliminées:
1. covid19 → perte_odorat = non → Rejetée
2. migraine → mal_tete_intense = non → Rejetée
3. conjonctivite → yeux_rouges = non → Rejetée
4. asthme → syndrome_respiratoire:
   - R1: fievre_legere=non échoue
   - R2: fievre_elevee=oui, toux=non échoue
   - R3: nez_bouche=non échoue
   → syndrome_respiratoire échoue → Rejetée
5. gastro_enterite → syndrome_digestif (diarrhee=non) échoue → Rejetée
6. grippe → syndrome_respiratoire (échoue, en cache) → Rejetée
7. angine → Testée:

Condition 1: syndrome_orl
- R10: mal_gorge_intense
  - mal_gorge_intense = oui (Q8)
- syndrome_orl = VRAI ✓

Condition 2: syndrome_febrile
- R4: fievre_elevee
  - fievre_elevee = oui (Q4, en cache)
- syndrome_febrile = VRAI ✓

Règle maladie activée:
- R15: syndrome_orl ∧ syndrome_febrile → angine
```

### Résultat Attendu
```
=== DIAGNOSTIC ===
Diagnostic: Angine
```

**Nombre de questions**: 9 (8 principales + 1 cascade) ✅

---

## Scénario 8: Bronchite (9 questions)

### Profil Patient
Patient avec toux productive et fièvre légère.

### Réponses Utilisateur
```
Question 1: Avez-vous perdu l'odorat ou le goût?
→ Réponse: 2 (Non)

Question 2: Avez-vous un mal de tête intense?
→ Réponse: 2 (Non)

Question 3: Avez-vous les yeux rouges?
→ Réponse: 2 (Non)

Question 4: Avez-vous de la fièvre?
→ Réponse: 1 (Oui)
  → Sous-question: Est-elle élevée (>38.5°C)?
  → Réponse: 2 (Non) [fievre_legere = oui]

Question 5: Avez-vous de la toux?
→ Réponse: 1 (Oui)
  → Sous-question: Est-elle productive (avec crachats)?
  → Réponse: 1 (Oui)

Question 6: Avez-vous eternue frequemment?
→ Réponse: 2 (Non)

Question 7: Avez-vous de la diarrhée?
→ Réponse: 2 (Non)

Question 8: Ressentez-vous une fatigue intense?
→ Réponse: 2 (Non)

Question 9: Avez-vous un mal de gorge intense?
→ Réponse: 2 (Non)
```

### Déduction Interne
```
Hypothèses testées et éliminées:
1. covid19 → perte_odorat = non → Rejetée
2. migraine → mal_tete_intense = non → Rejetée
3. conjonctivite → yeux_rouges = non → Rejetée
4. asthme → syndrome_respiratoire (R1: fievre_legere=oui, toux=oui) ✓, mais syndrome_allergique (eternuement=non) échoue → Rejetée
5. gastro_enterite → syndrome_digestif (diarrhee=non) échoue → Rejetée
6. grippe → syndrome_grippal (fatigue_intense=non) échoue → Rejetée
7. angine → syndrome_orl (mal_gorge_intense=non) échoue → Rejetée
8. bronchite → Testée:

Condition 1: syndrome_respiratoire
- R1: fievre_legere ∧ toux (en cache via asthme)
- syndrome_respiratoire = VRAI ✓

Condition 2: fievre_legere
- fievre_legere = oui (Q4, en cache)

Condition 3: toux_productive
- toux_productive = oui (Q5, en cache)

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

## Scénario 9: Allergie Saisonnière (12 questions)

### Profil Patient
Patient avec éternuements, yeux irrités, SANS difficultés respiratoires.

### Réponses Utilisateur
```
Question 1: Avez-vous perdu l'odorat ou le goût?
→ Réponse: 2 (Non)

Question 2: Avez-vous un mal de tête intense?
→ Réponse: 2 (Non)

Question 3: Avez-vous les yeux rouges?
→ Réponse: 1 (Oui)

Question 4: Avez-vous les yeux qui piquent ou qui démangent?
→ Réponse: 1 (Oui)

Question 5: Avez-vous des sécrétions purulentes aux yeux?
→ Réponse: 2 (Non)

Question 6: Avez-vous de la fièvre?
→ Réponse: 2 (Non)

Question 7: Avez-vous le nez bouché?
→ Réponse: 2 (Non)

Question 8: Avez-vous de la diarrhée?
→ Réponse: 2 (Non)

Question 9: Avez-vous un mal de gorge intense?
→ Réponse: 2 (Non)

Question 10: Avez-vous eternue frequemment?
→ Réponse: 1 (Oui)

Question 11: Avez-vous des difficultés à respirer?
→ Réponse: 2 (Non)
```

### Déduction Interne
```
Hypothèses testées et éliminées:
1. covid19 → perte_odorat = non → Rejetée
2. migraine → mal_tete_intense = non → Rejetée
3. conjonctivite → syndrome_oculaire (yeux_rouges=oui, yeux_qui_piquent=oui) ✓, mais secretions_purulentes = non → Rejetée
4. asthme → syndrome_respiratoire (R1/R2: fievre=non échoue, R3: nez_bouche=non) échoue → Rejetée
5. gastro_enterite → syndrome_digestif (diarrhee=non) échoue → Rejetée
6. grippe → syndrome_respiratoire (échoue, en cache) → Rejetée
7. angine → syndrome_orl (mal_gorge_intense=non) échoue → Rejetée
8. bronchite → syndrome_respiratoire (échoue, en cache) → Rejetée
9. allergie → Testée:

Condition 1: syndrome_allergique
- R6: eternuement
  - eternuement = oui (Q10)
- syndrome_allergique = VRAI ✓

Condition 2: syndrome_oculaire
- R7: yeux_rouges ∧ yeux_qui_piquent
  - yeux_rouges = oui (Q3, en cache)
  - yeux_qui_piquent = oui (Q4, en cache)
- syndrome_oculaire = VRAI ✓

Condition 3: ¬difficultes_respiratoires
- difficultes_respiratoires = non (Q11)

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

## Scénario 10: Rhume (10 questions)

### Profil Patient
Patient avec symptômes respiratoires légers, SANS fièvre élevée ni fatigue intense.

### Réponses Utilisateur
```
Question 1: Avez-vous perdu l'odorat ou le goût?
→ Réponse: 2 (Non)

Question 2: Avez-vous un mal de tête intense?
→ Réponse: 2 (Non)

Question 3: Avez-vous les yeux rouges?
→ Réponse: 2 (Non)

Question 4: Avez-vous de la fièvre?
→ Réponse: 2 (Non)

Question 5: Avez-vous le nez bouché?
→ Réponse: 1 (Oui)

Question 6: Avez-vous la gorge irritée?
→ Réponse: 1 (Oui)

Question 7: Avez-vous eternue frequemment?
→ Réponse: 2 (Non)

Question 8: Avez-vous de la diarrhée?
→ Réponse: 2 (Non)

Question 9: Ressentez-vous une fatigue intense?
→ Réponse: 2 (Non)

Question 10: Avez-vous un mal de gorge intense?
→ Réponse: 2 (Non)
```

### Déduction Interne
```
Hypothèses testées et éliminées:
1. covid19 → perte_odorat = non → Rejetée
2. migraine → mal_tete_intense = non → Rejetée
3. conjonctivite → yeux_rouges = non → Rejetée
4. asthme → syndrome_respiratoire (R1/R2: fievre=non échoue, R3: nez_bouche=oui, gorge_irritee=oui) ✓, syndrome_allergique (eternuement=non) échoue → Rejetée
5. gastro_enterite → syndrome_digestif (diarrhee=non) échoue → Rejetée
6. grippe → syndrome_respiratoire (en cache) ✓, syndrome_grippal (fatigue_intense=non) échoue → Rejetée
7. angine → syndrome_orl (mal_gorge_intense=non) échoue → Rejetée
8. bronchite → syndrome_respiratoire (en cache) ✓, fievre_legere (=non, en cache) échoue → Rejetée
9. allergie → syndrome_allergique (eternuement=non, en cache) échoue → Rejetée
10. rhume → Testé:

Condition 1: syndrome_respiratoire
- R3: nez_bouche ∧ gorge_irritee (en cache via asthme)
- syndrome_respiratoire = VRAI ✓

Condition 2: ¬syndrome_febrile
- syndrome_febrile teste fievre_elevee (en cache=non)
- syndrome_febrile = FAUX
- ¬syndrome_febrile = VRAI ✓

Condition 3: ¬syndrome_grippal
- syndrome_grippal teste fatigue_intense (en cache=non)
- syndrome_grippal = FAUX
- ¬syndrome_grippal = VRAI ✓

Règle maladie activée:
- R14: syndrome_respiratoire ∧ ¬syndrome_febrile ∧ ¬syndrome_grippal → rhume
```

### Résultat Attendu
```
=== DIAGNOSTIC ===
Diagnostic: Rhume
```

**Nombre de questions**: 10 ✅
