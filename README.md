# Système Expert de Diagnostic Médical

**Projet**: TP2 - IFT2003 Intelligence Artificielle 1
**Langage**: Prolog (SWI-Prolog)
**Équipe**: 4 personnes

## Description

Système expert médical interactif utilisant le **chaînage arrière** pour diagnostiquer 10 maladies courantes à partir de symptômes.

## Architecture

```
20 règles d'inférence
├── 10 règles: Symptômes → 8 Syndromes intermédiaires
└── 10 règles: Syndromes → 10 Maladies
```

**Maladies**: Grippe, COVID-19, Bronchite, Rhume, Angine, Allergie, Asthme, Migraine, Gastro-entérite, Conjonctivite

## Utilisation

```bash
swipl -s main.pl
?- start.
```

Le système pose 4-6 questions en moyenne et fournit un diagnostic justifié.

## Fichiers

- `base_connaissances.pl` - Base de règles médicales
- `main.pl` - Moteur d'inférence et interface
- `tests.pl` - Tests unitaires
- `docs/RESUME_PLAN.md` - Documentation complète du projet

## Exemple

```
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

## Échéance

**28 novembre 2025** - 21h00
