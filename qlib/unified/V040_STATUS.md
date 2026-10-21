# QLIB v0.4 — livraison de développement

La ROM `QLIB_UNIFIED_V040_TEST.ROM` compile en **16 384 octets**, dont **1 976 octets occupés** (avant remplissage FF) et **14 408 octets libres**. Run GitHub Actions 39646043619.

## Ajouts codés depuis v0.3.1
- Division unsigned 16 bits (quotient/reste ; routine simple et lente par soustraction ; division par zéro signalée par Carry).
- Opérations Q8.8 ADD/SUB avec comportement modulaire sur 16 bits.
- SIN et COS à table de 256 positions par tour, amplitude signée 8 bits -127 à 127, **extension CPC**, pas fonction QBX mathématique en radians.
- Huit nouveaux contrôles individuels, pour **31 contrôles** en tout ; `|MALLTEST` déclenche le bilan PASS/FAIL sur chaque ligne.

## Statut rigoureux
- **Compilation : validée.**
- **Exécution WinAPE v0.4 : non validée.** Les 23 cas hérités ont été validés uniquement sur la v0.3.1.
- Pas de preuve d'exhaustivité et pas de benchmark de cycles mesuré.
- Ce code n'est pas encore une bibliothèque mathématique complète PDS 7.1.

## Fonctionnalités toujours à développer
- Multiplication/division/modulo signés 16 bits avec comportement QBX, entier LONG 32 bits.
- Q8.8 MUL/DIV et format Q16.16 ; saturation/arrondis étudiés.
- TAN/ATN, SIN/COS en radians QBX, LOG, EXP, puissances et SQR réel.
- Types SINGLE, DOUBLE et CURRENCY avec formats et précision QBX conformes.
- Conversions CINT, CLNG, CSNG, CDBL, VAL, STR$ ; RND/RANDOMIZE compatibles.
- Matrices 4×4 et 3×3 à virgule fixe, interface ROM stable QCOMP → QLIB.

La branche stable `qlib-unified-v031-rsx-fix` est préservée intacte.
