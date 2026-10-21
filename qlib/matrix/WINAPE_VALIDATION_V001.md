# Validation WinAPE — QLIB_MATRIX v0.1

Date : 21 octobre 2026

## Résultat utilisateur
L'utilisateur confirme que la ROM `QLIB_MATRIX_V001_TEST.ROM`, appelée depuis Locomotive BASIC par `|M2TEST`, affiche **PASS** sous WinAPE.

Test effectué : matrice signée 2×2 [[1,2],[3,4]] multipliée par le vecteur [6,8], résultat attendu [22,50]. Le code ROM vérifie les deux composantes avant d'afficher PASS.

## Portée de la validation
- Validé : commande RSX `|M2TEST`, multiplication signée 8×8 sur ce vecteur positif, accumulation 16 bits et comparaison des résultats pour ce cas précis.
- Non validé : entrées négatives, limites -128..127, overflow, tous les coefficients possibles, rotations 2D/3D, matrices 2×3 et 3×3, virgule fixe 8.8, interface QCOMP/QLIB.
- La compilation GitHub Actions du prototype a réussi (run 39638506811, artefact 12364970368).
- Le retour utilisateur ne constitue pas une mesure de cycles ni une validation sur matériel CPC réel.

## Prochaines vérifications
Tester les signes négatifs, zéro, bornes, accumulations, puis développer 2×3 et 3×3 avec tests BASIC/WinAPE et benchmarks.
