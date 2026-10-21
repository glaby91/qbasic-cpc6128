# Validation WinAPE — QLIB_MATH v0.1.2

Date : 21 octobre 2026

## Résultat du test utilisateur
La ROM `QLIB_MATH_V012_TEST.ROM` a été installée et la commande Locomotive BASIC `|MTEST` exécutée sous WinAPE. L'utilisateur confirme que **tous les diagnostics affichent PASS**.

| Routine testée | Vecteur | Résultat |
|---|---|---|
| ADD_U8 | 12 + 34 = 46 | PASS |
| MUL_U8 | 13 × 17 = 221 | PASS |
| DIVMOD_U8 | 100 / 7 = quotient 14 et reste 2 | PASS |
| ISQRT_U16 | sqrt(144) = 12 | PASS |
| LCG16_STEP | état 100 -> 501 | PASS |

## Portée
- Valide le chargement et la reconnaissance de la commande RSX `|MTEST` sous WinAPE et l'exécution des cinq vecteurs testés dans la ROM.
- **Ne valide pas** toutes les valeurs d'entrée, les cas limites, les débordements, le comportement Microsoft QBX 7.1, ni l'ABI inter-ROM.
- La ROM de diagnostic v0.1.1 présentait une erreur d'aiguillage RSX ; corrigée dans la v0.1.2.
- Prochaines vérifications : zéros, valeurs limites 8/16 bits, division par zéro, signe, résultats détaillés et mesure des performances.

## Provenance
Validation utilisateur rapportée dans la conversation, sans journal WinAPE joint ; build GitHub Actions 39636968004.
