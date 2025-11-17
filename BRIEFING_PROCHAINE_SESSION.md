# 📋 Briefing - Implémentation Système Expert Médical

> **COMMENCEZ ICI** - Document unique de démarrage pour la prochaine session
>
> **Phase actuelle**: Planification TERMINÉE ✅ → **PRÊT POUR IMPLÉMENTATION**
> **Échéance**: 28 novembre 2025 (21h00)

---

## 💬 Message pour le Prochain Agent Claude

```
Bonjour! Je travaille sur un TP de système expert médical en Prolog (TP2 - IFT2003).

La phase de planification est TERMINÉE. Tous les documents sont prêts et validés.

Ma mission: Implémenter 3 fichiers Prolog:
- base_connaissances.pl (20 règles d'inférence)
- main.pl (moteur backward chaining + interface)
- tests.pl (validation)

IMPORTANT: Lis ce fichier (BRIEFING_PROCHAINE_SESSION.md) en entier d'abord,
puis suis docs/GUIDE_IMPLEMENTATION.md étape par étape.

Les 3 points CRITIQUES:
1. Fichiers en UTF-8 (accents français)
2. Cascades (fièvre, toux) - bien suivre le guide section 2.4-2.5
3. Utiliser get_single_char/1 pour UX (pas read/1)

Prêt à implémenter?
```

---

## 🎯 Votre Mission

Implémenter un système expert médical en Prolog qui diagnostique 10 maladies (Grippe, COVID-19, Bronchite, Rhume, Angine, Allergie, Asthme, Migraine, Gastro-entérite, Conjonctivite) à partir de symptômes, en utilisant le backward chaining.

**Temps estimé:** 60-90 minutes (implémentation + tests)

---

## 📚 Documents à Consulter (Dans Cet Ordre)

| # | Document | Quand | Durée |
|---|----------|-------|-------|
| 1️⃣ | **Ce fichier (BRIEFING)** | MAINTENANT | 5 min |
| 2️⃣ | [docs/GUIDE_IMPLEMENTATION.md](docs/GUIDE_IMPLEMENTATION.md) | Pendant implémentation (section par section) | 10-15 min |
| 3️⃣ | [docs/SCENARIOS_TEST.md](docs/SCENARIOS_TEST.md) | Pendant tests | 5 min |
| 4️⃣ | [docs/RESUME_PLAN.md](docs/RESUME_PLAN.md) | Si besoin clarification | Optionnel |

---

## 📊 Architecture (Rappel Rapide)

```
20 règles d'inférence
├── 10 règles: Symptômes → 8 Syndromes (R1-R10)
└── 10 règles: Syndromes → 10 Maladies (R11-R20)

Moteur: Backward chaining (main.pl)
Interface: Questions Oui/Non uniquement
Cascades: 2 (fièvre + toux)
Questions: 21 principales + 2 sous-questions en cascade
Moyenne: 7.4 questions par diagnostic
```

---

## 🚀 Plan de Session (3 Phases)

### Phase 1: base_connaissances.pl (15-20 min)

```bash
# Créer le fichier
touch base_connaissances.pl
```

**À copier depuis GUIDE sections 1.1 et 1.2:**
1. En-tête + commentaires
2. 10 règles syndromes (R1-R10): `syndrome_respiratoire`, `syndrome_febrile`, etc.
3. 10 règles maladies (R11-R20): `grippe`, `covid19`, `bronchite`, etc.

**✅ Checkpoint:** `?- consult('base_connaissances.pl').` → aucune erreur

---

### Phase 2: main.pl (30-40 min)

```bash
touch main.pl
```

**À implémenter dans l'ordre (GUIDE sections 2.1 à 2.8):**

| Section | Prédicat(s) | Temps | Difficulté |
|---------|-------------|-------|------------|
| 2.1 | Infrastructure (`dynamic`, `reinitialiser`) | 2 min | ⭐ Facile |
| 2.2 | Traductions (23 symptômes + 10 maladies + 8 syndromes) | 5 min | ⭐ Facile |
| 2.3 | Interface (`lire_reponse`, `poser_question_simple`) | 3 min | ⭐⭐ Moyen |
| 2.4 | **Cascades** (`poser_question_fievre`, `poser_question_toux`) | 10 min | ⭐⭐⭐ **CRITIQUE** |
| 2.5 | **Vérification** (`verifier_symptome`, `poser_question_et_enregistrer`) | 10 min | ⭐⭐⭐ **CRITIQUE** |
| 2.6 | Moteur (`diagnostiquer`) | 2 min | ⭐ Facile |
| 2.7 | Affichage (`afficher_diagnostic`, `collecter_syndromes`) | 5 min | ⭐⭐ Moyen |
| 2.8 | Point d'entrée (`start`) | 3 min | ⭐ Facile |

**✅ Checkpoint:** `?- consult('main.pl').` → aucune erreur

---

### Phase 3: Tests et Validation (20-30 min)

```bash
?- start.
```

**Tests prioritaires (dans l'ordre):**
1. ✅ **Scénario 1: Migraine** → 3 questions, diagnostic correct
2. ✅ **Scénario 2: COVID-19** → ~7 questions, cascades fonctionnent
3. ✅ **Scénario 10: Rhume** → ~10 questions, négations fonctionnent

**Si ces 3 passent:** Tester les 7 autres scénarios dans SCENARIOS_TEST.md

**✅ Succès complet:** 10/10 scénarios valides

---

## ⚠️ Points CRITIQUES (À Lire Avant de Coder)

### 🔴 #1: Encodage UTF-8 OBLIGATOIRE

```
Dans votre éditeur, VÉRIFIER:
✅ Encodage: UTF-8 (sans BOM)
✅ Fin de ligne: LF (Unix)
```

**Pourquoi:** Traductions françaises avec accents (fièvre, diarrhée, éternué...)
**Symptôme d'erreur:** Caractères bizarres `�` dans l'affichage

---

### 🔴 #2: Gestion des Cascades (Sections 2.4 et 2.5)

**La partie LA PLUS complexe du code:**

**Cascade Fièvre:**
- Pose 2 questions → enregistre 3 faits (`fievre`, `fievre_elevee`, `fievre_legere`)
- Utilise `poser_question_et_enregistrer/1` (PAS `poser_question/2`)
- Vérifie `\+ connu(fievre, _)` pour éviter de reposer
- Cut `!` OBLIGATOIRE après la cascade

**Cascade Toux:**
- Pose 2 questions → enregistre 2 faits (`toux`, `toux_productive`)
- Même logique que fièvre

**⚠️ Si questions posées 2 fois:** Relire GUIDE section 2.5 ligne par ligne

---

### 🔴 #3: UX avec get_single_char

```prolog
% ❌ NE PAS utiliser read/1 (nécessite "1." avec point)
% ✅ Utiliser get_single_char/1

lire_reponse(Reponse) :-
    get_single_char(Code),
    (   Code = 49 -> Reponse = oui      % 49 = '1'
    ;   Code = 50 -> Reponse = non      % 50 = '2'
    ;   ...
    ).
```

**Résultat:** L'utilisateur tape juste `1` ou `2`, réaction immédiate ✅

---

## 🐛 Débogage Rapide

| Erreur | Cause | Solution |
|--------|-------|----------|
| `connu/2 not defined` | Manque `:- dynamic connu/2.` | Ajouter en haut de main.pl |
| Question posée 2x | Cascade reposée | Vérifier `\+ connu(fievre, _)` section 2.5 |
| Caractères `�` | Encodage incorrect | Convertir fichier en UTF-8 |
| Syndrome non détecté | Erreur règle | Tester: `?- assert(connu(X, oui)), syndrome_Y.` |
| Boucle infinie | Manque cut `!` | Ajouter `!` après `connu(Symptome, oui)` |

**Détails:** Section "Débogage Commun" du GUIDE_IMPLEMENTATION.md

---

## ✅ Checklist de Démarrage

**Avant de commencer à coder, vérifier:**
- [ ] J'ai lu ce BRIEFING en entier
- [ ] J'ai ouvert [GUIDE_IMPLEMENTATION.md](docs/GUIDE_IMPLEMENTATION.md) à côté
- [ ] Je comprends les 3 points critiques (UTF-8, cascades, get_single_char)
- [ ] Mon éditeur est configuré en UTF-8
- [ ] J'ai [SCENARIOS_TEST.md](docs/SCENARIOS_TEST.md) sous la main

---

## 📈 Critères de Succès

### ✅ Implémentation Complète
- [ ] base_connaissances.pl: 20 règles
- [ ] main.pl: 8 sections (2.1 à 2.8)
- [ ] Fichiers se chargent sans erreur
- [ ] Encodage UTF-8 vérifié

### ✅ Tests Fonctionnels
- [ ] `?- start.` lance le système
- [ ] Migraine: 3 questions → "Migraine"
- [ ] COVID-19: ~7 questions → "COVID-19" + cascades OK
- [ ] Rhume: ~10 questions → "Rhume" + négations OK
- [ ] Aucune question en double
- [ ] Accents français corrects

### ✅ Validation Complète
- [ ] 10/10 scénarios SCENARIOS_TEST.md
- [ ] Moyenne ~7 questions
- [ ] Syndromes affichés
- [ ] Gestion erreurs (réponses invalides)

---

## 💡 Conseils d'Implémentation

### ✅ Bonnes Pratiques
1. **Suivre le GUIDE section par section** (ne pas improviser)
2. **Tester après chaque checkpoint** (compile après chaque étape)
3. **Copier-coller le code du GUIDE** (il est validé et testé)
4. **Vérifier UTF-8 immédiatement** (dès création fichiers)
5. **Lire les commentaires** (explications importantes)

### ❌ Pièges à Éviter
1. ❌ Utiliser `read/1` → Utiliser `get_single_char/1`
2. ❌ Oublier `!` après cascades → Backtracking infini
3. ❌ Oublier `:- dynamic connu/2.` → Erreur runtime
4. ❌ Encoder en ASCII → UTF-8 obligatoire
5. ❌ Créer `poser_question/2` → Utiliser `poser_question_et_enregistrer/1`

---

## 🎓 Contexte Projet

### ✅ Ce qui a été fait
- Analyse et modélisation complètes
- 20 règles d'inférence définies et validées
- Architecture 3 niveaux (Symptômes → Syndromes → Maladies)
- 10 scénarios de test complets
- Blueprint validé en profondeur (20 étapes de révision)
- Problème critique cascades corrigé
- UX optimisée (get_single_char)

### 🔲 Ce qui reste (VOTRE mission)
- Implémenter les 3 fichiers Prolog
- Tester avec les 10 scénarios
- Valider fonctionnement

### Équipe
- **Vous**: main.pl + base_connaissances.pl
- **Alexandre**: arbre_dependance.md (✅ fait)
- **Daniel**: Rapport final (après implémentation)

---

## 📞 En Cas de Blocage

**Procédure de débogage:**
1. Relire section du GUIDE correspondante
2. Vérifier section "Débogage Commun" du GUIDE
3. Tester règle isolément: `?- assert(connu(X, oui)), syndrome_Y.`
4. Comparer code exact du GUIDE (copier-coller)
5. Vérifier encodage UTF-8 si affichage bizarre

**Important:** Documentation complète et testée. En suivant le GUIDE, tout fonctionne du premier coup.

---

## 📝 Informations Techniques

- **Langage**: Prolog (SWI-Prolog)
- **Paradigme**: Backward chaining pur
- **Format questions**: Oui/Non uniquement (pas de "Je ne sais pas")
- **Nombre questions**: Moyenne 7.4 (min 3, max 10)
- **Format sortie**: Diagnostic + Syndromes identifiés

---

## 🚀 Prêt à Commencer?

**Prochaine action:**
1. ✅ Lire ce BRIEFING (vous venez de le faire!)
2. → Ouvrir [docs/GUIDE_IMPLEMENTATION.md](docs/GUIDE_IMPLEMENTATION.md)
3. → Créer `base_connaissances.pl` et commencer section 1.1

**Rappel:** Tous documents validés. Vous avez tout pour réussir! 💪

---

**Temps estimé total:** 60-90 minutes
**Difficulté:** Moyenne (si vous suivez le guide)
**Taux de succès attendu:** 100% ✅

**Bonne implémentation! 🎯**
