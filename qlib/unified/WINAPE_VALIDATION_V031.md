# Validation WinAPE — QLIB unifiée v0.3.1

Date : 21 octobre 2026

L'utilisateur confirme que **tous les tests affichent PASS** après installation de `QLIB_UNIFIED_V031_TEST.ROM` et exécution sous WinAPE.

## Portée
- Les 23 contrôles embarqués de calcul entier et des matrices 2×2, 2×3 et 3×3 ont été exécutés avec résultat PASS selon le retour utilisateur.
- Le problème de lancement automatique a été corrigé dans le code par la séparation des points d'entrée d'initialisation et de commande RSX. Le retour « tout est PASS » ne constitue pas à lui seul une confirmation explicite de la disparition de l'artefact visuel.
- GitHub Actions run 39644778672 : compilation réussie, ROM de 16384 octets, **1448 octets occupés avant le remplissage FF**, 14936 octets libres.
- Ce n'est pas une validation exhaustive de toutes les entrées ni une conformité QBX 7.1 complète.

## Version de référence
Branche `qlib-unified-v031-rsx-fix` ; conserver la v0.2.1 précédente et ses résultats historiques.
