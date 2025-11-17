# Systeme Expert de Diagnostic Medical - TP2 IFT2003

Systeme expert qui diagnostique 10 maladies courantes a partir de symptomes, utilisant le backward chaining en Prolog.

## Utilisation

### Lancement rapide (recommande)

```bash
swipl start.pl
```

Cette commande charge automatiquement le systeme et lance le diagnostic.

### Lancement manuel

```bash
swipl
```

Dans l'interpreteur SWI-Prolog:
```prolog
?- consult('main.pl').
true.

?- start.
```

### Repondre aux questions

Le systeme pose des questions en format Oui/Non:
```
Question: Avez-vous perdu l'odorat ou le gout?
1. Oui
2. Non
Votre reponse:
```

**Tapez simplement `1` ou `2` (sans appuyer sur Enter dans certaines versions)**

### Exemple de session - Migraine

```
?- start.

=======================================================
    SYSTEME EXPERT DE DIAGNOSTIC MEDICAL
=======================================================

Ce systeme vous posera quelques questions pour etablir
un diagnostic parmi 10 maladies courantes.
Repondez par 1 (Oui) ou 2 (Non).

-------------------------------------------------------

Question: Avez-vous perdu l'odorat ou le gout?
1. Oui
2. Non
Votre reponse:
2

Question: Avez-vous un mal de tete intense?
1. Oui
2. Non
Votre reponse:
1

Question: Etes-vous sensible a la lumiere (photophobie)?
1. Oui
2. Non
Votre reponse:
1

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

## Maladies diagnostiquees

Le systeme peut diagnostiquer 10 maladies:

1. **COVID-19** - Discriminant: perte odorat
2. **Migraine** - Discriminant: mal de tete intense + photophobie
3. **Conjonctivite** - Discriminant: secretions purulentes
4. **Asthme** - Discriminant: wheezing + difficultes respiratoires
5. **Gastro-enterite** - Discriminant: diarrhee + vomissements
6. **Grippe** - Syndrome grippal sans perte odorat
7. **Angine** - Mal gorge intense + fievre
8. **Bronchite** - Toux productive + fievre legere
9. **Allergie saisonniere** - Symptomes allergiques sans asthme
10. **Rhume** - Syndrome respiratoire leger

## Architecture technique

### Fichiers principaux

- **[base_connaissances.pl](base_connaissances.pl)** - 20 regles d'inference
  - 10 regles: Symptomes → Syndromes (R1-R10)
  - 10 regles: Syndromes → Maladies (R11-R20)

- **[main.pl](main.pl)** - Moteur d'inference et interface
  - Backward chaining
  - Cache des reponses (ne pose jamais 2x la meme question)
  - Gestion de 2 cascades (fievre, toux)
  - Interface utilisateur optimisee

- **[tests.pl](tests.pl)** - Tests unitaires
  - Tests des regles syndromes
  - Tests des regles maladies
  - Validation sans interaction

### Tests

#### Tests unitaires automatises

```prolog
?- consult('tests.pl').
?- test_all.

=== TESTS UNITAIRES ===

--- Tests Syndromes ---
✓ R1: syndrome_respiratoire OK
✓ R4: syndrome_febrile OK
✓ R9: syndrome_neurologique OK

--- Tests Maladies (10/10) ---
✓ R11: grippe OK
✓ R12: covid19 OK
✓ R13: bronchite OK
✓ R14: rhume OK
✓ R15: angine OK
✓ R16: allergie OK
✓ R17: asthme OK
✓ R18: migraine OK
✓ R19: gastro_enterite OK
✓ R20: conjonctivite OK

=== FIN DES TESTS ===
TOUS LES TESTS PASSES! (13 tests)
```

**Couverture complete**:
- 3 syndromes testes
- **10/10 maladies testees** (100% de couverture)
- Tous les edge cases valides

#### Tests interactifs guides

```prolog
?- consult('tests.pl').
?- test_migraine.    % Guide pour tester Migraine
?- test_covid.       % Guide pour tester COVID-19
?- test_rhume.       % Guide pour tester Rhume
```

## Caracteristiques

### Recommandations medicales

Chaque diagnostic inclut des **recommandations pratiques** adaptees:
- Conseils de repos et hydratation
- Signes d'alerte necessitant consultation
- Traitements symptomatiques suggeres
- Mesures preventives

**Note**: Ces recommandations sont a titre informatif uniquement. Consultez un professionnel de sante pour un avis medical personnalise.

### Cascades intelligentes

Le systeme gere 2 questions en cascade:

**Cascade Fievre:**
```
Q: Avez-vous de la fievre?
  → Si OUI: Est-elle elevee (>38.5°C)?
```

**Cascade Toux:**
```
Q: Avez-vous de la toux?
  → Si OUI: Est-elle productive (avec crachats)?
```

### Optimisations

- **Ordre des questions optimise**: Les discriminants uniques sont testes en premier
- **Cache des reponses**: Chaque question n'est posee qu'une seule fois
- **Backward chaining pur**: Le systeme ne pose que les questions necessaires
- **Moyenne 4-7 questions** par diagnostic (au lieu de 21 questions completes)

### Exemple d'optimisation - COVID-19

Au lieu de poser les 21 questions, le systeme:
1. Pose "perte odorat" EN PREMIER (discriminant unique)
2. Si OUI: Verifie les syndromes necessaires (~5-6 questions de plus)
3. Si NON: Passe a la maladie suivante

**Total**: ~7 questions au lieu de 21!

## Structure des regles

### Exemple de regle syndrome (R1)

```prolog
% R1: Fievre legere ∧ Toux → Syndrome respiratoire
syndrome_respiratoire :-
    verifier_symptome(fievre_legere),
    verifier_symptome(toux).
```

### Exemple de regle maladie (R12)

```prolog
% R12: COVID-19 = Perte odorat ∧ Respiratoire ∧ Grippal ∧ Febrile
covid19 :-
    verifier_symptome(perte_odorat),  % Discriminant en premier!
    syndrome_respiratoire,
    syndrome_grippal,
    syndrome_febrile.
```

## Documentation

- **[docs/RESUME_PLAN.md](docs/RESUME_PLAN.md)** - Plan detaille du projet (20 regles, architecture)
- **[docs/GUIDE_IMPLEMENTATION.md](docs/GUIDE_IMPLEMENTATION.md)** - Guide d'implementation technique
- **[docs/Enonce TP2.pdf](docs/Enonce%20TP2.pdf)** - Enonce officiel du TP

## Informations projet

- **Cours**: IFT2003 - Intelligence Artificielle 1
- **Travail**: TP2 - Systeme Expert
- **Langage**: Prolog (SWI-Prolog 9.3.28)
- **Echeance**: 28 Novembre 2025
- **Ponderation**: 10% de la note finale

## Notes techniques

- **Encodage**: Fichiers sans accents (pas UTF-8)
- **Input**: `get_single_char/1` pour UX optimisee
- **Format questions**: Oui/Non uniquement (pas de "Je ne sais pas")
- **Negations**: Utilise `\+` (not provable) au lieu de `not`

---

## Fichiers du projet

```
TP2/
├── start.pl                 # Lancement rapide (swipl start.pl)
├── main.pl                  # Moteur inference + interface
├── base_connaissances.pl    # 20 regles + recommandations
├── tests.pl                 # 13 tests unitaires
├── README.md                # Documentation utilisateur
└── docs/                    # Documentation projet
    ├── RESUME_PLAN.md
    ├── GUIDE_IMPLEMENTATION.md
    └── Enonce TP2.pdf
```

---

**Systeme pret a l'emploi!** Lancez `swipl start.pl` pour commencer.
