# QLIB unifiée MATH + MATRIX v0.2

## Objectif
Une seule ROM d'extension CPC6128 pour les primitives arithmétiques de QLIB_MATH et les transformations 2×2 de QLIB_MATRIX. Remplace les **ROM séparées pour ce test**, sans effacer leurs branches historiques.

## Build confirmé
- GitHub Actions : 39639910688, résultat **success**.
- ROM : `QLIB_UNIFIED_V020_TEST.ROM` de 16 384 octets.
- Code/données utilisés : 1 003 octets ; espace restant : 15 381 octets.

## Test sous WinAPE
1. Désinstaller les anciennes ROM de test QLIB_MATH et QLIB_MATRIX afin d'éviter plusieurs copies de fonctions.
2. Installer `QLIB_UNIFIED_V020_TEST.ROM` dans un emplacement libre de ROM supérieure (sans remplacer AMSDOS).
3. Faire un reset complet.
4. À l'invite Locomotive BASIC, taper `|MALLTEST` ; autre possibilité : lancer `tests/math/UNIFIED_MATH_TEST.BAS`.
5. La ROM affiche **PASS ou FAIL à chaque test** puis `ALL TESTS: PASS` uniquement si aucune vérification n'a échoué.

## Les 19 contrôles
ADD8, ADD8 WRAP, SUB8, MUL8, MUL8 LIMIT, DIV8, DIV8 /1, DIV8 /0 FLAG, ADD16, SUB16, ABS16, ABS16 MIN, SGN16, SQRT16, SQRT16 LIMIT, LCG16, MUL S8, MATRIX 2x2, MATRIX SIGNED.

## Limites explicites
- Ceci est **un test de conformité sur 19 vecteurs choisis**, et non une preuve exhaustive de toutes les valeurs possibles, de toutes les limites QBX ou de la vitesse.
- Le programme de test s'exécute en ROM ; le petit fichier BASIC ne fait que déclencher la commande RSX.
- Stockage temporaire pour compteur d'erreurs et sortie matricielle en RAM `#9000..#9005`. Ce prototype ne doit pas être considéré comme ABI ROM publique.
- Les routines sont encore des primitives ; les types flottants, 3×3, 2×3, trigonométrie et véritable `RND` QBX ne sont pas présents.
- Validation **WinAPE non encore obtenue** sur cette version.
- Les anciennes versions QLIB_MATH v0.1.2 et QLIB_MATRIX v0.1 restent conservées dans leurs branches.
