# FAQ - Backward Chaining et Questions Posees

## Question: Pourquoi je ne vois pas toutes les questions?

**C'est NORMAL!** Le backward chaining ne pose que les questions necessaires.

### Exemple concret

**Scenario**: Vous repondez "Non" a "perte_odorat"

```
Question: Avez-vous perdu l'odorat ou le gout?
Votre reponse: 2

Question: Avez-vous un mal de tete intense?
...
```

**Pourquoi pas de question "fievre"?**

Le systeme teste les maladies dans cet ordre:

1. **COVID-19** (perte_odorat=oui requis)
   - Vous avez dit NON → COVID elimine
   - **Passe a la maladie suivante**

2. **Migraine** (mal_tete_intense + photophobie requis)
   - Pose ces 2 questions
   - Si OUI aux 2 → **DIAGNOSTIC: Migraine**
   - Si NON → Passe a la maladie suivante

3. **Conjonctivite** (yeux_rouges + secretions_purulentes requis)
   - Pose ces questions
   - ...

4. **Asthme** (wheezing + difficultes_respiratoires requis)
   - ...

5. Plus tard: **Grippe**, **Angine** (qui demandent la fievre)

**La question "fievre" n'est posee QUE si une maladie qui en a besoin est testee!**

---

## Ordre de test des maladies

Voir [main.pl:254](main.pl#L254) - Liste optimisee:

```prolog
diagnostiquer(Maladie) :-
    member(Maladie, [
        covid19,           % perte_odorat unique
        migraine,          % neurologique unique
        conjonctivite,     % secretions_purulentes unique
        asthme,            % wheezing unique
        gastro_enterite,   % digestif unique
        grippe,            % 3 syndromes complexes
        angine,            % ORL + febrile
        bronchite,         % toux_productive
        allergie,          % allergique + oculaire
        rhume              % Par elimination
    ]),
    call(Maladie).
```

---

## Exemples de parcours

### Exemple 1: Diagnostic Migraine (3 questions)

**Reponses**: NON, OUI, OUI

```
Q1: Perte odorat? → NON (elimine COVID-19)
Q2: Mal tete intense? → OUI
Q3: Photophobie? → OUI
→ DIAGNOSTIC: Migraine ✓
```

**Questions NON posees**: fievre, toux, yeux_rouges, etc.

**Pourquoi?** Migraine trouvee avant d'arriver aux maladies qui demandent ces symptomes!

---

### Exemple 2: Diagnostic Grippe (7 questions)

**Reponses**: NON, NON, NON, NON, NON, OUI, OUI, OUI, OUI, OUI, NON

```
Q1: Perte odorat? → NON (elimine COVID-19)
Q2: Mal tete intense? → NON (elimine Migraine)
Q3: Secretions purulentes? → NON (elimine Conjonctivite)
Q4: Wheezing? → NON (elimine Asthme)
Q5: Diarrhee? → NON (elimine Gastro-enterite)

→ Maintenant teste Grippe:
Q6: Fievre? → OUI
Q7: Fievre elevee? → OUI (cascade)
Q8: Toux? → OUI
Q9: Toux productive? → NON (cascade)
Q10: Fatigue intense? → OUI
Q11: Courbatures? → OUI
Q12: Perte odorat? → NON (deja pose en Q1, utilise cache!)

→ DIAGNOSTIC: Grippe ✓
```

**Questions posees**: 11 (au lieu de 21 si forward chaining!)

---

### Exemple 3: Diagnostic Rhume (~10 questions)

**Le Rhume est le DERNIER teste** (diagnostic par elimination)

```
Q1: Perte odorat? → NON (elimine COVID-19)
Q2-Q5: ... (elimine Migraine, Conjonctivite, Asthme, Gastro)
Q6-Q11: ... (elimine Grippe, Angine, Bronchite, Allergie)

→ Teste Rhume:
Q12: Nez bouche? → OUI
Q13: Gorge irritee? → OUI
→ Syndrome respiratoire ✓

Verifie negations:
- Pas de fievre elevee? (cache: deja pose → NON) ✓
- Pas syndrome grippal? (cache: fatigue_intense=NON) ✓

→ DIAGNOSTIC: Rhume ✓
```

---

## Avantages du Backward Chaining

| Aspect | Forward Chaining | Backward Chaining |
|--------|------------------|-------------------|
| Questions posees | **TOUTES** (21 questions) | **Necessaires uniquement** (3-10 questions) |
| Ordre | Fixe, predetermine | Dynamique, optimise |
| Efficacite | Faible | **Elevee** ✓ |
| Experience utilisateur | Longue, repetitive | **Rapide, ciblee** ✓ |

---

## Questions frequentes

### Q: Pourquoi "fievre" n'apparait pas toujours en premier?

**R**: Parce que le systeme teste d'abord les maladies avec discriminants UNIQUES:
- COVID-19 (perte_odorat)
- Migraine (mal_tete_intense + photophobie)
- Conjonctivite (secretions_purulentes)

La fievre est un symptome COMMUN a plusieurs maladies (Grippe, Angine, Gastro). Elle n'est posee que si ces maladies sont testees.

### Q: Comment savoir quelles questions seront posees?

**R**: Impossible a predire! Cela depend de vos reponses. C'est la magie du backward chaining - adaptatif et intelligent.

### Q: Et si je veux voir toutes les 21 questions?

**R**: Il faudrait implementer un forward chaining, mais ce n'est PAS l'objectif du TP. Le backward chaining est plus efficace et intelligent.

---

## Verification du cache

Pour verifier que le cache fonctionne:

```prolog
?- consult('main.pl').
?- reinitialiser.
?- assert(connu(perte_odorat, non)).
?- assert(connu(fievre, oui)).
?- assert(connu(fievre_elevee, oui)).

% Verifier le cache
?- connu(perte_odorat, X).
X = non.

?- connu(fievre_elevee, X).
X = oui.
```

**Le cache evite de poser 2 fois la meme question!**

---

## Conclusion

**C'est NORMAL de ne pas voir toutes les questions.**

Le backward chaining est:
- ✅ Intelligent
- ✅ Efficace
- ✅ Adaptatif
- ✅ Optimise pour l'utilisateur

**Nombre de questions moyen**: 4-7 (au lieu de 21!)

---

**Pour plus d'info**: Voir [docs/RESUME_PLAN.md](docs/RESUME_PLAN.md) section "Backward Chaining"
