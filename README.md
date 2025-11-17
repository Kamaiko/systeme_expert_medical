# Systeme Expert de Diagnostic Medical - TP2 IFT2003

Systeme expert qui diagnostique 10 maladies courantes a partir de symptomes, utilisant le backward chaining en Prolog.

## Utilisation

### Lancement du systeme

```bash
swipl src/run.pl
```

Cette commande charge automatiquement le systeme et lance le diagnostic.

### Tests

Executer les tests unitaires:

```bash
swipl -g "consult('src/tests.pl'), test_all, halt"
```

**Couverture complete**: 18 tests (8 syndromes + 10 maladies) - 100%

### Repondre aux questions

Le systeme pose des questions en format Oui/Non:
```
Question: Avez-vous perdu l'odorat ou le gout?
1. Oui
2. Non
Votre reponse:
```

**Tapez simplement `1` ou `2`**

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

- **[src/base_connaissances.pl](src/base_connaissances.pl)** - 20 regles d'inference
  - 10 regles: Symptomes → Syndromes (R1-R10)
  - 10 regles: Syndromes → Maladies (R11-R20)

- **[src/main.pl](src/main.pl)** - Moteur d'inference et interface
  - Backward chaining
  - Cache des reponses (ne pose jamais 2x la meme question)
  - Gestion de 2 cascades (fievre, toux)
  - Interface utilisateur optimisee

- **[src/tests.pl](src/tests.pl)** - Tests unitaires
  - Tests des regles syndromes
  - Tests des regles maladies
  - Validation sans interaction

## Informations projet

- **Cours**: IFT2003 - Intelligence Artificielle 1
- **Travail**: TP2 - Systeme Expert
- **Langage**: Prolog (SWI-Prolog 9.3.28)
- **Echeance**: 28 Novembre 2025
- **Ponderation**: 10% de la note finale

---

## Fichiers du projet

```
TP2/
├── src/                     # Code source Prolog
│   ├── run.pl               # Lancement rapide (swipl src/run.pl)
│   ├── main.pl              # Moteur inference + interface
│   ├── base_connaissances.pl # 20 regles + recommandations
│   └── tests.pl             # 18 tests unitaires (100% couverture)
├── docs/                    # Documentation projet
│   ├── RESUME_PLAN.md       # Plan complet + tests
│   ├── arbre_dependance.md  # Graphe dependances
│   └── SCENARIOS_TEST.md    # Scenarios validation
└── README.md                # Documentation utilisateur
```

---

**Systeme pret a l'emploi!** Lancez `swipl src/run.pl` pour commencer.
