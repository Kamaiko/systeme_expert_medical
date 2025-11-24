/** <module> Moteur d'Inférence

Implémentation du backward chaining et de l'interface utilisateur
pour le diagnostic médical interactif.

@author   Équipe 6
@course   TP2 - IFT2003 Intelligence Artificielle 1
@date     Novembre 2025
@brief    - Backward chaining avec cache (évite questions redondantes)
          - Gestion de 2 cascades conditionnelles
*/

:- consult('base_connaissances.pl').

% -----------------------------------------------------------------------------
% GESTION MEMOIRE - Faits dynamiques
% -----------------------------------------------------------------------------

:- dynamic connu/2.  % connu(Symptome, oui/non)

% Reinitialiser la base de faits
reinitialiser :-
    retractall(connu(_, _)).

% -----------------------------------------------------------------------------
% TRADUCTIONS - Symptomes (SANS ACCENTS)
% -----------------------------------------------------------------------------

traduire_symptome(perte_odorat, "Perte de gout ou odorat").
traduire_symptome(fievre_elevee, "Fievre elevee (>38.5°C)").
traduire_symptome(fievre_legere, "Fievre legere").
traduire_symptome(toux_productive, "Toux productive").
traduire_symptome(nez_bouche, "Congestion nasale").
traduire_symptome(difficultes_respiratoires, "Difficultes respiratoires").
traduire_symptome(wheezing, "Sifflement respiratoire (wheezing)").
traduire_symptome(gorge_irritee, "Gorge irritee").
traduire_symptome(mal_gorge_intense, "Mal de gorge intense").
traduire_symptome(eternuement, "Eternuements frequents").
traduire_symptome(nez_qui_coule_clair, "Nez qui coule (ecoulement clair)").
traduire_symptome(yeux_rouges, "Yeux rouges").
traduire_symptome(yeux_qui_piquent, "Yeux qui piquent").
traduire_symptome(secretions_purulentes, "Secretions purulentes aux yeux").
traduire_symptome(fatigue_intense, "Fatigue intense").
traduire_symptome(courbatures, "Courbatures").
traduire_symptome(mal_tete_intense, "Mal de tete intense").
traduire_symptome(photophobie, "Sensibilite a la lumiere (photophobie)").
traduire_symptome(diarrhee, "Diarrhee").
traduire_symptome(vomissements, "Vomissements").

% -----------------------------------------------------------------------------
% TRADUCTIONS - Maladies (SANS ACCENTS)
% -----------------------------------------------------------------------------

traduire_maladie(grippe, "Grippe").
traduire_maladie(covid19, "COVID-19").
traduire_maladie(bronchite, "Bronchite").
traduire_maladie(rhume, "Rhume").
traduire_maladie(angine, "Angine").
traduire_maladie(allergie, "Allergie saisonniere").
traduire_maladie(asthme, "Asthme").
traduire_maladie(migraine, "Migraine").
traduire_maladie(gastro_enterite, "Gastro-enterite").
traduire_maladie(conjonctivite, "Conjonctivite").

% -----------------------------------------------------------------------------
% QUESTIONS - Format adapte pour chaque symptome (SANS ACCENTS)
% -----------------------------------------------------------------------------

question_symptome(perte_odorat, "Avez-vous perdu l'odorat ou le gout?").
question_symptome(fievre, "Avez-vous de la fievre?").
question_symptome(toux, "Avez-vous de la toux?").
question_symptome(nez_bouche, "Avez-vous le nez bouche?").
question_symptome(difficultes_respiratoires, "Avez-vous de la difficulte a respirer?").
question_symptome(wheezing, "Entendez-vous un sifflement lorsque vous respirez?").
question_symptome(gorge_irritee, "Votre gorge est-elle irritée?").
question_symptome(mal_gorge_intense, "Avez-vous un mal de gorge intense?").
question_symptome(eternuement, "Eternuez-vous frequemment?").
question_symptome(nez_qui_coule_clair, "Avez-vous le nez qui coule?").
question_symptome(yeux_rouges, "Vos yeux sont-ils rouges?").
question_symptome(yeux_qui_piquent, "Vos yeux piquent-ils?").
question_symptome(secretions_purulentes, "Avez-vous des secretions purulentes aux yeux?").
question_symptome(fatigue_intense, "Sentez-vous de la fatigue intense?").
question_symptome(courbatures, "Avez-vous des courbatures?").
question_symptome(mal_tete_intense, "Avez-vous un mal de tete intense?").
question_symptome(photophobie, "Etes-vous sensible a la lumiere?").
question_symptome(diarrhee, "Avez-vous de la diarrhee?").
question_symptome(vomissements, "Avez-vous des vomissements?").


% -----------------------------------------------------------------------------
% INTERFACE UTILISATEUR - Gestion des questions
% -----------------------------------------------------------------------------

% Lire reponse utilisateur (1 ou 2 uniquement)
% Utilise get_single_char pour meilleure UX (pas besoin de point ni Enter)
lire_reponse(Reponse) :-
    get_single_char(Code),
    % Afficher la reponse tapee pour feedback visuel
    char_code(Char, Code),
    write(Char), nl,
    (   Code = 49 -> Reponse = oui      % 49 = code ASCII de '1'
    ;   Code = 50 -> Reponse = non      % 50 = code ASCII de '2'
    ;   (
            write('Reponse invalide. Veuillez entrer 1 ou 2.'), nl,
            write('Votre reponse: '),
            lire_reponse(Reponse)
        )
    ).

% Poser question simple (pas de cascade)
poser_question_simple(Symptome, Reponse) :-
    question_symptome(Symptome, TexteQuestion),
    nl,
    format('Question: ~w~n', [TexteQuestion]),
    write('1. Oui'), nl,
    write('2. Non'), nl,
    write('Votre reponse: '),
    lire_reponse(Reponse),
    nl.

% -----------------------------------------------------------------------------
% GESTION CASCADES - Fievre et Toux
% -----------------------------------------------------------------------------

% CASCADE FIEVRE: Q1 "Avez-vous de la fievre?" → Si OUI: Q2 "Est-elle elevee?"
% Enregistre: fievre, fievre_elevee, fievre_legere (selon reponses)

poser_question_fievre :-
    question_symptome(fievre, TexteQuestion),
    nl,
    format('Question: ~w~n', [TexteQuestion]),
    write('1. Oui'), nl,
    write('2. Non'), nl,
    write('Votre reponse: '),
    lire_reponse(ReponseFievre),
    nl,
    (   ReponseFievre = oui ->
        (
            % Sous-question: fievre elevee?
            nl,
            format('Question: Votre fievre est-elle elevee (temperature >38.5°C)?~n', []),
            write('1. Oui'), nl,
            write('2. Non'), nl,
            write('Votre reponse: '),
            lire_reponse(ReponseElevee),
            nl,
            (   ReponseElevee = oui ->
                (
                    assert(connu(fievre, oui)),
                    assert(connu(fievre_elevee, oui)),
                    assert(connu(fievre_legere, non))
                )
            ;   % ReponseElevee = non
                (
                    assert(connu(fievre, oui)),
                    assert(connu(fievre_elevee, non)),
                    assert(connu(fievre_legere, oui))
                )
            )
        )
    ;   % ReponseFievre = non
        (
            assert(connu(fievre, non)),
            assert(connu(fievre_elevee, non)),
            assert(connu(fievre_legere, non))
        )
    ).

% CASCADE TOUX: Q1 "Avez-vous de la toux?" → Si OUI: Q2 "Est-elle productive?"
% Enregistre: toux, toux_productive (selon reponses)

poser_question_toux :-
    question_symptome(toux, TexteQuestion),
    nl,
    format('Question: ~w~n', [TexteQuestion]),
    write('1. Oui'), nl,
    write('2. Non'), nl,
    write('Votre reponse: '),
    lire_reponse(ReponseToux),
    nl,
    (   ReponseToux = oui ->
        (
            % Sous-question: toux productive?
            nl,
            format('Question: Votre toux est-elle productive (avec crachats/expectorations)?~n', []),
            write('1. Oui'), nl,
            write('2. Non'), nl,
            write('Votre reponse: '),
            lire_reponse(ReponseProductive),
            nl,
            (   ReponseProductive = oui ->
                (
                    assert(connu(toux, oui)),
                    assert(connu(toux_productive, oui))
                )
            ;   % ReponseProductive = non
                (
                    assert(connu(toux, oui)),
                    assert(connu(toux_productive, non))
                )
            )
        )
    ;   % ReponseToux = non
        (
            assert(connu(toux, non)),
            assert(connu(toux_productive, non))
        )
    ).

% -----------------------------------------------------------------------------
% MOTEUR D'INFERENCE - Verification Symptomes
% -----------------------------------------------------------------------------

% Verifier un symptome avec cache (ne pose jamais 2 fois la meme question)
verifier_symptome(Symptome) :-
    % Cas 1: Deja connu comme OUI
    connu(Symptome, oui), !.

verifier_symptome(Symptome) :-
    % Cas 2: Deja connu comme NON
    connu(Symptome, non), !, fail.

verifier_symptome(Symptome) :-
    % Cas 3: Pas encore demande - poser question et enregistrer
    \+ connu(Symptome, _),
    poser_question_et_enregistrer(Symptome),
    connu(Symptome, oui).  % Verifier cache apres (cascade fait assert directement)

% -----------------------------------------------------------------------------
% Poser questions et enregistrer dans le cache
% -----------------------------------------------------------------------------

% Gestion CASCADE FIEVRE
% Si on demande fievre, fievre_elevee ou fievre_legere et que la cascade
% n'a pas encore ete posee, on pose la cascade complete
poser_question_et_enregistrer(fievre) :-
    \+ connu(fievre, _),
    poser_question_fievre, !.

poser_question_et_enregistrer(fievre_elevee) :-
    \+ connu(fievre, _),
    poser_question_fievre, !.

poser_question_et_enregistrer(fievre_legere) :-
    \+ connu(fievre, _),
    poser_question_fievre, !.

% Gestion CASCADE TOUX
% Si on demande toux ou toux_productive et que la cascade
% n'a pas encore ete posee, on pose la cascade complete
poser_question_et_enregistrer(toux) :-
    \+ connu(toux, _),
    poser_question_toux, !.

poser_question_et_enregistrer(toux_productive) :-
    \+ connu(toux, _),
    poser_question_toux, !.

% Pour tous les AUTRES symptomes (non-cascades)
poser_question_et_enregistrer(Symptome) :-
    \+ member(Symptome, [fievre, fievre_elevee, fievre_legere, toux, toux_productive]),
    poser_question_simple(Symptome, Reponse),
    assert(connu(Symptome, Reponse)).

% -----------------------------------------------------------------------------
% MOTEUR PRINCIPAL - Backward Chaining
% -----------------------------------------------------------------------------

% Ordre optimise: maladies avec discriminants uniques d'abord
diagnostiquer(Maladie) :-
    member(Maladie, [
        covid19,           % perte_odorat unique → 2-3 questions
        migraine,          % neurologique unique → 3 questions
        conjonctivite,     % secretions_purulentes unique → 4-5 questions
        asthme,            % wheezing + difficultes respiratoires → 5-6 questions
        gastro_enterite,   % digestif + febrile → 5-6 questions
        grippe,            % 3 syndromes (complexe) → 6-8 questions
        angine,            % ORL + febrile → 5-6 questions
        bronchite,         % toux_productive + fievre_legere → 5-7 questions
        allergie,          % allergique + oculaire → 6-7 questions
        rhume              % Diagnostic par elimination (dernier) → 7-8 questions
    ]),
    call(Maladie).  % Appel dynamique de la regle maladie

% -----------------------------------------------------------------------------
% AFFICHAGE RESULTATS
% -----------------------------------------------------------------------------

% Collecter les symptômes positifs
% Sauf les symptômes génériques de fièvre et de toux
collecter_symptomes_positifs(Symptomes) :-
    findall(S, (connu(S, oui),
                \+S=fievre,
                \+S=toux),
            Symptomes).

% Version optimisee: accepte les symptomes positifs en parametre (evite double appel)
collecter_symptomes_associes(Maladie, Positifs, Symptomes) :-
    symptomes_associes(Maladie, Associes),
    findall(S, (member(S, Positifs), member(S, Associes)), Symptomes).

% Afficher liste de symptômes en français (format puces)
afficher_liste_symptomes([]).
afficher_liste_symptomes([S|Rest]) :-
    traduire_symptome(S, TexteFrancais),
    format('  - ~w~n', [TexteFrancais]),
    afficher_liste_symptomes(Rest).

% Afficher diagnostic final
afficher_diagnostic(Maladie) :-
    nl,
    write('======================================================='), nl,
    write('=== DIAGNOSTIC ==='), nl,
    write('======================================================='), nl,
    nl,
    traduire_maladie(Maladie, NomFrancais),
    format('~w~n~n', [NomFrancais]),

    % Optimisation: calculer les positifs une seule fois
    collecter_symptomes_positifs(Positifs),

    write('Base sur les symptomes suivants:'), nl,
    collecter_symptomes_associes(Maladie, Positifs, Symptomes_associes),
    afficher_liste_symptomes(Symptomes_associes),
    nl,
    afficher_recommandations(Maladie),
    nl.

% Afficher recommandations medicales
afficher_recommandations(Maladie) :-
    recommandation(Maladie, Recommandations),
    write('-------------------------------------------------------'), nl,
    write('RECOMMANDATIONS:'), nl,
    write('-------------------------------------------------------'), nl,
    afficher_liste_recommandations(Recommandations).

% Afficher liste de recommandations
afficher_liste_recommandations([]).
afficher_liste_recommandations([R|Rest]) :-
    format('  - ~w~n', [R]),
    afficher_liste_recommandations(Rest).

% Si aucun diagnostic trouve
afficher_aucun_diagnostic :-
    nl,
    write('======================================================='), nl,
    write('=== DIAGNOSTIC ==='), nl,
    write('======================================================='), nl,
    nl,
    write('Aucun diagnostic trouve avec les symptomes fournis.'), nl,
    write('Veuillez consulter un professionnel de la sante.'), nl,
    nl.

% -----------------------------------------------------------------------------
% POINT D'ENTREE PRINCIPAL
% -----------------------------------------------------------------------------

start :-
    % Banniere
    nl,
    write('======================================================='), nl,
    write('    SYSTEME EXPERT DE DIAGNOSTIC MEDICAL'), nl,
    write('======================================================='), nl,
    nl,
    write('Ce systeme vous posera quelques questions pour etablir'), nl,
    write('un diagnostic parmi 10 maladies courantes.'), nl,
    nl,
    write('-------------------------------------------------------'), nl,
    nl,

    % Reinitialisation
    reinitialiser,

    % Tentative de diagnostic
    (   diagnostiquer(Maladie) ->
        afficher_diagnostic(Maladie)
    ;   afficher_aucun_diagnostic
    ),

    % Menu: Nouveau diagnostic ou Quitter
    nl,
    write('-------------------------------------------------------'), nl,
    write('Que souhaitez-vous faire?'), nl,
    write('1. Nouveau diagnostic'), nl,
    write('2. Quitter'), nl,
    write('Votre choix: '),
    lire_reponse(Choix),
    nl,

    (   Choix = oui ->  % '1' converti en 'oui' par lire_reponse/1
        % Recommencer un nouveau diagnostic
        start
    ;   % Choix = non ('2')
        % Quitter le programme
        write('-------------------------------------------------------'), nl,
        write('Au revoir!'), nl,
        write('-------------------------------------------------------'), nl,
        nl,
        halt(0)
    ).
