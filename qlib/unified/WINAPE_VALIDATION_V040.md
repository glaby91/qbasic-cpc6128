# Validation WinAPE — QLIB MATH + MATRIX v0.4

Date : 21 octobre 2026.

L'utilisateur confirme explicitement que **tous les tests passent** dans WinAPE après installation de `QLIB_UNIFIED_V040_TEST.ROM` et appel à `|MALLTEST`.

- **31/31 tests : PASS** (selon compte-rendu utilisateur).
- GitHub Actions : run **39646043619** terminé avec succès.
- ROM : **16 384 octets**, dont **1 976 octets occupés** et **14 408 octets de remplissage FF**.
- Fonctions nouvellement incluses : division non signée 16 bits, addition/soustraction Q8.8, sinus/cosinus à table de phases 8 bits. Hérite des opérations entières et matricielles 2×2/2×3/3×3.

## Limites
Validation réelle **de 31 vecteurs embarqués sous WinAPE**, pas exhaustive et pas encore une conformité complète Microsoft QBX 7.1. Les trigonométries 8 bits sont des extensions CPC, non les fonctions QBX en radians. QCOMP et l'ABI inter-ROM restent à développer. Aucun benchmark de cycles effectué.

La v0.3.1 validée auparavant reste préservée séparément. Statut : **référence expérimentale validée pour ses tests**.
