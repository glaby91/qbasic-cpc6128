# État des versions — 21 octobre 2026

## Branches maintenues
| Branche | Objet | État |
|---|---|---|
| `main` | QEDIT v0.4.2 B005 | ROM 16 KiB compilée par GitHub Actions ; non validée sous WinAPE pour B005 |
| `qedit-b006-syntax` | Analyse syntaxique + stratégie de langage/QLIB | Plans et décisions enregistrés ; analyseur non implémenté |
| `qcomp-dev` | Compilateur BASIC → Z80 | Branche de préparation, compilateur non implémenté |
| `qlib-math-0.1` | ROM pilote mathématique | ROM 16 KiB compilée ; routines internes Z80 non validées sous WinAPE |

## Livrables et références
- QEDIT B005 : `editor/QEDIT_ROM.asm` + `editor/QEDIT_V04_CORE.asm`, dictionnaire `language/qbx71-cpc-profile.json` ; 196 tokens.
- Compilation indépendante de QEDIT : `.github/workflows/build-qedit.yml` ; run GitHub Actions **39565828640**, artefact **12329785931**.
- QLIB_MATH 0.1 : `qlib/math/QLIB_MATH_ROM.asm`, `qlib/math/README.md`, tests `tests/math/reference_tests.py` ; run GitHub Actions **39569712533**, artefact **12330764825**.
- Politique : fidélité QBX 7.1, instructions 8 bits optimisées seulement lorsque sémantique identique, accès 16 bits et plus selon les besoins, routines centralisées dans QLIB.
- Chaque fonction importée ou adaptée d'une bibliothèque externe devra être auditée (licence, format, coût, validation).

## Problèmes connus
1. **QEDIT Ctrl+S peut redémarrer le CPC** : sauvegarde à ne pas utiliser jusqu'à correction explicite.
2. B005 et QLIB_MATH n'ont pas de validation d'exécution WinAPE formelle.
3. Le dictionnaire des 196 mots-clés n'est pas une implémentation de toutes les commandes.
4. QCOMP n'a pas de backend Z80 fonctionnel.
5. L'ABI des appels inter-ROM QCOMP/QLIB est encore à concevoir et tester.
6. Tests Python QLIB = vecteurs de référence, **pas** une exécution des routines ROM.

## Règles de versioning
- Toute nouvelle version ROM reçoit son identifiant de version dans l'écran ou l'API, son nom de binaire et son workflow CI.
- Jamais remplacer silencieusement un binaire confirmé ; B005 demeure le jalon conservé de QEDIT.
- Branches distinctes pour les développements QEDIT, QCOMP et QLIB.
- GitHub Actions doit vérifier la taille ROM de 16 384 octets et archiver le binaire.
- Une compilation réussie ne vaut pas qualification CPC : noter « Compilé », « Testé sous WinAPE » et « Validé sur matériel » séparément.
- Les changements d'interface QLIB devront avoir une version ABI avant consommation par QCOMP.
- Préparer des tags de versions après qualification, sans tagger prématurément des prototypes comme stables.

## Prochaines étapes
1. Validation clavier et décodage des tokens B005 sous WinAPE.
2. QEDIT B006 : lexer, signatures et messages d'erreurs sur les lignes.
3. QLIB_MATH : tests réels Z80 sous émulateur et optimisation, puis conversions et fonctions spécialisées.
4. Spécifier ABI inter-ROM et amorcer QCOMP une fois les primitives testées.

La branche `main` conserve la base QEDIT B005 ; les éléments en chantier ne sont pas fusionnés automatiquement.

## Mise à jour — QLIB v0.4 (21 octobre 2026)

**QLIB MATH + MATRIX v0.4 : 31/31 PASS sous WinAPE**, rapport de validation utilisateur dans la branche `qlib-math-v040-expanded` : [WINAPE_VALIDATION_V040.md](https://github.com/glaby91/qbasic-cpc6128/blob/qlib-math-v040-expanded/qlib/unified/WINAPE_VALIDATION_V040.md).

- ROM de 16 384 octets : **1 976 octets occupés**, **14 408 octets de remplissage**.
- [Build GitHub Actions 39646043619](https://github.com/glaby91/qbasic-cpc6128/actions/runs/39646043619), artefact de la ROM `QLIB_UNIFIED_V040_TEST.ROM`.
- 31 tests exécutés avec `|MALLTEST` ; toutes les lignes PASS selon le retour utilisateur.
- Branches et périmètre : `main` conserve QEDIT B005 ; `qedit-b006-syntax` contient les choix d'analyseur et de compatibilité ; `qcomp-dev` prépare le compilateur ; `qlib-unified-v031-rsx-fix` conserve la ROM précédente 23/23 PASS ; `qlib-math-v040-expanded` fournit la nouvelle ROM mathématique.
- **Non implémenté :** fonctions QBX complètes SINGLE/DOUBLE/CURRENCY, trigonométrie en radians compatible, conversions complètes, ABI QCOMP→QLIB. Ne pas confondre les 31 tests réussis avec une validation exhaustive des calculs.
- Les historiques des autres branches restent intacts ; aucune fusion silencieuse du code de développement dans `main`.
