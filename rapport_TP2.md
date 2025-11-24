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
  - [Scénario 1 : Migraine](#scénario-1--migraine)
  - [Scénario 2 : COVID-19](#scénario-2--covid-19)
  - [Scénario 3 : Angine](#scénario-3--angine)
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

Le système repose sur une implémentation en Prolog, langage particulièrement adapté à la programmation logique et au raisonnement automatique. L'architecture adoptée utilise le chaînage arrière pour minimiser le nombre de questions posées tout en garantissant un diagnostic précis.

La base de connaissances développée comprend 20 règles d'inférence structurées en trois niveaux hiérarchiques : les symptômes observés déclenchent des syndromes intermédiaires, qui à leur tour permettent d'identifier la maladie finale.

# I. Méthodologie Adoptée

## 1.1 Architecture Globale du Système Expert

Le système expert développé repose sur une **architecture hiérarchique à trois niveaux**, inspirée des modèles classiques de systèmes experts médicaux (Figure 1). Cette structure permet de décomposer le raisonnement diagnostique en étapes logiques successives, facilitant la maintenance, l'évolution et la validation de la base de connaissances.

```
┌─────────────────────────────────────────────────────────────┐
│                    NIVEAU 1: SYMPTÔMES                      │
│                        19 symptômes                         │
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
| **Symptômes** | 19 | Observations cliniques élémentaires (fièvre, toux, mal de tête, fièvre élevée, fièvre légère, toux productive, nez qui coule, etc.) |
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
| Grippe | Respiratoire + Grippal + Fébrile | Fatigue intense, courbatures, sans perte odorat | 4 |
| COVID-19 | Respiratoire + Grippal + Fébrile | **Perte odorat/goût** (discriminant unique) | 4 |
| Bronchite | Respiratoire | Toux productive + Fièvre légère | 3 |
| Rhume | Respiratoire seul | Nez bouché, gorge irritée, sans fièvre élevée ni fatigue | 3 |
| Angine | ORL + Fébrile | Mal gorge intense + Fièvre élevée | 3 |
| Allergie saisonnière | Allergique + Oculaire | Éternuements, yeux rouges, sans difficultés respiratoires | 4 |
| Asthme | Respiratoire + Allergique | **Wheezing** + Difficultés respiratoires | 5 |
| Migraine | Neurologique seul | Mal tête intense + Photophobie | 2 |
| Gastro-entérite | Digestif + Fébrile | Diarrhée + Vomissements + Fièvre | 3 |
| Conjonctivite | Oculaire | Yeux rouges + Sécrétions purulentes | 3 |

**Tableau 2** : Caractéristiques diagnostiques des 10 maladies.

Les symptômes en gras (perte odorat, wheezing) représentent des discriminants uniques permettant de différencier rapidement certaines maladies.

### Les 8 Syndromes Intermédiaires

Les syndromes intermédiaires constituent le niveau central de raisonnement, agrégeant plusieurs symptômes en entités cliniques cohérentes. Le tableau 3 détaille ces syndromes avec leurs conditions de déclenchement.

| Syndrome | Symptômes déclencheurs | Règle(s) | Nb maladies |
|:---------|:-----------------------|:---------|:-----------:|
| syndrome_respiratoire | (Fièvre légère ∧ Toux) OU (Fièvre élevée ∧ Toux) OU (Nez bouché ∧ Gorge irritée) | R1, R2, R3 | **5** |
| syndrome_fébrile | Fièvre élevée | R4 | **4** |
| syndrome_grippal | Fatigue intense ∧ Courbatures ∧ Fièvre élevée | R5 | **2** |
| syndrome_allergique | Éternuements | R6 | **2** |
| syndrome_oculaire | Yeux rouges ∧ Yeux qui piquent | R7 | **2** |
| syndrome_digestif | Diarrhée ∧ Vomissements | R8 | 1 |
| syndrome_neurologique | Mal tête intense ∧ Photophobie | R9 | 1 |
| syndrome_orl | Mal gorge intense | R10 | 1 |

**Tableau 3** : Syndromes intermédiaires avec leurs conditions de déclenchement.

### La sous classe RFG

Afin de rendre la lecture du graphe de dépendance plus facile, nous avons créer une sous-classe de maladie nommée RFG. Quelqu'un a une maladie RFG quand il a les syndromes suivants: Respiratoire, Fébrile et Grippal.

### Les 21 Règles d'Inférence

La base de connaissances est constituée de **21 règles d'inférence** réparties en deux niveaux de déduction.

#### Niveau 1 → Niveau 2 : Symptômes → Syndromes (10 règles)

Le tableau 4 présente les 10 premières règles permettant de déduire les syndromes à partir des symptômes observés.

| # | Règle logique | Syndrome déduit |
|:-:|:--------------|:----------------|
| R1 | fièvre_légère ∧ toux → syndrome_respiratoire | Respiratoire |
| R2 | fièvre_élevée ∧ toux → syndrome_respiratoire | Respiratoire |
| R3 | nez_bouché ∧ gorge_irritée → syndrome_respiratoire | Respiratoire |
| R4 | fièvre_élevée → syndrome_fébrile | Fébrile |
| R5 | fatigue_intense ∧ courbatures ∧ fièvre_élevée → syndrome_grippal | Grippal |
| R6 | éternuements → syndrome_allergique | Allergique |
| R7 | yeux_rouges ∧ yeux_qui_piquent → syndrome_oculaire | Oculaire |
| R8 | diarrhée ∧ vomissements → syndrome_digestif | Digestif |
| R9 | mal_tête_intense ∧ photophobie → syndrome_neurologique | Neurologique |
| R10 | mal_gorge_intense → syndrome_orl | ORL |

**Tableau 4** : Règles d'inférence de Niveau 1 → Niveau 2.

#### Maladie RFG

Le tableau 5 présente la règle permettant de déduire si le patient a une maladie RFG

| # | Règle logique | Maladie diagnostiquée |
|:-:|:--------------|:----------------------|
| R11 | syndrome_respiratoire ∧ syndrome_grippal ∧ syndrome_fébrile| Maladie RFG |

**Tableau 5** : Règles d'inférence pour la sous-classe Maladie RFG.

#### Niveau 2 → Niveau 3 : Syndromes → Maladies (10 règles)

Le tableau 6 présente les 10 règles permettant de déduire les maladies finales à partir des syndromes identifiés.

| # | Règle logique | Maladie diagnostiquée |
|:-:|:--------------|:----------------------|
| R12 | Maladie RFG ∧ ¬perte_odorat → grippe | Grippe |
| R13 | Maladie RFG ∧ perte_odorat → covid19 | COVID-19 |
| R14 | syndrome_respiratoire ∧ fièvre_légère ∧ toux_productive → bronchite | Bronchite |
| R15 | syndrome_respiratoire ∧ ¬syndrome_fébrile ∧ ¬syndrome_grippal → rhume | Rhume |
| R16 | syndrome_orl ∧ syndrome_fébrile → angine | Angine |
| R17 | syndrome_allergique ∧ syndrome_oculaire ∧ ¬difficultés_respiratoires → allergie | Allergie saisonnière |
| R18 | syndrome_respiratoire ∧ syndrome_allergique ∧ wheezing ∧ difficultés_respiratoires → asthme | Asthme |
| R19 | syndrome_neurologique → migraine | Migraine |
| R20 | syndrome_digestif ∧ syndrome_fébrile → gastro_entérite | Gastro-entérite |
| R21 | syndrome_oculaire ∧ sécrétions_purulentes → conjonctivite | Conjonctivite |

**Tableau 6** : Règles d'inférence de Niveau 2 → Niveau 3.

### Justification de l'Interconnexion des Règles

Notre architecture garantit une forte interconnexion : 5 syndromes sur 8 (62,5 %) sont partagés par au moins 2 maladies, et 8 maladies sur 10 (80 %) utilisent au moins un syndrome partagé.

## 1.3 Graphe de Dépendance de la Structure du Raisonnement

Comme mentionné plus haut, nous avons créer une nouvelle règle afin de rendre le graphe plus facile à lire, la règle R11.

De plus, la négation est présente dans certaines des règles, ce que nous n'avons pas vu dans les diapositives du cours. Suivant le conseil que notre professeur nous a donné, nous avons utilisé ChatGPT afin de savoir comment inclure la négation dans le graphe.

Finalement, le logiciel que nous avons utilisé pour faire le graphe était un peu limité dans ces options. Nous avons donc fini par faire que les condition "Et" (∧) soient ce qui est entre deux points, incluant les lignes où les points sont sur. Par exemple, la règle R7 indique qu'avoir les yeux rouges et les yeux qui piquent montre que le patient a un syndrome occulaire.

<img width="2178" height="1122" alt="Graphe de dépendances" src="https://github.com/user-attachments/assets/677621d6-c875-4b05-aa7f-d9a5a4edb9da" />


## 1.4 Description du Moteur d'Inférence et du Mécanisme de Raisonnement

Le système utilise le **chaînage arrière** (backward chaining), une stratégie d'inférence orientée-but qui part d'une hypothèse de diagnostic et tente de la valider en vérifiant récursivement si les conditions nécessaires sont satisfaites. Cette approche se distingue du chaînage avant (forward chaining) qui partirait des symptômes pour déduire progressivement les conclusions possibles. Le backward chaining est particulièrement adapté à notre contexte diagnostique car il minimise le nombre de questions posées à l'utilisateur en ne vérifiant que les symptômes strictement nécessaires à la validation de l'hypothèse courante.

### Principe du Raisonnement Orienté-But

Le moteur d'inférence implémente un processus de validation séquentielle des hypothèses. Pour chaque maladie testée, le système vérifie si les syndromes requis (niveau 2) sont présents. Si un syndrome n'est pas encore connu, le système tente de le déduire en vérifiant récursivement les symptômes qui le composent (niveau 1). Lorsqu'un symptôme nécessaire n'a pas encore été vérifié, le système pose une question à l'utilisateur et enregistre la réponse en mémoire. Ce processus récursif crée une arborescence de vérifications qui s'arrête dès que toutes les conditions d'une maladie sont satisfaites, retournant ainsi le diagnostic avec ses recommandations médicales. Si une hypothèse échoue, le système passe immédiatement à l'hypothèse suivante dans l'ordre prédéfini.

### Stratégie d'Optimisation par Ordre de Test

L'efficacité du backward chaining repose en grande partie sur l'ordre dans lequel les hypothèses sont testées. Le système privilégie d'abord les maladies possédant des symptômes discriminants uniques (identifiés en gras dans le Tableau 2), permettant une élimination ou validation rapide en 2-4 questions. Suivent ensuite les maladies à syndromes spécifiques nécessitant des combinaisons particulières de symptômes, puis les cas complexes impliquant plusieurs syndromes interconnectés, et enfin les diagnostics d'élimination testés en dernier. Cette stratégie réduit le nombre moyen de questions de environ 10-15 (approche naïve testant les maladies aléatoirement) à 3-9 questions selon la complexité du cas clinique.

### Mécanisme de Cache des Réponses

Un aspect crucial du système est la gestion de la mémoire pour éviter de poser plusieurs fois la même question. Étant donné que notre architecture utilise des syndromes partagés entre plusieurs maladies (par exemple, le syndrome_febrile intervient dans 4 maladies différentes, et fievre_elevee est nécessaire à 3 syndromes), le risque de redemander un symptôme déjà vérifié est élevé sans mécanisme de cache. Le système utilise donc une base de faits dynamique (le prédicat connu/2) qui stocke toutes les réponses obtenues sous la forme connu(symptome, oui) ou connu(symptome, non). Avant de poser une question, le prédicat verifier_symptome/1 consulte d'abord ce cache : si le symptôme est déjà connu comme vrai, la vérification réussit immédiatement ; si déjà connu comme faux, elle échoue sans interaction ; sinon, la question est posée et la réponse est enregistrée en mémoire. Ce mécanisme garantit que chaque symptôme n'est demandé qu'une seule fois maximum, quelle que soit la complexité de l'arbre de décision et le nombre de règles qui le référencent. Par exemple, lors du diagnostic d'une Grippe, le symptôme fievre_elevee est vérifié pour le syndrome_respiratoire (R2), puis réutilisé directement du cache pour syndrome_grippal (R5) et syndrome_febrile (R4), évitant ainsi deux questions redondantes.

## 1.5 Détails des Prédicats Utilisés dans le Code

Cette section présente une description exhaustive des 27 prédicats principaux implémentés dans les modules `main.pl` et `base_connaissances.pl`.

### Prédicats du Moteur Principal (main.pl)

| Prédicat | Description |
|:---------|:------------|
| `start/0` | **Point d'entrée principal** du système. Affiche la bannière d'accueil, réinitialise le cache, lance le processus de diagnostic et affiche le résultat final. |
| `diagnostiquer/1` | **Moteur de backward chaining**. Teste séquentiellement les 10 maladies dans un ordre optimisé. Retourne la première maladie dont toutes les conditions sont satisfaites. |
| `reinitialiser/0` | **Efface le cache** des réponses (`connu/2`) pour permettre une nouvelle session de diagnostic indépendante. |

**Tableau 7a** : Prédicats principaux du système (1/3).

| Prédicat | Description |
|:---------|:------------|
| `verifier_symptome/1` | **Vérification de symptôme avec cache**. Trois clauses : (1) retourne succès si symptôme déjà connu=oui, (2) échoue si déjà connu=non, (3) pose question si inconnu. Évite de redemander la même question. |
| `poser_question_et_enregistrer/1` | **Dispatch de questions**. Détecte si le symptôme fait partie d'une cascade (fièvre, toux) et déclenche la séquence appropriée, sinon pose question simple. |
| `poser_question_simple/2` | **Question Oui/Non standard**. Affiche la question en français, propose les options 1=Oui / 2=Non, lit la réponse et la retourne. |
| `poser_question_fievre/0` | **Gestion cascade fièvre**. Pose la question principale "Avez-vous de la fièvre?", puis si oui, pose "Est-elle élevée?". Enregistre simultanément `fievre`, `fievre_elevee` et `fievre_legere` dans le cache selon les réponses. |
| `poser_question_toux/0` | **Gestion cascade toux**. Pose la question principale "Avez-vous de la toux?", puis si oui, pose "Est-elle productive?". Enregistre simultanément `toux` et `toux_productive` dans le cache. |
| `lire_reponse/1` | **Lecture et validation de l'entrée utilisateur**. Utilise `get_single_char/1` pour une lecture immédiate (sans Enter). Valide que la réponse est '1' ou '2', redemande sinon. Convertit en `oui`/`non`. |

**Tableau 7b** : Prédicats de vérification et d'interrogation (2/3).

| Prédicat | Description |
|:---------|:------------|
| `afficher_diagnostic/1` | **Affichage du diagnostic final**. Formate et affiche le nom de la maladie en français avec bannière, puis appelle `afficher_recommandations/1`. |
| `afficher_recommandations/1` | **Affichage des recommandations médicales**. Récupère la liste de recommandations depuis `recommandation/2` et l'affiche formatée sous forme de liste à puces. |
| `afficher_liste_recommandations/1` | **Affichage itératif de liste**. Prédicat récursif qui affiche chaque recommandation précédée d'un tiret. |
| `collecter_syndromes/1` | **Collecte des syndromes détectés**. Utilise `findall/3` pour identifier tous les syndromes qui sont actuellement vrais (utilisé pour debug/trace, non affiché par défaut). |
| `afficher_aucun_diagnostic/0` | **Message d'échec diagnostique**. Affiché si aucune des 10 maladies ne correspond aux symptômes fournis. Recommande une consultation médicale. |

**Tableau 7c** : Prédicats d'affichage des résultats (3/3).

### Prédicats de Traduction (main.pl)

| Prédicat | Description |
|:---------|:------------|
| `traduire_symptome/2` | **Mapping Prolog → Français pour symptômes**. Base de 19 faits associant chaque atome Prolog (ex: `perte_odorat`) à sa question en français (ex: "perdu l'odorat ou le goût"). Format sans accents pour compatibilité. |
| `traduire_maladie/2` | **Mapping Prolog → Français pour maladies**. Base de 10 faits associant chaque maladie Prolog (ex: `covid19`) à son nom français (ex: "COVID-19"). |
| `traduire_syndrome/2` | **Mapping Prolog → Français pour syndromes**. Base de 8 faits associant chaque syndrome Prolog (ex: `syndrome_respiratoire`) à son nom français (ex: "Syndrome respiratoire"). |

**Tableau 8** : Prédicats de traduction français.

### Prédicats de la Base de Connaissances (base_connaissances.pl)

| Prédicat | Description |
|:---------|:------------|
| `syndrome_respiratoire/0` | **Déduction syndrome respiratoire**. 3 clauses alternatives (R1, R2, R3) : fièvre+toux (légère ou élevée) OU nez_bouché+gorge_irritée. |
| `syndrome_febrile/0` | **Déduction syndrome fébrile**. 1 clause (R4) : fièvre_élevée suffit (règle simplifiée). |
| `syndrome_grippal/0` | **Déduction syndrome grippal**. 1 clause (R5) : fatigue_intense ∧ courbatures ∧ fièvre_élevée. |
| `syndrome_allergique/0` | **Déduction syndrome allergique**. 1 clause (R6) : éternuements suffisent (règle simplifiée). |
| `syndrome_oculaire/0` | **Déduction syndrome oculaire**. 1 clause (R7) : yeux_rouges ∧ yeux_qui_piquent. |
| `syndrome_digestif/0` | **Déduction syndrome digestif**. 1 clause (R8) : diarrhée ∧ vomissements. |
| `syndrome_neurologique/0` | **Déduction syndrome neurologique**. 1 clause (R9) : mal_tête_intense ∧ photophobie. |
| `syndrome_orl/0` | **Déduction syndrome ORL**. 1 clause (R10) : mal_gorge_intense suffit (règle simplifiée). |

**Tableau 9** : Prédicats de déduction des syndromes (Règles R1-R10).

| Prédicat | Description |
|:---------|:------------|
| `grippe/0` | **Règle R12**. Diagnostic Grippe : syndrome_respiratoire ∧ syndrome_grippal ∧ syndrome_fébrile ∧ ¬perte_odorat. |
| `covid19/0` | **Règle R13**. Diagnostic COVID-19 : perte_odorat ∧ syndrome_respiratoire ∧ syndrome_grippal ∧ syndrome_fébrile. Discriminant unique en premier pour optimisation. |
| `bronchite/0` | **Règle R14**. Diagnostic Bronchite : syndrome_respiratoire ∧ fièvre_légère ∧ toux_productive. |
| `rhume/0` | **Règle R15**. Diagnostic Rhume : syndrome_respiratoire ∧ ¬syndrome_fébrile ∧ ¬syndrome_grippal. |
| `angine/0` | **Règle R16**. Diagnostic Angine : syndrome_orl ∧ syndrome_fébrile. |
| `allergie/0` | **Règle R17**. Diagnostic Allergie saisonnière : syndrome_allergique ∧ syndrome_oculaire ∧ ¬difficultés_respiratoires. |
| `asthme/0` | **Règle R18**. Diagnostic Asthme : syndrome_respiratoire ∧ syndrome_allergique ∧ wheezing ∧ difficultés_respiratoires. |
| `migraine/0` | **Règle R19**. Diagnostic Migraine : syndrome_neurologique. |
| `gastro_enterite/0` | **Règle R20**. Diagnostic Gastro-entérite : syndrome_digestif ∧ syndrome_fébrile. |
| `conjonctivite/0` | **Règle R21**. Diagnostic Conjonctivite : syndrome_oculaire ∧ sécrétions_purulentes. |

**Tableau 10** : Prédicats de diagnostic des maladies (Règles R12-R21).

### Prédicat de Recommandations (base_connaissances.pl)

| Prédicat | Description |
|:---------|:------------|
| `recommandation/2` | **Base de recommandations médicales**. 10 faits associant chaque maladie à une liste de 4-5 conseils pratiques (repos, hydratation, consultation, traitements). Format sans accents. **Attention** : informations à titre indicatif uniquement, ne remplacent pas un avis médical. |

**Tableau 11** : Prédicat de recommandations médicales.

### Base de Faits Dynamique

| Directive | Description |
|:----------|:------------|
| `:- dynamic connu/2.` | Déclare le prédicat `connu/2` comme **dynamique**, permettant l'ajout (`assert`) et la suppression (`retract`) de faits en cours d'exécution. Utilisé pour le cache des réponses sous la forme `connu(symptome, oui/non)`. |

**Tableau 12** : Directive de base dynamique.

Cette architecture modulaire permet une maintenance facilitée : les règles médicales sont isolées dans `base_connaissances.pl`, tandis que la logique de contrôle et l'interface utilisateur sont dans `main.pl`, respectant ainsi le principe de séparation des préoccupations.

\newpage

# II. Les Cas de Test avec Résultats Obtenus

Cette section présente trois scénarios de test démontrant le fonctionnement du système expert dans des situations cliniques variées. Chaque scénario illustre le processus complet de diagnostic, du questionnement initial au résultat final avec recommandations.

## Scénario 1 : Migraine

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

Question: Etes-vous sensible a la lumiere?
1. Oui
2. Non
Votre reponse: 1

=======================================================
=== DIAGNOSTIC ===
=======================================================

Migraine

Base sur les symptomes suivants:
  - Mal de tete intense
  - Sensibilite a la lumiere (photophobie)

-------------------------------------------------------
RECOMMANDATIONS:
-------------------------------------------------------
  - Repos dans piece sombre et calme
  - Antalgiques des premiers symptomes

-------------------------------------------------------
```

### Raisonnement Suivi

Le système élimine d'abord l'hypothèse COVID-19 (perte_odorat=non), puis teste la Migraine en deuxième position selon l'ordre optimisé. Le diagnostic repose sur la règle R18 qui requiert le syndrome neurologique. Ce syndrome est établi par R9 dès confirmation de deux symptômes : mal de tête intense et photophobie. Le diagnostic est donc établi en 3 questions seulement (efficacité optimale).

**Règles activées** : R9 (syndrome neurologique) → R18 (diagnostic Migraine)

---

## Scénario 2 : COVID-19

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

Question: Votre fievre est-elle elevee (temperature >38.5°C)?
1. Oui
2. Non
Votre reponse: 1

Question: Avez-vous de la toux?
1. Oui
2. Non
Votre reponse: 1

Question: Votre toux est-elle productive (avec crachats/expectorations)?
1. Oui
2. Non
Votre reponse: 2

Question: Sentez-vous de la fatigue intense?
1. Oui
2. Non
Votre reponse: 1

Question: Avez-vous des courbatures?
1. Oui
2. Non
Votre reponse: 1

=======================================================
=== DIAGNOSTIC ===
=======================================================

COVID-19

Base sur les symptomes suivants:
  - Perte de gout ou odorat
  - Fievre elevee (>38.5°C)
  - Fatigue intense
  - Courbatures

-------------------------------------------------------
RECOMMANDATIONS:
-------------------------------------------------------
  - Isolement immediat pendant 5-10 jours
  - Consulter medecin pour evaluation et traitement

-------------------------------------------------------
```

### Raisonnement Suivi

Le COVID-19 est testé en premier grâce à son discriminant unique (perte d'odorat). Une fois ce symptôme confirmé, le système vérifie la règle R12 qui nécessite trois syndromes additionnels. Le syndrome respiratoire (R2) est établi par les cascades fièvre et toux, générant automatiquement les sous-questions sur leur intensité. Le syndrome grippal (R5) requiert la fatigue intense et les courbatures, en réutilisant la fièvre élevée déjà en cache. Le syndrome fébrile (R4) est confirmé directement par cette même fièvre élevée déjà vérifiée. Le diagnostic est établi en 7 questions (5 principales + 2 cascades).

**Règles activées** : R2 (respiratoire) + R4 (fébrile) + R5 (grippal) → R12 (COVID-19)

---

## Scénario 3 : Angine

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

Question: Vos yeux sont-ils rouges?
1. Oui
2. Non
Votre reponse: 2

Question: Avez-vous de la fievre?
1. Oui
2. Non
Votre reponse: 1

Question: Votre fievre est-elle elevee (temperature >38.5°C)?
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

Angine

Base sur les symptomes suivants:
  - Fievre elevee (>38.5°C)
  - Mal de gorge intense

-------------------------------------------------------
RECOMMANDATIONS:
-------------------------------------------------------
  - Consulter medecin pour test streptocoque
  - Antalgiques pour douleur gorge

-------------------------------------------------------
```

### Raisonnement Suivi

Le système teste d'abord six hypothèses à discriminants uniques (covid19, migraine, conjonctivite, asthme, gastro-entérite, grippe) qui sont rapidement éliminées par des réponses négatives. L'Angine est testée en 7ème position et validée par la règle R15 nécessitant deux syndromes. Le syndrome ORL (R10) est confirmé dès la réponse positive au mal de gorge intense. Le syndrome fébrile (R4) est établi en réutilisant la fièvre élevée déjà vérifiée lors du test de l'asthme, évitant ainsi toute re-question. Le diagnostic est établi en 9 questions (8 principales + 1 cascade fièvre), dont 6 servent à éliminer les hypothèses précédentes.

**Règles activées** : R10 (ORL) + R4 (fébrile) → R15 (Angine)

\newpage

# Conclusion

Ce projet a permis de concevoir et d'implémenter avec succès un système expert de diagnostic médical fonctionnel, reposant sur une architecture hiérarchique à trois niveaux. Le système répond pleinement aux objectifs pédagogiques fixés, en démontrant les principes fondamentaux des systèmes experts : modélisation des connaissances sous forme de règles logiques, mécanisme de raisonnement automatique et interface d'interaction avec l'utilisateur.

## Synthèse des Réalisations

La base de connaissances comprend 20 règles d'inférence structurées, permettant de diagnostiquer 10 maladies courantes à partir de 19 symptômes regroupés en 8 syndromes intermédiaires.

Le moteur d'inférence implémenté utilise un ordre de test optimisé, permettant de réduire le nombre moyen de questions de ~10 (approche naïve) à 3-9 questions selon la complexité du cas. Le mécanisme de cache des réponses assure une expérience utilisateur fluide et cohérente en évitant de poser deux fois la même question.

Les tests réalisés sur trois scénarios cliniques variés (Migraine, COVID-19, Angine) ont démontré la robustesse et la fiabilité du système, avec des diagnostics corrects accompagnés de recommandations médicales adaptées.

## Limites Identifiées

Le système présente plusieurs limites inhérentes à sa nature pédagogique. La base de connaissances restreinte (10 maladies, 20 règles) ne reflète pas la complexité diagnostique réelle où des dizaines de pathologies peuvent partager des symptômes similaires. Le format questions binaires (Oui/Non) ne capture pas les nuances cliniques importantes comme l'intensité, la durée ou l'évolution des symptômes. L'absence de gestion de l'incertitude empêche l'expression de diagnostics différentiels pondérés par des coefficients de confiance. Enfin, les règles n'ont pas été validées par des professionnels de santé et les recommandations fournies demeurent génériques, ne tenant pas compte du profil individuel du patient.

## Pistes d'Amélioration

Plusieurs améliorations significatives pourraient renforcer le système. L'implémentation de la logique floue permettrait d'associer des degrés de certitude aux diagnostics plutôt qu'un résultat binaire. L'ajout de questions graduées (échelles d'intensité, durées précises) capturerait mieux les nuances cliniques. Un module explicatif montrant l'arbre de décision parcouru renforcerait la transparence du raisonnement pour l'utilisateur. L'intégration d'apprentissage automatique (réseaux bayésiens) permettrait d'ajuster dynamiquement les poids des règles selon des données cliniques réelles. Enfin, une validation clinique rigoureuse en collaboration avec des professionnels de santé s'imposerait avant toute utilisation réelle, incluant des tests sur corpus réels et le calcul de métriques de performance (sensibilité, spécificité).

## Réflexion Finale

Ce projet a permis de comprendre concrètement les défis de la représentation des connaissances et de la modélisation du raisonnement expert. Bien que volontairement simplifié à des fins pédagogiques, notre système illustre les principes fondamentaux qui sous-tendent les véritables systèmes d'aide à la décision clinique utilisés dans les hôpitaux modernes. L'intelligence artificielle médicale offre des perspectives prometteuses pour améliorer l'accès aux soins et assister les professionnels de santé. Toutefois, il est crucial de maintenir l'humain au centre du processus décisionnel : ces outils doivent être conçus comme des assistants augmentant les capacités du médecin, jamais comme des substituts à son expertise et à son jugement clinique.
