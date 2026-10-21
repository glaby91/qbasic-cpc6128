# QLIB unifiée v0.3 — build réel

## Résultat GitHub Actions
- Build : **39644054828** — réussite.
- Binaire : `QLIB_UNIFIED_V030_TEST.ROM`, **16 384 octets**.
- Occupation mesurée : **1 438 octets** avant remplissage `FF`.
- Place de remplissage : **14 946 octets**.
- Méthode : longueur du binaire sans les octets `FF` terminaux ; valeur indicative « code + données » et non mesure du coût RAM.

## Capacités compilées
19 tests hérités de v0.2.1 (validés sous WinAPE seulement pour l'ancienne ROM), plus **4 tests nouveaux** :
- multiplication 16 bits modulo 65536 ;
- multiplication 16 bits avec passage par zéro ;
- transformation affine 2×3 avec translation ;
- transformation matricielle 3×3.

La ROM affiche `PASS` ou `FAIL` ligne par ligne via `|MALLTEST`, avec bilan final. Version affichée v0.3.

## Tests en attente
**La v0.3 n'a pas encore été exécutée dans WinAPE.** Seuls l'assemblage, la taille et la présence du binaire sont confirmés. Ne pas confondre un build réussi avec une vérification mathématique.

Installer la nouvelle ROM dans un emplacement libre à la place de l'ancienne ROM unifiée, réinitialiser puis saisir `|MALLTEST`. Attendu : **23 contrôles PASS et ALL TESTS PASS**.

## Modules toujours à coder
- division/multiplication signées 16 bits complètes, gestion formelle du débordement ;
- virgule fixe Q8.8 et Q16.16 avec arrondi ;
- trigonométrie, logarithmes et exponentielles ;
- SINGLE/DOUBLE, CURRENCY et conversions conformes Microsoft QBX 7.1 ;
- RND/RANDOMIZE compatibles ;
- matrices 4×4, transformations 3×3 en virgule fixe ;
- ABI sécurisée inter-ROM pour QCOMP.

La spécification complète de ces modules se trouve sur la branche `qlib-math-v030-architecture`. La ROM v0.2.1 validée 19/19 reste conservée sur sa branche.
