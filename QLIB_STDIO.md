# QLIB_STDIO — API d'entrées/sorties partagée (proposition)

Inspirée de C stdio, sans prétendre à une compatibilité ANSI C binaire. Interface à destination de QCOMP et des programmes Z80 compilés.

## Fonctions candidates
- `QL_PUTCHAR`, `QL_GETCHAR`, `QL_PUTS` : console CPC, par wrappers firmware ou implémentations optimisées.
- `QL_PRINT_INT`, `QL_PRINT_HEX` : formats compacts, avant un éventuel `QL_PRINTF`.
- `QL_FOPEN`, `QL_FCLOSE`, `QL_FREAD`, `QL_FWRITE` : accès séquentiel aux fichiers AMSDOS, avec conventions de retour/erreurs documentées.
- `QL_FGETC`, `QL_FPUTC`, `QL_EOF` : candidats après validation des buffers et des handles.

## Principes
1. API interne Z80 stable et versionnée : identifiants de services, paramètres, résultat et convention de registres.
2. Modèle console / périphérique / fichier séparé des commandes BASIC (`PRINT`, `INPUT`, `OPEN`).
3. `printf` complet reporté pour préserver taille et temps CPU ; commencer par nombres entiers et chaînes.
4. Interface vers AMSDOS sous contrôle : disponibilité, numérotation des canaux, buffers, erreurs et appels firmware à valider.
5. Examiner coût des appels inter-ROM et possibilité de liaison statique des primitives utilisées fréquemment.
6. Pas de code runtime annoncé comme fonctionnel : document de conception uniquement.

## Tests pilotes
- Affichage caractère/chaîne en MODE 2.
- Saisie clavier sans corruption des registres conservés.
- Écriture/lecture courte dans un fichier test sous WinAPE, indépendamment du bug Ctrl+S de QEDIT.
