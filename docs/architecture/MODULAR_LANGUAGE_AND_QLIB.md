# Architecture modulaire QEDIT / QLANG / QCOMP / QLIB

**Décision du 21 octobre 2026 — conception retenue, implémentation progressive.**

Objectif : un environnement de développement CPC6128 dont l'éditeur ne dépend pas du langage ; passer du BASIC à un futur C en changeant le module de langage, sans réécrire l'éditeur. QLIB, dont la ROM mathématique, est commune à BASIC, C et assembleur.

## 1. Découpage et responsabilités

| Composant | Responsabilité | Indépendance |
|---|---|---|
| **QEDIT** | écran MODE 2, clavier, curseur, menus, défilement, édition, stockage compact en RAM paginée, recherche, fichiers, diagnostics affichés | Ne contient aucune grammaire BASIC ou C codée en dur |
| **QLANG-BASIC** | dictionnaire QBX/PDS 7.1, reconnaissance des mots, règles de tokenisation/détokenisation, commentaires/chaînes, validation syntaxique rapide | Plug-in interchangeable |
| **QLANG-C** (futur) | lexique C, ponctuation, chaînes, commentaires, directives, grammaire propre au C | Même interface de service que QLANG-BASIC |
| **QCOMP** | orchestration de compilation ; frontends BASIC/C propres à chacun et représentation intermédiaire si utile | Backend Z80 et outils communs sans supposer une grammaire commune |
| **QLIB** | fonctions exécutables Z80 réutilisables : mathématiques, vecteurs/matrices ; autres bibliothèques seulement après réalisation et validation | Ne connaît pas le langage appelant |

Une simple ROM de *tokens* peut changer le vocabulaire de l'éditeur, mais le passage au C nécessite également un lexer, des règles syntaxiques, un frontend compilateur et un runtime adaptés.

## 2. Contrat QEDIT ↔ QLANG (ABI future, non implémentée)

Entrées fonctionnelles à spécifier et versionner :
- `LANG_INFO` : signature, identifiant de langage, version de l'ABI, version du dictionnaire et capacités.
- `LANG_INIT` / `LANG_SHUTDOWN` : initialisation et libération de l'état propre au langage.
- `LANG_LEX` : état lexical et reconnaissance d'une ligne ; préserver l'état interligne (commentaires multilignes en C, etc.).
- `LANG_TOKENIZE` / `LANG_DETOKENIZE` : encodage stable et réversibilité du source.
- `LANG_DIAG` : diagnostics rapides (valide / incomplet / erreur / analyse différée), position et code d'erreur.
- `LANG_EXTENSIONS` : extensions de fichiers et modes pris en charge.

**À définir avant codage** : protocole de sélection et d'appel de ROM, registres préservés, mémoire tampon, offsets, erreurs, réentrance, version ABI, coûts temporels et politique de compatibilité.

QEDIT conserve l'édition texte même si aucun module QLANG n'est chargé ou si une fonctionnalité facultative n'existe pas. La syntaxe ne doit pas altérer irréversiblement le texte saisi.

## 3. Format source et tokens

- Conserver la possibilité d'import/export en ASCII (.BAS, .C) ; ne jamais exposer des identifiants de tokens internes comme norme de fichier externe.
- Pour un format tokenisé natif, prévoir un en-tête avec **identifiant du langage, version du format et version du dictionnaire**, et une voie de migration.
- Les 196 entrées du dictionnaire actuel ne signifient pas 196 commandes effectivement parsées, compilées ou exécutées.
- Conserver des IDs stables ou gérer explicitement leur migration ; les tokens BASIC ne doivent pas être supposés valables pour le C.
- Prévoir chaînes, commentaires, noms d'utilisateurs et ponctuation ; le lexer C doit pouvoir gérer les états entre lignes.

## 4. Contrat QCOMP ↔ QLIB (ABI future, non implémentée)

- Séparer la **sémantique du langage** de l'**implémentation machine** : BASIC `SQR` et C `sqrt` peuvent appeler la même primitive seulement lorsque types, précision et gestion des erreurs concordent.
- Définir types signés/non signés, largeur et représentation (entiers, fixe, futurs flottants), ordre des octets, valeurs renvoyées, registres détruits, pile, erreurs et conventions d'arrondi.
- Une ROM est limitée à 16 KiB, et les appels inter-ROM imposent un mécanisme de sélection et de retour correctement testé avec le firmware/AMSDOS.
- L'interface QLIB doit être utilisable aussi depuis un programme Z80 assembleur, sans dépendance au BASIC.
- Versionner l'ABI et proposer des tests d'appels croisés avant utilisation par QCOMP.

## 5. État établi au départ

- QEDIT v0.4.2 B005 (branche `main`) : ROM de 16 KiB compilée ; validation WinAPE B005 encore manquante ; Ctrl+S peut provoquer un reset, **ne pas utiliser pour sauvegarder des données importantes**.
- QEDIT jusqu'à 1 500 lignes testées dans versions précédentes.
- QCOMP : pas encore de compilateur natif opérationnel.
- QLIB MATH + MATRIX v0.4 (branche `qlib-math-v040-expanded`) : **31/31 PASS sous WinAPE** selon les essais rapportés, mais pas qualification exhaustive ; 1 976 octets de contenu pour une image ROM de 16 384 octets.
- Les fonctions SINGLE/DOUBLE/CURRENCY et les conversions QBX complètes ne sont pas démontrées par ces tests.

## 6. Plan de migration sans régression

1. Figer la **spécification ABI QLANG v0** et les formats de diagnostics/tokens ; relever les dépendances au lexique du code QEDIT actuel.
2. Sur une branche expérimentale QEDIT B006, extraire progressivement les tables et traitements BASIC dans QLANG-BASIC ; commencer par un backend mock/test pour valider l'échange.
3. Valider ouverture/édition/scroll/navigation sur le corpus des 1 500 lignes ; conserver la version B005 intacte et résoudre le défaut Ctrl+S comme chantier séparé et prioritaire à la qualification.
4. Concevoir ABI QLIB v0 avec tests d'appel assembleur, puis liaison de QCOMP-BASIC.
5. Tester l'interchangeabilité avec un QLANG-C minimal (mots-clés, chaînes, commentaires, accolades) **sans annoncer un compilateur C complet**.
6. Porter ensuite le frontend C en réutilisant QEDIT, une partie de QCOMP, et QLIB.

## Règles de versioning et de sécurité

- Branche dédiée aux décisions d'architecture ; **aucune fusion directe automatique** dans la version de référence.
- Différencier : spécifié, codé, compilé, testé sous WinAPE, validé sur matériel.
- Ne jamais écraser une ROM fonctionnelle sans recette de non-régression.
- Source d'autorité actuelle : `PROJECT_STATUS.md`, `PROJECT_HANDOFF.md`, `LANGUAGE_TARGET.md`.
