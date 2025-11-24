/** <module> Base de Connaissances

Définition des 21 règles d'inférence du système expert
(architecture 4 niveaux: Symptômes → Syndromes → RFG → Maladies).

@author   Équipe 6
@course   TP2 - IFT2003 Intelligence Artificielle 1
@date     Novembre 2025
@brief    - 21 règles (R1-R10: symptômes→syndromes, R11: syndromes→RFG, R12-R21: RFG/syndromes→maladies)
          - 8 syndromes intermédiaires, 1 abstraction RFG, 10 maladies diagnosticables
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

% -----------------------------------------------------------------------------
% NIVEAU 2 → NIVEAU 2.5: Syndromes → Maladie RFG (1 regle)
% -----------------------------------------------------------------------------

% R11: Maladie RFG = Respiratoire ∧ Grippal ∧ Febrile
% Abstraction regroupant les 3 syndromes communs a Grippe et COVID-19
% (introduite pour simplifier le graphe de dependances)
maladie_rfg :-
    syndrome_respiratoire,
    syndrome_grippal,
    syndrome_febrile.

% -----------------------------------------------------------------------------
% NIVEAU 2.5 → NIVEAU 3: Maladie RFG/Syndromes → Diagnostics finaux
% (2 regles RFG + 8 regles syndromes = 10 maladies)
% -----------------------------------------------------------------------------

% R12: Grippe = RFG ∧ ¬Perte odorat
grippe :-
    maladie_rfg,
    \+ verifier_symptome(perte_odorat).

% R13: COVID-19 = Perte odorat ∧ RFG
% NOTE: perte_odorat EN PREMIER (discriminant unique) pour optimiser backward chaining
covid19 :-
    verifier_symptome(perte_odorat),
    maladie_rfg.

% R14: Bronchite = Respiratoire ∧ Fievre legere ∧ Toux productive
bronchite :-
    syndrome_respiratoire,
    verifier_symptome(fievre_legere),
    verifier_symptome(toux_productive).

% R15: Rhume = Respiratoire ∧ ¬Febrile ∧ ¬Grippal
rhume :-
    syndrome_respiratoire,
    \+ syndrome_febrile,
    \+ syndrome_grippal.

% R16: Angine = ORL ∧ Febrile
angine :-
    syndrome_orl,
    syndrome_febrile.

% R17: Allergie saisonniere = Allergique ∧ Oculaire ∧ ¬Difficultes respiratoires
allergie :-
    syndrome_allergique,
    syndrome_oculaire,
    \+ verifier_symptome(difficultes_respiratoires).

% R18: Asthme = Respiratoire ∧ Allergique ∧ Wheezing ∧ Difficultes respiratoires
asthme :-
    syndrome_respiratoire,
    syndrome_allergique,
    verifier_symptome(wheezing),
    verifier_symptome(difficultes_respiratoires).

% R19: Migraine = Neurologique
migraine :-
    syndrome_neurologique.

% R20: Gastro-enterite = Digestif ∧ Febrile
gastro_enterite :-
    syndrome_digestif,
    syndrome_febrile.

% R21: Conjonctivite = Oculaire ∧ Secretions purulentes
conjonctivite :-
    syndrome_oculaire,
    verifier_symptome(secretions_purulentes).

% -----------------------------------------------------------------------------
% SYMPTOMES ASSOCIES (SANS ACCENTS)
% -----------------------------------------------------------------------------

symptomes_associes(grippe, [fievre_elevee, fatigue_intense, courbatures]).

symptomes_associes(covid19, [perte_odorat, fievre_elevee, fatigue_intense, courbatures]).

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
    "Paracetamol pour fievre et douleurs"
]).

recommandation(covid19, [
    "Isolement immediat pendant 5-10 jours",
    "Consulter medecin pour evaluation et traitement"
]).

recommandation(bronchite, [
    "Repos et hydratation",
    "Consulter si fievre persiste >3 jours"
]).

recommandation(rhume, [
    "Lavages nasaux serum physiologique",
    "Hydratation reguliere"
]).

recommandation(angine, [
    "Consulter medecin pour test streptocoque",
    "Antalgiques pour douleur gorge"
]).

recommandation(allergie, [
    "Identifier et eviter allergenes",
    "Antihistaminiques si necessaire"
]).

recommandation(asthme, [
    "CONSULTATION URGENTE recommandee",
    "Bronchodilatateur si prescrit"
]).

recommandation(migraine, [
    "Repos dans piece sombre et calme",
    "Antalgiques des premiers symptomes"
]).

recommandation(gastro_enterite, [
    "Hydratation intensive (SRO recommande)",
    "Consulter si deshydratation ou sang dans selles"
]).

recommandation(conjonctivite, [
    "Lavages oculaires serum physiologique",
    "Consulter si secretions purulentes persistantes"
]).
