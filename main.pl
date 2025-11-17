% =============================================================================
% MAIN - Systeme Expert de Diagnostic Medical
% =============================================================================
% Projet: TP2 - IFT2003
% Moteur d'inference (backward chaining) + Interface utilisateur
% =============================================================================

% Chargement de la base de connaissances
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

traduire_symptome(perte_odorat, "perdu l'odorat ou le gout").
traduire_symptome(fievre, "de la fievre").
traduire_symptome(fievre_elevee, "une fievre elevee (>38.5°C)").
traduire_symptome(fievre_legere, "une fievre legere").
traduire_symptome(frissons, "des frissons").
traduire_symptome(toux, "de la toux").
traduire_symptome(toux_productive, "une toux productive (avec crachats/expectorations)").
traduire_symptome(nez_bouche, "le nez bouche").
traduire_symptome(difficultes_respiratoires, "des difficultes a respirer").
traduire_symptome(wheezing, "un sifflement respiratoire (wheezing)").
traduire_symptome(gorge_irritee, "la gorge irritee").
traduire_symptome(mal_gorge_intense, "un mal de gorge intense").
traduire_symptome(difficulte_avaler, "de la difficulte a avaler").
traduire_symptome(eternuement, "eternue frequemment").
traduire_symptome(nez_qui_coule_clair, "le nez qui coule (ecoulement clair)").
traduire_symptome(yeux_rouges, "les yeux rouges").
traduire_symptome(yeux_qui_piquent, "les yeux qui piquent ou qui demangent").
traduire_symptome(secretions_purulentes, "des secretions purulentes aux yeux").
traduire_symptome(fatigue_intense, "ressenti une fatigue intense").
traduire_symptome(courbatures, "des courbatures (douleurs musculaires)").
traduire_symptome(mal_tete_intense, "un mal de tete intense").
traduire_symptome(photophobie, "sensible a la lumiere (photophobie)").
traduire_symptome(diarrhee, "de la diarrhee").
traduire_symptome(vomissements, "des vomissements").

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
% TRADUCTIONS - Syndromes (SANS ACCENTS)
% -----------------------------------------------------------------------------

traduire_syndrome(syndrome_respiratoire, "Syndrome respiratoire").
traduire_syndrome(syndrome_febrile, "Syndrome febrile").
traduire_syndrome(syndrome_grippal, "Syndrome grippal").
traduire_syndrome(syndrome_allergique, "Syndrome allergique").
traduire_syndrome(syndrome_oculaire, "Syndrome oculaire").
traduire_syndrome(syndrome_digestif, "Syndrome digestif").
traduire_syndrome(syndrome_neurologique, "Syndrome neurologique").
traduire_syndrome(syndrome_orl, "Syndrome ORL").

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
    traduire_symptome(Symptome, TexteFrancais),
    nl,
    format('Question: Avez-vous ~w?~n', [TexteFrancais]),
    write('1. Oui'), nl,
    write('2. Non'), nl,
    write('Votre reponse: '),
    lire_reponse(Reponse),
    nl.

% -----------------------------------------------------------------------------
% GESTION CASCADES - Fievre et Toux
% -----------------------------------------------------------------------------

% CASCADE FIEVRE
% Q: "Avez-vous de la fievre?"
%   → Si OUI: "Est-elle elevee (>38.5°C)?"
%     → Si OUI: fievre=oui, fievre_elevee=oui, fievre_legere=non
%     → Si NON: fievre=oui, fievre_elevee=non, fievre_legere=oui
%   → Si NON: fievre=non, fievre_elevee=non, fievre_legere=non

poser_question_fievre :-
    traduire_symptome(fievre, TexteFievre),
    nl,
    format('Question: Avez-vous ~w?~n', [TexteFievre]),
    write('1. Oui'), nl,
    write('2. Non'), nl,
    write('Votre reponse: '),
    lire_reponse(ReponseFievre),
    nl,
    (   ReponseFievre = oui ->
        (
            % Sous-question: fievre elevee?
            nl,
            format('Question: Est-elle elevee (temperature >38.5°C)?~n', []),
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

% CASCADE TOUX
% Q: "Avez-vous de la toux?"
%   → Si OUI: "Est-elle productive (avec crachats)?"
%     → Si OUI: toux=oui, toux_productive=oui
%     → Si NON: toux=oui, toux_productive=non
%   → Si NON: toux=non, toux_productive=non

poser_question_toux :-
    traduire_symptome(toux, TexteToux),
    nl,
    format('Question: Avez-vous ~w?~n', [TexteToux]),
    write('1. Oui'), nl,
    write('2. Non'), nl,
    write('Votre reponse: '),
    lire_reponse(ReponseToux),
    nl,
    (   ReponseToux = oui ->
        (
            % Sous-question: toux productive?
            nl,
            format('Question: Est-elle productive (avec crachats/expectorations)?~n', []),
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

% Collecter les syndromes detectes
collecter_syndromes(Syndromes) :-
    findall(S, (
        member(S, [syndrome_respiratoire, syndrome_febrile, syndrome_grippal,
                   syndrome_allergique, syndrome_oculaire, syndrome_digestif,
                   syndrome_neurologique, syndrome_orl]),
        call(S)
    ), Syndromes).

% Afficher diagnostic final
afficher_diagnostic(Maladie) :-
    nl,
    write('======================================================='), nl,
    write('=== DIAGNOSTIC ==='), nl,
    write('======================================================='), nl,
    nl,
    traduire_maladie(Maladie, NomFrancais),
    format('Diagnostic: ~w~n', [NomFrancais]),
    nl.

% Afficher liste de syndromes traduits
afficher_liste_syndromes([]).
afficher_liste_syndromes([S]) :-
    traduire_syndrome(S, NomFrancais),
    write(NomFrancais), !.
afficher_liste_syndromes([S|Rest]) :-
    traduire_syndrome(S, NomFrancais),
    format('~w, ', [NomFrancais]),
    afficher_liste_syndromes(Rest).

% Si aucun diagnostic trouve
afficher_aucun_diagnostic :-
    nl,
    write('======================================================='), nl,
    write('=== DIAGNOSTIC ==='), nl,
    write('======================================================='), nl,
    nl,
    write('Aucun diagnostic trouve avec les symptomes fournis.'), nl,
    write('Veuillez consulter un professionnel de sante.'), nl,
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
    write('Repondez par 1 (Oui) ou 2 (Non).'), nl,
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

    nl,
    write('-------------------------------------------------------'), nl,
    write('Session terminee.'), nl,
    nl.
