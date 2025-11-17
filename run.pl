/** <module> Lancement Rapide

Point d'entrée du système expert. Charge le moteur d'inférence
et lance automatiquement la session de diagnostic interactive.

@author   Équipe 6
@course   TP2 - IFT2003 Intelligence Artificielle 1
@date     Novembre 2025
*/

:- consult('src/main.pl').
:- initialization(start, main).
