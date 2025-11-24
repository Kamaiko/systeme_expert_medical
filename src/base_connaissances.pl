/** <module> Base de Connaissances

Définition des 20 règles d'inférence du système expert
(architecture 3 niveaux: Symptômes → Syndromes → Maladies).

@author   Équipe 6
@course   TP2 - IFT2003 Intelligence Artificielle 1
@date     Novembre 2025
@brief    - 20 règles (R1-R10: symptômes→syndromes, R11-R20: syndromes→maladies)
          - 8 syndromes intermédiaires, 10 maladies diagnosticables
          - 2 cascades: fièvre (légère/élevée), toux (productive/non)
*/

% -----------------------------------------------------------------------------
% NIVEAU 1 → NIVEAU 2: Symptomes → Syndromes (10 regles)
% -----------------------------------------------------------------------------

% R1: Fievre legere ∧ Toux → Respiratoire
syndrome_respiratoire :-
    verifier_symptome(fievre_legere),
    verifier_symptome(toux).

% R2: Fievre elevee ∧ Toux → Respiratoire
syndrome_respiratoire :-
    verifier_symptome(fievre_elevee),
    verifier_symptome(toux).

% R3: Nez bouche ∧ Gorge irritee → Respiratoire
syndrome_respiratoire :-
    verifier_symptome(nez_bouche),
    verifier_symptome(gorge_irritee).

% R4: Fievre elevee → Febrile (SIMPLIFIE)
syndrome_febrile :-
    verifier_symptome(fievre_elevee).

% R5: Fatigue intense ∧ Courbatures ∧ Fievre elevee → Grippal
syndrome_grippal :-
    verifier_symptome(fatigue_intense),
    verifier_symptome(courbatures),
    verifier_symptome(fievre_elevee).

% R6: Eternuements → Allergique (SIMPLIFIE)
syndrome_allergique :-
    verifier_symptome(eternuement).

% R7: Yeux rouges ∧ Yeux qui piquent → Oculaire
syndrome_oculaire :-
    verifier_symptome(yeux_rouges),
    verifier_symptome(yeux_qui_piquent).

% R8: Diarrhee ∧ Vomissements → Digestif
syndrome_digestif :-
    verifier_symptome(diarrhee),
    verifier_symptome(vomissements).

% R9: Mal tete intense ∧ Photophobie → Neurologique
syndrome_neurologique :-
    verifier_symptome(mal_tete_intense),
    verifier_symptome(photophobie).

% R10: Mal gorge intense → ORL (SIMPLIFIE)
syndrome_orl :-
    verifier_symptome(mal_gorge_intense).

% -----------------------------------------------------------------------------c
% NIVEAU 2 → NIVEAU 3: Syndromes → Maladies (10 regles)
% -----------------------------------------------------------------------------
%

% R11: Grippe = Respiratoire ∧ Grippal ∧ Febrile ∧ ¬Perte odorat
grippe :-
    syndrome_respiratoire,
    syndrome_grippal,
    syndrome_febrile,
    \+ verifier_symptome(perte_odorat).

% R12: COVID-19 = Perte odorat ∧ Respiratoire ∧ Grippal ∧ Febrile
% NOTE: perte_odorat EN PREMIER (discriminant unique) pour optimiser backward chaining
covid19 :-
    verifier_symptome(perte_odorat),
    syndrome_respiratoire,
    syndrome_grippal,
    syndrome_febrile.

% R13: Bronchite = Respiratoire ∧ Fievre legere ∧ Toux productive
bronchite :-
    syndrome_respiratoire,
    verifier_symptome(fievre_legere),
    verifier_symptome(toux_productive).

% R14: Rhume = Respiratoire ∧ ¬Febrile ∧ ¬Grippal
rhume :-
    syndrome_respiratoire,
    \+ syndrome_febrile,
    \+ syndrome_grippal.

% R15: Angine = ORL ∧ Febrile
angine :-
    syndrome_orl,
    syndrome_febrile.

% R16: Allergie saisonniere = Allergique ∧ Oculaire ∧ ¬Difficultes respiratoires
allergie :-
    syndrome_allergique,
    syndrome_oculaire,
    \+ verifier_symptome(difficultes_respiratoires).

% R17: Asthme = Respiratoire ∧ Allergique ∧ Wheezing ∧ Difficultes respiratoires
asthme :-
    syndrome_respiratoire,
    syndrome_allergique,
    verifier_symptome(wheezing),
    verifier_symptome(difficultes_respiratoires).

% R18: Migraine = Neurologique
migraine :-
    syndrome_neurologique.

% R19: Gastro-enterite = Digestif ∧ Febrile
gastro_enterite :-
    syndrome_digestif,
    syndrome_febrile.

% R20: Conjonctivite = Oculaire ∧ Secretions purulentes
conjonctivite :-
    syndrome_oculaire,
    verifier_symptome(secretions_purulentes).

% -----------------------------------------------------------------------------
% SYMPTOMES ASSOCIES (SANS ACCENTS)
% -----------------------------------------------------------------------------

symptomes_associes(grippe, [fievre_elevee, toux, fatigue_intense, courbatures]).

symptomes_associes(covid19, [perte_odorat, fievre_elevee, toux, fatigue_intense, courbatures]).

symptomes_associes(bronchite, [fievre_legere, toux_productive, nez_bouche, gorge_irritee]).

symptomes_associes(rhume, [nez_bouche, gorge_irritee, nez_qui_coule_clair]).

symptomes_associes(angine, [mal_gorge_intense, fievre_elevee]).

symptomes_associes(allergie, [eternuement, yeux_rouges, yeux_qui_piquent]).

symptomes_associes(asthme, [eternuement, wheezing, difficultes_respiratoires]).

symptomes_associes(migraine, [mal_tete_intense, photophobie]).

symptomes_associes(gastro_enterite, [diarrhee, vomissements, fievre_elevee]).

symptomes_associes(conjonctivite, [yeux_rouges, yeux_qui_piquent, secretions_purulentes]).

% -----------------------------------------------------------------------------
% RECOMMANDATIONS MEDICALES (SANS ACCENTS)
% -----------------------------------------------------------------------------

recommandation(grippe, [
    "Repos au lit pendant 3-5 jours",
    "Hydratation abondante (eau, tisanes)",
    "Paracetamol pour fievre et douleurs",
    "Consultation si symptomes persistent >7 jours"
]).

recommandation(covid19, [
    "Isolement immediat pendant 5-10 jours",
    "Repos et hydratation",
    "Surveillance oxymetrie (consulter si <95%)",
    "Consulter medecin pour evaluation et traitement",
    "Informer contacts proches"
]).

recommandation(bronchite, [
    "Repos et hydratation",
    "Eviter fumee et irritants respiratoires",
    "Humidificateur d'air recommande",
    "Consulter si fievre persiste >3 jours",
    "Antibiotiques seulement si prescrits"
]).

recommandation(rhume, [
    "Repos leger",
    "Hydratation reguliere",
    "Lavages nasaux serum physiologique",
    "Consultation si aggravation apres 7 jours"
]).

recommandation(angine, [
    "Consulter medecin pour test streptocoque",
    "Antibiotiques si angine bacterienne",
    "Antalgiques pour douleur gorge",
    "Repos et alimentation molle"
]).

recommandation(allergie, [
    "Identifier et eviter allergenes",
    "Antihistaminiques si necessaire",
    "Lavages nasaux serum physiologique",
    "Consulter allergologue pour tests cutanes"
]).

recommandation(asthme, [
    "CONSULTATION URGENTE recommandee",
    "Eviter allergenes et irritants",
    "Bronchodilatateur si prescrit",
    "Plan d'action asthme avec medecin",
    "Surveillance reguliere fonction respiratoire"
]).

recommandation(migraine, [
    "Repos dans piece sombre et calme",
    "Antalgiques des premiers symptomes",
    "Identifier facteurs declenchants",
    "Consulter si migraines frequentes (>4/mois)",
    "Tenir journal des crises"
]).

recommandation(gastro_enterite, [
    "Hydratation intensive (SRO recommande)",
    "Alimentation legere (riz, banane, compote)",
    "Eviter produits laitiers temporairement",
    "Consulter si deshydratation ou sang dans selles",
    "Repos et hygiene des mains"
]).

recommandation(conjonctivite, [
    "Lavages oculaires serum physiologique",
    "Ne pas partager serviettes/oreillers",
    "Consulter si secretions purulentes persistantes",
    "Antibiotiques topiques si bacterienne",
    "Eviter frottement yeux"
]).
