# Validation WinAPE — QLIB MATH + MATRIX v0.2.1

Date : 21 octobre 2026

## Résultat constaté
L'utilisateur a fourni une capture de l'exécution de `|MALLTEST` sur WinAPE. **Les 19 lignes affichent PASS, et la ligne finale indique `ALL TESTS: PASS`.**

Tests :
1. ADD8 : PASS
2. ADD8 WRAP : PASS
3. SUB8 : PASS
4. MUL8 : PASS
5. MUL8 LIMIT : PASS
6. DIV8 : PASS
7. DIV8 /1 : PASS
8. DIV8 /0 FLAG : PASS
9. ADD16 : PASS
10. SUB16 : PASS
11. ABS16 : PASS
12. ABS16 MIN : PASS
13. SGN16 : PASS
14. SQRT16 : PASS
15. SQRT16 LIMIT : PASS
16. LCG16 : PASS
17. MUL S8 : PASS
18. MATRIX 2x2 : PASS
19. MATRIX SIGNED : PASS

**Bilan affiché : `ALL TESTS: PASS`**.

Version ROM compilée : `QLIB_UNIFIED_V021_TEST.ROM`, GitHub Actions run 39640715870, artefact 12364627368.

## Portée et limites
Cette validation démontre l'exécution des 19 vecteurs de test dans WinAPE. Elle ne prouve pas l'exhaustivité pour toutes les entrées, la précision QBX 7.1, l'absence de dépassements, les performances, ni le comportement sur CPC physique. L'API QCOMP/QLIB reste à qualifier.

La capture montre un bandeau `QLIB MATH + MATRIX v0.2` : ce libellé d'affichage n'a pas encore été actualisé dans la ROM v0.2.1, bien que le fichier de livraison et la correction RSX portent v0.2.1.

**Statut : prototype validé sous WinAPE pour 19/19 cas.** Conserver cette version comme référence sans la confondre avec une bibliothèque complète.
