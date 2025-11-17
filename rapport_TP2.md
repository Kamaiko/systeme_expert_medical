---
title: "Système Expert de Diagnostic Médical"
subtitle: "Conception et réalisation en Prolog"
author:
  - Alexandre [Nom]
  - Xavier [Nom]
  - Daniel [Nom]
  - [Votre Nom]
date: "Novembre 2025"
course: "IFT2003 - Intelligence Artificielle 1"
institution: "Université Laval"
abstract: |
  Ce rapport présente la conception et l'implémentation d'un système expert de diagnostic médical développé en Prolog. Le système utilise le chaînage arrière (backward chaining) pour diagnostiquer 10 maladies courantes à partir de symptômes saisis par l'utilisateur. L'architecture hiérarchique à trois niveaux (Symptômes → Syndromes → Maladies) comprend 20 règles d'inférence interconnectées, permettant un diagnostic efficace en 3 à 10 questions selon la complexité du cas.
toc: true
toc-depth: 3
numbersections: true
geometry: "margin=2.5cm"
fontsize: 12pt
mainfont: "Times New Roman"
---

\newpage

# Table des Matières

- [Introduction](#introduction)
- [I. Méthodologie Adoptée](#i-méthodologie-adoptée)
  - [1.1 Architecture Globale du Système Expert](#11-architecture-globale-du-système-expert)
  - [1.2 Présentation des Maladies et Construction de la Base de Faits et Règles](#12-présentation-des-maladies-et-construction-de-la-base-de-faits-et-règles)
    - [Les 10 Maladies Diagnostiquées](#les-10-maladies-diagnostiquées)
    - [Les 8 Syndromes Intermédiaires](#les-8-syndromes-intermédiaires)
    - [Les 20 Règles d'Inférence](#les-20-règles-dinférence)
  - [1.3 Graphe de Dépendance de la Structure du Raisonnement](#13-graphe-de-dépendance-de-la-structure-du-raisonnement)
  - [1.4 Description du Moteur d'Inférence et du Mécanisme de Raisonnement](#14-description-du-moteur-dinférence-et-du-mécanisme-de-raisonnement)
    - [Principe du Chaînage Arrière](#principe-du-chaînage-arrière-backward-chaining)
    - [Ordre Optimisé des Hypothèses](#ordre-optimisé-des-hypothèses)
    - [Mécanisme de Cache et Gestion de la Mémoire](#mécanisme-de-cache-et-gestion-de-la-mémoire)
    - [Exemple de Trace de Raisonnement](#exemple-de-trace-de-raisonnement)
  - [1.5 Détails des Prédicats Utilisés dans le Code](#15-détails-des-prédicats-utilisés-dans-le-code)
- [II. Les Cas de Test avec Résultats Obtenus](#ii-les-cas-de-test-avec-résultats-obtenus)
  - [Scénario 1 : Migraine (Cas Optimal)](#scénario-1--migraine-cas-optimal)
  - [Scénario 2 : COVID-19 (Cas Moyen)](#scénario-2--covid-19-cas-moyen)
  - [Scénario 3 : Angine (Cas Typique)](#scénario-3--angine-cas-typique)
  - [Synthèse Comparative des Trois Scénarios](#synthèse-comparative-des-trois-scénarios)
- [Conclusion](#conclusion)
  - [Synthèse des Réalisations](#synthèse-des-réalisations)
  - [Limites Identifiées](#limites-identifiées)
  - [Pistes d'Amélioration](#pistes-damélioration)
  - [Réflexion Finale](#réflexion-finale)

\newpage

# Introduction

Les systèmes experts représentent une branche fondamentale de l'intelligence artificielle, permettant de modéliser et d'automatiser le raisonnement d'experts humains dans des domaines spécifiques. Dans le contexte médical, ces systèmes offrent un potentiel considérable pour assister les professionnels de santé dans leurs démarches diagnostiques, particulièrement dans l'identification de pathologies courantes.

Ce travail pratique s'inscrit dans une démarche pédagogique visant à concevoir et développer un système expert de diagnostic médical simplifié. L'objectif principal est de créer un outil interactif capable d'identifier une maladie parmi 10 pathologies courantes (Grippe, COVID-19, Bronchite, Rhume, Angine, Allergie saisonnière, Asthme, Migraine, Gastro-entérite, Conjonctivite) en posant une série de questions ciblées à l'utilisateur.

Le système repose sur une implémentation en Prolog, langage particulièrement adapté à la programmation logique et au raisonnement automatique. L'architecture adoptée utilise le **chaînage arrière** (*backward chaining*), une stratégie d'inférence orientée-but qui permet de minimiser le nombre de questions posées tout en garantissant un diagnostic précis.

La base de connaissances développée comprend **20 règles d'inférence** structurées en trois niveaux hiérarchiques : les symptômes observés déclenchent des syndromes intermédiaires, qui à leur tour permettent d'identifier la maladie finale. Cette organisation garantit une interconnexion forte entre les règles, évitant la création de sous-arbres de décision isolés, conformément aux exigences du projet.

# I. Méthodologie Adoptée

## 1.1 Architecture Globale du Système Expert

Le système expert développé repose sur une **architecture hiérarchique à trois niveaux**, inspirée des modèles classiques de systèmes experts médicaux (Figure 1). Cette structure permet de décomposer le raisonnement diagnostique en étapes logiques successives, facilitant la maintenance, l'évolution et la validation de la base de connaissances.

```
┌─────────────────────────────────────────────────────────────┐
│                    NIVEAU 1: SYMPTÔMES                      │
│                        23 symptômes                         │
│   (fièvre, toux, mal de tête, photophobie, diarrhée, ...)   │
└───────────────────────────┬─────────────────────────────────┘
                            │
                   10 règles d'inférence (R1-R10)
                            │
                            ↓
┌─────────────────────────────────────────────────────────────┐
│              NIVEAU 2: SYNDROMES INTERMÉDIAIRES             │
│                       8 syndromes                           │
│  (respiratoire, fébrile, grippal, allergique, oculaire,     │
│        digestif, neurologique, ORL)                         │
└───────────────────────────┬─────────────────────────────────┘
                            │
                   10 règles d'inférence (R11-R20)
                            │
                            ↓
┌─────────────────────────────────────────────────────────────┐
│                   NIVEAU 3: MALADIES                        │
│                     10 diagnostics finaux                   │
│  (Grippe, COVID-19, Bronchite, Rhume, Angine, Allergie,     │
│      Asthme, Migraine, Gastro-entérite, Conjonctivite)      │
└─────────────────────────────────────────────────────────────┘
```

**Figure 1** : Architecture hiérarchique à trois niveaux du système expert.

### Composantes du Système

Le tableau 1 présente un récapitulatif quantitatif des différentes composantes du système :

| Composante | Quantité | Description |
|:-----------|:--------:|:------------|
| **Symptômes** | 23 | Observations cliniques élémentaires (fièvre, toux, mal de tête, fièvre élevée, fièvre légère, toux productive, etc.) |
| **Syndromes intermédiaires** | 8 | Groupements de symptômes formant des entités cliniques cohérentes |
| **Maladies diagnostiquées** | 10 | Pathologies courantes identifiables par le système |
| **Règles Niveau 1→2** | 10 | Déduction des syndromes à partir des symptômes |
| **Règles Niveau 2→3** | 10 | Déduction des maladies à partir des syndromes |
| **Total règles** | **20** | Conforme aux exigences (20-30 règles) |

**Tableau 1** : Récapitulatif quantitatif des composantes du système expert.

### Modules Logiciels

L'implémentation se décompose en trois modules Prolog principaux :

1. **base_connaissances.pl** : Contient les 20 règles d'inférence, les syndromes, les maladies et les recommandations médicales
2. **main.pl** : Implémente le moteur d'inférence (backward chaining), la gestion du cache et l'interface utilisateur
3. **tests.pl** : Suite de 18 tests unitaires validant l'intégralité des règles (8 syndromes + 10 maladies)

## 1.2 Présentation des Maladies et Construction de la Base de Faits et Règles

### Les 10 Maladies Diagnostiquées

Le système expert est conçu pour diagnostiquer 10 pathologies courantes, choisies pour couvrir un large spectre de symptomatologies tout en permettant une discrimination efficace. Le tableau 2 présente ces maladies avec leurs caractéristiques diagnostiques principales.

| Maladie | Syndromes requis | Symptômes discriminants clés | Nb règles |
|:--------|:-----------------|:-----------------------------|:---------:|
| **Grippe** | Respiratoire + Grippal + Fébrile | Fatigue intense, courbatures, **sans** perte odorat | 4 |
| **COVID-19** | Respiratoire + Grippal + Fébrile | **Perte odorat/goût** (discriminant unique) | 4 |
| **Bronchite** | Respiratoire | **Toux productive** + Fièvre légère | 3 |
| **Rhume** | Respiratoire seul | Nez bouché, gorge irritée, **sans** fièvre élevée ni fatigue | 3 |
| **Angine** | ORL + Fébrile | **Mal gorge intense** + Fièvre élevée | 3 |
| **Allergie saisonnière** | Allergique + Oculaire | Éternuements, yeux rouges, **sans** difficultés respiratoires | 4 |
| **Asthme** | Respiratoire + Allergique | **Wheezing** + Difficultés respiratoires | 5 |
| **Migraine** | Neurologique seul | Mal tête intense + **Photophobie** | 2 |
| **Gastro-entérite** | Digestif + Fébrile | Diarrhée + Vomissements + Fièvre | 3 |
| **Conjonctivite** | Oculaire | Yeux rouges + **Sécrétions purulentes** | 3 |

**Tableau 2** : Caractéristiques diagnostiques des 10 maladies.

Les symptômes en **gras** représentent des **discriminants uniques** permettant de différencier rapidement certaines maladies (par exemple, la perte d'odorat pour COVID-19, le wheezing pour l'asthme).

### Les 8 Syndromes Intermédiaires

Les syndromes intermédiaires constituent le niveau central de raisonnement, agrégeant plusieurs symptômes en entités cliniques cohérentes. Le tableau 3 détaille ces syndromes avec leurs conditions de déclenchement.

| Syndrome | Symptômes déclencheurs | Règle(s) | Nb maladies |
|:---------|:-----------------------|:---------|:-----------:|
| **syndrome_respiratoire** | (Fièvre légère ∧ Toux) **OU** (Fièvre élevée ∧ Toux) **OU** (Nez bouché ∧ Gorge irritée) | R1, R2, R3 | **5** |
| **syndrome_fébrile** | Fièvre élevée | R4 | **4** |
| **syndrome_grippal** | Fatigue intense ∧ Courbatures ∧ Fièvre élevée | R5 | **2** |
| **syndrome_allergique** | Éternuements | R6 | **2** |
| **syndrome_oculaire** | Yeux rouges ∧ Yeux qui piquent | R7 | **2** |
| **syndrome_digestif** | Diarrhée ∧ Vomissements | R8 | 1 |
| **syndrome_neurologique** | Mal tête intense ∧ Photophobie | R9 | 1 |
| **syndrome_orl** | Mal gorge intense | R10 | 1 |

**Tableau 3** : Syndromes intermédiaires avec leurs conditions de déclenchement.

**Note importante** : Les syndromes avec plusieurs maladies associées (en gras) créent l'**interconnexion globale** de l'arbre de décision, évitant ainsi les sous-arbres isolés.

### Les 20 Règles d'Inférence

La base de connaissances est constituée de **20 règles d'inférence** réparties en deux niveaux de déduction.

#### Niveau 1 → Niveau 2 : Symptômes → Syndromes (10 règles)

Le tableau 4 présente les 10 premières règles permettant de déduire les syndromes à partir des symptômes observés.

| # | Règle logique | Syndrome déduit |
|:-:|:--------------|:----------------|
| **R1** | fièvre_légère ∧ toux → syndrome_respiratoire | Respiratoire |
| **R2** | fièvre_élevée ∧ toux → syndrome_respiratoire | Respiratoire |
| **R3** | nez_bouché ∧ gorge_irritée → syndrome_respiratoire | Respiratoire |
| **R4** | fièvre_élevée → syndrome_fébrile | Fébrile |
| **R5** | fatigue_intense ∧ courbatures ∧ fièvre_élevée → syndrome_grippal | Grippal |
| **R6** | éternuements → syndrome_allergique | Allergique |
| **R7** | yeux_rouges ∧ yeux_qui_piquent → syndrome_oculaire | Oculaire |
| **R8** | diarrhée ∧ vomissements → syndrome_digestif | Digestif |
| **R9** | mal_tête_intense ∧ photophobie → syndrome_neurologique | Neurologique |
| **R10** | mal_gorge_intense → syndrome_orl | ORL |

**Tableau 4** : Règles d'inférence de Niveau 1 → Niveau 2.

#### Niveau 2 → Niveau 3 : Syndromes → Maladies (10 règles)

Le tableau 5 présente les 10 règles permettant de déduire les maladies finales à partir des syndromes identifiés.

| # | Règle logique | Maladie diagnostiquée |
|:-:|:--------------|:----------------------|
| **R11** | syndrome_respiratoire ∧ syndrome_grippal ∧ syndrome_fébrile ∧ **¬**perte_odorat → grippe | Grippe |
| **R12** | syndrome_respiratoire ∧ syndrome_grippal ∧ syndrome_fébrile ∧ perte_odorat → covid19 | COVID-19 |
| **R13** | syndrome_respiratoire ∧ fièvre_légère ∧ toux_productive → bronchite | Bronchite |
| **R14** | syndrome_respiratoire ∧ **¬**syndrome_fébrile ∧ **¬**syndrome_grippal → rhume | Rhume |
| **R15** | syndrome_orl ∧ syndrome_fébrile → angine | Angine |
| **R16** | syndrome_allergique ∧ syndrome_oculaire ∧ **¬**difficultés_respiratoires → allergie | Allergie saisonnière |
| **R17** | syndrome_respiratoire ∧ syndrome_allergique ∧ wheezing ∧ difficultés_respiratoires → asthme | Asthme |
| **R18** | syndrome_neurologique → migraine | Migraine |
| **R19** | syndrome_digestif ∧ syndrome_fébrile → gastro_entérite | Gastro-entérite |
| **R20** | syndrome_oculaire ∧ sécrétions_purulentes → conjonctivite | Conjonctivite |

**Tableau 5** : Règles d'inférence de Niveau 2 → Niveau 3.

### Justification de l'Interconnexion des Règles

Conformément à la note importante de l'énoncé stipulant que *"la construction d'un arbre de dépendance (global) n'est possible que si certaines règles partagent au moins un fait commun dans leurs prémisses"*, notre architecture garantit une forte interconnexion :

- **5 syndromes sur 8** (62,5 %) sont partagés par au moins 2 maladies
- **8 maladies sur 10** (80 %) utilisent au moins un syndrome partagé
- Le syndrome_respiratoire seul interconnecte **5 maladies** différentes
- Le syndrome_fébrile seul interconnecte **4 maladies** différentes

Cette conception évite explicitement la création de sous-arbres isolés et respecte pleinement les exigences du projet.

## 1.3 Graphe de Dépendance de la Structure du Raisonnement

## 1.4 Description du Moteur d'Inférence et du Mécanisme de Raisonnement

### Principe du Chaînage Arrière (Backward Chaining)

Le moteur d'inférence développé utilise la stratégie du **chaînage arrière** (*backward chaining*), un raisonnement **orienté-but** (*goal-driven reasoning*) qui part d'une **hypothèse de diagnostic** et tente de la valider en vérifiant si les conditions nécessaires sont satisfaites.

#### Processus de Raisonnement

Le mécanisme de raisonnement suit les étapes suivantes :

1. **Sélection d'une hypothèse** : Le système teste séquentiellement les maladies dans un ordre optimisé (voir section suivante)

2. **Vérification des prémisses** : Pour chaque maladie testée, le système vérifie si les syndromes requis sont présents
   - Si un syndrome requis n'est pas encore connu, le système vérifie récursivement si ce syndrome peut être déduit
   - Si un symptôme nécessaire n'est pas connu, le système **pose une question** à l'utilisateur

3. **Déduction récursive** : Chaque syndrome peut lui-même nécessiter la vérification de plusieurs symptômes, créant une arborescence de vérifications

4. **Validation ou invalidation** :
   - Si toutes les conditions sont satisfaites → **Diagnostic confirmé**
   - Si au moins une condition n'est pas satisfaite → Passage à l'hypothèse suivante

5. **Affichage du résultat** : Le premier diagnostic validé est retourné avec ses recommandations médicales

### Ordre Optimisé des Hypothèses

Pour minimiser le nombre de questions posées à l'utilisateur, les maladies sont testées dans un **ordre stratégique**, en privilégiant celles possédant des **symptômes discriminants uniques** :

```prolog
diagnostiquer(Maladie) :-
    member(Maladie, [
        covid19,           % Discriminant unique: perte_odorat → 2-3 questions
        migraine,          % Discriminant: neurologique → 3 questions
        conjonctivite,     % Discriminant: sécrétions_purulentes → 4-5 questions
        asthme,            % Discriminants: wheezing + diff. respiratoires → 5-6 questions
        gastro_enterite,   % Syndromes: digestif + fébrile → 5-6 questions
        grippe,            % 3 syndromes complexes → 6-8 questions
        angine,            % Syndromes: ORL + fébrile → 5-6 questions
        bronchite,         % Syndromes: toux_productive + fièvre_légère → 5-7 questions
        allergie,          % Syndromes: allergique + oculaire → 6-7 questions
        rhume              % Diagnostic par élimination (dernier) → 7-8 questions
    ]),
    call(Maladie).
```

**Justification de l'ordre** :

- **COVID-19 en premier** : La présence/absence de perte d'odorat permet de confirmer/infirmer rapidement (1-2 questions seulement)
- **Migraine en deuxième** : Symptômes très spécifiques (mal de tête intense + photophobie)
- **Rhume en dernier** : Pathologie nécessitant de vérifier de nombreuses négations (absence de fièvre, absence de fatigue intense, etc.)

Cette stratégie réduit le nombre moyen de questions posées de **~10 questions** (approche naïve) à **~5-6 questions** (approche optimisée).

### Mécanisme de Cache et Gestion de la Mémoire

Un aspect crucial du système est la **gestion du cache des réponses** pour éviter de poser plusieurs fois la même question à l'utilisateur.

#### Base de Faits Dynamique

```prolog
:- dynamic connu/2.  % connu(Symptome, Reponse)
```

Le prédicat `connu/2` stocke en mémoire les réponses déjà obtenues sous la forme `connu(symptome, oui)` ou `connu(symptome, non)`.

#### Algorithme de Vérification avec Cache

Le prédicat `verifier_symptome/1` implémente une logique à trois clauses :

```prolog
% Cas 1: Symptôme déjà connu comme VRAI
verifier_symptome(Symptome) :-
    connu(Symptome, oui), !.

% Cas 2: Symptôme déjà connu comme FAUX
verifier_symptome(Symptome) :-
    connu(Symptome, non), !, fail.

% Cas 3: Symptôme non encore vérifié → poser question
verifier_symptome(Symptome) :-
    \+ connu(Symptome, _),
    poser_question_et_enregistrer(Symptome),
    connu(Symptome, oui).
```

**Avantage** : Quelle que soit la complexité de l'arbre de décision, chaque symptôme n'est demandé qu'**une seule fois** maximum.

### Exemple de Trace de Raisonnement

Prenons l'exemple d'un diagnostic de **Grippe**. Le système teste séquentiellement les hypothèses dans l'ordre optimisé :

**Hypothèses éliminées** : `covid19` (perte_odorat=non), `migraine` (mal_tete_intense=non), `conjonctivite` (secretions_purulentes=non), etc.

**Hypothèse validée - Grippe (R11)** :

- **syndrome_respiratoire** ✓ (R2 : fievre_elevee ∧ toux)
  - Questions posées : fievre_elevee, toux

- **syndrome_grippal** ✓ (R5 : fatigue_intense ∧ courbatures ∧ fievre_elevee)
  - fatigue_intense=oui, courbatures=oui
  - fievre_elevee **réutilisée du cache** (pas de re-question)

- **syndrome_febrile** ✓ (R4 : fievre_elevee)
  - fievre_elevee **réutilisée du cache**

- **¬perte_odorat** ✓ (déjà en cache=non)

**Résultat** : DIAGNOSTIC Grippe confirmé | **7 questions posées**

Ce mécanisme illustre l'efficacité du backward chaining : seules les questions nécessaires sont posées, et le cache évite toute redondance.

## 1.5 Détails des Prédicats Utilisés dans le Code

Cette section présente une description exhaustive des 27 prédicats principaux implémentés dans les modules `main.pl` et `base_connaissances.pl`.

### Prédicats du Moteur Principal (main.pl)

| Prédicat | Arité | Description |
|:---------|:-----:|:------------|
| `start/0` | 0 | **Point d'entrée principal** du système. Affiche la bannière d'accueil, réinitialise le cache, lance le processus de diagnostic et affiche le résultat final. |
| `diagnostiquer/1` | 1 | **Moteur de backward chaining**. Teste séquentiellement les 10 maladies dans un ordre optimisé. Retourne la première maladie dont toutes les conditions sont satisfaites. |
| `reinitialiser/0` | 0 | **Efface le cache** des réponses (`connu/2`) pour permettre une nouvelle session de diagnostic indépendante. |

**Tableau 6a** : Prédicats principaux du système (1/3).

| Prédicat | Arité | Description |
|:---------|:-----:|:------------|
| `verifier_symptome/1` | 1 | **Vérification de symptôme avec cache**. Trois clauses : (1) retourne succès si symptôme déjà connu=oui, (2) échoue si déjà connu=non, (3) pose question si inconnu. Évite de redemander la même question. |
| `poser_question_et_enregistrer/1` | 1 | **Dispatch de questions**. Détecte si le symptôme fait partie d'une cascade (fièvre, toux) et déclenche la séquence appropriée, sinon pose question simple. |
| `poser_question_simple/2` | 2 | **Question Oui/Non standard**. Affiche la question en français, propose les options 1=Oui / 2=Non, lit la réponse et la retourne. |
| `poser_question_fievre/0` | 0 | **Gestion cascade fièvre**. Pose la question principale "Avez-vous de la fièvre?", puis si oui, pose "Est-elle élevée?". Enregistre simultanément `fievre`, `fievre_elevee` et `fievre_legere` dans le cache selon les réponses. |
| `poser_question_toux/0` | 0 | **Gestion cascade toux**. Pose la question principale "Avez-vous de la toux?", puis si oui, pose "Est-elle productive?". Enregistre simultanément `toux` et `toux_productive` dans le cache. |
| `lire_reponse/1` | 1 | **Lecture et validation de l'entrée utilisateur**. Utilise `get_single_char/1` pour une lecture immédiate (sans Enter). Valide que la réponse est '1' ou '2', redemande sinon. Convertit en `oui`/`non`. |

**Tableau 6b** : Prédicats de vérification et d'interrogation (2/3).

| Prédicat | Arité | Description |
|:---------|:-----:|:------------|
| `afficher_diagnostic/1` | 1 | **Affichage du diagnostic final**. Formate et affiche le nom de la maladie en français avec bannière, puis appelle `afficher_recommandations/1`. |
| `afficher_recommandations/1` | 1 | **Affichage des recommandations médicales**. Récupère la liste de recommandations depuis `recommandation/2` et l'affiche formatée sous forme de liste à puces. |
| `afficher_liste_recommandations/1` | 1 | **Affichage itératif de liste**. Prédicat récursif qui affiche chaque recommandation précédée d'un tiret. |
| `collecter_syndromes/1` | 1 | **Collecte des syndromes détectés**. Utilise `findall/3` pour identifier tous les syndromes qui sont actuellement vrais (utilisé pour debug/trace, non affiché par défaut). |
| `afficher_aucun_diagnostic/0` | 0 | **Message d'échec diagnostique**. Affiché si aucune des 10 maladies ne correspond aux symptômes fournis. Recommande une consultation médicale. |

**Tableau 6c** : Prédicats d'affichage des résultats (3/3).

### Prédicats de Traduction (main.pl)

| Prédicat | Arité | Description |
|:---------|:-----:|:------------|
| `traduire_symptome/2` | 2 | **Mapping Prolog → Français pour symptômes**. Base de 21 faits associant chaque atome Prolog (ex: `perte_odorat`) à sa question en français (ex: "perdu l'odorat ou le goût"). Format sans accents pour compatibilité. |
| `traduire_maladie/2` | 2 | **Mapping Prolog → Français pour maladies**. Base de 10 faits associant chaque maladie Prolog (ex: `covid19`) à son nom français (ex: "COVID-19"). |
| `traduire_syndrome/2` | 2 | **Mapping Prolog → Français pour syndromes**. Base de 8 faits associant chaque syndrome Prolog (ex: `syndrome_respiratoire`) à son nom français (ex: "Syndrome respiratoire"). |

**Tableau 7** : Prédicats de traduction français.

### Prédicats de la Base de Connaissances (base_connaissances.pl)

| Prédicat | Arité | Description |
|:---------|:-----:|:------------|
| `syndrome_respiratoire/0` | 0 | **Déduction syndrome respiratoire**. 3 clauses alternatives (R1, R2, R3) : fièvre+toux (légère ou élevée) OU nez_bouché+gorge_irritée. |
| `syndrome_febrile/0` | 0 | **Déduction syndrome fébrile**. 1 clause (R4) : fièvre_élevée suffit (règle simplifiée). |
| `syndrome_grippal/0` | 0 | **Déduction syndrome grippal**. 1 clause (R5) : fatigue_intense ∧ courbatures ∧ fièvre_élevée. |
| `syndrome_allergique/0` | 0 | **Déduction syndrome allergique**. 1 clause (R6) : éternuements suffisent (règle simplifiée). |
| `syndrome_oculaire/0` | 0 | **Déduction syndrome oculaire**. 1 clause (R7) : yeux_rouges ∧ yeux_qui_piquent. |
| `syndrome_digestif/0` | 0 | **Déduction syndrome digestif**. 1 clause (R8) : diarrhée ∧ vomissements. |
| `syndrome_neurologique/0` | 0 | **Déduction syndrome neurologique**. 1 clause (R9) : mal_tête_intense ∧ photophobie. |
| `syndrome_orl/0` | 0 | **Déduction syndrome ORL**. 1 clause (R10) : mal_gorge_intense suffit (règle simplifiée). |

**Tableau 8** : Prédicats de déduction des syndromes (Règles R1-R10).

| Prédicat | Arité | Description |
|:---------|:-----:|:------------|
| `grippe/0` | 0 | **Règle R11**. Diagnostic Grippe : syndrome_respiratoire ∧ syndrome_grippal ∧ syndrome_fébrile ∧ ¬perte_odorat. |
| `covid19/0` | 0 | **Règle R12**. Diagnostic COVID-19 : perte_odorat ∧ syndrome_respiratoire ∧ syndrome_grippal ∧ syndrome_fébrile. Discriminant unique en premier pour optimisation. |
| `bronchite/0` | 0 | **Règle R13**. Diagnostic Bronchite : syndrome_respiratoire ∧ fièvre_légère ∧ toux_productive. |
| `rhume/0` | 0 | **Règle R14**. Diagnostic Rhume : syndrome_respiratoire ∧ ¬syndrome_fébrile ∧ ¬syndrome_grippal. |
| `angine/0` | 0 | **Règle R15**. Diagnostic Angine : syndrome_orl ∧ syndrome_fébrile. |
| `allergie/0` | 0 | **Règle R16**. Diagnostic Allergie saisonnière : syndrome_allergique ∧ syndrome_oculaire ∧ ¬difficultés_respiratoires. |
| `asthme/0` | 0 | **Règle R17**. Diagnostic Asthme : syndrome_respiratoire ∧ syndrome_allergique ∧ wheezing ∧ difficultés_respiratoires. |
| `migraine/0` | 0 | **Règle R18**. Diagnostic Migraine : syndrome_neurologique. |
| `gastro_enterite/0` | 0 | **Règle R19**. Diagnostic Gastro-entérite : syndrome_digestif ∧ syndrome_fébrile. |
| `conjonctivite/0` | 0 | **Règle R20**. Diagnostic Conjonctivite : syndrome_oculaire ∧ sécrétions_purulentes. |

**Tableau 9** : Prédicats de diagnostic des maladies (Règles R11-R20).

### Prédicat de Recommandations (base_connaissances.pl)

| Prédicat | Arité | Description |
|:---------|:-----:|:------------|
| `recommandation/2` | 2 | **Base de recommandations médicales**. 10 faits associant chaque maladie à une liste de 4-5 conseils pratiques (repos, hydratation, consultation, traitements). Format sans accents. **Attention** : informations à titre indicatif uniquement, ne remplacent pas un avis médical. |

**Tableau 10** : Prédicat de recommandations médicales.

### Base de Faits Dynamique

| Directive | Description |
|:----------|:------------|
| `:- dynamic connu/2.` | Déclare le prédicat `connu/2` comme **dynamique**, permettant l'ajout (`assert`) et la suppression (`retract`) de faits en cours d'exécution. Utilisé pour le cache des réponses sous la forme `connu(symptome, oui/non)`. |

**Tableau 11** : Directive de base dynamique.

Cette architecture modulaire permet une maintenance facilitée : les règles médicales sont isolées dans `base_connaissances.pl`, tandis que la logique de contrôle et l'interface utilisateur sont dans `main.pl`, respectant ainsi le principe de séparation des préoccupations.

\newpage

# II. Les Cas de Test avec Résultats Obtenus

Cette section présente trois scénarios de test démontrant le fonctionnement du système expert dans des situations cliniques variées. Chaque scénario illustre le processus complet de diagnostic, du questionnement initial au résultat final avec recommandations.

## Scénario 1 : Migraine (Cas Optimal)

### Description du Profil Patient

Patient présentant des céphalées intenses accompagnées d'une sensibilité marquée à la lumière (photophobie), sans autres symptômes associés.

### Déroulement de la Session

```
=======================================================
    SYSTEME EXPERT DE DIAGNOSTIC MEDICAL
=======================================================

Ce systeme vous posera quelques questions pour etablir
un diagnostic parmi 10 maladies courantes.

-------------------------------------------------------

Question: Avez-vous perdu l'odorat ou le gout?
1. Oui
2. Non
Votre reponse: 2

Question: Avez-vous un mal de tete intense?
1. Oui
2. Non
Votre reponse: 1

Question: Etes-vous sensible a la lumiere (photophobie)?
1. Oui
2. Non
Votre reponse: 1

=======================================================
=== DIAGNOSTIC ===
=======================================================

Diagnostic: Migraine, car vous presentez un mal de tete intense
et une photophobie.

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

### Raisonnement Suivi

**1. Hypothèses testées et éliminées :**

- **`covid19`** : Vérifie `perte_odorat` → **Non** → Hypothèse rejetée immédiatement ✗
- **`migraine`** : Testée en deuxième position (ordre optimisé)

**2. Vérification de l'hypothèse Migraine (R18) :**

- **Condition requise** : `syndrome_neurologique`
  - **R9** : `mal_tete_intense ∧ photophobie`
    - `verifier_symptome(mal_tete_intense)` → Question posée → **Oui** ✓
    - `verifier_symptome(photophobie)` → Question posée → **Oui** ✓
  - **syndrome_neurologique = VRAI** ✓

**3. Conclusion :**

- Toutes les conditions de R18 sont satisfaites → **DIAGNOSTIC : Migraine**

**4. Statistiques :**

- **Nombre de questions posées** : **3** (optimal)
- **Règles activées** : R9 (syndrome), R18 (diagnostic)
- **Efficacité** : **Optimale** – Le discriminant unique (syndrome neurologique) permet un diagnostic en 3 questions seulement

**Analyse** : Ce scénario démontre l'efficacité du backward chaining avec ordre optimisé. En testant d'abord les maladies à discriminants uniques (covid19, puis migraine), le système atteint rapidement le diagnostic correct sans explorer inutilement d'autres branches de l'arbre.

---

## Scénario 2 : COVID-19 (Cas Moyen)

### Description du Profil Patient

Patient présentant des symptômes grippaux typiques (fièvre élevée, toux, fatigue intense, courbatures) avec la particularité d'une perte d'odorat et de goût, symptôme caractéristique du COVID-19.

### Déroulement de la Session

```
=======================================================
    SYSTEME EXPERT DE DIAGNOSTIC MEDICAL
=======================================================

Ce systeme vous posera quelques questions pour etablir
un diagnostic parmi 10 maladies courantes.

-------------------------------------------------------

Question: Avez-vous perdu l'odorat ou le gout?
1. Oui
2. Non
Votre reponse: 1

Question: Avez-vous de la fievre?
1. Oui
2. Non
Votre reponse: 1

Question: Est-elle elevee (temperature >38.5°C)?
1. Oui
2. Non
Votre reponse: 1

Question: Avez-vous de la toux?
1. Oui
2. Non
Votre reponse: 1

Question: Est-elle productive (avec crachats/expectorations)?
1. Oui
2. Non
Votre reponse: 2

Question: Ressentez-vous une fatigue intense?
1. Oui
2. Non
Votre reponse: 1

Question: Avez-vous des courbatures (douleurs musculaires)?
1. Oui
2. Non
Votre reponse: 1

=======================================================
=== DIAGNOSTIC ===
=======================================================

Diagnostic: COVID-19, car vous presentez une perte d'odorat, une fievre
elevee, de la toux, une fatigue intense et des courbatures.

-------------------------------------------------------
RECOMMANDATIONS:
-------------------------------------------------------
  - Isolement immediat pendant 5-10 jours
  - Repos et hydratation
  - Surveillance oxymetrie (consulter si <95%)
  - Consulter medecin pour evaluation et traitement
  - Informer contacts proches

-------------------------------------------------------
Session terminee.
```

### Raisonnement Suivi

**1. Hypothèse testée : `covid19` (première dans l'ordre optimisé)**

**2. Vérification de la règle R12 :**

**Condition 1** : `perte_odorat`
- `verifier_symptome(perte_odorat)` → Question posée → **Oui** ✓
- **Discriminant unique confirmé → Poursuite de la vérification**

**Condition 2** : `syndrome_respiratoire`
- Teste clause **R2** : `fievre_elevee ∧ toux`
  - `verifier_symptome(fievre_elevee)` → **Cascade fièvre déclenchée**
    - Question principale : "Avez-vous de la fièvre?" → **Oui**
    - Sous-question : "Est-elle élevée?" → **Oui**
    - Enregistrement : `fievre=oui`, `fievre_elevee=oui`, `fievre_legere=non`
  - `verifier_symptome(toux)` → **Cascade toux déclenchée**
    - Question principale : "Avez-vous de la toux?" → **Oui**
    - Sous-question : "Est-elle productive?" → **Non**
    - Enregistrement : `toux=oui`, `toux_productive=non`
- **syndrome_respiratoire = VRAI** ✓

**Condition 3** : `syndrome_grippal`
- **R5** : `fatigue_intense ∧ courbatures ∧ fievre_elevee`
  - `verifier_symptome(fatigue_intense)` → Question posée → **Oui** ✓
  - `verifier_symptome(courbatures)` → Question posée → **Oui** ✓
  - `fievre_elevee` → **Déjà en cache** (oui) → Pas de re-question
- **syndrome_grippal = VRAI** ✓

**Condition 4** : `syndrome_febrile`
- **R4** : `fievre_elevee`
  - `fievre_elevee` → **Déjà en cache** (oui)
- **syndrome_febrile = VRAI** ✓

**3. Conclusion :**

- Toutes les conditions de R12 satisfaites → **DIAGNOSTIC : COVID-19**

**4. Statistiques :**

- **Nombre de questions posées** : **7** (5 principales + 2 sous-questions de cascades)
- **Règles activées** : R2 (syndrome respiratoire), R4 (syndrome fébrile), R5 (syndrome grippal), R12 (diagnostic COVID-19)
- **Syndromes déduits** : 3 (respiratoire, fébrile, grippal)
- **Efficacité** : **Moyenne** – Complexité due aux 3 syndromes requis

**Analyse** : Ce scénario illustre plusieurs aspects importants du système :
- **Gestion des cascades** : Les questions fièvre et toux déclenchent automatiquement leurs sous-questions
- **Réutilisation du cache** : `fievre_elevee` n'est demandée qu'une fois mais réutilisée 3 fois (R2, R5, R4)
- **Ordre optimisé** : Le discriminant unique `perte_odorat` placé en premier dans R12 permet de confirmer rapidement COVID-19

---

## Scénario 3 : Angine (Cas Typique)

### Description du Profil Patient

Patient souffrant d'un mal de gorge intense accompagné de fièvre élevée, symptomatologie classique d'une angine.

### Déroulement de la Session

```
=======================================================
    SYSTEME EXPERT DE DIAGNOSTIC MEDICAL
=======================================================

Ce systeme vous posera quelques questions pour etablir
un diagnostic parmi 10 maladies courantes.

-------------------------------------------------------

Question: Avez-vous perdu l'odorat ou le gout?
1. Oui
2. Non
Votre reponse: 2

Question: Avez-vous un mal de tete intense?
1. Oui
2. Non
Votre reponse: 2

Question: Avez-vous les yeux rouges?
1. Oui
2. Non
Votre reponse: 2

Question: Avez-vous de la fievre?
1. Oui
2. Non
Votre reponse: 1

Question: Est-elle elevee (temperature >38.5°C)?
1. Oui
2. Non
Votre reponse: 1

Question: Avez-vous de la toux?
1. Oui
2. Non
Votre reponse: 2

Question: Avez-vous le nez bouche?
1. Oui
2. Non
Votre reponse: 2

Question: Avez-vous de la diarrhee?
1. Oui
2. Non
Votre reponse: 2

Question: Avez-vous un mal de gorge intense?
1. Oui
2. Non
Votre reponse: 1

=======================================================
=== DIAGNOSTIC ===
=======================================================

Diagnostic: Angine, car vous presentez une fievre elevee
et un mal de gorge intense.

-------------------------------------------------------
RECOMMANDATIONS:
-------------------------------------------------------
  - Consulter medecin pour test streptocoque
  - Antibiotiques si angine bacterienne
  - Antalgiques pour douleur gorge
  - Repos et alimentation molle

-------------------------------------------------------
Session terminee.
```

### Raisonnement Suivi

**1. Hypothèses testées et éliminées séquentiellement :**

- **`covid19`** : `perte_odorat` → **Non** → Rejetée ✗
- **`migraine`** : `mal_tete_intense` → **Non** → Rejetée ✗
- **`conjonctivite`** : `yeux_rouges` → **Non** → Rejetée ✗
- **`asthme`** : Teste `syndrome_respiratoire` → R1 échoue (fievre_legere=non), R2 échoue (toux=non), R3 échoue (nez_bouche=non) → Rejetée ✗
- **`gastro_enterite`** : `diarrhee` → **Non** → Rejetée ✗
- **`grippe`** : Nécessite `syndrome_grippal` (fatigue_intense non testée) → Rejetée ✗
- **`angine`** : Testée en 7ème position

**2. Vérification de l'hypothèse Angine (R15) :**

**Condition 1** : `syndrome_orl`
- **R10** : `mal_gorge_intense`
  - `verifier_symptome(mal_gorge_intense)` → Question posée → **Oui** ✓
- **syndrome_orl = VRAI** ✓

**Condition 2** : `syndrome_febrile`
- **R4** : `fievre_elevee`
  - `fievre_elevee` → **Déjà en cache** (oui, vérifié lors du test asthme)
- **syndrome_febrile = VRAI** ✓

**3. Conclusion :**

- Toutes les conditions de R15 satisfaites → **DIAGNOSTIC : Angine**

**4. Statistiques :**

- **Nombre de questions posées** : **9** (8 principales + 1 sous-question cascade fièvre)
- **Dont questions d'élimination** : 6 (perte odorat, mal tête, yeux rouges, toux, nez bouché, diarrhée)
- **Règles activées** : R10 (syndrome ORL), R4 (syndrome fébrile), R15 (diagnostic Angine)
- **Syndromes déduits** : 2 (ORL, fébrile)
- **Efficacité** : **Typique** – Position intermédiaire dans l'ordre de test

**Analyse** : Ce scénario met en évidence :
- **Stratégie de backward chaining** : Le système teste d'abord les maladies à discriminants uniques (covid19, migraine, etc.) avant d'arriver à Angine
- **Questions d'élimination** : Les 6 premières questions éliminent rapidement les pathologies peu probables (covid19, migraine, conjonctivite, asthme, gastro-entérite, grippe)
- **Réutilisation du cache** : `fievre_elevee` est vérifiée lors du test asthme puis réutilisée pour `syndrome_febrile`, évitant une re-question
- **Interconnexion via `syndrome_febrile`** : Ce syndrome est partagé par 4 maladies (Grippe, COVID-19, Angine, Gastro-entérite), illustrant l'interconnexion de l'arbre de décision

---

## Synthèse Comparative des Trois Scénarios

| Critère | Migraine | COVID-19 | Angine |
|:--------|:--------:|:--------:|:------:|
| **Nombre de questions** | 3 | 7 | 9 |
| **Dont cascades** | 0 | 2 | 1 |
| **Syndromes déduits** | 1 | 3 | 2 |
| **Règles activées** | 2 | 4 | 3 |
| **Position test** | 2ème | 1ère | 7ème |
| **Efficacité** | Optimale | Moyenne | Typique |
| **Type de pathologie** | Neurologique | Respiratoire complexe | ORL + Fébrile |

**Tableau 12** : Comparaison des trois scénarios de test.

**Observations générales :**

1. **Variabilité du nombre de questions** : Entre 3 (optimal) et 9 (cas d'éliminations multiples), démontrant l'adaptabilité du backward chaining

2. **Impact de l'ordre optimisé** : Les maladies testées en premier (covid19, migraine) nécessitent moins de questions que celles testées plus tard (angine)

3. **Efficacité du cache** : Aucune question n'est jamais posée deux fois, même dans les scénarios complexes

4. **Gestion des cascades** : Les sous-questions (fièvre élevée, toux productive) permettent d'affiner le diagnostic sans alourdir l'arborescence

5. **Validation complète** : Les trois scénarios couvrent différentes branches de l'arbre de décision, démontrant la robustesse du système sur des profils cliniques variés

\newpage

# Conclusion

Ce projet a permis de concevoir et d'implémenter avec succès un système expert de diagnostic médical fonctionnel, reposant sur une architecture hiérarchique à trois niveaux et utilisant le chaînage arrière comme stratégie d'inférence. Le système développé répond pleinement aux objectifs pédagogiques fixés, en démontrant les principes fondamentaux des systèmes experts : modélisation des connaissances sous forme de règles logiques, mécanisme de raisonnement automatique et interface d'interaction avec l'utilisateur.

## Synthèse des Réalisations

La base de connaissances comprend **20 règles d'inférence** structurées, permettant de diagnostiquer **10 maladies courantes** à partir de **23 symptômes** regroupés en **8 syndromes intermédiaires**. L'architecture garantit une forte interconnexion des règles, avec 62,5 % des syndromes partagés par plusieurs maladies, évitant ainsi la fragmentation en sous-arbres isolés.

Le moteur d'inférence implémenté utilise efficacement le **backward chaining** avec un ordre de test optimisé, permettant de réduire le nombre moyen de questions de ~10 (approche naïve) à **3-9 questions** selon la complexité du cas. Le mécanisme de **cache des réponses** assure une expérience utilisateur fluide et cohérente en évitant de poser deux fois la même question.

Les tests réalisés sur trois scénarios cliniques variés (Migraine, COVID-19, Angine) ont démontré la robustesse et la fiabilité du système, avec des diagnostics corrects accompagnés de recommandations médicales adaptées.

## Limites Identifiées

Malgré ses qualités techniques, le système présente plusieurs limites importantes qu'il convient de souligner :

### Limites Médicales

1. **Simplification diagnostique excessive** : Les maladies réelles nécessitent des examens cliniques approfondis, des analyses biologiques et l'expertise d'un professionnel de santé. Le système ne prend pas en compte l'anamnèse complète, l'examen physique ni les résultats de laboratoire.

2. **Absence de gestion des comorbidités** : Le système cherche un diagnostic unique, alors que dans la réalité clinique, plusieurs pathologies peuvent coexister (par exemple, allergie + asthme, grippe + bronchite).

3. **Questions binaires limitantes** : Le format Oui/Non ne permet pas de capturer les nuances importantes : intensité des symptômes (échelle 1-10), durée d'évolution (heures, jours, semaines), caractère intermittent ou permanent, facteurs déclenchants, etc.

4. **Recommandations génériques** : Les conseils fournis sont généraux et ne tiennent pas compte du profil individuel du patient (âge, antécédents, traitements en cours, allergies, grossesse, etc.).

5. **Absence de pondération des symptômes** : Tous les symptômes ont le même poids dans le raisonnement, alors qu'en pratique, certains sont plus discriminants ou plus graves que d'autres.

### Limites Techniques

1. **Base de connaissances restreinte** : Seulement 10 maladies couvertes, alors que le diagnostic différentiel d'une fièvre seule peut impliquer des dizaines de pathologies.

2. **Système statique sans apprentissage** : La base de connaissances est figée et ne s'améliore pas avec l'usage, contrairement aux systèmes modernes utilisant le machine learning.

3. **Dépendance à l'ordre des règles** : Bien qu'optimisé, l'ordre de test des hypothèses reste fixe et ne s'adapte pas dynamiquement selon les symptômes déjà observés.

4. **Absence de gestion de l'incertitude** : Le système ne manipule pas de coefficients de confiance ni de probabilités bayésiennes, rendant impossible l'expression de diagnostics différentiels pondérés.

5. **Pas de mécanisme d'explication détaillée** : Bien que le raisonnement soit traçable techniquement, le système n'explique pas à l'utilisateur *pourquoi* certaines questions sont posées ni *comment* le diagnostic a été établi.

### Limites d'Interface et d'Utilisation

1. **Interface textuelle austère** : Absence d'interface graphique moderne (web, mobile), limitant l'accessibilité et l'ergonomie.

2. **Pas de persistance des données** : Le système ne conserve aucun historique des consultations précédentes d'un même patient, empêchant le suivi longitudinal.

3. **Support linguistique unique** : Français uniquement, avec suppression des accents pour des raisons de compatibilité technique.

4. **Pas de validation par des experts médicaux** : Les règles ont été construites sur la base de connaissances générales mais n'ont pas été validées par des professionnels de santé.

## Pistes d'Amélioration

### Améliorations à Court Terme

1. **Ajout de facteurs de confiance** : Implémenter la **logique floue** (*fuzzy logic*) pour associer des degrés de certitude aux symptômes et aux diagnostics. Par exemple, un diagnostic pourrait être retourné avec "Grippe (85 % de confiance)" permettant d'envisager des diagnostics alternatifs.

2. **Élargissement de la base de connaissances** : Porter le nombre de maladies à 20-30, couvrir davantage de spécialités médicales (dermatologie, gastro-entérologie, etc.) et affiner la granularité des syndromes.

3. **Questions graduées** : Remplacer certaines questions binaires par des échelles (0-10) pour l'intensité, des choix multiples pour la localisation, ou des durées précises.

4. **Historique patient** : Implémenter un système de persistance (base de données) pour mémoriser les consultations antérieures, permettant un suivi dans le temps et la détection de pathologies chroniques.

5. **Explication du raisonnement** : Ajouter un module explicatif montrant à l'utilisateur l'arbre de décision parcouru et justifiant chaque étape (par exemple, "Je vous pose cette question car vous avez déclaré avoir de la fièvre, ce qui peut indiquer...").

### Évolutions à Moyen Terme

1. **Chaînage mixte** : Combiner **forward chaining** et **backward chaining** pour permettre des hypothèses multiples simultanées et gérer les diagnostics différentiels.

2. **Apprentissage automatique** : Intégrer des algorithmes de **machine learning** (arbres de décision, réseaux bayésiens, réseaux de neurones) pour ajuster dynamiquement les poids des règles en fonction de données cliniques réelles.

3. **Interface web/mobile moderne** : Développer une application web responsive (React, Vue.js) ou une application mobile native pour améliorer l'accessibilité et l'ergonomie.

4. **Intégration de standards médicaux** : Connecter la base de connaissances à des ontologies médicales standardisées comme **SNOMED-CT** (terminologie clinique internationale) ou **CIM-10** (Classification internationale des maladies).

5. **Gestion avancée des comorbidités** : Permettre au système de retourner plusieurs diagnostics simultanés avec leurs interactions potentielles.

### Évolutions à Long Terme

1. **Validation clinique rigoureuse** :
   - Collaboration avec des professionnels de santé pour valider et enrichir les règles
   - Tests sur des corpus de cas cliniques réels
   - Calcul de métriques de performance : **sensibilité**, **spécificité**, **valeur prédictive positive (VPP)**, **valeur prédictive négative (VPN)**

2. **Intégration avec des systèmes de santé** :
   - Connexion aux dossiers médicaux électroniques (DME)
   - Accès aux résultats de laboratoire et d'imagerie médicale
   - Prescription assistée et alertes d'interactions médicamenteuses

3. **Support multilingue intelligent** :
   - Traduction automatique avec conservation du contexte médical
   - Adaptation culturelle des recommandations

4. **Détection des urgences** :
   - Algorithmes de détection de signaux d'alarme (*red flags*)
   - Recommandations de consultation urgente ou d'appel au SAMU selon la gravité

5. **Personnalisation avancée** :
   - Adaptation des questions selon le profil du patient (âge, sexe, antécédents)
   - Prise en compte des traitements en cours et des allergies connues
   - Calcul de scores de risque personnalisés

## Réflexion Finale

Ce projet a été une excellente introduction aux systèmes experts et à leurs applications dans le domaine médical. Il a permis de comprendre concrètement les défis de la **représentation des connaissances**, de la **modélisation du raisonnement expert** et de la **gestion de l'incertitude**.

Bien que notre système soit volontairement simplifié à des fins pédagogiques, il illustre les principes fondamentaux qui sous-tendent les véritables systèmes d'aide à la décision clinique utilisés dans les hôpitaux modernes. Ces systèmes, nettement plus sophistiqués, intègrent des dizaines de milliers de règles, des bases de données médicales massives et des algorithmes d'apprentissage profond, mais reposent sur les mêmes fondations logiques que notre implémentation.

L'intelligence artificielle médicale est un domaine en pleine expansion, avec des perspectives prometteuses pour améliorer l'accès aux soins, réduire les erreurs diagnostiques et assister les professionnels de santé. Toutefois, il est crucial de maintenir l'humain au centre du processus décisionnel : ces outils doivent être conçus comme des **assistants** augmentant les capacités du médecin, jamais comme des **substituts** à son expertise et à son jugement clinique.

---

**Avertissement important** : Ce système expert a été développé dans un cadre strictement pédagogique. Il ne doit en aucun cas être utilisé pour établir un diagnostic médical réel ou prendre des décisions thérapeutiques. En cas de symptômes, il est impératif de consulter un professionnel de santé qualifié.
